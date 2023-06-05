Return-Path: <netdev+bounces-8182-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 36F27722FB4
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 21:21:30 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E0F832813F9
	for <lists+netdev@lfdr.de>; Mon,  5 Jun 2023 19:21:28 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4DA7624E8E;
	Mon,  5 Jun 2023 19:20:16 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D465DDC0
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 19:20:16 +0000 (UTC)
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75772E75
	for <netdev@vger.kernel.org>; Mon,  5 Jun 2023 12:19:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1685992798; x=1717528798;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=QuuEGQgCz3B33kFqSaXFVOytvjOjRaTsLr3VM/QlqeA=;
  b=I7sGgsj1gb+/2d+GgbMDBniMe1Udh+id1cqohs5T+h9eIEnn6ohzkE/X
   cZg3FDtRSZAnFXXi931/D8VVS5vk9vQwTKwGA9RGtFBrljRgFFflidVHu
   rlo/5gOCICDW+RdUv0PCk2i+YeQgK2HMVpk9oH28AnwEpZEPcYRcgDA3+
   aIFsNiSTa1mmGwRmQa5/tEuzjRyZ8u10wNkVCvcOSUmLOc70w77Te+7n4
   zv9sasdC2CyZaZJTzwGaUuESiZ1N1K/itcb9pj4H6QmfJ40/FsDZsXUQ7
   Gi9lDV3fU8X1TGyHinR65d69vcCdyDlYmB0Gsd7hzH3rQ25MYdIXCqEfL
   g==;
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="359771643"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="359771643"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 05 Jun 2023 12:18:22 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10732"; a="686227574"
X-IronPort-AV: E=Sophos;i="6.00,218,1681196400"; 
   d="scan'208";a="686227574"
Received: from lkp-server01.sh.intel.com (HELO 15ab08e44a81) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 05 Jun 2023 12:18:20 -0700
Received: from kbuild by 15ab08e44a81 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q6Fie-0004NW-0s;
	Mon, 05 Jun 2023 19:18:20 +0000
Date: Tue, 6 Jun 2023 03:17:47 +0800
From: kernel test robot <lkp@intel.com>
To: Maxime Chevallier <maxime.chevallier@bootlin.com>
Cc: oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org,
	Simon Horman <simon.horman@corigine.com>
Subject: [net-next:main 3/19]
 drivers/net/ethernet/altera/altera_tse_main.c:1419: undefined reference to
 `lynx_pcs_create_mdiodev'
Message-ID: <202306060325.l3TVneV8-lkp@intel.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
	autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git main
head:   69da40ac3481993d6f599c98e84fcdbbf0bcd7e0
commit: db48abbaa18e571106711b42affe68ca6f36ca5a [3/19] net: ethernet: altera-tse: Convert to mdio-regmap and use PCS Lynx
config: nios2-defconfig (https://download.01.org/0day-ci/archive/20230606/202306060325.l3TVneV8-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 12.3.0
reproduce (this is a W=1 build):
        mkdir -p ~/bin
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=db48abbaa18e571106711b42affe68ca6f36ca5a
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch --no-tags net-next main
        git checkout db48abbaa18e571106711b42affe68ca6f36ca5a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=nios2 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.3.0 ~/bin/make.cross W=1 O=build_dir ARCH=nios2 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306060325.l3TVneV8-lkp@intel.com/

All errors (new ones prefixed by >>):

   nios2-linux-ld: drivers/net/ethernet/altera/altera_tse_main.o: in function `altera_tse_probe':
>> drivers/net/ethernet/altera/altera_tse_main.c:1419: undefined reference to `lynx_pcs_create_mdiodev'
   drivers/net/ethernet/altera/altera_tse_main.c:1419:(.text+0xd7c): relocation truncated to fit: R_NIOS2_CALL26 against `lynx_pcs_create_mdiodev'
