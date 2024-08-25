import type { JesusCrypt } from "../typechain/contracts/JesusCrypt";
import type { JesusCryptAdvisors } from "../typechain/contracts/JesusCryptAdvisors";
import type { JesusCryptLiquidityLocker } from "../typechain/contracts/JesusCryptLiquidityLocker";
import type { JesusCryptPresale } from "../typechain/contracts/JesusCryptPresale";

import { main } from "../lib/deploy";

// import { expect } from "chai";
const chai = require("chai");
const { expect } = chai;

describe("JesusCrypt", function () {
    let JesusCrypt: JesusCrypt;
    let JesusCryptAdvisors: JesusCryptAdvisors;
    let JesusCryptLiquidityLocker: JesusCryptLiquidityLocker;
    let JesusCryptPresale: JesusCryptPresale;

    beforeEach(async function () {
        const { jesusCryptAdvisorsInstance, jesusCryptInstance, jesusCryptLiquidityLockerInstance, jesusCryptPresaleInstance } = await main();

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
