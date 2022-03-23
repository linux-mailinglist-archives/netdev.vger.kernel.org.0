Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 97C874E534D
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 14:39:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236703AbiCWNlE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 09:41:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48786 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236678AbiCWNlD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 09:41:03 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 619156FA33;
        Wed, 23 Mar 2022 06:39:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1648042773; x=1679578773;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=v2X5IinRsrjsst3cRYDQVGHehfFp8moOElKTZPrxT00=;
  b=XSth00u+lBjsU7PLMkFpBk5I77Eo9zl3E/pAfS/lVkirDmDblijeVbTw
   QaGq5UAFLlh+aUUxNJyDAzWn+iZyBUqxfRyqd3lu9y/EWIzOqlO/tpjE7
   sl0HnDhtn3peEK5ZWoATsiAK/U+SVoCThPzSnYKgr902pTU+Nb+5Kdp+x
   znu7EPT0OUqOUi1p5a9bec950Hqt43skLbdeDNvuAllHUmncL05UgRNGk
   RgMfJpgfGXbr4EFoiTa27eJr/xRJvH5ncYCgUdK1mf1rx2lebgJT0d+kk
   qiVGIc2J8Mg7FwOSZ3Ow+c/C2ZzzA81Y3z/CuD8qxRKdd0G7DU0iErsz2
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10294"; a="238715177"
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="238715177"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 Mar 2022 06:39:33 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,204,1643702400"; 
   d="scan'208";a="637463597"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by FMSMGA003.fm.intel.com with ESMTP; 23 Mar 2022 06:39:30 -0700
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nX1D0-000K5q-5M; Wed, 23 Mar 2022 13:39:30 +0000
Date:   Wed, 23 Mar 2022 21:38:57 +0800
From:   kernel test robot <lkp@intel.com>
To:     Haowen Bai <baihaowen@meizu.com>, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Haowen Bai <baihaowen@meizu.com>
Subject: Re: [PATCH] net: l2tp: Fix duplicate included trace.h
Message-ID: <202203232123.4w2jlskl-lkp@intel.com>
References: <1648006705-30269-1-git-send-email-baihaowen@meizu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1648006705-30269-1-git-send-email-baihaowen@meizu.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-5.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Haowen,

Thank you for the patch! Yet something to improve:

[auto build test ERROR on net-next/master]
[also build test ERROR on net/master horms-ipvs/master linus/master v5.17 next-20220323]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Haowen-Bai/net-l2tp-Fix-duplicate-included-trace-h/20220323-114023
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 4a0cb83ba6e0cd73a50fa4f84736846bf0029f2b
config: riscv-randconfig-r034-20220323 (https://download.01.org/0day-ci/archive/20220323/202203232123.4w2jlskl-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project 902f4708fe1d03b0de7e5315ef875006a6adc319)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # install riscv cross compiling tool for clang build
        # apt-get install binutils-riscv64-linux-gnu
        # https://github.com/0day-ci/linux/commit/d079f4f8992c56c4d970665bad819349d4916c46
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Haowen-Bai/net-l2tp-Fix-duplicate-included-trace-h/20220323-114023
        git checkout d079f4f8992c56c4d970665bad819349d4916c46
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=riscv SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> ld.lld: error: undefined symbol: __tracepoint_delete_session
   >>> referenced by l2tp_core.c
   >>> l2tp/l2tp_core.o:(trace_delete_session) in archive net/built-in.a
   >>> referenced by l2tp_core.c
   >>> l2tp/l2tp_core.o:(__jump_table+0x44) in archive net/built-in.a
--
>> ld.lld: error: undefined symbol: __traceiter_delete_session
   >>> referenced by l2tp_core.c
   >>> l2tp/l2tp_core.o:(trace_delete_session) in archive net/built-in.a
--
>> ld.lld: error: undefined symbol: __tracepoint_delete_tunnel
   >>> referenced by l2tp_core.c
   >>> l2tp/l2tp_core.o:(trace_delete_tunnel) in archive net/built-in.a
   >>> referenced by l2tp_core.c
   >>> l2tp/l2tp_core.o:(__jump_table+0x38) in archive net/built-in.a
--
>> ld.lld: error: undefined symbol: __traceiter_delete_tunnel
   >>> referenced by l2tp_core.c
   >>> l2tp/l2tp_core.o:(trace_delete_tunnel) in archive net/built-in.a

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
