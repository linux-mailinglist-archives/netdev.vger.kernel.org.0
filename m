Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DA57D538ADF
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 07:28:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243943AbiEaF2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 01:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38592 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236819AbiEaF2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 01:28:00 -0400
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24FF19155E
        for <netdev@vger.kernel.org>; Mon, 30 May 2022 22:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653974879; x=1685510879;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=Pla0/q/HQAKj+x+RZ8QfTMwgwx68UXha8hCNh8r5Vxw=;
  b=Z883Art19tJ7eZk6IWLpYo0raJrh9Aj0fZ7lJK47P7ZoddPM06qybqXJ
   p/IqdnvsxFomrQEUz49gX6twJtUpa0+izsauuYI2sam9jQ7szkq4a4Ikj
   AdrM6Dp9QWG/mQMk+u7O7lb8O4tOBTZyKK5OQ42/u09Ru0zC3bbmXhw2E
   re6CasRzbry//Li9HtpJR8wr7PURjH9NJ+BtupsICKXj6CQNKNJGIVwFS
   QLcMYZFj9nN6fUQkGb6y04gv5i62a/XFj1fCj9CmSHDt21Q428j153JLB
   XJ8OcCuL5wYVmUhndWdpDj9WV4t26ORvCBwZkZ6tDxTtXae0oowt9M4jd
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10363"; a="361519055"
X-IronPort-AV: E=Sophos;i="5.91,264,1647327600"; 
   d="scan'208";a="361519055"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 May 2022 22:27:58 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,264,1647327600"; 
   d="scan'208";a="754245519"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 30 May 2022 22:27:57 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nvuQ8-0002Mo-Ne;
        Tue, 31 May 2022 05:27:56 +0000
Date:   Tue, 31 May 2022 13:27:54 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, Jiawen Wu <jiawenwu@trustnetic.com>
Subject: Re: [PATCH net-next v4] net: txgbe: Add build support for txgbe
Message-ID: <202205311308.X0cnd1ha-lkp@intel.com>
References: <20220531032640.27678-1-jiawenwu@trustnetic.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220531032640.27678-1-jiawenwu@trustnetic.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jiawen,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Jiawen-Wu/net-txgbe-Add-build-support-for-txgbe/20220531-112035
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 7e062cda7d90543ac8c7700fc7c5527d0c0f22ad
config: alpha-defconfig (https://download.01.org/0day-ci/archive/20220531/202205311308.X0cnd1ha-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/52085d783a4667549a5f4224135c71c0a643bec0
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Jiawen-Wu/net-txgbe-Add-build-support-for-txgbe/20220531-112035
        git checkout 52085d783a4667549a5f4224135c71c0a643bec0
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=alpha SHELL=/bin/bash drivers/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/pci/quirks.c:5911:60: error: unterminated argument list invoking macro "DECLARE_PCI_FIXUP_HEADER"
    5911 | DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_WANGXUN, PCI_ANY_ID,
         |                                                            ^
>> drivers/pci/quirks.c:5911:1: error: expected '=', ',', ';', 'asm' or '__attribute__' at end of input
    5911 | DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_WANGXUN, PCI_ANY_ID,
         | ^~~~~~~~~~~~~~~~~~~~~~~~
   drivers/pci/quirks.c:5899:13: warning: 'quirk_wangxun_set_read_req_size' defined but not used [-Wunused-function]
    5899 | static void quirk_wangxun_set_read_req_size(struct pci_dev *pdev)
         |             ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/DECLARE_PCI_FIXUP_HEADER +5911 drivers/pci/quirks.c

  5898	
  5899	static void quirk_wangxun_set_read_req_size(struct pci_dev *pdev)
  5900	{
  5901		u16 ctl;
  5902	
  5903		pcie_capability_read_word(pdev, PCI_EXP_DEVCTL, &ctl);
  5904	
  5905		if (((ctl & PCI_EXP_DEVCTL_READRQ) != PCI_EXP_DEVCTL_READRQ_128B) &&
  5906		    ((ctl & PCI_EXP_DEVCTL_READRQ) != PCI_EXP_DEVCTL_READRQ_256B))
  5907			pcie_capability_clear_and_set_word(pdev, PCI_EXP_DEVCTL,
  5908							   PCI_EXP_DEVCTL_READRQ,
  5909							   PCI_EXP_DEVCTL_READRQ_256B);
  5910	}
> 5911	DECLARE_PCI_FIXUP_HEADER(PCI_VENDOR_ID_WANGXUN, PCI_ANY_ID,

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
