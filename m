Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4F6C64C926E
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 19:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234674AbiCASAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 13:00:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229583AbiCASAk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 13:00:40 -0500
Received: from mga02.intel.com (mga02.intel.com [134.134.136.20])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 24D2B3ED3F;
        Tue,  1 Mar 2022 09:59:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1646157599; x=1677693599;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=YNeHmdRGaQLAxxHHm0icgDjR5GUsQ65k7RpZGnymZEg=;
  b=ZIKfiSUr6pnV2g0oIyYmSRBOitP06Ck+5Iz/UpMqin5CxxFpsCyV1Hvl
   ta0S7k/2XfapLMI5SnYznWb+yzoSui//U7iYIrnT5AWRlXsnbAzcn/41u
   W7Wa9NSxxI4IS/1zgTNSYe93ucQQG8g9f7/5p3kxM+7LQJxUfw8g9+Fcc
   xIlsqre/x8d4Mael1SJ62zy/GZjQnlmxPa35yb5FVm8RH1Nw56wn0p22B
   7sqh2Cx933/HE0fMmEfemLFLF9fP8queiWBo7C6huK1UK94Q+LUL4mF3D
   yzQzblFjayIrKnrd4iUXiD/CsasAJfqypvCZyKcsxRTtwpvfV/wzK6Osu
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10273"; a="240613341"
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="240613341"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by orsmga101.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Mar 2022 09:59:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,146,1643702400"; 
   d="scan'208";a="507891417"
Received: from lkp-server01.sh.intel.com (HELO 2146afe809fb) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 01 Mar 2022 09:59:55 -0800
Received: from kbuild by 2146afe809fb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nP6mx-0000ps-3d; Tue, 01 Mar 2022 17:59:55 +0000
Date:   Wed, 2 Mar 2022 01:59:22 +0800
From:   kernel test robot <lkp@intel.com>
To:     Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        torvalds@linux-foundation.org
Cc:     kbuild-all@lists.01.org, arnd@arndb.de, jakobkoschel@gmail.com,
        linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        keescook@chromium.org, jannh@google.com,
        linux-kbuild@vger.kernel.org, linux-mm@kvack.org,
        netdev@vger.kernel.org, Xiaomeng Tong <xiam0nd.tong@gmail.com>
Subject: Re: [PATCH 1/6] Kbuild: compile kernel with gnu11 std
Message-ID: <202203020135.5duGpXM2-lkp@intel.com>
References: <20220301075839.4156-2-xiam0nd.tong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220301075839.4156-2-xiam0nd.tong@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Xiaomeng,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linux/master]
[also build test WARNING on vkoul-dmaengine/next soc/for-next linus/master v5.17-rc6 next-20220301]
[cannot apply to hnaz-mm/master]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/0day-ci/linux/commits/Xiaomeng-Tong/list_for_each_entry-make-iterator-invisiable-outside-the-loop/20220301-160113
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git 2c271fe77d52a0555161926c232cd5bc07178b39
config: mips-rb532_defconfig (https://download.01.org/0day-ci/archive/20220302/202203020135.5duGpXM2-lkp@intel.com/config)
compiler: mipsel-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://github.com/0day-ci/linux/commit/84ec4077430a7e8c23ea1ebc7b69e254fda25cb1
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Xiaomeng-Tong/list_for_each_entry-make-iterator-invisiable-outside-the-loop/20220301-160113
        git checkout 84ec4077430a7e8c23ea1ebc7b69e254fda25cb1
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=mips SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> cc1: warning: result of '-117440512 << 16' requires 44 bits to represent, but 'int' only has 32 bits [-Wshift-overflow=]
   arch/mips/pci/pci-rc32434.c: In function 'rc32434_pcibridge_init':
   arch/mips/pci/pci-rc32434.c:111:22: warning: variable 'dummyread' set but not used [-Wunused-but-set-variable]
     111 |         unsigned int dummyread, pcicntlval;
         |                      ^~~~~~~~~

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
