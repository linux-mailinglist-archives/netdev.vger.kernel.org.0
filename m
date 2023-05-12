Return-Path: <netdev+bounces-2018-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 115626FFFA1
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 06:20:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id B71702818CD
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 04:20:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B70B8A51;
	Fri, 12 May 2023 04:19:59 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5134A3C
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 04:19:59 +0000 (UTC)
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F023C7D97;
	Thu, 11 May 2023 21:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1683865181; x=1715401181;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=9fVYCoUOkPrB/HD+rOqjJUl91Xym0VZzb1G18ctyUJc=;
  b=aDpX778/IEoSKW/eem7BoBzF+GeFlgYXDBm7M7wwiWUszEAcJUO76V6t
   lv7/vmPJ7JCh7JU1FraY9vWmfkCPhtlpn0v3/FPfItLiRwQJLXIxwMb2l
   sbDpcXjR6QrLq9njRBqVUhtL4sXTP3Ym+fsGGKlf5Z6vAjabP+vScQ1tC
   L5m5SSaB0EbVRqkAc+GNlkHOTAQtjZ4J86LlsP/K/ExkU8su1j6Gbmy4P
   s9uRFueuTMwe6+dcPP9DhfBm+cwE/Pu6DsGB6O3VnAZvd7hoP8XTW6EIE
   j+iDI0sgUiq+eyXPhdky7MwfMEoOvt8msXADVTIUTzvh1JP0CBTbtGzaw
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="340007294"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="340007294"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 May 2023 21:19:40 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10707"; a="789650891"
X-IronPort-AV: E=Sophos;i="5.99,269,1677571200"; 
   d="scan'208";a="789650891"
Received: from lkp-server01.sh.intel.com (HELO dea6d5a4f140) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 11 May 2023 21:19:36 -0700
Received: from kbuild by dea6d5a4f140 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1pxKFj-0004V8-1t;
	Fri, 12 May 2023 04:19:35 +0000
Date: Fri, 12 May 2023 12:19:30 +0800
From: kernel test robot <lkp@intel.com>
To: alexis.lothore@bootlin.com, andrew@lunn.ch, f.fainelli@gmail.com,
	olteanv@gmail.com, davem@davemloft.net, edumazet@google.com,
	kuba@kernel.org, pabeni@redhat.com
Cc: oe-kbuild-all@lists.linux.dev, linux-renesas-soc@vger.kernel.org,
	netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
	thomas.petazzoni@bootlin.com, herve.codina@bootlin.com,
	miquel.raynal@bootlin.com, milan.stevanovic@se.com,
	jimmy.lalande@se.com, pascal.eberhard@se.com
Subject: Re: [PATCH net v2 1/3] net: dsa: rzn1-a5psw: enable management
 frames for CPU port
Message-ID: <202305121153.NMzdkguI-lkp@intel.com>
References: <20230511170202.742087-2-alexis.lothore@bootlin.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230511170202.742087-2-alexis.lothore@bootlin.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
	T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
	version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi,

kernel test robot noticed the following build errors:

[auto build test ERROR on net/main]

