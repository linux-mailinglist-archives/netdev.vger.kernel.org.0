Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67F1C4B2FE5
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 22:55:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236055AbiBKVzN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 16:55:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:33716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229663AbiBKVzN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 16:55:13 -0500
Received: from mga05.intel.com (mga05.intel.com [192.55.52.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89987C6E
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 13:55:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1644616511; x=1676152511;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=TopYakJWlx3R6lJuj9QEDVnZISl5WHk9gEo0i7LyijM=;
  b=FQ+O+74Atxar6a85ov0WNLSYAquQx1+DuT/47q+lQfRcUPl0j6X8kBUR
   yJkNG85O4qscnOTvR01B+U5r8CTHPuZzrg/4CGv7LNfqSn6pRktftAMQa
   gtd9mWpN10LbzCbYNuYvZjIollzw7vqtE8rhukLyl1SPOKcWrOHA5YsgA
   4At2e5hb7nxo3byd7x2JNWbSBXVvbOmeZRjy5/8QfAhsx6u0+JOcqZ4ri
   O7ljmtnzlOfw4fviwdHDVaffXswdFtIyrl44hvHSgKWAskhiR2b9GfZ1D
   jYR4Koq2grCVbDmAggLDJsqnxsn0MNYEC+42JNaQk7r6bbPU/UJh2GoL/
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10255"; a="336238559"
X-IronPort-AV: E=Sophos;i="5.88,361,1635231600"; 
   d="scan'208";a="336238559"
Received: from orsmga002.jf.intel.com ([10.7.209.21])
  by fmsmga105.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Feb 2022 13:55:11 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,361,1635231600"; 
   d="scan'208";a="500913149"
Received: from lkp-server01.sh.intel.com (HELO d95dc2dabeb1) ([10.239.97.150])
  by orsmga002.jf.intel.com with ESMTP; 11 Feb 2022 13:55:09 -0800
Received: from kbuild by d95dc2dabeb1 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nIdsi-0005ES-RZ; Fri, 11 Feb 2022 21:55:08 +0000
Date:   Sat, 12 Feb 2022 05:54:31 +0800
From:   kernel test robot <lkp@intel.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     llvm@lists.linux.dev, kbuild-all@lists.01.org,
        netdev@vger.kernel.org, Pablo Neira Ayuso <pablo@netfilter.org>,
        Florian Westphal <fw@strlen.de>
Subject: [net:master 21/30] net/netfilter/xt_socket.c:224:3: error: implicit
 declaration of function 'nf_defrag_ipv6_disable'
Message-ID: <202202120509.FMR7TEL1-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
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

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git master
head:   85d24ad38bc4658ce9a16b85b9c8dc0577d66c71
commit: 75063c9294fb239bbe64eb72141b6871fe526d29 [21/30] netfilter: xt_socket: fix a typo in socket_mt_destroy()
config: hexagon-randconfig-r045-20220211 (https://download.01.org/0day-ci/archive/20220212/202202120509.FMR7TEL1-lkp@intel.com/config)
compiler: clang version 15.0.0 (https://github.com/llvm/llvm-project f6685f774697c85d6a352dcea013f46a99f9fe31)
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git/commit/?id=75063c9294fb239bbe64eb72141b6871fe526d29
        git remote add net https://git.kernel.org/pub/scm/linux/kernel/git/davem/net.git
        git fetch --no-tags net master
        git checkout 75063c9294fb239bbe64eb72141b6871fe526d29
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=clang make.cross W=1 O=build_dir ARCH=hexagon SHELL=/bin/bash net/netfilter/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

>> net/netfilter/xt_socket.c:224:3: error: implicit declaration of function 'nf_defrag_ipv6_disable' [-Werror,-Wimplicit-function-declaration]
                   nf_defrag_ipv6_disable(par->net);
                   ^
   net/netfilter/xt_socket.c:224:3: note: did you mean 'nf_defrag_ipv4_disable'?
   include/net/netfilter/ipv4/nf_defrag_ipv4.h:7:6: note: 'nf_defrag_ipv4_disable' declared here
   void nf_defrag_ipv4_disable(struct net *net);
        ^
   1 error generated.


vim +/nf_defrag_ipv6_disable +224 net/netfilter/xt_socket.c

   218	
   219	static void socket_mt_destroy(const struct xt_mtdtor_param *par)
   220	{
   221		if (par->family == NFPROTO_IPV4)
   222			nf_defrag_ipv4_disable(par->net);
   223		else if (par->family == NFPROTO_IPV6)
 > 224			nf_defrag_ipv6_disable(par->net);
   225	}
   226	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
