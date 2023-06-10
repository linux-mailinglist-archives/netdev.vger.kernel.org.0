Return-Path: <netdev+bounces-9779-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 908EC72A89B
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 05:02:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id BD07F281AA8
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 03:02:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id BEC8F1FCA;
	Sat, 10 Jun 2023 03:02:13 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AC1C31FA9
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 03:02:13 +0000 (UTC)
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 26A083AAC
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 20:02:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1686366130; x=1717902130;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=tWimKZqP6OqLgt04lsDsqq4aDGgvzCAjmOwBMwNqJIY=;
  b=NGPxoBl20OnUa5TOz9TWf8s994arFQxj4IW8rdPRCOALmtBHMeX8Npn5
   R5FLXqOWKGfHcq7bD2D04aTjOgIHQcnJNPM9xXnKV7wjB6EkKTpF4bofB
   tXnIUBdN1T0yzZtvT14abgrJjH0Gs09wQmvG5HLhu4Jqa5gtz+bjYs7QI
   cTKOf+Z9BfjbECK44FlZOAhqz1bz11gv9uW727FGVVK9L8yNp7PGFMwyR
   XNsB9z++Bb9dFq7lvT9Bhy8Fo6R33mkEeMCNy4A/44h3gcquqmHEBGIh1
   t6FbKMbMcAcZrOZccMay+MZM4KSlfzcaYbu4rGVbd6eSx7AxA+Ani7Hwd
   w==;
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="356617545"
X-IronPort-AV: E=Sophos;i="6.00,231,1681196400"; 
   d="scan'208";a="356617545"
Received: from fmsmga006.fm.intel.com ([10.253.24.20])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 09 Jun 2023 20:02:09 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6600,9927,10736"; a="957354834"
X-IronPort-AV: E=Sophos;i="6.00,231,1681196400"; 
   d="scan'208";a="957354834"
Received: from lkp-server01.sh.intel.com (HELO 15ab08e44a81) ([10.239.97.150])
  by fmsmga006.fm.intel.com with ESMTP; 09 Jun 2023 20:02:07 -0700
Received: from kbuild by 15ab08e44a81 with local (Exim 4.96)
	(envelope-from <lkp@intel.com>)
	id 1q7ore-0009dR-1e;
	Sat, 10 Jun 2023 03:02:06 +0000
Date: Sat, 10 Jun 2023 11:01:38 +0800
From: kernel test robot <lkp@intel.com>
To: Simon Horman <horms@kernel.org>, Ariel Elior <aelior@marvell.com>,
	Sudarsana Kalluru <skalluru@marvell.com>,
	Manish Chopra <manishc@marvell.com>
Cc: oe-kbuild-all@lists.linux.dev, Eric Dumazet <edumazet@google.com>,
	Jakub Kicinski <kuba@kernel.org>, Paolo Abeni <pabeni@redhat.com>,
	netdev@vger.kernel.org
Subject: Re: [PATCH net-next] bnx2x: Make dmae_reg_go_c static
Message-ID: <202306101031.iF29XzEV-lkp@intel.com>
References: <20230609-bnx2x-static-v1-1-6c1a6888d227@kernel.org>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230609-bnx2x-static-v1-1-6c1a6888d227@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
	SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

Hi Simon,

kernel test robot noticed the following build errors:

[auto build test ERROR on net-next/main]

