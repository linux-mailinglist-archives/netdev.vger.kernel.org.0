Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43FB458F13A
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 19:09:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233282AbiHJRJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 13:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233363AbiHJRJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 13:09:19 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BA52E7968A
        for <netdev@vger.kernel.org>; Wed, 10 Aug 2022 10:09:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1660151357; x=1691687357;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=aJlOqWl4ARLfoDFjyMNCooHKMtINC/XL2bv9vB80dJo=;
  b=HEWn0K2emQtSFr1xPtleaOMi7NzZQWC/tJ1y2WZxpRW1vJORzBYXO8Re
   EyjPi6zYnR4Za/2uMzeQTaoWXr8prHDSrNyJdlcmsgc98djsgtEQuIAv+
   7a1XQ/rg4b4G/qniUVsrY6uxQjDvN4pi6C1Dk2l8rduaHQG+orrvir4F8
   TvgQfQngFwtbQEqMhgBC1YWTp9RZYzysV7EarGpfjfPLxIf+IOiVc/qcx
   BTAZqERzkIvGU7KiYSusahSJqZKSMinlPcEOiNxeLOwMFLAJZmKT5hsSB
   oQ77OYZE4g4e+PFC0vvuwGkVnxwgA/jDTtJp8BIUWJT68v4KNVx0K4WeB
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10435"; a="291143776"
X-IronPort-AV: E=Sophos;i="5.93,227,1654585200"; 
   d="scan'208";a="291143776"
Received: from orsmga004.jf.intel.com ([10.7.209.38])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Aug 2022 10:08:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,227,1654585200"; 
   d="scan'208";a="731564863"
Received: from lkp-server02.sh.intel.com (HELO 5d6b42aa80b8) ([10.239.97.151])
  by orsmga004.jf.intel.com with ESMTP; 10 Aug 2022 10:08:57 -0700
Received: from kbuild by 5d6b42aa80b8 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1oLpCS-0000Uz-1J;
        Wed, 10 Aug 2022 17:08:56 +0000
Date:   Thu, 11 Aug 2022 01:08:19 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mengyuan Lou <mengyuanlou@net-swift.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, jiawenwu@net-swift.com,
        Mengyuan Lou <mengyuanlou@net-swift.com>
Subject: Re: [PATCH net-next] net: ngbe: Add build support for ngbe
Message-ID: <202208110135.9PK79CPj-lkp@intel.com>
References: <20220808094113.9434-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220808094113.9434-1-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mengyuan,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Mengyuan-Lou/net-ngbe-Add-build-support-for-ngbe/20220808-174431
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git f86d1fbbe7858884d6754534a0afbb74fc30bc26
config: i386-allyesconfig (https://download.01.org/0day-ci/archive/20220811/202208110135.9PK79CPj-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.3.0-3) 11.3.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/b813046e2626a39496a064fb85ed44916289a4ee
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Mengyuan-Lou/net-ngbe-Add-build-support-for-ngbe/20220808-174431
        git checkout b813046e2626a39496a064fb85ed44916289a4ee
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   drivers/net/ethernet/wangxun/ngbe/ngbe_main.c: In function 'ngbe_probe':
>> drivers/net/ethernet/wangxun/ngbe/ngbe_main.c:105:42: error: 'ngbe_MAX_TX_QUEUES' undeclared (first use in this function); did you mean 'NGBE_MAX_TX_QUEUES'?
     105 |                                          ngbe_MAX_TX_QUEUES,
         |                                          ^~~~~~~~~~~~~~~~~~
         |                                          NGBE_MAX_TX_QUEUES
   drivers/net/ethernet/wangxun/ngbe/ngbe_main.c:105:42: note: each undeclared identifier is reported only once for each function it appears in
>> drivers/net/ethernet/wangxun/ngbe/ngbe_main.c:106:42: error: 'ngbe_MAX_RX_QUEUES' undeclared (first use in this function); did you mean 'NGBE_MAX_RX_QUEUES'?
     106 |                                          ngbe_MAX_RX_QUEUES);
         |                                          ^~~~~~~~~~~~~~~~~~
         |                                          NGBE_MAX_RX_QUEUES


vim +105 drivers/net/ethernet/wangxun/ngbe/ngbe_main.c

    61	
    62	/**
    63	 * ngbe_probe - Device Initialization Routine
    64	 * @pdev: PCI device information struct
    65	 * @ent: entry in ngbe_pci_tbl
    66	 *
    67	 * Returns 0 on success, negative on failure
    68	 *
    69	 * ngbe_probe initializes an adapter identified by a pci_dev structure.
    70	 * The OS initialization, configuring of the adapter private structure,
    71	 * and a hardware reset occur.
    72	 **/
    73	static int ngbe_probe(struct pci_dev *pdev,
    74			      const struct pci_device_id __always_unused *ent)
    75	{
    76		struct ngbe_adapter *adapter = NULL;
    77		struct net_device *netdev;
    78		int err;
    79	
    80		err = pci_enable_device_mem(pdev);
    81		if (err)
    82			return err;
    83	
    84		err = dma_set_mask_and_coherent(&pdev->dev, DMA_BIT_MASK(64));
    85		if (err) {
    86			dev_err(&pdev->dev,
    87				"No usable DMA configuration, aborting\n");
    88			goto err_pci_disable_dev;
    89		}
    90	
    91		err = pci_request_selected_regions(pdev,
    92						   pci_select_bars(pdev, IORESOURCE_MEM),
    93						   ngbe_driver_name);
    94		if (err) {
    95			dev_err(&pdev->dev,
    96				"pci_request_selected_regions failed 0x%x\n", err);
    97			goto err_pci_disable_dev;
    98		}
    99	
   100		pci_enable_pcie_error_reporting(pdev);
   101		pci_set_master(pdev);
   102	
   103		netdev = devm_alloc_etherdev_mqs(&pdev->dev,
   104						 sizeof(struct ngbe_adapter),
 > 105						 ngbe_MAX_TX_QUEUES,
 > 106						 ngbe_MAX_RX_QUEUES);
   107		if (!netdev) {
   108			err = -ENOMEM;
   109			goto err_pci_release_regions;
   110		}
   111	
   112		SET_NETDEV_DEV(netdev, &pdev->dev);
   113	
   114		adapter = netdev_priv(netdev);
   115		adapter->netdev = netdev;
   116		adapter->pdev = pdev;
   117	
   118		adapter->io_addr = devm_ioremap(&pdev->dev,
   119						pci_resource_start(pdev, 0),
   120						pci_resource_len(pdev, 0));
   121		if (!adapter->io_addr) {
   122			err = -EIO;
   123			goto err_pci_release_regions;
   124		}
   125	
   126		netdev->features |= NETIF_F_HIGHDMA;
   127	
   128		pci_set_drvdata(pdev, adapter);
   129	
   130		return 0;
   131	
   132	err_pci_release_regions:
   133		pci_disable_pcie_error_reporting(pdev);
   134		pci_release_selected_regions(pdev,
   135					     pci_select_bars(pdev, IORESOURCE_MEM));
   136	err_pci_disable_dev:
   137		pci_disable_device(pdev);
   138		return err;
   139	}
   140	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
