Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 82C3A5517AD
	for <lists+netdev@lfdr.de>; Mon, 20 Jun 2022 13:46:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242178AbiFTLpo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jun 2022 07:45:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242057AbiFTLpP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jun 2022 07:45:15 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA96365D1;
        Mon, 20 Jun 2022 04:45:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1655725513; x=1687261513;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=MwZ99lFV63pbzMEapd9Oh22WAGTF8yCQ3fVqd5zuOsw=;
  b=fdkwcLyhkghnLEzDZuZlMRlPZbCFaeeMfgtfagJ0dyxTl5B6k4D4GTF9
   zwrC+Kqm7UkJWxG8xnCo6hdO8eyngWR0IDlOaAXD22lOFepZAejv+Owax
   25gqvXrdtF+A8KOl4lov8H5t3yyF4b4+QsyvWwSJaOaI8RaGFeVo8zx1H
   QCEGEVoRpv9XpMatDp1ec61+NkCNxv/x7kcAkh5TngP+52ZOG6fH6Geer
   kzlO0wt5JA3T4io5w3BzrAJAAj7aFje4gkYd4ti7FIN9eJ13FV2Nu06vB
   C8KfbuNnzy1CrsfgCcch6IaX2FQFZTqN8EiOmFidZ56fuSxDicV7U+HzP
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10380"; a="279923981"
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="279923981"
Received: from orsmga006.jf.intel.com ([10.7.209.51])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Jun 2022 04:45:13 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,306,1650956400"; 
   d="scan'208";a="561913662"
Received: from lkp-server01.sh.intel.com (HELO 60dabacc1df6) ([10.239.97.150])
  by orsmga006.jf.intel.com with ESMTP; 20 Jun 2022 04:45:10 -0700
Received: from kbuild by 60dabacc1df6 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o3Fq9-000T8d-RN;
        Mon, 20 Jun 2022 11:45:09 +0000
Date:   Mon, 20 Jun 2022 19:45:01 +0800
From:   kernel test robot <lkp@intel.com>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     kbuild-all@lists.01.org, Pavel Machek <pavel@ucw.cz>,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH bpf-next] libbpf: Include linux/log2.h to use
 is_pow_of_2()
Message-ID: <202206201942.DQpI2tgb-lkp@intel.com>
References: <1655711942-6181-1-git-send-email-yangtiezhu@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1655711942-6181-1-git-send-email-yangtiezhu@loongson.cn>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Tiezhu,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on bpf-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Tiezhu-Yang/libbpf-Include-linux-log2-h-to-use-is_pow_of_2/20220620-160053
base:   https://git.kernel.org/pub/scm/linux/kernel/git/bpf/bpf-next.git master
config: s390-defconfig (https://download.01.org/0day-ci/archive/20220620/202206201942.DQpI2tgb-lkp@intel.com/config)
compiler: s390-linux-gcc (GCC) 11.3.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/intel-lab-lkp/linux/commit/785c0dfdcebd7deec5cfaaf7bce252c40f30a350
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Tiezhu-Yang/libbpf-Include-linux-log2-h-to-use-is_pow_of_2/20220620-160053
        git checkout 785c0dfdcebd7deec5cfaaf7bce252c40f30a350
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=s390 prepare

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   scripts/genksyms/parse.y: warning: 9 shift/reduce conflicts [-Wconflicts-sr]
   scripts/genksyms/parse.y: warning: 5 reduce/reduce conflicts [-Wconflicts-rr]
   scripts/genksyms/parse.y: note: rerun with option '-Wcounterexamples' to generate conflict counterexamples
   linker.c: In function 'linker_sanity_check_elf':
>> linker.c:722:49: error: implicit declaration of function 'is_pow_of_2'; did you mean 'is_power_of_2'? [-Werror=implicit-function-declaration]
     722 |                 if (sec->shdr->sh_addralign && !is_pow_of_2(sec->shdr->sh_addralign))
         |                                                 ^~~~~~~~~~~
         |                                                 is_power_of_2
>> linker.c:722:49: error: nested extern declaration of 'is_pow_of_2' [-Werror=nested-externs]
   libbpf.c: In function 'adjust_ringbuf_sz':
>> libbpf.c:5134:36: error: implicit declaration of function 'is_pow_of_2'; did you mean 'is_power_of_2'? [-Werror=implicit-function-declaration]
    5134 |         if ((sz % page_sz) == 0 && is_pow_of_2(sz / page_sz))
         |                                    ^~~~~~~~~~~
         |                                    is_power_of_2
>> libbpf.c:5134:36: error: nested extern declaration of 'is_pow_of_2' [-Werror=nested-externs]
   cc1: all warnings being treated as errors
   make[5]: *** [tools/build/Makefile.build:96: tools/bpf/resolve_btfids/libbpf/staticobjs/linker.o] Error 1
   make[5]: *** Waiting for unfinished jobs....
   cc1: all warnings being treated as errors
   make[5]: *** [tools/build/Makefile.build:96: tools/bpf/resolve_btfids/libbpf/staticobjs/libbpf.o] Error 1
   make[4]: *** [Makefile:157: tools/bpf/resolve_btfids/libbpf/staticobjs/libbpf-in.o] Error 2
   make[3]: *** [Makefile:55: tools/bpf/resolve_btfids//libbpf/libbpf.a] Error 2
   make[2]: *** [Makefile:76: bpf/resolve_btfids] Error 2
   make[1]: *** [Makefile:1344: tools/bpf/resolve_btfids] Error 2
   make[1]: Target 'prepare' not remade because of errors.
   make: *** [Makefile:219: __sub-make] Error 2
   make: Target 'prepare' not remade because of errors.

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
