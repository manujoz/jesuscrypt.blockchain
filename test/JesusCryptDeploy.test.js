import { expect } from "chai";
import { main } from "../lib/deploy.js";

describe("JesusCrypt deploy", function () {
    /** @type {string} */
    let deployer;
    /** @type {import("../typechain/contracts/JesusCrypt").JesusCrypt} */
    let JesusCrypt;
    /** @type {import("../typechain/contracts/JesusCryptAdvisors").JesusCryptAdvisors} */
    let JesusCryptAdvisors;
    /** @type {import("../typechain/contracts/JesusCryptLiquidityLocker").JesusCryptLiquidityLocker} */
    let JesusCryptLiquidityLocker;
    /** @type {import("../typechain/contracts/JesusCryptPresale").JesusCryptPresale} */
    let JesusCryptPresale;

    beforeEach(async function () {
        const { jesusCryptAdvisorsInstance, jesusCryptInstance, jesusCryptLiquidityLockerInstance, jesusCryptPresaleInstance, deployer: dp } = await main();

        deployer = dp;
        JesusCrypt = jesusCryptInstance;
        JesusCryptAdvisors = jesusCryptAdvisorsInstance;
        JesusCryptLiquidityLocker = jesusCryptLiquidityLockerInstance;
        JesusCryptPresale = jesusCryptPresaleInstance;
    });

    it("should deploy the JesusCrypt contract", async function () {
        expect(JesusCrypt.address).to.not.be.undefined;
    });

    it("should deploy the JesusCryptPresale contract", async function () {
        expect(JesusCryptPresale.address).to.not.be.undefined;
    });

    it("should deploy the JesusCryptAdvisors contract", async function () {
        expect(JesusCryptAdvisors.address).to.not.be.undefined;
    });

    it("should deploy the JesusCryptLiquidityLocker contract", async function () {
        expect(JesusCryptLiquidityLocker.address).to.not.be.undefined;
    });
});
