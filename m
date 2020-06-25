Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 330E1209DE7
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 13:55:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404607AbgFYLzB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 07:55:01 -0400
Received: from userp2120.oracle.com ([156.151.31.85]:34474 "EHLO
        userp2120.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728063AbgFYLzA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 07:55:00 -0400
Received: from pps.filterd (userp2120.oracle.com [127.0.0.1])
        by userp2120.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PBpxWR072338;
        Thu, 25 Jun 2020 11:54:35 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : mime-version : content-type : in-reply-to;
 s=corp-2020-01-29; bh=aho2hy4v698Uw07DSjFJ5ZWOsVsHmwTB1zicv6ZHLho=;
 b=PijgXaSCMdNfl9chxuShLfr5RUftCBkh6BifAH9eDCP9EbCXSFabUElD+3ZVmQV4hrSI
 cR0UjQQ/vIl/uKF3l9ryXpj266x5X1Pr6J7m8cFcSQ0MKQTGx1awK0dfnbqVxqBl8mna
 r4jjo4J7UPbGD9Pn67NQA1xgOaecgTqk0ZhSBKNiZ3o+lZCff3uxSxubklzCVymh3Kmx
 EYGSJOAOqTlwaQKKXkyBvGBCkB84eOzqeMG8zG1UMar20MVbQnDfUt7/9F3dA1F+RdA0
 OBi7FDF1xZaa9aSgCdZG36ni+wQG7tEXSrLIhOmXepXTHbI6bMl4SW6LKSf7Cy3Zsbpx eg== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by userp2120.oracle.com with ESMTP id 31uustr1wf-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Thu, 25 Jun 2020 11:54:34 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 05PBlwtG019673;
        Thu, 25 Jun 2020 11:52:34 GMT
Received: from userv0122.oracle.com (userv0122.oracle.com [156.151.31.75])
        by aserp3030.oracle.com with ESMTP id 31uur14fwk-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Thu, 25 Jun 2020 11:52:33 +0000
Received: from abhmp0015.oracle.com (abhmp0015.oracle.com [141.146.116.21])
        by userv0122.oracle.com (8.14.4/8.14.4) with ESMTP id 05PBqQwl005011;
        Thu, 25 Jun 2020 11:52:26 GMT
Received: from kadam (/41.57.98.10)
        by default (Oracle Beehive Gateway v4.0)
        with ESMTP ; Thu, 25 Jun 2020 11:52:25 +0000
Date:   Thu, 25 Jun 2020 14:52:15 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     kbuild@lists.01.org, Antoine Tenart <antoine.tenart@bootlin.com>,
        davem@davemloft.net, andrew@lunn.ch, f.fainelli@gmail.com,
        hkallweit1@gmail.com, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com
Cc:     lkp@intel.com, kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, thomas.petazzoni@bootlin.com
Subject: Re: [PATCH net-next v4 5/8] net: phy: mscc: 1588 block initialization
Message-ID: <20200625115215.GD2549@kadam>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="A6N2fC+uXW/VQSAv"
Content-Disposition: inline
In-Reply-To: <20200623143014.47864-6-antoine.tenart@bootlin.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9662 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 mlxlogscore=999
 adultscore=0 mlxscore=0 suspectscore=0 malwarescore=0 phishscore=0
 bulkscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2004280000 definitions=main-2006250075
X-Proofpoint-Virus-Version: vendor=nai engine=6000 definitions=9662 signatures=668680
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 mlxlogscore=999
 cotscore=-2147483648 adultscore=0 bulkscore=0 spamscore=0 phishscore=0
 suspectscore=0 priorityscore=1501 lowpriorityscore=0 clxscore=1011
 impostorscore=0 malwarescore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.12.0-2004280000 definitions=main-2006250076
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--A6N2fC+uXW/VQSAv
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi Antoine,

url:    https://github.com/0day-ci/linux/commits/Antoine-Tenart/net-phy-mscc-PHC-and-timestamping-support/20200623-223712
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 8af7b4525acf5012b2f111a8b168b8647f2c8d60
config: x86_64-randconfig-m001-20200624 (attached as .config)
compiler: gcc-9 (Debian 9.3.0-13) 9.3.0

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>
Reported-by: Dan Carpenter <dan.carpenter@oracle.com>

smatch warnings:
drivers/net/phy/mscc/mscc_main.c:1472 vsc8584_config_init() error: double unlocked 'phydev->mdio.bus->mdio_lock' (orig line 1431)
drivers/net/phy/mscc/mscc_ptp.c:87 vsc85xx_ts_read_csr() error: uninitialized symbol 'blk_hw'.

# https://github.com/0day-ci/linux/commit/b3225965b276bd4f492184090bbac3a117bc77ae
git remote add linux-review https://github.com/0day-ci/linux
git remote update linux-review
git checkout b3225965b276bd4f492184090bbac3a117bc77ae
vim +1472 drivers/net/phy/mscc/mscc_main.c

a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1326  static int vsc8584_config_init(struct phy_device *phydev)
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1327  {
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1328  	struct vsc8531_private *vsc8531 = phydev->priv;
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1329  	int ret, i;
deb04e9c0ff2b4 drivers/net/phy/mscc/mscc_main.c Michael Walle     2020-05-06  1330  	u16 val;
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1331  
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1332  	phydev->mdix_ctrl = ETH_TP_MDI_AUTO;
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1333  
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1334  	mutex_lock(&phydev->mdio.bus->mdio_lock);
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1335  
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1336  	/* Some parts of the init sequence are identical for every PHY in the
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1337  	 * package. Some parts are modifying the GPIO register bank which is a
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1338  	 * set of registers that are affecting all PHYs, a few resetting the
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1339  	 * microprocessor common to all PHYs. The CRC check responsible of the
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1340  	 * checking the firmware within the 8051 microprocessor can only be
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1341  	 * accessed via the PHY whose internal address in the package is 0.
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1342  	 * All PHYs' interrupts mask register has to be zeroed before enabling
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1343  	 * any PHY's interrupt in this register.
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1344  	 * For all these reasons, we need to do the init sequence once and only
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1345  	 * once whatever is the first PHY in the package that is initialized and
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1346  	 * do the correct init sequence for all PHYs that are package-critical
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1347  	 * in this pre-init function.
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1348  	 */
deb04e9c0ff2b4 drivers/net/phy/mscc/mscc_main.c Michael Walle     2020-05-06  1349  	if (phy_package_init_once(phydev)) {
75a1ccfe6c726b drivers/net/phy/mscc.c           Bryan Whitehead   2019-11-13  1350  		/* The following switch statement assumes that the lowest
75a1ccfe6c726b drivers/net/phy/mscc.c           Bryan Whitehead   2019-11-13  1351  		 * nibble of the phy_id_mask is always 0. This works because
75a1ccfe6c726b drivers/net/phy/mscc.c           Bryan Whitehead   2019-11-13  1352  		 * the lowest nibble of the PHY_ID's below are also 0.
75a1ccfe6c726b drivers/net/phy/mscc.c           Bryan Whitehead   2019-11-13  1353  		 */
75a1ccfe6c726b drivers/net/phy/mscc.c           Bryan Whitehead   2019-11-13  1354  		WARN_ON(phydev->drv->phy_id_mask & 0xf);
75a1ccfe6c726b drivers/net/phy/mscc.c           Bryan Whitehead   2019-11-13  1355  
75a1ccfe6c726b drivers/net/phy/mscc.c           Bryan Whitehead   2019-11-13  1356  		switch (phydev->phy_id & phydev->drv->phy_id_mask) {
75a1ccfe6c726b drivers/net/phy/mscc.c           Bryan Whitehead   2019-11-13  1357  		case PHY_ID_VSC8504:
75a1ccfe6c726b drivers/net/phy/mscc.c           Bryan Whitehead   2019-11-13  1358  		case PHY_ID_VSC8552:
75a1ccfe6c726b drivers/net/phy/mscc.c           Bryan Whitehead   2019-11-13  1359  		case PHY_ID_VSC8572:
75a1ccfe6c726b drivers/net/phy/mscc.c           Bryan Whitehead   2019-11-13  1360  		case PHY_ID_VSC8574:
00d70d8e0e7811 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1361  			ret = vsc8574_config_pre_init(phydev);
75a1ccfe6c726b drivers/net/phy/mscc.c           Bryan Whitehead   2019-11-13  1362  			break;
75a1ccfe6c726b drivers/net/phy/mscc.c           Bryan Whitehead   2019-11-13  1363  		case PHY_ID_VSC856X:
75a1ccfe6c726b drivers/net/phy/mscc.c           Bryan Whitehead   2019-11-13  1364  		case PHY_ID_VSC8575:
75a1ccfe6c726b drivers/net/phy/mscc.c           Bryan Whitehead   2019-11-13  1365  		case PHY_ID_VSC8582:
75a1ccfe6c726b drivers/net/phy/mscc.c           Bryan Whitehead   2019-11-13  1366  		case PHY_ID_VSC8584:
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1367  			ret = vsc8584_config_pre_init(phydev);
75a1ccfe6c726b drivers/net/phy/mscc.c           Bryan Whitehead   2019-11-13  1368  			break;
75a1ccfe6c726b drivers/net/phy/mscc.c           Bryan Whitehead   2019-11-13  1369  		default:
00d70d8e0e7811 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1370  			ret = -EINVAL;
75a1ccfe6c726b drivers/net/phy/mscc.c           Bryan Whitehead   2019-11-13  1371  			break;
1e8795b1b20d27 drivers/net/phy/mscc.c           kbuild test robot 2019-11-16  1372  		}
00d70d8e0e7811 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1373  
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1374  		if (ret)
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1375  			goto err;
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1376  	}
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1377  
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1378  	phy_base_write(phydev, MSCC_EXT_PAGE_ACCESS,
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1379  		       MSCC_PHY_PAGE_EXTENDED_GPIO);
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1380  
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1381  	val = phy_base_read(phydev, MSCC_PHY_MAC_CFG_FASTLINK);
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1382  	val &= ~MAC_CFG_MASK;
e8e4223046e19d drivers/net/phy/mscc/mscc_main.c Antoine Tenart    2020-03-19  1383  	if (phydev->interface == PHY_INTERFACE_MODE_QSGMII) {
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1384  		val |= MAC_CFG_QSGMII;
e8e4223046e19d drivers/net/phy/mscc/mscc_main.c Antoine Tenart    2020-03-19  1385  	} else if (phydev->interface == PHY_INTERFACE_MODE_SGMII) {
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1386  		val |= MAC_CFG_SGMII;
e8e4223046e19d drivers/net/phy/mscc/mscc_main.c Antoine Tenart    2020-03-19  1387  	} else if (phy_interface_is_rgmii(phydev)) {
e8e4223046e19d drivers/net/phy/mscc/mscc_main.c Antoine Tenart    2020-03-19  1388  		val |= MAC_CFG_RGMII;
e8e4223046e19d drivers/net/phy/mscc/mscc_main.c Antoine Tenart    2020-03-19  1389  	} else {
e8e4223046e19d drivers/net/phy/mscc/mscc_main.c Antoine Tenart    2020-03-19  1390  		ret = -EINVAL;
e8e4223046e19d drivers/net/phy/mscc/mscc_main.c Antoine Tenart    2020-03-19  1391  		goto err;
e8e4223046e19d drivers/net/phy/mscc/mscc_main.c Antoine Tenart    2020-03-19  1392  	}
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1393  
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1394  	ret = phy_base_write(phydev, MSCC_PHY_MAC_CFG_FASTLINK, val);
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1395  	if (ret)
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1396  		goto err;
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1397  
e8e4223046e19d drivers/net/phy/mscc/mscc_main.c Antoine Tenart    2020-03-19  1398  	if (!phy_interface_is_rgmii(phydev)) {
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1399  		val = PROC_CMD_MCB_ACCESS_MAC_CONF | PROC_CMD_RST_CONF_PORT |
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1400  			PROC_CMD_READ_MOD_WRITE_PORT;
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1401  		if (phydev->interface == PHY_INTERFACE_MODE_QSGMII)
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1402  			val |= PROC_CMD_QSGMII_MAC;
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1403  		else
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1404  			val |= PROC_CMD_SGMII_MAC;
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1405  
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1406  		ret = vsc8584_cmd(phydev, val);
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1407  		if (ret)
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1408  			goto err;
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1409  
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1410  		usleep_range(10000, 20000);
e8e4223046e19d drivers/net/phy/mscc/mscc_main.c Antoine Tenart    2020-03-19  1411  	}
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1412  
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1413  	/* Disable SerDes for 100Base-FX */
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1414  	ret = vsc8584_cmd(phydev, PROC_CMD_FIBER_MEDIA_CONF |
49113d5e0c3f3f drivers/net/phy/mscc/mscc_main.c Antoine Tenart    2020-06-05  1415  			  PROC_CMD_FIBER_PORT(vsc8531->addr) |
deb04e9c0ff2b4 drivers/net/phy/mscc/mscc_main.c Michael Walle     2020-05-06  1416  			  PROC_CMD_FIBER_DISABLE |
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1417  			  PROC_CMD_READ_MOD_WRITE_PORT |
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1418  			  PROC_CMD_RST_CONF_PORT | PROC_CMD_FIBER_100BASE_FX);
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1419  	if (ret)
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1420  		goto err;
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1421  
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1422  	/* Disable SerDes for 1000Base-X */
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1423  	ret = vsc8584_cmd(phydev, PROC_CMD_FIBER_MEDIA_CONF |
49113d5e0c3f3f drivers/net/phy/mscc/mscc_main.c Antoine Tenart    2020-06-05  1424  			  PROC_CMD_FIBER_PORT(vsc8531->addr) |
deb04e9c0ff2b4 drivers/net/phy/mscc/mscc_main.c Michael Walle     2020-05-06  1425  			  PROC_CMD_FIBER_DISABLE |
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1426  			  PROC_CMD_READ_MOD_WRITE_PORT |
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1427  			  PROC_CMD_RST_CONF_PORT | PROC_CMD_FIBER_1000BASE_X);
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1428  	if (ret)
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1429  		goto err;
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1430  
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08 @1431  	mutex_unlock(&phydev->mdio.bus->mdio_lock);
                                                                                        ^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1432  
1bbe0ecc2a1a00 drivers/net/phy/mscc.c           Antoine Tenart    2020-01-13  1433  	ret = vsc8584_macsec_init(phydev);
1bbe0ecc2a1a00 drivers/net/phy/mscc.c           Antoine Tenart    2020-01-13  1434  	if (ret)
fa164e40c53b38 drivers/net/phy/mscc/mscc_main.c Antoine Tenart    2020-03-13  1435  		return ret;
1bbe0ecc2a1a00 drivers/net/phy/mscc.c           Antoine Tenart    2020-01-13  1436  
b3225965b276bd drivers/net/phy/mscc/mscc_main.c Quentin Schulz    2020-06-23  1437  	ret = vsc8584_ptp_init(phydev);
b3225965b276bd drivers/net/phy/mscc/mscc_main.c Quentin Schulz    2020-06-23  1438  	if (ret)
b3225965b276bd drivers/net/phy/mscc/mscc_main.c Quentin Schulz    2020-06-23  1439  		goto err;
                                                                                                ^^^^^^^^
This should be a direct return.


b3225965b276bd drivers/net/phy/mscc/mscc_main.c Quentin Schulz    2020-06-23  1440  
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1441  	phy_write(phydev, MSCC_EXT_PAGE_ACCESS, MSCC_PHY_PAGE_STANDARD);
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1442  
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1443  	val = phy_read(phydev, MSCC_PHY_EXT_PHY_CNTL_1);
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1444  	val &= ~(MEDIA_OP_MODE_MASK | VSC8584_MAC_IF_SELECTION_MASK);
1ac7b090ec4618 drivers/net/phy/mscc.c           Antoine Tenart    2020-02-26  1445  	val |= (MEDIA_OP_MODE_COPPER << MEDIA_OP_MODE_POS) |
1ac7b090ec4618 drivers/net/phy/mscc.c           Antoine Tenart    2020-02-26  1446  	       (VSC8584_MAC_IF_SELECTION_SGMII << VSC8584_MAC_IF_SELECTION_POS);
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1447  	ret = phy_write(phydev, MSCC_PHY_EXT_PHY_CNTL_1, val);
09d65e6d631c05 drivers/net/phy/mscc/mscc_main.c Antoine Tenart    2020-03-19  1448  	if (ret)
09d65e6d631c05 drivers/net/phy/mscc/mscc_main.c Antoine Tenart    2020-03-19  1449  		return ret;
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1450  
2283a02b67d412 drivers/net/phy/mscc/mscc_main.c Vladimir Oltean   2020-03-24  1451  	if (phy_interface_is_rgmii(phydev)) {
2283a02b67d412 drivers/net/phy/mscc/mscc_main.c Vladimir Oltean   2020-03-24  1452  		ret = vsc85xx_rgmii_set_skews(phydev, VSC8572_RGMII_CNTL,
2283a02b67d412 drivers/net/phy/mscc/mscc_main.c Vladimir Oltean   2020-03-24  1453  					      VSC8572_RGMII_RX_DELAY_MASK,
2283a02b67d412 drivers/net/phy/mscc/mscc_main.c Vladimir Oltean   2020-03-24  1454  					      VSC8572_RGMII_TX_DELAY_MASK);
2283a02b67d412 drivers/net/phy/mscc/mscc_main.c Vladimir Oltean   2020-03-24  1455  		if (ret)
2283a02b67d412 drivers/net/phy/mscc/mscc_main.c Vladimir Oltean   2020-03-24  1456  			return ret;
2283a02b67d412 drivers/net/phy/mscc/mscc_main.c Vladimir Oltean   2020-03-24  1457  	}
dee48f78d02e15 drivers/net/phy/mscc/mscc_main.c Antoine Tenart    2020-03-19  1458  
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1459  	ret = genphy_soft_reset(phydev);
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1460  	if (ret)
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1461  		return ret;
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1462  
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1463  	for (i = 0; i < vsc8531->nleds; i++) {
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1464  		ret = vsc85xx_led_cntl_set(phydev, i, vsc8531->leds_mode[i]);
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1465  		if (ret)
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1466  			return ret;
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1467  	}
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1468  
c227ce4423855b drivers/net/phy/mscc.c           Heiner Kallweit   2019-08-17  1469  	return 0;
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1470  
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1471  err:
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08 @1472  	mutex_unlock(&phydev->mdio.bus->mdio_lock);
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1473  	return ret;
a5afc1678044a3 drivers/net/phy/mscc.c           Quentin Schulz    2018-10-08  1474  }

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--A6N2fC+uXW/VQSAv
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--A6N2fC+uXW/VQSAv--
