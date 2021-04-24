const { assert } = require('chai')

const MNFTH = artifacts.require('./MNFTH.sol')

require('chai')
  .use(require('chai-as-promised'))
  .should()

contract('MNFTH', (accounts) => {
  let contract

  before(async () => {
    contract = await MNFTH.deployed()
  })

  describe('deployment', async () => {
    it('deploys successfully', async () => {
      const address = contract.address
      assert.notEqual(address, 0x0)
      assert.notEqual(address, '')
      assert.notEqual(address, null)
      assert.notEqual(address, undefined)
    })

    it('has a name', async () => {
      const name = await contract.name()
      assert.equal(name, 'Million NFT Home Page')
    })

    it('has a symbol', async () => {
      const symbol = await contract.symbol()
      assert.equal(symbol, 'MNFTH')
    })

  })

  // describe('ownerHasAllTokens', async () => {
  //   it('checksOwnerTokens', async () => {
  //     const ownerTokens = await contract.balanceOf('0x63f8012E9568317dCf3e15e0B066A0c54034d121')

  //     assert.equal(ownerTokens,1000000, 'Correct number of owner tokens')

  //   })
  // })

  describe('minting', async () => {

    it('creates a new token', async () => {
      const result = await contract.mintPixel('1','#EC058E')
      const totalSupply = await contract.totalSupply()
      // SUCCESS
      assert.equal(totalSupply, 1)
      const event = result.logs[0].args
      assert.equal(event.tokenId.toNumber(), 1, 'id is correct')
      assert.equal(event.from, '0x0000000000000000000000000000000000000000', 'from is correct')
      assert.equal(event.to, accounts[0], 'to is correct')

      //await contract.mintPixel('31','#EC058E')
      // FAILURE: cannot mint same color twice
      await contract.mintPixel('1','#EC058E').should.be.rejected;
      
    })
  })

  describe('indexing', async () => {
    it('lists colors', async () => {
      // Mint 3 more tokens
      await contract.mintPixel('2','#5386E4')
      await contract.mintPixel('3','#FFFFFF')
      await contract.mintPixel('4','#000000')
      const totalSupply = await contract.totalSupply()

      let color
      let result = []

      for (var i = 1; i <= totalSupply; i++) {
        color = await contract.readColor(i)
        result.push(color)
      }

      let expected = ['#EC058E', '#5386E4', '#FFFFFF', '#000000']
      assert.equal(result.join(','), expected.join(','))
    })
  })

  describe('changing the color of a token', async () => {

    it('exists and owner', async () => {
      await contract.mintPixel('5','#000000')
      const result = await contract.ownerOf('5')
      assert.equal(result,'0x63f8012E9568317dCf3e15e0B066A0c54034d121')
      await contract.updatePixelMapping('5','#AAAAAA')
      
    })
    it('not owner', async () => {
      await contract.mintPixel('6','#000000',{from: accounts[1]})
      await contract.updatePixelMapping('6','#BBBBBB',{from: accounts[2]}).should.be.rejected
    })
    it('non-existant', async () => {
      await contract.updatePixelMapping('55','#AAAAAA').should.be.rejected
    })
    

      
  })
})