>> nios2-linux-ld: drivers/net/ethernet/altera/altera_tse_main.c:1451: undefined reference to `lynx_pcs_destroy'
   drivers/net/ethernet/altera/altera_tse_main.c:1451:(.text+0xdf8): relocation truncated to fit: R_NIOS2_CALL26 against `lynx_pcs_destroy'
   nios2-linux-ld: drivers/net/ethernet/altera/altera_tse_main.o: in function `altera_tse_remove':
>> drivers/net/ethernet/altera/altera_tse_main.c:1473: undefined reference to `lynx_pcs_destroy'
   drivers/net/ethernet/altera/altera_tse_main.c:1473:(.text+0x1564): relocation truncated to fit: R_NIOS2_CALL26 against `lynx_pcs_destroy'


vim +1419 drivers/net/ethernet/altera/altera_tse_main.c

  1131	
  1132	/* Probe Altera TSE MAC device
  1133	 */
  1134	static int altera_tse_probe(struct platform_device *pdev)
  1135	{
  1136		const struct of_device_id *of_id = NULL;
  1137		struct regmap_config pcs_regmap_cfg;
  1138		struct altera_tse_private *priv;
  1139		struct mdio_regmap_config mrc;
  1140		struct resource *control_port;
  1141		struct regmap *pcs_regmap;
  1142		struct resource *dma_res;
  1143		struct resource *pcs_res;
  1144		struct mii_bus *pcs_bus;
  1145		struct net_device *ndev;
  1146		void __iomem *descmap;
  1147		int ret = -ENODEV;
  1148	
  1149		ndev = alloc_etherdev(sizeof(struct altera_tse_private));
  1150		if (!ndev) {
  1151			dev_err(&pdev->dev, "Could not allocate network device\n");
  1152			return -ENODEV;
  1153		}
  1154	
  1155		SET_NETDEV_DEV(ndev, &pdev->dev);
  1156	
  1157		priv = netdev_priv(ndev);
  1158		priv->device = &pdev->dev;
  1159		priv->dev = ndev;
  1160		priv->msg_enable = netif_msg_init(debug, default_msg_level);
  1161	
  1162		of_id = of_match_device(altera_tse_ids, &pdev->dev);
  1163	
  1164		if (of_id)
  1165			priv->dmaops = (struct altera_dmaops *)of_id->data;
  1166	
  1167	
  1168		if (priv->dmaops &&
  1169		    priv->dmaops->altera_dtype == ALTERA_DTYPE_SGDMA) {
  1170			/* Get the mapped address to the SGDMA descriptor memory */
  1171			ret = request_and_map(pdev, "s1", &dma_res, &descmap);
  1172			if (ret)
  1173				goto err_free_netdev;
  1174	
  1175			/* Start of that memory is for transmit descriptors */
  1176			priv->tx_dma_desc = descmap;
  1177	
  1178			/* First half is for tx descriptors, other half for tx */
  1179			priv->txdescmem = resource_size(dma_res)/2;
  1180	
  1181			priv->txdescmem_busaddr = (dma_addr_t)dma_res->start;
  1182	
  1183			priv->rx_dma_desc = (void __iomem *)((uintptr_t)(descmap +
  1184							     priv->txdescmem));
  1185			priv->rxdescmem = resource_size(dma_res)/2;
  1186			priv->rxdescmem_busaddr = dma_res->start;
  1187			priv->rxdescmem_busaddr += priv->txdescmem;
  1188	
  1189			if (upper_32_bits(priv->rxdescmem_busaddr)) {
  1190				dev_dbg(priv->device,
  1191					"SGDMA bus addresses greater than 32-bits\n");
  1192				ret = -EINVAL;
  1193				goto err_free_netdev;
  1194			}
  1195			if (upper_32_bits(priv->txdescmem_busaddr)) {
  1196				dev_dbg(priv->device,
  1197					"SGDMA bus addresses greater than 32-bits\n");
  1198				ret = -EINVAL;
  1199				goto err_free_netdev;
  1200			}
  1201		} else if (priv->dmaops &&
  1202			   priv->dmaops->altera_dtype == ALTERA_DTYPE_MSGDMA) {
  1203			ret = request_and_map(pdev, "rx_resp", &dma_res,
  1204					      &priv->rx_dma_resp);
  1205			if (ret)
  1206				goto err_free_netdev;
  1207	
  1208			ret = request_and_map(pdev, "tx_desc", &dma_res,
  1209					      &priv->tx_dma_desc);
  1210			if (ret)
  1211				goto err_free_netdev;
  1212	
  1213			priv->txdescmem = resource_size(dma_res);
  1214			priv->txdescmem_busaddr = dma_res->start;
  1215	
  1216			ret = request_and_map(pdev, "rx_desc", &dma_res,
  1217					      &priv->rx_dma_desc);
  1218			if (ret)
  1219				goto err_free_netdev;
  1220	
  1221			priv->rxdescmem = resource_size(dma_res);
  1222			priv->rxdescmem_busaddr = dma_res->start;
  1223	
  1224		} else {
  1225			ret = -ENODEV;
  1226			goto err_free_netdev;
  1227		}
  1228	
  1229		if (!dma_set_mask(priv->device, DMA_BIT_MASK(priv->dmaops->dmamask))) {
  1230			dma_set_coherent_mask(priv->device,
  1231					      DMA_BIT_MASK(priv->dmaops->dmamask));
  1232		} else if (!dma_set_mask(priv->device, DMA_BIT_MASK(32))) {
  1233			dma_set_coherent_mask(priv->device, DMA_BIT_MASK(32));
  1234		} else {
  1235			ret = -EIO;
  1236			goto err_free_netdev;
  1237		}
  1238	
  1239		/* MAC address space */
  1240		ret = request_and_map(pdev, "control_port", &control_port,
  1241				      (void __iomem **)&priv->mac_dev);
  1242		if (ret)
  1243			goto err_free_netdev;
  1244	
  1245		/* xSGDMA Rx Dispatcher address space */
  1246		ret = request_and_map(pdev, "rx_csr", &dma_res,
  1247				      &priv->rx_dma_csr);
  1248		if (ret)
  1249			goto err_free_netdev;
  1250	
  1251	
  1252		/* xSGDMA Tx Dispatcher address space */
  1253		ret = request_and_map(pdev, "tx_csr", &dma_res,
  1254				      &priv->tx_dma_csr);
  1255		if (ret)
  1256			goto err_free_netdev;
  1257	
  1258		/* SGMII PCS address space. The location can vary depending on how the
  1259		 * IP is integrated. We can have a resource dedicated to it at a specific
  1260		 * address space, but if it's not the case, we fallback to the mdiophy0
  1261		 * from the MAC's address space
  1262		 */
  1263		ret = request_and_map(pdev, "pcs", &pcs_res, &priv->pcs_base);
  1264		if (ret) {
  1265			/* If we can't find a dedicated resource for the PCS, fallback
  1266			 * to the internal PCS, that has a different address stride
  1267			 */
  1268			priv->pcs_base = priv->mac_dev + tse_csroffs(mdio_phy0);
  1269			pcs_regmap_cfg.reg_bits = 32;
  1270			/* Values are MDIO-like values, on 16 bits */
  1271			pcs_regmap_cfg.val_bits = 16;
  1272			pcs_regmap_cfg.reg_shift = REGMAP_UPSHIFT(2);
  1273		} else {
  1274			pcs_regmap_cfg.reg_bits = 16;
  1275			pcs_regmap_cfg.val_bits = 16;
  1276			pcs_regmap_cfg.reg_shift = REGMAP_UPSHIFT(1);
  1277		}
  1278	
  1279		/* Create a regmap for the PCS so that it can be used by the PCS driver */
  1280		pcs_regmap = devm_regmap_init_mmio(&pdev->dev, priv->pcs_base,
  1281						   &pcs_regmap_cfg);
  1282		if (IS_ERR(pcs_regmap)) {
  1283			ret = PTR_ERR(pcs_regmap);
  1284			goto err_free_netdev;
  1285		}
  1286		mrc.regmap = pcs_regmap;
  1287		mrc.parent = &pdev->dev;
  1288		mrc.valid_addr = 0x0;
  1289	
  1290		/* Rx IRQ */
  1291		priv->rx_irq = platform_get_irq_byname(pdev, "rx_irq");
  1292		if (priv->rx_irq == -ENXIO) {
  1293			dev_err(&pdev->dev, "cannot obtain Rx IRQ\n");
  1294			ret = -ENXIO;
  1295			goto err_free_netdev;
  1296		}
  1297	
  1298		/* Tx IRQ */
  1299		priv->tx_irq = platform_get_irq_byname(pdev, "tx_irq");
  1300		if (priv->tx_irq == -ENXIO) {
  1301			dev_err(&pdev->dev, "cannot obtain Tx IRQ\n");
  1302			ret = -ENXIO;
  1303			goto err_free_netdev;
  1304		}
  1305	
  1306		/* get FIFO depths from device tree */
  1307		if (of_property_read_u32(pdev->dev.of_node, "rx-fifo-depth",
  1308					 &priv->rx_fifo_depth)) {
  1309			dev_err(&pdev->dev, "cannot obtain rx-fifo-depth\n");
  1310			ret = -ENXIO;
  1311			goto err_free_netdev;
  1312		}
  1313	
  1314		if (of_property_read_u32(pdev->dev.of_node, "tx-fifo-depth",
  1315					 &priv->tx_fifo_depth)) {
  1316			dev_err(&pdev->dev, "cannot obtain tx-fifo-depth\n");
  1317			ret = -ENXIO;
  1318			goto err_free_netdev;
  1319		}
  1320	
  1321		/* get hash filter settings for this instance */
  1322		priv->hash_filter =
  1323			of_property_read_bool(pdev->dev.of_node,
  1324					      "altr,has-hash-multicast-filter");
  1325	
  1326		/* Set hash filter to not set for now until the
  1327		 * multicast filter receive issue is debugged
  1328		 */
  1329		priv->hash_filter = 0;
  1330	
  1331		/* get supplemental address settings for this instance */
  1332		priv->added_unicast =
  1333			of_property_read_bool(pdev->dev.of_node,
  1334					      "altr,has-supplementary-unicast");
  1335	
  1336		priv->dev->min_mtu = ETH_ZLEN + ETH_FCS_LEN;
  1337		/* Max MTU is 1500, ETH_DATA_LEN */
  1338		priv->dev->max_mtu = ETH_DATA_LEN;
  1339	
  1340		/* Get the max mtu from the device tree. Note that the
  1341		 * "max-frame-size" parameter is actually max mtu. Definition
  1342		 * in the ePAPR v1.1 spec and usage differ, so go with usage.
  1343		 */
  1344		of_property_read_u32(pdev->dev.of_node, "max-frame-size",
  1345				     &priv->dev->max_mtu);
  1346	
  1347		/* The DMA buffer size already accounts for an alignment bias
  1348		 * to avoid unaligned access exceptions for the NIOS processor,
  1349		 */
  1350		priv->rx_dma_buf_sz = ALTERA_RXDMABUFFER_SIZE;
  1351	
  1352		/* get default MAC address from device tree */
  1353		ret = of_get_ethdev_address(pdev->dev.of_node, ndev);
  1354		if (ret)
  1355			eth_hw_addr_random(ndev);
  1356	
  1357		/* get phy addr and create mdio */
  1358		ret = altera_tse_phy_get_addr_mdio_create(ndev);
  1359	
  1360		if (ret)
  1361			goto err_free_netdev;
  1362	
  1363		/* initialize netdev */
  1364		ndev->mem_start = control_port->start;
  1365		ndev->mem_end = control_port->end;
  1366		ndev->netdev_ops = &altera_tse_netdev_ops;
  1367		altera_tse_set_ethtool_ops(ndev);
  1368	
  1369		altera_tse_netdev_ops.ndo_set_rx_mode = tse_set_rx_mode;
  1370	
  1371		if (priv->hash_filter)
  1372			altera_tse_netdev_ops.ndo_set_rx_mode =
  1373				tse_set_rx_mode_hashfilter;
  1374	
  1375		/* Scatter/gather IO is not supported,
  1376		 * so it is turned off
  1377		 */
  1378		ndev->hw_features &= ~NETIF_F_SG;
  1379		ndev->features |= ndev->hw_features | NETIF_F_HIGHDMA;
  1380	
  1381		/* VLAN offloading of tagging, stripping and filtering is not
  1382		 * supported by hardware, but driver will accommodate the
  1383		 * extra 4-byte VLAN tag for processing by upper layers
  1384		 */
  1385		ndev->features |= NETIF_F_HW_VLAN_CTAG_RX;
  1386	
  1387		/* setup NAPI interface */
  1388		netif_napi_add(ndev, &priv->napi, tse_poll);
  1389	
  1390		spin_lock_init(&priv->mac_cfg_lock);
  1391		spin_lock_init(&priv->tx_lock);
  1392		spin_lock_init(&priv->rxdma_irq_lock);
  1393	
  1394		netif_carrier_off(ndev);
  1395		ret = register_netdev(ndev);
  1396		if (ret) {
  1397			dev_err(&pdev->dev, "failed to register TSE net device\n");
  1398			goto err_register_netdev;
  1399		}
  1400	
  1401		platform_set_drvdata(pdev, ndev);
  1402	
  1403		priv->revision = ioread32(&priv->mac_dev->megacore_revision);
  1404	
  1405		if (netif_msg_probe(priv))
  1406			dev_info(&pdev->dev, "Altera TSE MAC version %d.%d at 0x%08lx irq %d/%d\n",
  1407				 (priv->revision >> 8) & 0xff,
  1408				 priv->revision & 0xff,
  1409				 (unsigned long) control_port->start, priv->rx_irq,
  1410				 priv->tx_irq);
  1411	
  1412		snprintf(mrc.name, MII_BUS_ID_SIZE, "%s-pcs-mii", ndev->name);
  1413		pcs_bus = devm_mdio_regmap_register(&pdev->dev, &mrc);
  1414		if (IS_ERR(pcs_bus)) {
  1415			ret = PTR_ERR(pcs_bus);
  1416			goto err_init_pcs;
  1417		}
  1418	
> 1419		priv->pcs = lynx_pcs_create_mdiodev(pcs_bus, 0);
  1420		if (IS_ERR(priv->pcs)) {
  1421			ret = PTR_ERR(priv->pcs);
  1422			goto err_init_pcs;
  1423		}
  1424	
  1425		priv->phylink_config.dev = &ndev->dev;
  1426		priv->phylink_config.type = PHYLINK_NETDEV;
  1427		priv->phylink_config.mac_capabilities = MAC_SYM_PAUSE | MAC_10 |
  1428							MAC_100 | MAC_1000FD;
  1429	
  1430		phy_interface_set_rgmii(priv->phylink_config.supported_interfaces);
  1431		__set_bit(PHY_INTERFACE_MODE_MII,
  1432			  priv->phylink_config.supported_interfaces);
  1433		__set_bit(PHY_INTERFACE_MODE_GMII,
  1434			  priv->phylink_config.supported_interfaces);
  1435		__set_bit(PHY_INTERFACE_MODE_SGMII,
  1436			  priv->phylink_config.supported_interfaces);
  1437		__set_bit(PHY_INTERFACE_MODE_1000BASEX,
  1438			  priv->phylink_config.supported_interfaces);
  1439	
  1440		priv->phylink = phylink_create(&priv->phylink_config,
  1441					       of_fwnode_handle(priv->device->of_node),
  1442					       priv->phy_iface, &alt_tse_phylink_ops);
  1443		if (IS_ERR(priv->phylink)) {
  1444			dev_err(&pdev->dev, "failed to create phylink\n");
  1445			ret = PTR_ERR(priv->phylink);
  1446			goto err_init_phylink;
  1447		}
  1448	
  1449		return 0;
  1450	err_init_phylink:
> 1451		lynx_pcs_destroy(priv->pcs);
  1452	err_init_pcs:
  1453		unregister_netdev(ndev);
  1454	err_register_netdev:
  1455		netif_napi_del(&priv->napi);
  1456		altera_tse_mdio_destroy(ndev);
  1457	err_free_netdev:
  1458		free_netdev(ndev);
  1459		return ret;
  1460	}
  1461	
  1462	/* Remove Altera TSE MAC device
  1463	 */
  1464	static int altera_tse_remove(struct platform_device *pdev)
  1465	{
  1466		struct net_device *ndev = platform_get_drvdata(pdev);
  1467		struct altera_tse_private *priv = netdev_priv(ndev);
  1468	
  1469		platform_set_drvdata(pdev, NULL);
  1470		altera_tse_mdio_destroy(ndev);
  1471		unregister_netdev(ndev);
  1472		phylink_destroy(priv->phylink);
> 1473		lynx_pcs_destroy(priv->pcs);
  1474	
  1475		free_netdev(ndev);
  1476	
  1477		return 0;
  1478	}
  1479	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

