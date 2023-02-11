Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65292692DEF
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 04:34:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229560AbjBKDe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 22:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbjBKDeZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 22:34:25 -0500
Received: from mga06.intel.com (mga06b.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CD2665CBF0
        for <netdev@vger.kernel.org>; Fri, 10 Feb 2023 19:33:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1676086438; x=1707622438;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=3KdXGkEFcFuGl3jnCYs57pKJThyFqSgkef/kUytVrMU=;
  b=LnWIJq669UUPIfIJ8PZ6nwkd7JBPjzJXLzKplrAOX+c1Wldul7h715HC
   dr/r6w5IZ4jvquEdQ2GXrPDFtjQgBSb4+WyABTItfHGXFegKabSByrD9h
   9oz6E5QCnCfzRIk1YEOrlBc7QOyih7N+acbXfgIxGri1Z8IwIJ1NMA7ZO
   2IaErSHkGP3fzwsm3oQOA7KOoaapgq2NBKbssCfvYCq2Ff2/IsFSLxChe
   GmJABoheuCY9my6Hf7MGMcgg97FZJ+Y+KqVa/zTlv7MC8z6Js/33v2q9r
   Fu1kDgPN/5qCYHaxYLGSmm+tjr68zhOb6OjfL8aZAURez0b0QEdWhRdzr
   g==;
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="392980661"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="392980661"
Received: from fmsmga002.fm.intel.com ([10.253.24.26])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 10 Feb 2023 19:33:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10617"; a="777152285"
X-IronPort-AV: E=Sophos;i="5.97,287,1669104000"; 
   d="scan'208";a="777152285"
Received: from lkp-server01.sh.intel.com (HELO 4455601a8d94) ([10.239.97.150])
  by fmsmga002.fm.intel.com with ESMTP; 10 Feb 2023 19:33:54 -0800
Received: from kbuild by 4455601a8d94 with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pQge9-0006Cr-2l;
        Sat, 11 Feb 2023 03:33:53 +0000
Date:   Sat, 11 Feb 2023 11:32:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Harsh Jain <h.jain@amd.com>, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        thomas.lendacky@amd.com, Raju.Rangoju@amd.com,
        Shyam-sundar.S-k@amd.com, harshjain.prof@gmail.com,
        abhijit.gangurde@amd.com, puneet.gupta@amd.com,
        nikhil.agarwal@amd.com, tarak.reddy@amd.com, netdev@vger.kernel.org
Cc:     oe-kbuild-all@lists.linux.dev, Harsh Jain <h.jain@amd.com>
Subject: Re: [PATCH  6/6]  net: ethernet: efct: Add maintainer, kconfig,
 makefile
Message-ID: <202302111128.JPr7UbtM-lkp@intel.com>
References: <20230210130321.2898-7-h.jain@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230210130321.2898-7-h.jain@amd.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Harsh,

I love your patch! Yet something to improve:

[auto build test ERROR on net-next/master]
[also build test ERROR on net/master horms-ipvs/master linus/master v6.2-rc7 next-20230210]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/Harsh-Jain/net-ethernet-efct-New-X3-net-driver/20230210-210711
patch link:    https://lore.kernel.org/r/20230210130321.2898-7-h.jain%40amd.com
patch subject: [PATCH  6/6]  net: ethernet: efct: Add maintainer, kconfig, makefile
config: mips-db1xxx_defconfig (https://download.01.org/0day-ci/archive/20230211/202302111128.JPr7UbtM-lkp@intel.com/config)
compiler: mipsel-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/93ed306161ac0259bd72b14922a7f6af60b3748c
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Harsh-Jain/net-ethernet-efct-New-X3-net-driver/20230210-210711
        git checkout 93ed306161ac0259bd72b14922a7f6af60b3748c
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=mips olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=mips SHELL=/bin/bash drivers/net/ethernet/amd/efct/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302111128.JPr7UbtM-lkp@intel.com/

All error/warnings (new ones prefixed by >>):

   drivers/net/ethernet/amd/efct/mcdi_functions.c: In function 'efct_mcdi_filter_table_probe':
>> drivers/net/ethernet/amd/efct/mcdi_functions.c:283:24: error: implicit declaration of function 'vzalloc'; did you mean 'kvzalloc'? [-Werror=implicit-function-declaration]
     283 |         table->entry = vzalloc(EFCT_MCDI_FILTER_TBL_ROWS *
         |                        ^~~~~~~
         |                        kvzalloc
>> drivers/net/ethernet/amd/efct/mcdi_functions.c:283:22: warning: assignment to 'struct <anonymous> *' from 'int' makes pointer from integer without a cast [-Wint-conversion]
     283 |         table->entry = vzalloc(EFCT_MCDI_FILTER_TBL_ROWS *
         |                      ^
   drivers/net/ethernet/amd/efct/mcdi_functions.c: In function 'efct_mcdi_filter_table_remove':
>> drivers/net/ethernet/amd/efct/mcdi_functions.c:309:9: error: implicit declaration of function 'vfree'; did you mean 'kfree'? [-Werror=implicit-function-declaration]
     309 |         vfree(table->entry);
         |         ^~~~~
         |         kfree
   cc1: some warnings being treated as errors


vim +283 drivers/net/ethernet/amd/efct/mcdi_functions.c

83f06a5b784384c Harsh Jain 2023-02-10  267  
83f06a5b784384c Harsh Jain 2023-02-10  268  int efct_mcdi_filter_table_probe(struct efct_nic *efct)
83f06a5b784384c Harsh Jain 2023-02-10  269  {
83f06a5b784384c Harsh Jain 2023-02-10  270  	struct efct_mcdi_filter_table *table;
83f06a5b784384c Harsh Jain 2023-02-10  271  	int rc = 0, i;
83f06a5b784384c Harsh Jain 2023-02-10  272  
83f06a5b784384c Harsh Jain 2023-02-10  273  	if (efct->filter_table) /* already probed */
83f06a5b784384c Harsh Jain 2023-02-10  274  		return rc;
83f06a5b784384c Harsh Jain 2023-02-10  275  
83f06a5b784384c Harsh Jain 2023-02-10  276  	table = kzalloc(sizeof(*table), GFP_KERNEL);
83f06a5b784384c Harsh Jain 2023-02-10  277  	if (!table)
83f06a5b784384c Harsh Jain 2023-02-10  278  		return -ENOMEM;
83f06a5b784384c Harsh Jain 2023-02-10  279  
83f06a5b784384c Harsh Jain 2023-02-10  280  	efct->filter_table = table;
83f06a5b784384c Harsh Jain 2023-02-10  281  
83f06a5b784384c Harsh Jain 2023-02-10  282  	init_rwsem(&table->lock);
83f06a5b784384c Harsh Jain 2023-02-10 @283  	table->entry = vzalloc(EFCT_MCDI_FILTER_TBL_ROWS *
83f06a5b784384c Harsh Jain 2023-02-10  284  			       sizeof(*table->entry));
83f06a5b784384c Harsh Jain 2023-02-10  285  	if (!table->entry) {
83f06a5b784384c Harsh Jain 2023-02-10  286  		rc = -ENOMEM;
83f06a5b784384c Harsh Jain 2023-02-10  287  		return rc;
83f06a5b784384c Harsh Jain 2023-02-10  288  	}
83f06a5b784384c Harsh Jain 2023-02-10  289  
83f06a5b784384c Harsh Jain 2023-02-10  290  	for (i = 0; i < EFCT_MCDI_FILTER_TBL_ROWS; i++) {
83f06a5b784384c Harsh Jain 2023-02-10  291  		table->entry[i].handle = EFCT_HANDLE_INVALID;
83f06a5b784384c Harsh Jain 2023-02-10  292  		table->entry[i].ref_cnt = 0;
83f06a5b784384c Harsh Jain 2023-02-10  293  	}
83f06a5b784384c Harsh Jain 2023-02-10  294  
83f06a5b784384c Harsh Jain 2023-02-10  295  	return rc;
83f06a5b784384c Harsh Jain 2023-02-10  296  }
83f06a5b784384c Harsh Jain 2023-02-10  297  
83f06a5b784384c Harsh Jain 2023-02-10  298  void efct_mcdi_filter_table_remove(struct efct_nic *efct)
83f06a5b784384c Harsh Jain 2023-02-10  299  {
83f06a5b784384c Harsh Jain 2023-02-10  300  	struct efct_mcdi_filter_table *table = efct->filter_table;
83f06a5b784384c Harsh Jain 2023-02-10  301  	int i;
83f06a5b784384c Harsh Jain 2023-02-10  302  
83f06a5b784384c Harsh Jain 2023-02-10  303  	if (!table)
83f06a5b784384c Harsh Jain 2023-02-10  304  		return;
83f06a5b784384c Harsh Jain 2023-02-10  305  	for (i = 0; i < EFCT_MCDI_FILTER_TBL_ROWS; i++) {
83f06a5b784384c Harsh Jain 2023-02-10  306  		if (table->entry[i].spec)
83f06a5b784384c Harsh Jain 2023-02-10  307  			kfree((struct efct_filter_spec *)table->entry[i].spec);
83f06a5b784384c Harsh Jain 2023-02-10  308  	}
83f06a5b784384c Harsh Jain 2023-02-10 @309  	vfree(table->entry);
83f06a5b784384c Harsh Jain 2023-02-10  310  	table->entry = NULL;
83f06a5b784384c Harsh Jain 2023-02-10  311  	efct->filter_table = NULL;
83f06a5b784384c Harsh Jain 2023-02-10  312  	kfree(table);
83f06a5b784384c Harsh Jain 2023-02-10  313  }
83f06a5b784384c Harsh Jain 2023-02-10  314  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
