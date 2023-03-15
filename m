Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93EA16BBF81
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 22:57:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230036AbjCOV5N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 17:57:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjCOV5M (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 17:57:12 -0400
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A1B608B30A
        for <netdev@vger.kernel.org>; Wed, 15 Mar 2023 14:57:11 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1678917431; x=1710453431;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xmV4u+ctYnXUHofgFv2+KoJfIWPuXUyHMQ7/4Z77yYg=;
  b=ImSWPjwlAtpUJzUi0SUQwGIAVNRW+WuEQ9O/dvnNSHiECwCN0FLioi9+
   /ntXWEmCiy+f4Hzyp2pDiwc6wyAPKxHXZUKn+/npfkobNOnVjAKgQZkEX
   h1XeGRtSCQHKd9Yk52d/Juv7nQEktqHcMZoiPRXsRoVncvX9SUJaJWA0e
   kZ8bkVZGse65AVvP8FMrwP6Vf7/6Jt6UVsQMl4lVS88kMfubQpgupwoID
   n5KxnO76y2Iwp0EHU1op4nqQUEaComhotZ5IovR+Le4e59fO7s8tEAJ1E
   jdrA++omK9xnNc0RQKct0/5G4w/nTVK6ReZnVLfRQLlwpN7kzOdLU93ZV
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="326186046"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="326186046"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 15 Mar 2023 14:57:10 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10650"; a="789999462"
X-IronPort-AV: E=Sophos;i="5.98,262,1673942400"; 
   d="scan'208";a="789999462"
Received: from lkp-server01.sh.intel.com (HELO b613635ddfff) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 15 Mar 2023 14:57:09 -0700
Received: from kbuild by b613635ddfff with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pcZ7M-00083e-2w;
        Wed, 15 Mar 2023 21:57:08 +0000
Date:   Thu, 16 Mar 2023 05:56:59 +0800
From:   kernel test robot <lkp@intel.com>
To:     mengyuanlou <mengyuanlou@net-swift.com>, netdev@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, jiawenwu@trustnetic.com,
        mengyuanlou <mengyuanlou@net-swift.com>
Subject: Re: [PATCH net-next] net: wangxun: Remove macro that is redefined
Message-ID: <202303160530.zDOH600Q-lkp@intel.com>
References: <20230315091846.17314-1-mengyuanlou@net-swift.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230315091846.17314-1-mengyuanlou@net-swift.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi mengyuanlou,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/mengyuanlou/net-wangxun-Remove-macro-that-is-redefined/20230315-172033
patch link:    https://lore.kernel.org/r/20230315091846.17314-1-mengyuanlou%40net-swift.com
patch subject: [PATCH net-next] net: wangxun: Remove macro that is redefined
config: loongarch-allmodconfig (https://download.01.org/0day-ci/archive/20230316/202303160530.zDOH600Q-lkp@intel.com/config)
compiler: loongarch64-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/189cd0016c7fb0ad7ae6b2bc58f2247d40885a97
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review mengyuanlou/net-wangxun-Remove-macro-that-is-redefined/20230315-172033
        git checkout 189cd0016c7fb0ad7ae6b2bc58f2247d40885a97
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=loongarch SHELL=/bin/bash drivers/net/ethernet/wangxun/libwx/ drivers/net/ethernet/wangxun/txgbe/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202303160530.zDOH600Q-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/net/ethernet/wangxun/libwx/wx_hw.c: In function 'wx_sw_init':
>> drivers/net/ethernet/wangxun/libwx/wx_hw.c:1688:29: error: 'PCI_VENDOR_ID_WANGXUN' undeclared (first use in this function); did you mean 'PCI_VENDOR_ID_SAMSUNG'?
    1688 |         if (wx->oem_svid == PCI_VENDOR_ID_WANGXUN) {
         |                             ^~~~~~~~~~~~~~~~~~~~~
         |                             PCI_VENDOR_ID_SAMSUNG
   drivers/net/ethernet/wangxun/libwx/wx_hw.c:1688:29: note: each undeclared identifier is reported only once for each function it appears in
--
   In file included from drivers/net/ethernet/wangxun/txgbe/txgbe_main.c:6:
>> include/linux/pci.h:1018:19: error: 'PCI_VENDOR_ID_WANGXUN' undeclared here (not in a function); did you mean 'PCI_VENDOR_ID_SAMSUNG'?
    1018 |         .vendor = PCI_VENDOR_ID_##vend, .device = (dev), \
         |                   ^~~~~~~~~~~~~~
   drivers/net/ethernet/wangxun/txgbe/txgbe_main.c:31:11: note: in expansion of macro 'PCI_VDEVICE'
      31 |         { PCI_VDEVICE(WANGXUN, TXGBE_DEV_ID_SP1000), 0},
         |           ^~~~~~~~~~~


vim +1688 drivers/net/ethernet/wangxun/libwx/wx_hw.c

02338c484ab6250 Mengyuan Lou 2022-10-31  1673  
9607a3e62645c25 Jiawen Wu    2023-01-06  1674  int wx_sw_init(struct wx *wx)
a34b3e6ed8fbf66 Jiawen Wu    2022-10-27  1675  {
9607a3e62645c25 Jiawen Wu    2023-01-06  1676  	struct pci_dev *pdev = wx->pdev;
a34b3e6ed8fbf66 Jiawen Wu    2022-10-27  1677  	u32 ssid = 0;
a34b3e6ed8fbf66 Jiawen Wu    2022-10-27  1678  	int err = 0;
a34b3e6ed8fbf66 Jiawen Wu    2022-10-27  1679  
9607a3e62645c25 Jiawen Wu    2023-01-06  1680  	wx->vendor_id = pdev->vendor;
9607a3e62645c25 Jiawen Wu    2023-01-06  1681  	wx->device_id = pdev->device;
9607a3e62645c25 Jiawen Wu    2023-01-06  1682  	wx->revision_id = pdev->revision;
9607a3e62645c25 Jiawen Wu    2023-01-06  1683  	wx->oem_svid = pdev->subsystem_vendor;
9607a3e62645c25 Jiawen Wu    2023-01-06  1684  	wx->oem_ssid = pdev->subsystem_device;
9607a3e62645c25 Jiawen Wu    2023-01-06  1685  	wx->bus.device = PCI_SLOT(pdev->devfn);
9607a3e62645c25 Jiawen Wu    2023-01-06  1686  	wx->bus.func = PCI_FUNC(pdev->devfn);
9607a3e62645c25 Jiawen Wu    2023-01-06  1687  
9607a3e62645c25 Jiawen Wu    2023-01-06 @1688  	if (wx->oem_svid == PCI_VENDOR_ID_WANGXUN) {
9607a3e62645c25 Jiawen Wu    2023-01-06  1689  		wx->subsystem_vendor_id = pdev->subsystem_vendor;
9607a3e62645c25 Jiawen Wu    2023-01-06  1690  		wx->subsystem_device_id = pdev->subsystem_device;
a34b3e6ed8fbf66 Jiawen Wu    2022-10-27  1691  	} else {
9607a3e62645c25 Jiawen Wu    2023-01-06  1692  		err = wx_flash_read_dword(wx, 0xfffdc, &ssid);
a34b3e6ed8fbf66 Jiawen Wu    2022-10-27  1693  		if (!err)
9607a3e62645c25 Jiawen Wu    2023-01-06  1694  			wx->subsystem_device_id = swab16((u16)ssid);
a34b3e6ed8fbf66 Jiawen Wu    2022-10-27  1695  
a34b3e6ed8fbf66 Jiawen Wu    2022-10-27  1696  		return err;
a34b3e6ed8fbf66 Jiawen Wu    2022-10-27  1697  	}
a34b3e6ed8fbf66 Jiawen Wu    2022-10-27  1698  
9607a3e62645c25 Jiawen Wu    2023-01-06  1699  	wx->mac_table = kcalloc(wx->mac.num_rar_entries,
79625f45ca73ef3 Jiawen Wu    2023-01-06  1700  				sizeof(struct wx_mac_addr),
79625f45ca73ef3 Jiawen Wu    2023-01-06  1701  				GFP_KERNEL);
9607a3e62645c25 Jiawen Wu    2023-01-06  1702  	if (!wx->mac_table) {
9607a3e62645c25 Jiawen Wu    2023-01-06  1703  		wx_err(wx, "mac_table allocation failed\n");
79625f45ca73ef3 Jiawen Wu    2023-01-06  1704  		return -ENOMEM;
79625f45ca73ef3 Jiawen Wu    2023-01-06  1705  	}
79625f45ca73ef3 Jiawen Wu    2023-01-06  1706  
a34b3e6ed8fbf66 Jiawen Wu    2022-10-27  1707  	return 0;
a34b3e6ed8fbf66 Jiawen Wu    2022-10-27  1708  }
a34b3e6ed8fbf66 Jiawen Wu    2022-10-27  1709  EXPORT_SYMBOL(wx_sw_init);
a34b3e6ed8fbf66 Jiawen Wu    2022-10-27  1710  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
