Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8B8B36A53C1
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 08:35:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230084AbjB1Hfb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 02:35:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbjB1Hf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 02:35:27 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 669391BAE0;
        Mon, 27 Feb 2023 23:35:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1677569726; x=1709105726;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=5DKTTTfE7aOaO2jXKu3LiEoHHcR0Zhj6K7jhlb2yClQ=;
  b=aQ+vaebbBv0FAo2tvTkD3zfxymDQBGfbGmyUzoUMjwS6iWYJEkiQxpWW
   2hMxKtDo2pyTfsSBz8u29IFasVJfzTwHzRLtfuwA8N+tON8FX7kSKGfNJ
   SEaNTDWK474btoVsWMeo2iThkcmAIO9P+hpAZMVrw05X8EYuxB8opI6Kt
   ok6nTAX9r8g8RFSSvNZiUkFjqwOGZpBRr+e267PBGP/aiPUFAcIzBw43j
   pdPChfvh9dodJK/BNtEtR55+Rn+oI4wCE+ryELtxcA2jY1W0sbfeFcWSn
   e61Juwb26z5tqtk8U4Vxe2mMf4LlCUJ9eqsfmrchTtkbQNY+QHVHzTd9D
   A==;
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="332796138"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="332796138"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Feb 2023 23:35:25 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10634"; a="848155546"
X-IronPort-AV: E=Sophos;i="5.98,221,1673942400"; 
   d="scan'208";a="848155546"
Received: from lkp-server01.sh.intel.com (HELO 3895f5c55ead) ([10.239.97.150])
  by orsmga005.jf.intel.com with ESMTP; 27 Feb 2023 23:35:22 -0800
Received: from kbuild by 3895f5c55ead with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pWuW9-0005Bn-2d;
        Tue, 28 Feb 2023 07:35:21 +0000
Date:   Tue, 28 Feb 2023 15:34:36 +0800
From:   kernel test robot <lkp@intel.com>
To:     lingfuyi <lingfuyi@126.com>, jhs@mojatatu.com, davem@davemloft.net
Cc:     llvm@lists.linux.dev, oe-kbuild-all@lists.linux.dev,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        lingfuyi <lingfuyi@kylinos.cn>, k2ci <kernel-bot@kylinos.cn>
Subject: Re: [PATCH] sched: delete some api is not used
Message-ID: <202302281531.3gOSrvTO-lkp@intel.com>
References: <20230228031241.1675263-1-lingfuyi@126.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230228031241.1675263-1-lingfuyi@126.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi lingfuyi,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on horms-ipvs/master]
[also build test ERROR on linus/master next-20230228]
[cannot apply to v6.2]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch#_base_tree_information]

url:    https://github.com/intel-lab-lkp/linux/commits/lingfuyi/sched-delete-some-api-is-not-used/20230228-124804
base:   https://git.kernel.org/pub/scm/linux/kernel/git/horms/ipvs.git master
patch link:    https://lore.kernel.org/r/20230228031241.1675263-1-lingfuyi%40126.com
patch subject: [PATCH] sched: delete some api is not used
config: x86_64-randconfig-a001-20230227 (https://download.01.org/0day-ci/archive/20230228/202302281531.3gOSrvTO-lkp@intel.com/config)
compiler: clang version 14.0.6 (https://github.com/llvm/llvm-project f28c006a5895fc0e329fe15fead81e37457cb1d1)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/6d9fd0340845396f9866b8a8c53ad65066de39ac
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review lingfuyi/sched-delete-some-api-is-not-used/20230228-124804
        git checkout 6d9fd0340845396f9866b8a8c53ad65066de39ac
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash net/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>
| Link: https://lore.kernel.org/oe-kbuild-all/202302281531.3gOSrvTO-lkp@intel.com/

All errors (new ones prefixed by >>):

>> net/sched/cls_api.c:3242:2: error: implicit declaration of function 'tcf_exts_miss_cookie_base_destroy' is invalid in C99 [-Werror,-Wimplicit-function-declaration]
           tcf_exts_miss_cookie_base_destroy(exts);
           ^
   net/sched/cls_api.c:3242:2: note: did you mean 'tcf_exts_miss_cookie_base_alloc'?
   net/sched/cls_api.c:135:1: note: 'tcf_exts_miss_cookie_base_alloc' declared here
   tcf_exts_miss_cookie_base_alloc(struct tcf_exts *exts, struct tcf_proto *tp,
   ^
   1 error generated.


vim +/tcf_exts_miss_cookie_base_destroy +3242 net/sched/cls_api.c

80cd22c35c9001 Paul Blakey       2023-02-18  3238  
18d0264f630e20 WANG Cong         2014-09-25  3239  void tcf_exts_destroy(struct tcf_exts *exts)
^1da177e4c3f41 Linus Torvalds    2005-04-16  3240  {
^1da177e4c3f41 Linus Torvalds    2005-04-16  3241  #ifdef CONFIG_NET_CLS_ACT
80cd22c35c9001 Paul Blakey       2023-02-18 @3242  	tcf_exts_miss_cookie_base_destroy(exts);
80cd22c35c9001 Paul Blakey       2023-02-18  3243  
3d66b89c30f922 Eric Dumazet      2019-09-18  3244  	if (exts->actions) {
90b73b77d08ec3 Vlad Buslov       2018-07-05  3245  		tcf_action_destroy(exts->actions, TCA_ACT_UNBIND);
22dc13c837c332 WANG Cong         2016-08-13  3246  		kfree(exts->actions);
3d66b89c30f922 Eric Dumazet      2019-09-18  3247  	}
22dc13c837c332 WANG Cong         2016-08-13  3248  	exts->nr_actions = 0;
^1da177e4c3f41 Linus Torvalds    2005-04-16  3249  #endif
^1da177e4c3f41 Linus Torvalds    2005-04-16  3250  }
aa767bfea48289 Stephen Hemminger 2008-01-21  3251  EXPORT_SYMBOL(tcf_exts_destroy);
^1da177e4c3f41 Linus Torvalds    2005-04-16  3252  

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
