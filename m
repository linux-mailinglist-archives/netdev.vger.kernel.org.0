Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1477D4F6B45
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 22:23:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232729AbiDFUYy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 16:24:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55934 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236766AbiDFUYN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 16:24:13 -0400
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75A8934A209;
        Wed,  6 Apr 2022 11:43:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1649270610; x=1680806610;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=EvXsANBydW34DUZu/F9WD/po+jfkxLKwsoOVWLPsEVQ=;
  b=lQzORZ4naH8+wp8A1jJIvGaZBYDSfR+c7P2VWW0/vWpkqX3yWATMy8zF
   y6AbInZwjsftn/rhfoKZf/YT4t34yjDKOfv+Gtv1CyBl2VvgM2hp7cqHe
   di8F7rwdqSrYcT3Efoi4iE4RmF1R142oTkkmZjxEutorn98gWTkEmDDof
   MaR0Aklw3Db8lMPiJunxNPFREMymi/mBNRAqYjF/NL9yJksNdfXyk0UjP
   7Ht1Bz0S6dVEKZiqsw6P7dXy4iYBrhWylCEG4mrdIItoD4bHyGQbbNXyK
   wywSyPkl1Ft+LGa2elR4mNx+iYl1YIKj1DG0MW8845w+EXMfb797mTq8M
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10309"; a="259963271"
X-IronPort-AV: E=Sophos;i="5.90,240,1643702400"; 
   d="scan'208";a="259963271"
Received: from fmsmga008.fm.intel.com ([10.253.24.58])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 06 Apr 2022 11:43:30 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,240,1643702400"; 
   d="scan'208";a="609012743"
Received: from lkp-server02.sh.intel.com (HELO a44fdfb70b94) ([10.239.97.151])
  by fmsmga008.fm.intel.com with ESMTP; 06 Apr 2022 11:43:28 -0700
Received: from kbuild by a44fdfb70b94 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1ncAcp-0004ej-Tk;
        Wed, 06 Apr 2022 18:43:27 +0000
Date:   Thu, 7 Apr 2022 02:42:52 +0800
From:   kernel test robot <lkp@intel.com>
To:     Stanislav Fomichev <sdf@google.com>, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     kbuild-all@lists.01.org, ast@kernel.org, daniel@iogearbox.net,
        andrii@kernel.org, Stanislav Fomichev <sdf@google.com>
Subject: Re: [PATCH bpf-next v2 2/7] bpf: per-cgroup lsm flavor
Message-ID: <202204070201.lzjdBJq0-lkp@intel.com>
References: <20220405214342.1968262-3-sdf@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20220405214342.1968262-3-sdf@google.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Stanislav,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Stanislav-Fomichev/bpf-cgroup_sock-lsm-flavor/20220406-162419
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: powerpc-buildonly-randconfig-r003-20220406 (https://download.01.org/0day-ci/archive/20220407/202204070201.lzjdBJq0-lkp@intel.com/config)
compiler: powerpc-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/b416dabea64e9ab8418ffb26990f2d303b968f2d
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Stanislav-Fomichev/bpf-cgroup_sock-lsm-flavor/20220406-162419
        git checkout b416dabea64e9ab8418ffb26990f2d303b968f2d
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=powerpc SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   powerpc-linux-ld: kernel/bpf/trampoline.o: in function `bpf_trampoline_compute_key':
>> include/linux/bpf_verifier.h:540: undefined reference to `btf_obj_id'
>> powerpc-linux-ld: include/linux/bpf_verifier.h:540: undefined reference to `btf_obj_id'


vim +540 include/linux/bpf_verifier.h

ab3f0063c48c26c Jakub Kicinski          2017-11-03  521  
be80a1d3f9dbe5a Daniel Borkmann         2022-01-10  522  int check_ptr_off_reg(struct bpf_verifier_env *env,
51c39bb1d5d105a Alexei Starovoitov      2020-01-09  523  		      const struct bpf_reg_state *reg, int regno);
25b35dd28138f61 Kumar Kartikeya Dwivedi 2022-03-05  524  int check_func_arg_reg_off(struct bpf_verifier_env *env,
25b35dd28138f61 Kumar Kartikeya Dwivedi 2022-03-05  525  			   const struct bpf_reg_state *reg, int regno,
24d5bb806c7e2c0 Kumar Kartikeya Dwivedi 2022-03-05  526  			   enum bpf_arg_type arg_type,
24d5bb806c7e2c0 Kumar Kartikeya Dwivedi 2022-03-05  527  			   bool is_release_func);
d583691c47dc042 Kumar Kartikeya Dwivedi 2022-01-14  528  int check_kfunc_mem_size_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
d583691c47dc042 Kumar Kartikeya Dwivedi 2022-01-14  529  			     u32 regno);
e5069b9c23b3857 Dmitrii Banshchikov     2021-02-13  530  int check_mem_reg(struct bpf_verifier_env *env, struct bpf_reg_state *reg,
e5069b9c23b3857 Dmitrii Banshchikov     2021-02-13  531  		   u32 regno, u32 mem_size);
51c39bb1d5d105a Alexei Starovoitov      2020-01-09  532  
f7b12b6fea00988 Toke Høiland-Jørgensen  2020-09-25  533  /* this lives here instead of in bpf.h because it needs to dereference tgt_prog */
f7b12b6fea00988 Toke Høiland-Jørgensen  2020-09-25  534  static inline u64 bpf_trampoline_compute_key(const struct bpf_prog *tgt_prog,
22dc4a0f5ed11b6 Andrii Nakryiko         2020-12-03  535  					     struct btf *btf, u32 btf_id)
f7b12b6fea00988 Toke Høiland-Jørgensen  2020-09-25  536  {
22dc4a0f5ed11b6 Andrii Nakryiko         2020-12-03  537  	if (tgt_prog)
22dc4a0f5ed11b6 Andrii Nakryiko         2020-12-03  538  		return ((u64)tgt_prog->aux->id << 32) | btf_id;
22dc4a0f5ed11b6 Andrii Nakryiko         2020-12-03  539  	else
22dc4a0f5ed11b6 Andrii Nakryiko         2020-12-03 @540  		return ((u64)btf_obj_id(btf) << 32) | 0x80000000 | btf_id;
f7b12b6fea00988 Toke Høiland-Jørgensen  2020-09-25  541  }
f7b12b6fea00988 Toke Høiland-Jørgensen  2020-09-25  542  

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
