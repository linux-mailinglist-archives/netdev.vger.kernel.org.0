Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D825F33349E
	for <lists+netdev@lfdr.de>; Wed, 10 Mar 2021 05:57:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232394AbhCJE4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Mar 2021 23:56:40 -0500
Received: from mga03.intel.com ([134.134.136.65]:46530 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232378AbhCJE4S (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Mar 2021 23:56:18 -0500
IronPort-SDR: AarE3g8ggS4nczHbcnuJnYJiDBmKOYVNkn7DQ883LY1JmS24IYT2O35uz/da8SEC6NkXhN9K8Q
 CUVkGFJKv/nw==
X-IronPort-AV: E=McAfee;i="6000,8403,9917"; a="188425841"
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="gz'50?scan'50,208,50";a="188425841"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Mar 2021 20:56:17 -0800
IronPort-SDR: tPKMq6T0L7k3iu6c2ZZaEyn3XJG/nPLhmkxTUwcMmDt7jH5U7mvnxuR2c/zTckNlLFUBT8pPVR
 r8eTSsaF4GCQ==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.81,236,1610438400"; 
   d="gz'50?scan'50,208,50";a="371807628"
Received: from lkp-server01.sh.intel.com (HELO 3e992a48ca98) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 09 Mar 2021 20:56:15 -0800
Received: from kbuild by 3e992a48ca98 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1lJqtK-00021k-DV; Wed, 10 Mar 2021 04:56:14 +0000
Date:   Wed, 10 Mar 2021 12:55:20 +0800
From:   kernel test robot <lkp@intel.com>
To:     Daniel =?iso-8859-1?Q?Gonz=E1lez?= Cabanelas <dgcbueu@gmail.com>,
        davem@davemloft.net
Cc:     kbuild-all@lists.01.org, kuba@kernel.org, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, netdev@vger.kernel.org,
        noltari@gmail.com
Subject: Re: [PATCH v3] bcm63xx_enet: fix internal phy IRQ assignment
Message-ID: <202103101234.B2OkiWWU-lkp@intel.com>
References: <2190629.1yaby32tsi@tool>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="a8Wt8u1KmwUX3Y2C"
Content-Disposition: inline
In-Reply-To: <2190629.1yaby32tsi@tool>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--a8Wt8u1KmwUX3Y2C
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi "Daniel,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on ipvs/master]
[also build test ERROR on linus/master sparc-next/master v5.12-rc2 next-20210309]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Daniel-Gonz-lez-Cabanelas/bcm63xx_enet-fix-internal-phy-IRQ-assignment/20210225-001952
base:   https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs.git master
config: mips-bcm63xx_defconfig (attached as .config)
compiler: mips-linux-gcc (GCC) 9.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/65174cd38e1739216cc40e3d285f16391d79d6e5
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Daniel-Gonz-lez-Cabanelas/bcm63xx_enet-fix-internal-phy-IRQ-assignment/20210225-001952
        git checkout 65174cd38e1739216cc40e3d285f16391d79d6e5
        # save the attached .config to linux build tree
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-9.3.0 make.cross ARCH=mips 

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/net/ethernet/broadcom/bcm63xx_enet.c: In function 'bcm_enet_start_xmit':
   drivers/net/ethernet/broadcom/bcm63xx_enet.c:583:9: warning: variable 'data' set but not used [-Wunused-but-set-variable]
     583 |   char *data;
         |         ^~~~
   drivers/net/ethernet/broadcom/bcm63xx_enet.c: In function 'bcm_enet_probe':
>> drivers/net/ethernet/broadcom/bcm63xx_enet.c:1807:4: error: 'phydev' undeclared (first use in this function); did you mean 'pdev'?
    1807 |    phydev = mdiobus_get_phy(bus, priv->phy_id);
         |    ^~~~~~
         |    pdev
   drivers/net/ethernet/broadcom/bcm63xx_enet.c:1807:4: note: each undeclared identifier is reported only once for each function it appears in


vim +1807 drivers/net/ethernet/broadcom/bcm63xx_enet.c

  1683	
  1684	/*
  1685	 * allocate netdevice, request register memory and register device.
  1686	 */
  1687	static int bcm_enet_probe(struct platform_device *pdev)
  1688	{
  1689		struct bcm_enet_priv *priv;
  1690		struct net_device *dev;
  1691		struct bcm63xx_enet_platform_data *pd;
  1692		struct resource *res_irq, *res_irq_rx, *res_irq_tx;
  1693		struct mii_bus *bus;
  1694		int i, ret;
  1695	
  1696		if (!bcm_enet_shared_base[0])
  1697			return -EPROBE_DEFER;
  1698	
  1699		res_irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
  1700		res_irq_rx = platform_get_resource(pdev, IORESOURCE_IRQ, 1);
  1701		res_irq_tx = platform_get_resource(pdev, IORESOURCE_IRQ, 2);
  1702		if (!res_irq || !res_irq_rx || !res_irq_tx)
  1703			return -ENODEV;
  1704	
  1705		dev = alloc_etherdev(sizeof(*priv));
  1706		if (!dev)
  1707			return -ENOMEM;
  1708		priv = netdev_priv(dev);
  1709	
  1710		priv->enet_is_sw = false;
  1711		priv->dma_maxburst = BCMENET_DMA_MAXBURST;
  1712	
  1713		ret = bcm_enet_change_mtu(dev, dev->mtu);
  1714		if (ret)
  1715			goto out;
  1716	
  1717		priv->base = devm_platform_ioremap_resource(pdev, 0);
  1718		if (IS_ERR(priv->base)) {
  1719			ret = PTR_ERR(priv->base);
  1720			goto out;
  1721		}
  1722	
  1723		dev->irq = priv->irq = res_irq->start;
  1724		priv->irq_rx = res_irq_rx->start;
  1725		priv->irq_tx = res_irq_tx->start;
  1726	
  1727		priv->mac_clk = devm_clk_get(&pdev->dev, "enet");
  1728		if (IS_ERR(priv->mac_clk)) {
  1729			ret = PTR_ERR(priv->mac_clk);
  1730			goto out;
  1731		}
  1732		ret = clk_prepare_enable(priv->mac_clk);
  1733		if (ret)
  1734			goto out;
  1735	
  1736		/* initialize default and fetch platform data */
  1737		priv->rx_ring_size = BCMENET_DEF_RX_DESC;
  1738		priv->tx_ring_size = BCMENET_DEF_TX_DESC;
  1739	
  1740		pd = dev_get_platdata(&pdev->dev);
  1741		if (pd) {
  1742			memcpy(dev->dev_addr, pd->mac_addr, ETH_ALEN);
  1743			priv->has_phy = pd->has_phy;
  1744			priv->phy_id = pd->phy_id;
  1745			priv->has_phy_interrupt = pd->has_phy_interrupt;
  1746			priv->phy_interrupt = pd->phy_interrupt;
  1747			priv->use_external_mii = !pd->use_internal_phy;
  1748			priv->pause_auto = pd->pause_auto;
  1749			priv->pause_rx = pd->pause_rx;
  1750			priv->pause_tx = pd->pause_tx;
  1751			priv->force_duplex_full = pd->force_duplex_full;
  1752			priv->force_speed_100 = pd->force_speed_100;
  1753			priv->dma_chan_en_mask = pd->dma_chan_en_mask;
  1754			priv->dma_chan_int_mask = pd->dma_chan_int_mask;
  1755			priv->dma_chan_width = pd->dma_chan_width;
  1756			priv->dma_has_sram = pd->dma_has_sram;
  1757			priv->dma_desc_shift = pd->dma_desc_shift;
  1758			priv->rx_chan = pd->rx_chan;
  1759			priv->tx_chan = pd->tx_chan;
  1760		}
  1761	
  1762		if (priv->has_phy && !priv->use_external_mii) {
  1763			/* using internal PHY, enable clock */
  1764			priv->phy_clk = devm_clk_get(&pdev->dev, "ephy");
  1765			if (IS_ERR(priv->phy_clk)) {
  1766				ret = PTR_ERR(priv->phy_clk);
  1767				priv->phy_clk = NULL;
  1768				goto out_disable_clk_mac;
  1769			}
  1770			ret = clk_prepare_enable(priv->phy_clk);
  1771			if (ret)
  1772				goto out_disable_clk_mac;
  1773		}
  1774	
  1775		/* do minimal hardware init to be able to probe mii bus */
  1776		bcm_enet_hw_preinit(priv);
  1777	
  1778		/* MII bus registration */
  1779		if (priv->has_phy) {
  1780	
  1781			priv->mii_bus = mdiobus_alloc();
  1782			if (!priv->mii_bus) {
  1783				ret = -ENOMEM;
  1784				goto out_uninit_hw;
  1785			}
  1786	
  1787			bus = priv->mii_bus;
  1788			bus->name = "bcm63xx_enet MII bus";
  1789			bus->parent = &pdev->dev;
  1790			bus->priv = priv;
  1791			bus->read = bcm_enet_mdio_read_phylib;
  1792			bus->write = bcm_enet_mdio_write_phylib;
  1793			sprintf(bus->id, "%s-%d", pdev->name, pdev->id);
  1794	
  1795			/* only probe bus where we think the PHY is, because
  1796			 * the mdio read operation return 0 instead of 0xffff
  1797			 * if a slave is not present on hw */
  1798			bus->phy_mask = ~(1 << priv->phy_id);
  1799	
  1800			ret = mdiobus_register(bus);
  1801			if (ret) {
  1802				dev_err(&pdev->dev, "unable to register mdio bus\n");
  1803				goto out_free_mdio;
  1804			}
  1805	
  1806			if (priv->has_phy_interrupt) {
> 1807				phydev = mdiobus_get_phy(bus, priv->phy_id);
  1808				if (!phydev) {
  1809					dev_err(&dev->dev, "no PHY found\n");
  1810					goto out_unregister_mdio;
  1811				}
  1812	
  1813				bus->irq[priv->phy_id] = priv->phy_interrupt;
  1814				phydev->irq = priv->phy_interrupt;
  1815			}
  1816		} else {
  1817	
  1818			/* run platform code to initialize PHY device */
  1819			if (pd && pd->mii_config &&
  1820			    pd->mii_config(dev, 1, bcm_enet_mdio_read_mii,
  1821					   bcm_enet_mdio_write_mii)) {
  1822				dev_err(&pdev->dev, "unable to configure mdio bus\n");
  1823				goto out_uninit_hw;
  1824			}
  1825		}
  1826	
  1827		spin_lock_init(&priv->rx_lock);
  1828	
  1829		/* init rx timeout (used for oom) */
  1830		timer_setup(&priv->rx_timeout, bcm_enet_refill_rx_timer, 0);
  1831	
  1832		/* init the mib update lock&work */
  1833		mutex_init(&priv->mib_update_lock);
  1834		INIT_WORK(&priv->mib_update_task, bcm_enet_update_mib_counters_defer);
  1835	
  1836		/* zero mib counters */
  1837		for (i = 0; i < ENET_MIB_REG_COUNT; i++)
  1838			enet_writel(priv, 0, ENET_MIB_REG(i));
  1839	
  1840		/* register netdevice */
  1841		dev->netdev_ops = &bcm_enet_ops;
  1842		netif_napi_add(dev, &priv->napi, bcm_enet_poll, 16);
  1843	
  1844		dev->ethtool_ops = &bcm_enet_ethtool_ops;
  1845		/* MTU range: 46 - 2028 */
  1846		dev->min_mtu = ETH_ZLEN - ETH_HLEN;
  1847		dev->max_mtu = BCMENET_MAX_MTU - VLAN_ETH_HLEN;
  1848		SET_NETDEV_DEV(dev, &pdev->dev);
  1849	
  1850		ret = register_netdev(dev);
  1851		if (ret)
  1852			goto out_unregister_mdio;
  1853	
  1854		netif_carrier_off(dev);
  1855		platform_set_drvdata(pdev, dev);
  1856		priv->pdev = pdev;
  1857		priv->net_dev = dev;
  1858	
  1859		return 0;
  1860	
  1861	out_unregister_mdio:
  1862		if (priv->mii_bus)
  1863			mdiobus_unregister(priv->mii_bus);
  1864	
  1865	out_free_mdio:
  1866		if (priv->mii_bus)
  1867			mdiobus_free(priv->mii_bus);
  1868	
  1869	out_uninit_hw:
  1870		/* turn off mdc clock */
  1871		enet_writel(priv, 0, ENET_MIISC_REG);
  1872		clk_disable_unprepare(priv->phy_clk);
  1873	
  1874	out_disable_clk_mac:
  1875		clk_disable_unprepare(priv->mac_clk);
  1876	out:
  1877		free_netdev(dev);
  1878		return ret;
  1879	}
  1880	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org

--a8Wt8u1KmwUX3Y2C
Content-Type: application/gzip
Content-Disposition: attachment; filename=".config.gz"
Content-Transfer-Encoding: base64

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

--a8Wt8u1KmwUX3Y2C--
