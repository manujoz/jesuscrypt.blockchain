import { JesusCrypt } from "../typechain/contracts/JesusCrypt";
import { JesusCryptAdvisors } from "../typechain/contracts/JesusCryptAdvisors";
import { JesusCryptLiquidityLocker } from "../typechain/contracts/JesusCryptLiquidityLocker";
import { JesusCryptPresale } from "../typechain/contracts/JesusCryptPresale";

export async function main(): Promise<{
    jesusCryptInstance: JesusCrypt;
    jesusCryptPresaleInstance: JesusCryptPresale;
    jesusCryptAdvisorsInstance: JesusCryptAdvisors;
    jesusCryptLiquidityLockerInstance: JesusCryptLiquidityLocker;
    deployer: string;
}> {}