url:    https://github.com/intel-lab-lkp/linux/commits/Simon-Horman/bnx2x-Make-dmae_reg_go_c-static/20230609-215242
base:   net-next/main
patch link:    https://lore.kernel.org/r/20230609-bnx2x-static-v1-1-6c1a6888d227%40kernel.org
patch subject: [PATCH net-next] bnx2x: Make dmae_reg_go_c static
config: x86_64-kexec (https://download.01.org/0day-ci/archive/20230610/202306101031.iF29XzEV-lkp@intel.com/config)
compiler: gcc-12 (Debian 12.2.0-14) 12.2.0
reproduce (this is a W=1 build):
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch net-next main
        git checkout net-next/main
        b4 shazam https://lore.kernel.org/r/20230609-bnx2x-static-v1-1-6c1a6888d227@kernel.org
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 olddefconfig
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash

If you fix the issue in a separate patch/commit (i.e. not just a new version of
the same patch/commit), kindly add following tags
| Reported-by: kernel test robot <lkp@intel.com>
| Closes: https://lore.kernel.org/oe-kbuild-all/202306101031.iF29XzEV-lkp@intel.com/

All errors (new ones prefixed by >>):

   ld: vmlinux.o: in function `bnx2x_port_stats_init':
>> drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c:297: undefined reference to `dmae_reg_go_c'
>> ld: drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c:311: undefined reference to `dmae_reg_go_c'
   ld: drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c:333: undefined reference to `dmae_reg_go_c'
   ld: drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c:422: undefined reference to `dmae_reg_go_c'
   ld: drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c:453: undefined reference to `dmae_reg_go_c'
   ld: vmlinux.o:drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c:1292: more undefined references to `dmae_reg_go_c' follow


vim +297 drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c

6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  266  
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  267  static void bnx2x_port_stats_init(struct bnx2x *bp)
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  268  {
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  269  	struct dmae_command *dmae;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  270  	int port = BP_PORT(bp);
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  271  	u32 opcode;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  272  	int loader_idx = PMF_DMAE_C(bp);
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  273  	u32 mac_addr;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  274  	u32 *stats_comp = bnx2x_sp(bp, stats_comp);
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  275  
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  276  	/* sanity */
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  277  	if (!bp->link_vars.link_up || !bp->port.pmf) {
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  278  		BNX2X_ERR("BUG!\n");
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  279  		return;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  280  	}
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  281  
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  282  	bp->executer_idx = 0;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  283  
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  284  	/* MCP */
f2e0899f0f275c drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-10-06  285  	opcode = bnx2x_dmae_opcode(bp, DMAE_SRC_PCI, DMAE_DST_GRC,
f2e0899f0f275c drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-10-06  286  				    true, DMAE_COMP_GRC);
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  287  
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  288  	if (bp->port.port_stx) {
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  289  
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  290  		dmae = bnx2x_sp(bp, dmae[bp->executer_idx++]);
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  291  		dmae->opcode = opcode;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  292  		dmae->src_addr_lo = U64_LO(bnx2x_sp_mapping(bp, port_stats));
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  293  		dmae->src_addr_hi = U64_HI(bnx2x_sp_mapping(bp, port_stats));
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  294  		dmae->dst_addr_lo = bp->port.port_stx >> 2;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  295  		dmae->dst_addr_hi = 0;
1d187b34daaecb drivers/net/ethernet/broadcom/bnx2x/bnx2x_stats.c Barak Witkowski 2011-12-05  296  		dmae->len = bnx2x_get_port_stats_dma_len(bp);
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27 @297  		dmae->comp_addr_lo = dmae_reg_go_c[loader_idx] >> 2;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  298  		dmae->comp_addr_hi = 0;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  299  		dmae->comp_val = 1;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  300  	}
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  301  
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  302  	if (bp->func_stx) {
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  303  
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  304  		dmae = bnx2x_sp(bp, dmae[bp->executer_idx++]);
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  305  		dmae->opcode = opcode;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  306  		dmae->src_addr_lo = U64_LO(bnx2x_sp_mapping(bp, func_stats));
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  307  		dmae->src_addr_hi = U64_HI(bnx2x_sp_mapping(bp, func_stats));
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  308  		dmae->dst_addr_lo = bp->func_stx >> 2;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  309  		dmae->dst_addr_hi = 0;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  310  		dmae->len = sizeof(struct host_func_stats) >> 2;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27 @311  		dmae->comp_addr_lo = dmae_reg_go_c[loader_idx] >> 2;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  312  		dmae->comp_addr_hi = 0;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  313  		dmae->comp_val = 1;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  314  	}
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  315  
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  316  	/* MAC */
f2e0899f0f275c drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-10-06  317  	opcode = bnx2x_dmae_opcode(bp, DMAE_SRC_GRC, DMAE_DST_PCI,
f2e0899f0f275c drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-10-06  318  				   true, DMAE_COMP_GRC);
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  319  
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  320  	/* EMAC is special */
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  321  	if (bp->link_vars.mac_type == MAC_TYPE_EMAC) {
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  322  		mac_addr = (port ? GRCBASE_EMAC1 : GRCBASE_EMAC0);
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  323  
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  324  		/* EMAC_REG_EMAC_RX_STAT_AC (EMAC_REG_EMAC_RX_STAT_AC_COUNT)*/
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  325  		dmae = bnx2x_sp(bp, dmae[bp->executer_idx++]);
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  326  		dmae->opcode = opcode;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  327  		dmae->src_addr_lo = (mac_addr +
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  328  				     EMAC_REG_EMAC_RX_STAT_AC) >> 2;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  329  		dmae->src_addr_hi = 0;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  330  		dmae->dst_addr_lo = U64_LO(bnx2x_sp_mapping(bp, mac_stats));
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  331  		dmae->dst_addr_hi = U64_HI(bnx2x_sp_mapping(bp, mac_stats));
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  332  		dmae->len = EMAC_REG_EMAC_RX_STAT_AC_COUNT;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  333  		dmae->comp_addr_lo = dmae_reg_go_c[loader_idx] >> 2;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  334  		dmae->comp_addr_hi = 0;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  335  		dmae->comp_val = 1;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  336  
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  337  		/* EMAC_REG_EMAC_RX_STAT_AC_28 */
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  338  		dmae = bnx2x_sp(bp, dmae[bp->executer_idx++]);
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  339  		dmae->opcode = opcode;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  340  		dmae->src_addr_lo = (mac_addr +
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  341  				     EMAC_REG_EMAC_RX_STAT_AC_28) >> 2;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  342  		dmae->src_addr_hi = 0;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  343  		dmae->dst_addr_lo = U64_LO(bnx2x_sp_mapping(bp, mac_stats) +
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  344  		     offsetof(struct emac_stats, rx_stat_falsecarriererrors));
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  345  		dmae->dst_addr_hi = U64_HI(bnx2x_sp_mapping(bp, mac_stats) +
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  346  		     offsetof(struct emac_stats, rx_stat_falsecarriererrors));
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  347  		dmae->len = 1;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  348  		dmae->comp_addr_lo = dmae_reg_go_c[loader_idx] >> 2;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  349  		dmae->comp_addr_hi = 0;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  350  		dmae->comp_val = 1;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  351  
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  352  		/* EMAC_REG_EMAC_TX_STAT_AC (EMAC_REG_EMAC_TX_STAT_AC_COUNT)*/
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  353  		dmae = bnx2x_sp(bp, dmae[bp->executer_idx++]);
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  354  		dmae->opcode = opcode;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  355  		dmae->src_addr_lo = (mac_addr +
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  356  				     EMAC_REG_EMAC_TX_STAT_AC) >> 2;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  357  		dmae->src_addr_hi = 0;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  358  		dmae->dst_addr_lo = U64_LO(bnx2x_sp_mapping(bp, mac_stats) +
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  359  			offsetof(struct emac_stats, tx_stat_ifhcoutoctets));
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  360  		dmae->dst_addr_hi = U64_HI(bnx2x_sp_mapping(bp, mac_stats) +
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  361  			offsetof(struct emac_stats, tx_stat_ifhcoutoctets));
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  362  		dmae->len = EMAC_REG_EMAC_TX_STAT_AC_COUNT;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  363  		dmae->comp_addr_lo = dmae_reg_go_c[loader_idx] >> 2;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  364  		dmae->comp_addr_hi = 0;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  365  		dmae->comp_val = 1;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  366  	} else {
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  367  		u32 tx_src_addr_lo, rx_src_addr_lo;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  368  		u16 rx_len, tx_len;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  369  
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  370  		/* configure the params according to MAC type */
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  371  		switch (bp->link_vars.mac_type) {
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  372  		case MAC_TYPE_BMAC:
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  373  			mac_addr = (port ? NIG_REG_INGRESS_BMAC1_MEM :
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  374  					   NIG_REG_INGRESS_BMAC0_MEM);
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  375  
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  376  			/* BIGMAC_REGISTER_TX_STAT_GTPKT ..
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  377  			   BIGMAC_REGISTER_TX_STAT_GTBYT */
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  378  			if (CHIP_IS_E1x(bp)) {
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  379  				tx_src_addr_lo = (mac_addr +
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  380  					BIGMAC_REGISTER_TX_STAT_GTPKT) >> 2;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  381  				tx_len = (8 + BIGMAC_REGISTER_TX_STAT_GTBYT -
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  382  					  BIGMAC_REGISTER_TX_STAT_GTPKT) >> 2;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  383  				rx_src_addr_lo = (mac_addr +
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  384  					BIGMAC_REGISTER_RX_STAT_GR64) >> 2;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  385  				rx_len = (8 + BIGMAC_REGISTER_RX_STAT_GRIPJ -
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  386  					  BIGMAC_REGISTER_RX_STAT_GR64) >> 2;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  387  			} else {
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  388  				tx_src_addr_lo = (mac_addr +
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  389  					BIGMAC2_REGISTER_TX_STAT_GTPOK) >> 2;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  390  				tx_len = (8 + BIGMAC2_REGISTER_TX_STAT_GTBYT -
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  391  					  BIGMAC2_REGISTER_TX_STAT_GTPOK) >> 2;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  392  				rx_src_addr_lo = (mac_addr +
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  393  					BIGMAC2_REGISTER_RX_STAT_GR64) >> 2;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  394  				rx_len = (8 + BIGMAC2_REGISTER_RX_STAT_GRIPJ -
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  395  					  BIGMAC2_REGISTER_RX_STAT_GR64) >> 2;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  396  			}
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  397  			break;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  398  
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  399  		case MAC_TYPE_UMAC: /* handled by MSTAT */
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  400  		case MAC_TYPE_XMAC: /* handled by MSTAT */
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  401  		default:
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  402  			mac_addr = port ? GRCBASE_MSTAT1 : GRCBASE_MSTAT0;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  403  			tx_src_addr_lo = (mac_addr +
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  404  					  MSTAT_REG_TX_STAT_GTXPOK_LO) >> 2;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  405  			rx_src_addr_lo = (mac_addr +
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  406  					  MSTAT_REG_RX_STAT_GR64_LO) >> 2;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  407  			tx_len = sizeof(bp->slowpath->
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  408  					mac_stats.mstat_stats.stats_tx) >> 2;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  409  			rx_len = sizeof(bp->slowpath->
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  410  					mac_stats.mstat_stats.stats_rx) >> 2;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  411  			break;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  412  		}
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  413  
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  414  		/* TX stats */
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  415  		dmae = bnx2x_sp(bp, dmae[bp->executer_idx++]);
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  416  		dmae->opcode = opcode;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  417  		dmae->src_addr_lo = tx_src_addr_lo;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  418  		dmae->src_addr_hi = 0;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  419  		dmae->len = tx_len;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  420  		dmae->dst_addr_lo = U64_LO(bnx2x_sp_mapping(bp, mac_stats));
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  421  		dmae->dst_addr_hi = U64_HI(bnx2x_sp_mapping(bp, mac_stats));
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  422  		dmae->comp_addr_lo = dmae_reg_go_c[loader_idx] >> 2;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  423  		dmae->comp_addr_hi = 0;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  424  		dmae->comp_val = 1;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  425  
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  426  		/* RX stats */
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  427  		dmae = bnx2x_sp(bp, dmae[bp->executer_idx++]);
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  428  		dmae->opcode = opcode;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  429  		dmae->src_addr_hi = 0;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  430  		dmae->src_addr_lo = rx_src_addr_lo;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  431  		dmae->dst_addr_lo =
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  432  			U64_LO(bnx2x_sp_mapping(bp, mac_stats) + (tx_len << 2));
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  433  		dmae->dst_addr_hi =
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  434  			U64_HI(bnx2x_sp_mapping(bp, mac_stats) + (tx_len << 2));
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  435  		dmae->len = rx_len;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  436  		dmae->comp_addr_lo = dmae_reg_go_c[loader_idx] >> 2;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  437  		dmae->comp_addr_hi = 0;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  438  		dmae->comp_val = 1;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  439  	}
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  440  
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  441  	/* NIG */
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  442  	if (!CHIP_IS_E3(bp)) {
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  443  		dmae = bnx2x_sp(bp, dmae[bp->executer_idx++]);
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  444  		dmae->opcode = opcode;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  445  		dmae->src_addr_lo = (port ? NIG_REG_STAT1_EGRESS_MAC_PKT0 :
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  446  					    NIG_REG_STAT0_EGRESS_MAC_PKT0) >> 2;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  447  		dmae->src_addr_hi = 0;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  448  		dmae->dst_addr_lo = U64_LO(bnx2x_sp_mapping(bp, nig_stats) +
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  449  				offsetof(struct nig_stats, egress_mac_pkt0_lo));
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  450  		dmae->dst_addr_hi = U64_HI(bnx2x_sp_mapping(bp, nig_stats) +
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  451  				offsetof(struct nig_stats, egress_mac_pkt0_lo));
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  452  		dmae->len = (2*sizeof(u32)) >> 2;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  453  		dmae->comp_addr_lo = dmae_reg_go_c[loader_idx] >> 2;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  454  		dmae->comp_addr_hi = 0;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  455  		dmae->comp_val = 1;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  456  
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  457  		dmae = bnx2x_sp(bp, dmae[bp->executer_idx++]);
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  458  		dmae->opcode = opcode;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  459  		dmae->src_addr_lo = (port ? NIG_REG_STAT1_EGRESS_MAC_PKT1 :
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  460  					    NIG_REG_STAT0_EGRESS_MAC_PKT1) >> 2;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  461  		dmae->src_addr_hi = 0;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  462  		dmae->dst_addr_lo = U64_LO(bnx2x_sp_mapping(bp, nig_stats) +
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  463  				offsetof(struct nig_stats, egress_mac_pkt1_lo));
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  464  		dmae->dst_addr_hi = U64_HI(bnx2x_sp_mapping(bp, nig_stats) +
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  465  				offsetof(struct nig_stats, egress_mac_pkt1_lo));
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  466  		dmae->len = (2*sizeof(u32)) >> 2;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  467  		dmae->comp_addr_lo = dmae_reg_go_c[loader_idx] >> 2;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  468  		dmae->comp_addr_hi = 0;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  469  		dmae->comp_val = 1;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  470  	}
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  471  
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  472  	dmae = bnx2x_sp(bp, dmae[bp->executer_idx++]);
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  473  	dmae->opcode = bnx2x_dmae_opcode(bp, DMAE_SRC_GRC, DMAE_DST_PCI,
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  474  						 true, DMAE_COMP_PCI);
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  475  	dmae->src_addr_lo = (port ? NIG_REG_STAT1_BRB_DISCARD :
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  476  				    NIG_REG_STAT0_BRB_DISCARD) >> 2;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  477  	dmae->src_addr_hi = 0;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  478  	dmae->dst_addr_lo = U64_LO(bnx2x_sp_mapping(bp, nig_stats));
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  479  	dmae->dst_addr_hi = U64_HI(bnx2x_sp_mapping(bp, nig_stats));
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  480  	dmae->len = (sizeof(struct nig_stats) - 4*sizeof(u32)) >> 2;
619c5cb6885b93 drivers/net/bnx2x/bnx2x_stats.c                   Vlad Zolotarov  2011-06-14  481  
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  482  	dmae->comp_addr_lo = U64_LO(bnx2x_sp_mapping(bp, stats_comp));
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  483  	dmae->comp_addr_hi = U64_HI(bnx2x_sp_mapping(bp, stats_comp));
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  484  	dmae->comp_val = DMAE_COMP_VAL;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  485  
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  486  	*stats_comp = 0;
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  487  }
6c719d00bd9911 drivers/net/bnx2x/bnx2x_stats.c                   Dmitry Kravkov  2010-07-27  488  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests/wiki

