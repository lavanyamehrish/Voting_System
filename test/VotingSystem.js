const{ expect } = require("chai");

describe("VotingSystem", function () {
    it("Should deploy and initialize candidates", async function () {
        const VotingSystem = await ethers.getContractFactory("VotingSystem");
        const votingSystem = await VotingSystem.deploy(["Alice", "Bob", "Charlie"]);
        await votingSystem.deployed();

        expect(await votingSystem.candidates(0)).to.have.property("name", "Alice");
        expect(await votingSystem.candidates(1)).to.have.property("name", "Bob");
        expect(await votingSystem.candidates(2)).to.have.property("name", "Charlie");
    });

    it("Should allow voting and update state", async function () {
        const [, addr1] = await ethers.getSigners();
        const VotingSystem = await ethers.getContractFactory("VotingSystem");
        const votingSystem = await VotingSystem.deploy(["Alice", "Bob", "Charlie"]);
        await votingSystem.deployed();

        await votingSystem.connect(addr1).vote(0);

        expect(await votingSystem.hasVoted(addr1.address)).to.be.true;
        expect((await votingSystem.candidates(0)).voteCount.toString()).to.equal(ethers.BigNumber.from("1").toString());
    });

    it("Should return the winner", async function () {
        const [, addr1, addr2] = await ethers.getSigners();
        const VotingSystem = await ethers.getContractFactory("VotingSystem");
        const votingSystem = await VotingSystem.deploy(["Alice", "Bob", "Charlie"]);
        await votingSystem.deployed();

        await votingSystem.connect(addr1).vote(0);
        await votingSystem.connect(addr2).vote(0);

        expect(await votingSystem.getWinner()).to.equal("Alice");
    });

});