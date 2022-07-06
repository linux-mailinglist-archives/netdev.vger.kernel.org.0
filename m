Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 49254568680
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 13:15:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231347AbiGFLPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 07:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52300 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229531AbiGFLPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 07:15:02 -0400
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1498E2EE
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 04:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657106101; x=1688642101;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=c6uUdvhC8o/s0B8Lu/JdCtZlQm/LBontoqG4zpeohM0=;
  b=RcICbtxJC/KDZABbA6yYDShOrnp509nPLDU4B1q1d0yZ1IQC6iPS04qs
   /kYjEnxYFoQJGB1Io0hd9kGK1s4YLzpqEX9sBgXBP3K2bucCci7g6NXnT
   Z/i3dHryuVJvU9Zu9HvGJe8aDtkLLX31U/Q/LWUXTCqKHyXflWnSgB7Eu
   Euv/3oHTGyi9mWnzqMoLbKHldne9PziusNzck4BuWqAsUXbSVQqV9YcHT
   4Qh+GXP0BxjriL6mGNOZ3CL6vrDjwaxaMdPqs9V86DcSdaK5fdsyLQTk8
   nrT+NNesNgLZyvzt9QuhPagA/LUvIBgj9WYRHSY+D/pFwuxLPVJsFxbky
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10399"; a="345403295"
X-IronPort-AV: E=Sophos;i="5.92,249,1650956400"; 
   d="scan'208";a="345403295"
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2022 04:15:00 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,249,1650956400"; 
   d="scan'208";a="920125963"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by fmsmga005.fm.intel.com with ESMTP; 06 Jul 2022 04:14:59 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o92zi-000KVH-QX;
        Wed, 06 Jul 2022 11:14:58 +0000
Date:   Wed, 6 Jul 2022 19:14:28 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ratheesh Kannoth <rkannoth@marvell.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: [net-next:master 9/16]
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1080:14: warning:
 variable 'rc' set but not used
Message-ID: <202207061918.lo2TMG5P-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   2ef8e39f58f08589ab035223c2687830c0eba30f
commit: c6238bc0614d3bafa5f491a065584b2e5ba6194a [9/16] octeontx2-af: Drop rules for NPC MCAM
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20220706/202207061918.lo2TMG5P-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=c6238bc0614d3bafa5f491a065584b2e5ba6194a
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch --no-tags net-next master
        git checkout c6238bc0614d3bafa5f491a065584b2e5ba6194a
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=alpha SHELL=/bin/bash drivers/net/ethernet/marvell/octeontx2/af/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:388:5: warning: no previous prototype for 'rvu_exact_calculate_hash' [-Wmissing-prototypes]
     388 | u32 rvu_exact_calculate_hash(struct rvu *rvu, u16 chan, u16 ctype, u8 *mac,
         |     ^~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c: In function 'rvu_npc_exact_get_drop_rule_info':
>> drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1080:14: warning: variable 'rc' set but not used [-Wunused-but-set-variable]
    1080 |         bool rc;
         |              ^~
   drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c: At top level:
   drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1248:5: warning: no previous prototype for 'rvu_npc_exact_add_table_entry' [-Wmissing-prototypes]
    1248 | int rvu_npc_exact_add_table_entry(struct rvu *rvu, u8 cgx_id, u8 lmac_id, u8 *mac,
         |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c: In function 'rvu_npc_exact_add_table_entry':
   drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1254:33: warning: variable 'table' set but not used [-Wunused-but-set-variable]
    1254 |         struct npc_exact_table *table;
         |                                 ^~~~~
   drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c: At top level:
   drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1320:5: warning: no previous prototype for 'rvu_npc_exact_update_table_entry' [-Wmissing-prototypes]
    1320 | int rvu_npc_exact_update_table_entry(struct rvu *rvu, u8 cgx_id, u8 lmac_id,
         |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/rc +1080 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c

  1062	
  1063	/**
  1064	 *	rvu_npc_exact_get_drop_rule_info - Get drop rule information.
  1065	 *      @rvu: resource virtualization unit.
  1066	 *	@intf_type: Interface type (CGX, SDP or LBK)
  1067	 *	@cgx_id: CGX identifier.
  1068	 *	@lmac_id: LMAC identifier.
  1069	 *	@drop_mcam_idx: NPC mcam drop rule index.
  1070	 *	@val: Channel value.
  1071	 *	@mask: Channel mask.
  1072	 *	@pcifunc: pcifunc of interface corresponding to the drop rule.
  1073	 */
  1074	static bool rvu_npc_exact_get_drop_rule_info(struct rvu *rvu, u8 intf_type, u8 cgx_id,
  1075						     u8 lmac_id, u32 *drop_mcam_idx, u64 *val,
  1076						     u64 *mask, u16 *pcifunc)
  1077	{
  1078		struct npc_exact_table *table;
  1079		u64 chan_val, chan_mask;
> 1080		bool rc;
  1081		int i;
  1082	
  1083		table = rvu->hw->table;
  1084	
  1085		if (intf_type != NIX_INTF_TYPE_CGX) {
  1086			dev_err(rvu->dev, "%s: No drop rule for LBK/SDP mode\n", __func__);
  1087			return false;
  1088		}
  1089	
  1090		rc = rvu_npc_exact_calc_drop_rule_chan_and_mask(rvu, intf_type, cgx_id,
  1091								lmac_id, &chan_val, &chan_mask);
  1092	
  1093		for (i = 0; i < NPC_MCAM_DROP_RULE_MAX; i++) {
  1094			if (!table->drop_rule_map[i].valid)
  1095				break;
  1096	
  1097			if (table->drop_rule_map[i].chan_val != (u16)chan_val)
  1098				continue;
  1099	
  1100			if (val)
  1101				*val = table->drop_rule_map[i].chan_val;
  1102			if (mask)
  1103				*mask = table->drop_rule_map[i].chan_mask;
  1104			if (pcifunc)
  1105				*pcifunc = table->drop_rule_map[i].pcifunc;
  1106	
  1107			*drop_mcam_idx = i;
  1108			return true;
  1109		}
  1110	
  1111		if (i == NPC_MCAM_DROP_RULE_MAX) {
  1112			dev_err(rvu->dev, "%s: drop mcam rule index (%d) >= NPC_MCAM_DROP_RULE_MAX\n",
  1113				__func__, *drop_mcam_idx);
  1114			return false;
  1115		}
  1116	
  1117		dev_err(rvu->dev, "%s: Could not retrieve for cgx=%d, lmac=%d\n",
  1118			__func__, cgx_id, lmac_id);
  1119		return false;
  1120	}
  1121	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
