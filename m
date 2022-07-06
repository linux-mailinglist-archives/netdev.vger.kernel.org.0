Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4259B5684F0
	for <lists+netdev@lfdr.de>; Wed,  6 Jul 2022 12:14:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232385AbiGFKN5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Jul 2022 06:13:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231613AbiGFKN5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Jul 2022 06:13:57 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 392BBD43
        for <netdev@vger.kernel.org>; Wed,  6 Jul 2022 03:13:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1657102436; x=1688638436;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=v8lsTg5R/Ga9UUIeaaR/imONf2XpRzLAD2dNh5YNxXM=;
  b=LMDQpkHWtzpx8sApB2HpltsaMOq+zIg8hzXWyl2zwQg2povFrRKW7ueO
   w67sGrKZEG3V/fxQI85A60WKCiUJEpxnEDG2NAvhgy6lc1XuYNpHgL43N
   Av8zjMvK9X3SqkCHyJBl6ECc0WblhyWSjGgQjwGNPXsxYIO4IrMJuceyF
   +8Dsj/8LauLroNXODORfJDyN9CEwnEBsgOdjxw5+T08etx2WFErqY3dgq
   HXYeFUlOB18ZPpAlFpLiYbHTITX9Y541UM2PqJzehqsken4xeTIpC8XhZ
   qzzrCYTELb1oe6avsqbT0sdnZExoJ6FbHHo7cgLhb1W9A+Gk0BcH/jBRr
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10399"; a="263489253"
X-IronPort-AV: E=Sophos;i="5.92,249,1650956400"; 
   d="scan'208";a="263489253"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Jul 2022 03:13:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,249,1650956400"; 
   d="scan'208";a="682862228"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 06 Jul 2022 03:13:54 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o922c-000KQF-AO;
        Wed, 06 Jul 2022 10:13:54 +0000
Date:   Wed, 6 Jul 2022 18:12:54 +0800
From:   kernel test robot <lkp@intel.com>
To:     Ratheesh Kannoth <rkannoth@marvell.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: [net-next:master 5/16]
 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:388:5: warning: no
 previous prototype for 'rvu_exact_calculate_hash'
Message-ID: <202207061806.PD7mLTe7-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   2ef8e39f58f08589ab035223c2687830c0eba30f
commit: 017691914c115903ee513d9ca058335bb35f8bd6 [5/16] octeontx2-af: Exact match support
config: alpha-allyesconfig (https://download.01.org/0day-ci/archive/20220706/202207061806.PD7mLTe7-lkp@intel.com/config)
compiler: alpha-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=017691914c115903ee513d9ca058335bb35f8bd6
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch --no-tags net-next master
        git checkout 017691914c115903ee513d9ca058335bb35f8bd6
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=alpha SHELL=/bin/bash drivers/net/ethernet/marvell/octeontx2/af/

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:388:5: warning: no previous prototype for 'rvu_exact_calculate_hash' [-Wmissing-prototypes]
     388 | u32 rvu_exact_calculate_hash(struct rvu *rvu, u16 chan, u16 ctype, u8 *mac,
         |     ^~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1026:5: warning: no previous prototype for 'rvu_npc_exact_add_table_entry' [-Wmissing-prototypes]
    1026 | int rvu_npc_exact_add_table_entry(struct rvu *rvu, u8 cgx_id, u8 lmac_id, u8 *mac,
         |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~
   drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c: In function 'rvu_npc_exact_add_table_entry':
>> drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1032:33: warning: variable 'table' set but not used [-Wunused-but-set-variable]
    1032 |         struct npc_exact_table *table;
         |                                 ^~~~~
   drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c: At top level:
   drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c:1084:5: warning: no previous prototype for 'rvu_npc_exact_update_table_entry' [-Wmissing-prototypes]
    1084 | int rvu_npc_exact_update_table_entry(struct rvu *rvu, u8 cgx_id, u8 lmac_id,
         |     ^~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


vim +/rvu_exact_calculate_hash +388 drivers/net/ethernet/marvell/octeontx2/af/rvu_npc_hash.c

   378	
   379	/**
   380	 *      rvu_exact_calculate_hash - calculate hash index to mem table.
   381	 *	@rvu: resource virtualization unit.
   382	 *	@chan: Channel number
   383	 *	@ctype: Channel type.
   384	 *	@mac: MAC address
   385	 *	@mask: HASH mask.
   386	 *	@table_depth: Depth of table.
   387	 */
 > 388	u32 rvu_exact_calculate_hash(struct rvu *rvu, u16 chan, u16 ctype, u8 *mac,
   389				     u64 mask, u32 table_depth)
   390	{
   391		struct npc_exact_table *table = rvu->hw->table;
   392		u64 hash_key[2];
   393		u64 key_in[2];
   394		u64 ldata;
   395		u32 hash;
   396	
   397		key_in[0] = RVU_NPC_HASH_SECRET_KEY0;
   398		key_in[1] = RVU_NPC_HASH_SECRET_KEY2;
   399	
   400		hash_key[0] = key_in[0] << 31;
   401		hash_key[0] |= key_in[1];
   402		hash_key[1] = key_in[0] >> 33;
   403	
   404		ldata = rvu_exact_prepare_mdata(mac, chan, ctype, mask);
   405	
   406		dev_dbg(rvu->dev, "%s: ldata=0x%llx hash_key0=0x%llx hash_key2=0x%llx\n", __func__,
   407			ldata, hash_key[1], hash_key[0]);
   408		hash = rvu_npc_toeplitz_hash(&ldata, (u64 *)hash_key, 64, 95);
   409	
   410		hash &= table->mem_table.hash_mask;
   411		hash += table->mem_table.hash_offset;
   412		dev_dbg(rvu->dev, "%s: hash=%x\n", __func__,  hash);
   413	
   414		return hash;
   415	}
   416	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
