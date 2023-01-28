Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2630C67F538
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 07:34:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231860AbjA1GeJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 01:34:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39916 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229530AbjA1GeJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 01:34:09 -0500
Received: from mga04.intel.com (mga04.intel.com [192.55.52.120])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 18FE21117F
        for <netdev@vger.kernel.org>; Fri, 27 Jan 2023 22:33:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1674887626; x=1706423626;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=3WKbuf1iW8oixBPi4K/walT1oULTmDxYNWvZt7XWcYQ=;
  b=RywvJZJhieLu4l3XsA8GoJ9+3FZwaJal0A4GFrLTDT4gzrVYbaKuCL3Q
   keP/25+WCKygCofVTGEPqigMBpk8LKmHh/m3QhC4HZtNHsF5rdiuoCbQJ
   7dtoDPxMH8xHe+FIdoHi6Sd0QijMdr3rVQ7W2RRlDrRmpZrPtyIKBp+fs
   HhtYO3vITiEC+PkwNdxO+CR30QxtAIWwQiGyBSRCKktfC3xIHzpoJX7Wu
   60AES5QHmmRHfbE74RsKcuQOL+1Oym1o9QoqFL6n7eTHIZ7FkyMN09kOB
   6p+f+m/5zuhHIH1EXKQW2e7zEEJtOWVd4NmWnvZuEoTMuij9zzYIJq6JQ
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="325941034"
X-IronPort-AV: E=Sophos;i="5.97,253,1669104000"; 
   d="scan'208";a="325941034"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 27 Jan 2023 22:33:21 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10603"; a="806072350"
X-IronPort-AV: E=Sophos;i="5.97,253,1669104000"; 
   d="scan'208";a="806072350"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 27 Jan 2023 22:33:20 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pLem7-0000SH-1q;
        Sat, 28 Jan 2023 06:33:19 +0000
Date:   Sat, 28 Jan 2023 14:32:29 +0800
From:   kernel test robot <lkp@intel.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     oe-kbuild-all@lists.linux.dev, netdev@vger.kernel.org
Subject: [net-next:master 12/39] arch/sh/include/asm/checksum_32.h:53:14:
 error: implicit declaration of function 'access_ok'
Message-ID: <202301281438.ZNGVwW6S-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   c2ea552065e43d05bce240f53c3185fd3a066204
commit: 68f4eae781dd25aca2eb84ca2279663689db8d19 [12/39] net: checksum: drop the linux/uaccess.h include
config: sh-allmodconfig (https://download.01.org/0day-ci/archive/20230128/202301281438.ZNGVwW6S-lkp@intel.com/config)
compiler: sh4-linux-gcc (GCC) 12.1.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=68f4eae781dd25aca2eb84ca2279663689db8d19
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch --no-tags net-next master
        git checkout 68f4eae781dd25aca2eb84ca2279663689db8d19
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sh olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross W=1 O=build_dir ARCH=sh SHELL=/bin/bash net/netfilter/ipvs/

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   In file included from arch/sh/include/asm/checksum.h:2,
                    from include/net/checksum.h:21,
                    from include/net/ip_vs.h:23,
                    from net/netfilter/ipvs/ip_vs_rr.c:23:
   arch/sh/include/asm/checksum_32.h: In function 'csum_and_copy_from_user':
>> arch/sh/include/asm/checksum_32.h:53:14: error: implicit declaration of function 'access_ok' [-Werror=implicit-function-declaration]
      53 |         if (!access_ok(src, len))
         |              ^~~~~~~~~
   cc1: some warnings being treated as errors


vim +/access_ok +53 arch/sh/include/asm/checksum_32.h

fcfdd0f14f94d4 include/asm-sh/checksum_32.h      Paul Mundt 2007-11-11  48  
7fe8970a78a193 arch/sh/include/asm/checksum_32.h Al Viro    2020-02-18  49  #define _HAVE_ARCH_COPY_AND_CSUM_FROM_USER
fcfdd0f14f94d4 include/asm-sh/checksum_32.h      Paul Mundt 2007-11-11  50  static inline
c693cc4676a055 arch/sh/include/asm/checksum_32.h Al Viro    2020-07-11  51  __wsum csum_and_copy_from_user(const void __user *src, void *dst, int len)
fcfdd0f14f94d4 include/asm-sh/checksum_32.h      Paul Mundt 2007-11-11  52  {
c693cc4676a055 arch/sh/include/asm/checksum_32.h Al Viro    2020-07-11 @53  	if (!access_ok(src, len))
c693cc4676a055 arch/sh/include/asm/checksum_32.h Al Viro    2020-07-11  54  		return 0;
dc16c8a9ce980d arch/sh/include/asm/checksum_32.h Al Viro    2020-07-12  55  	return csum_partial_copy_generic((__force const void *)src, dst, len);
fcfdd0f14f94d4 include/asm-sh/checksum_32.h      Paul Mundt 2007-11-11  56  }
fcfdd0f14f94d4 include/asm-sh/checksum_32.h      Paul Mundt 2007-11-11  57  

:::::: The code at line 53 was first introduced by commit
:::::: c693cc4676a055c4126e487b30b0a96ea7ec9936 saner calling conventions for csum_and_copy_..._user()

:::::: TO: Al Viro <viro@zeniv.linux.org.uk>
:::::: CC: Al Viro <viro@zeniv.linux.org.uk>

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
