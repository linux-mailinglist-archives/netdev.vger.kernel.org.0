Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4B4E44B913C
	for <lists+netdev@lfdr.de>; Wed, 16 Feb 2022 20:34:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233326AbiBPTeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Feb 2022 14:34:05 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233203AbiBPTeE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Feb 2022 14:34:04 -0500
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B9BEC1F464D;
        Wed, 16 Feb 2022 11:33:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645040031; x=1676576031;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=vdbKgdDHdZFkbCvwB5I4kA5Ddz4ZRh56woj0KUxGhj0=;
  b=hkXPVTUKloqexR8PQHV1/f1mO/4wOO5Xo3HAKCzSQp6t/o1Zd+LpV2/9
   o07Kx42cWei93bgqOxLgrCS8MkaqzZ7T8MgwTM8dMKtwIMunpO6/JfMaA
   qs5YsGcgZ/beviocAlX6P/3TBkyDNtQLZscyOvwiCp3m3iM2jskj3wOg7
   cNOeyprbSe1VQItqEfIwvFo92EM4AlSD2ILMf4v7DVhoXnuwK9sSX0urd
   kWXwhj1ZCWI6e6pBRbf+uKM/vqBs2JbHpXBv59q+Nizhhh8VbFZJPvJgu
   WwXjxtt9rANwLlWDTtH4eBxkm14KifdK+bw920L+BRyafObBqqFK4dcQC
   A==;
X-IronPort-AV: E=McAfee;i="6200,9189,10260"; a="230669732"
X-IronPort-AV: E=Sophos;i="5.88,374,1635231600"; 
   d="scan'208";a="230669732"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 16 Feb 2022 11:33:51 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,374,1635231600"; 
   d="scan'208";a="571437048"
Received: from lkp-server01.sh.intel.com (HELO d95dc2dabeb1) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 16 Feb 2022 11:33:48 -0800
Received: from kbuild by d95dc2dabeb1 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nKQ3f-000B3n-D4; Wed, 16 Feb 2022 19:33:47 +0000
Date:   Thu, 17 Feb 2022 03:33:39 +0800
From:   kernel test robot <lkp@intel.com>
To:     Mans Rullgard <mans@mansr.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Juergen Borleis <kernel@pengutronix.de>,
        linux-kernel@vger.kernel.org
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: lan9303: add VLAN IDs to master device
Message-ID: <202202170327.RiXqUeGc-lkp@intel.com>
References: <20220216151111.6376-1-mans@mansr.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220216151111.6376-1-mans@mansr.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mans,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on linus/master]
[also build test ERROR on v5.17-rc4 next-20220216]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Mans-Rullgard/net-dsa-lan9303-add-VLAN-IDs-to-master-device/20220216-231201
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git c5d9ae265b105d9a67575fb67bd4650a6fc08e25
config: x86_64-randconfig-a005 (https://download.01.org/0day-ci/archive/20220217/202202170327.RiXqUeGc-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 0e628a783b935c70c80815db6c061ec84f884af5)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/960beb0e82f5d219a4f7e8bdcc49fb548a82a69d
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Mans-Rullgard/net-dsa-lan9303-add-VLAN-IDs-to-master-device/20220216-231201
        git checkout 960beb0e82f5d219a4f7e8bdcc49fb548a82a69d
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash drivers/net/dsa/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> drivers/net/dsa/lan9303-core.c:1095:2: error: implicit declaration of function 'vlan_vid_add' [-Werror,-Wimplicit-function-declaration]
           vlan_vid_add(cpu_dp->master, htons(ETH_P_8021Q), port);
           ^
>> drivers/net/dsa/lan9303-core.c:1111:2: error: implicit declaration of function 'vlan_vid_del' [-Werror,-Wimplicit-function-declaration]
           vlan_vid_del(cpu_dp->master, htons(ETH_P_8021Q), port);
           ^
   2 errors generated.


vim +/vlan_vid_add +1095 drivers/net/dsa/lan9303-core.c

  1082	
  1083	static int lan9303_port_enable(struct dsa_switch *ds, int port,
  1084				       struct phy_device *phy)
  1085	{
  1086		struct lan9303 *chip = ds->priv;
  1087		struct dsa_port *cpu_dp;
  1088	
  1089		if (!dsa_is_user_port(ds, port))
  1090			return 0;
  1091	
  1092		dsa_switch_for_each_cpu_port(cpu_dp, ds)
  1093			break;
  1094	
> 1095		vlan_vid_add(cpu_dp->master, htons(ETH_P_8021Q), port);
  1096	
  1097		return lan9303_enable_processing_port(chip, port);
  1098	}
  1099	
  1100	static void lan9303_port_disable(struct dsa_switch *ds, int port)
  1101	{
  1102		struct lan9303 *chip = ds->priv;
  1103		struct dsa_port *cpu_dp;
  1104	
  1105		if (!dsa_is_user_port(ds, port))
  1106			return;
  1107	
  1108		dsa_switch_for_each_cpu_port(cpu_dp, ds)
  1109			break;
  1110	
> 1111		vlan_vid_del(cpu_dp->master, htons(ETH_P_8021Q), port);
  1112	
  1113		lan9303_disable_processing_port(chip, port);
  1114		lan9303_phy_write(ds, chip->phy_addr_base + port, MII_BMCR, BMCR_PDOWN);
  1115	}
  1116	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
