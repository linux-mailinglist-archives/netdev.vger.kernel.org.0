Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B2E9495A1D
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 07:47:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348865AbiAUGrj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 01:47:39 -0500
Received: from mga17.intel.com ([192.55.52.151]:14504 "EHLO mga17.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234730AbiAUGrj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 21 Jan 2022 01:47:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1642747659; x=1674283659;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=2Z2Q5NbDptKHesj9kA2fhmfkV9D++wKqxn0cl9MoG4w=;
  b=KESEbidaGTnAHH2iIvUsOA9A2hjMPTzO2YYD8lG7FC4rkHXmN2yXSFJJ
   4guoUtVLPAO6FI5Ow0EIcZQdmy2P+641kv4SuaL2A3f8wCoHAjYMzgkcf
   2shTaiCBaurO8Cyi45qv1gLhUdp3ZD2Cu/hL/LVUWRUpcZgVzIMK5is5v
   QM5EsOjPtbkzTgsgYwP1XIK2kp9QhYUFFE+3x0e22l1gUIUXpwNYtWwQi
   9fjM/K5Bb3LCEPeRw8eH0cHB21sNzXbuaxIZZmh5DWOELHXpOff4I7wMC
   fp07AHM4DxpQ2qoBiyyJS3wfL73vBYVndQIFhDg5Bmjm9im19tzQqOuNS
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10233"; a="226256082"
X-IronPort-AV: E=Sophos;i="5.88,304,1635231600"; 
   d="scan'208";a="226256082"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jan 2022 22:47:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,304,1635231600"; 
   d="scan'208";a="561763638"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 20 Jan 2022 22:47:35 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nAnhv-000F1j-0q; Fri, 21 Jan 2022 06:47:35 +0000
Date:   Fri, 21 Jan 2022 14:47:07 +0800
From:   kernel test robot <lkp@intel.com>
To:     Kai-Heng Feng <kai.heng.feng@canonical.com>, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: phy: marvell: Honor phy LED set by system
 firmware on a Dell hardware
Message-ID: <202201211407.0fB4ltJZ-lkp@intel.com>
References: <20220120051929.1625791-1-kai.heng.feng@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220120051929.1625791-1-kai.heng.feng@canonical.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Kai-Heng,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v5.16 next-20220121]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Kai-Heng-Feng/net-phy-marvell-Honor-phy-LED-set-by-system-firmware-on-a-Dell-hardware/20220120-132020
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 1d1df41c5a33359a00e919d54eaebfb789711fdc
config: x86_64-randconfig-a005 (https://download.01.org/0day-ci/archive/20220121/202201211407.0fB4ltJZ-lkp@intel.com/config)
compiler: clang version 14.0.0 (https://github.com/llvm/llvm-project f7b7138a62648f4019c55e4671682af1f851f295)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/7556c47e56e3c39c1b4ddb5a8171f943b10be919
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Kai-Heng-Feng/net-phy-marvell-Honor-phy-LED-set-by-system-firmware-on-a-Dell-hardware/20220120-132020
        git checkout 7556c47e56e3c39c1b4ddb5a8171f943b10be919
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/phy/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/phy/phy_device.c:1465:24: warning: cast to smaller integer type 'u32' (aka 'unsigned int') from 'void *' [-Wvoid-pointer-to-int-cast]
                   phydev->dev_flags |= (u32)dmi->driver_data;
                                        ^~~~~~~~~~~~~~~~~~~~~
   1 warning generated.


vim +1465 drivers/net/phy/phy_device.c

  1360	
  1361	/**
  1362	 * phy_attach_direct - attach a network device to a given PHY device pointer
  1363	 * @dev: network device to attach
  1364	 * @phydev: Pointer to phy_device to attach
  1365	 * @flags: PHY device's dev_flags
  1366	 * @interface: PHY device's interface
  1367	 *
  1368	 * Description: Called by drivers to attach to a particular PHY
  1369	 *     device. The phy_device is found, and properly hooked up
  1370	 *     to the phy_driver.  If no driver is attached, then a
  1371	 *     generic driver is used.  The phy_device is given a ptr to
  1372	 *     the attaching device, and given a callback for link status
  1373	 *     change.  The phy_device is returned to the attaching driver.
  1374	 *     This function takes a reference on the phy device.
  1375	 */
  1376	int phy_attach_direct(struct net_device *dev, struct phy_device *phydev,
  1377			      u32 flags, phy_interface_t interface)
  1378	{
  1379		struct mii_bus *bus = phydev->mdio.bus;
  1380		struct device *d = &phydev->mdio.dev;
  1381		struct module *ndev_owner = NULL;
  1382		const struct dmi_system_id *dmi;
  1383		bool using_genphy = false;
  1384		int err;
  1385	
  1386		/* For Ethernet device drivers that register their own MDIO bus, we
  1387		 * will have bus->owner match ndev_mod, so we do not want to increment
  1388		 * our own module->refcnt here, otherwise we would not be able to
  1389		 * unload later on.
  1390		 */
  1391		if (dev)
  1392			ndev_owner = dev->dev.parent->driver->owner;
  1393		if (ndev_owner != bus->owner && !try_module_get(bus->owner)) {
  1394			phydev_err(phydev, "failed to get the bus module\n");
  1395			return -EIO;
  1396		}
  1397	
  1398		get_device(d);
  1399	
  1400		/* Assume that if there is no driver, that it doesn't
  1401		 * exist, and we should use the genphy driver.
  1402		 */
  1403		if (!d->driver) {
  1404			if (phydev->is_c45)
  1405				d->driver = &genphy_c45_driver.mdiodrv.driver;
  1406			else
  1407				d->driver = &genphy_driver.mdiodrv.driver;
  1408	
  1409			using_genphy = true;
  1410		}
  1411	
  1412		if (!try_module_get(d->driver->owner)) {
  1413			phydev_err(phydev, "failed to get the device driver module\n");
  1414			err = -EIO;
  1415			goto error_put_device;
  1416		}
  1417	
  1418		if (using_genphy) {
  1419			err = d->driver->probe(d);
  1420			if (err >= 0)
  1421				err = device_bind_driver(d);
  1422	
  1423			if (err)
  1424				goto error_module_put;
  1425		}
  1426	
  1427		if (phydev->attached_dev) {
  1428			dev_err(&dev->dev, "PHY already attached\n");
  1429			err = -EBUSY;
  1430			goto error;
  1431		}
  1432	
  1433		phydev->phy_link_change = phy_link_change;
  1434		if (dev) {
  1435			phydev->attached_dev = dev;
  1436			dev->phydev = phydev;
  1437	
  1438			if (phydev->sfp_bus_attached)
  1439				dev->sfp_bus = phydev->sfp_bus;
  1440			else if (dev->sfp_bus)
  1441				phydev->is_on_sfp_module = true;
  1442		}
  1443	
  1444		/* Some Ethernet drivers try to connect to a PHY device before
  1445		 * calling register_netdevice() -> netdev_register_kobject() and
  1446		 * does the dev->dev.kobj initialization. Here we only check for
  1447		 * success which indicates that the network device kobject is
  1448		 * ready. Once we do that we still need to keep track of whether
  1449		 * links were successfully set up or not for phy_detach() to
  1450		 * remove them accordingly.
  1451		 */
  1452		phydev->sysfs_links = false;
  1453	
  1454		phy_sysfs_create_links(phydev);
  1455	
  1456		if (!phydev->attached_dev) {
  1457			err = sysfs_create_file(&phydev->mdio.dev.kobj,
  1458						&dev_attr_phy_standalone.attr);
  1459			if (err)
  1460				phydev_err(phydev, "error creating 'phy_standalone' sysfs entry\n");
  1461		}
  1462	
  1463		dmi = dmi_first_match(platform_flags);
  1464		if (dmi)
> 1465			phydev->dev_flags |= (u32)dmi->driver_data;
  1466	
  1467		phydev->dev_flags |= flags;
  1468	
  1469		phydev->interface = interface;
  1470	
  1471		phydev->state = PHY_READY;
  1472	
  1473		/* Port is set to PORT_TP by default and the actual PHY driver will set
  1474		 * it to different value depending on the PHY configuration. If we have
  1475		 * the generic PHY driver we can't figure it out, thus set the old
  1476		 * legacy PORT_MII value.
  1477		 */
  1478		if (using_genphy)
  1479			phydev->port = PORT_MII;
  1480	
  1481		/* Initial carrier state is off as the phy is about to be
  1482		 * (re)initialized.
  1483		 */
  1484		if (dev)
  1485			netif_carrier_off(phydev->attached_dev);
  1486	
  1487		/* Do initial configuration here, now that
  1488		 * we have certain key parameters
  1489		 * (dev_flags and interface)
  1490		 */
  1491		err = phy_init_hw(phydev);
  1492		if (err)
  1493			goto error;
  1494	
  1495		err = phy_disable_interrupts(phydev);
  1496		if (err)
  1497			return err;
  1498	
  1499		phy_resume(phydev);
  1500		phy_led_triggers_register(phydev);
  1501	
  1502		return err;
  1503	
  1504	error:
  1505		/* phy_detach() does all of the cleanup below */
  1506		phy_detach(phydev);
  1507		return err;
  1508	
  1509	error_module_put:
  1510		module_put(d->driver->owner);
  1511	error_put_device:
  1512		put_device(d);
  1513		if (ndev_owner != bus->owner)
  1514			module_put(bus->owner);
  1515		return err;
  1516	}
  1517	EXPORT_SYMBOL(phy_attach_direct);
  1518	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