url:    https://github.com/intel-lab-lkp/linux/commits/alexis-lothore-bootlin-com/net-dsa-rzn1-a5psw-enable-management-frames-for-CPU-port/20230512-010530
base:   net/main
patch link:    https://lore.kernel.org/r/20230511170202.742087-2-alexis.lothore%40bootlin.com
patch subject: [PATCH net v2 1/3] net: dsa: rzn1-a5psw: enable management frames for CPU port
config: arm-allyesconfig (https://download.01.org/0day-ci/archive/20230512/202305121153.NMzdkguI-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/1a3acdd4d7ad50be9d4df989592327668610b13a
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review alexis-lothore-bootlin-com/net-dsa-rzn1-a5psw-enable-management-frames-for-CPU-port/20230512-010530
        git checkout 1a3acdd4d7ad50be9d4df989592327668610b13a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202305121153.NMzdkguI-lkp@intel.com/

All errors (new ones prefixed by >>):

   drivers/net/dsa/rzn1_a5psw.c: In function 'a5psw_setup':
>> drivers/net/dsa/rzn1_a5psw.c:676:32: error: 'A5PSW_MGMT_CFG_ENABLE' undeclared (first use in this function); did you mean 'A5PSW_MGMT_TAG_CFG_ENABLE'?
     676 |         reg = A5PSW_CPU_PORT | A5PSW_MGMT_CFG_ENABLE;
         |                                ^~~~~~~~~~~~~~~~~~~~~
         |                                A5PSW_MGMT_TAG_CFG_ENABLE
   drivers/net/dsa/rzn1_a5psw.c:676:32: note: each undeclared identifier is reported only once for each function it appears in


vim +676 drivers/net/dsa/rzn1_a5psw.c

   659	
   660	static int a5psw_setup(struct dsa_switch *ds)
   661	{
   662		struct a5psw *a5psw = ds->priv;
   663		int port, vlan, ret;
   664		struct dsa_port *dp;
   665		u32 reg;
   666	
   667		/* Validate that there is only 1 CPU port with index A5PSW_CPU_PORT */
   668		dsa_switch_for_each_cpu_port(dp, ds) {
   669			if (dp->index != A5PSW_CPU_PORT) {
   670				dev_err(a5psw->dev, "Invalid CPU port\n");
   671				return -EINVAL;
   672			}
   673		}
   674	
   675		/* Configure management port */
 > 676		reg = A5PSW_CPU_PORT | A5PSW_MGMT_CFG_ENABLE;
   677		a5psw_reg_writel(a5psw, A5PSW_MGMT_CFG, reg);
   678	
   679		/* Set pattern 0 to forward all frame to mgmt port */
   680		a5psw_reg_writel(a5psw, A5PSW_PATTERN_CTRL(A5PSW_PATTERN_MGMTFWD),
   681				 A5PSW_PATTERN_CTRL_MGMTFWD);
   682	
   683		/* Enable port tagging */
   684		reg = FIELD_PREP(A5PSW_MGMT_TAG_CFG_TAGFIELD, ETH_P_DSA_A5PSW);
   685		reg |= A5PSW_MGMT_TAG_CFG_ENABLE | A5PSW_MGMT_TAG_CFG_ALL_FRAMES;
   686		a5psw_reg_writel(a5psw, A5PSW_MGMT_TAG_CFG, reg);
   687	
   688		/* Enable normal switch operation */
   689		reg = A5PSW_LK_ADDR_CTRL_BLOCKING | A5PSW_LK_ADDR_CTRL_LEARNING |
   690		      A5PSW_LK_ADDR_CTRL_AGEING | A5PSW_LK_ADDR_CTRL_ALLOW_MIGR |
   691		      A5PSW_LK_ADDR_CTRL_CLEAR_TABLE;
   692		a5psw_reg_writel(a5psw, A5PSW_LK_CTRL, reg);
   693	
   694		ret = readl_poll_timeout(a5psw->base + A5PSW_LK_CTRL, reg,
   695					 !(reg & A5PSW_LK_ADDR_CTRL_CLEAR_TABLE),
   696					 A5PSW_LK_BUSY_USEC_POLL, A5PSW_CTRL_TIMEOUT);
   697		if (ret) {
   698			dev_err(a5psw->dev, "Failed to clear lookup table\n");
   699			return ret;
   700		}
   701	
   702		/* Reset learn count to 0 */
   703		reg = A5PSW_LK_LEARNCOUNT_MODE_SET;
   704		a5psw_reg_writel(a5psw, A5PSW_LK_LEARNCOUNT, reg);
   705	
   706		/* Clear VLAN resource table */
   707		reg = A5PSW_VLAN_RES_WR_PORTMASK | A5PSW_VLAN_RES_WR_TAGMASK;
   708		for (vlan = 0; vlan < A5PSW_VLAN_COUNT; vlan++)
   709			a5psw_reg_writel(a5psw, A5PSW_VLAN_RES(vlan), reg);
   710	
   711		/* Reset all ports */
   712		dsa_switch_for_each_port(dp, ds) {
   713			port = dp->index;
   714	
   715			/* Reset the port */
   716			a5psw_reg_writel(a5psw, A5PSW_CMD_CFG(port),
   717					 A5PSW_CMD_CFG_SW_RESET);
   718	
   719			/* Enable only CPU port */
   720			a5psw_port_enable_set(a5psw, port, dsa_port_is_cpu(dp));
   721	
   722			if (dsa_port_is_unused(dp))
   723				continue;
   724	
   725			/* Enable egress flooding for CPU port */
   726			if (dsa_port_is_cpu(dp))
   727				a5psw_flooding_set_resolution(a5psw, port, true);
   728	
   729			/* Enable management forward only for user ports */
   730			if (dsa_port_is_user(dp))
   731				a5psw_port_mgmtfwd_set(a5psw, port, true);
   732		}
   733	
   734		return 0;
   735	}
   736	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests

