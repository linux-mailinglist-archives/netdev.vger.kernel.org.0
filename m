Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C5DE14BD112
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 20:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244657AbiBTTkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 14:40:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234494AbiBTTkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 14:40:12 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CB0E25C47
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 11:39:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645385990; x=1676921990;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=3szNmDTIBbNSRjlfn6Pg5l/WTXQNYK7yFS4O6MVmjXg=;
  b=ZPIYKr+IJeVbpHMCMZkDEB9MfZtopAR3XyI/LyxUV+IJI73x1q9xZehx
   8aS3rvw6p2qvwycIZEzzii8/U8eFF7bTyHsTbpKUeQbxMMtWitA8UlwTL
   CJz7G/AEMnwYX6uzVVDG3DFeUB4+toUAnTRRuN+95gzEvPXMVudSiSMhp
   iOTalqBVdDse9LdF7OA6jrJVWtEYs4KpHoGK9S1IwmY+9DzlXvytQszdl
   m5B/zZe3SKM6Iq/LjXhdUp59Yx7ahE5LtVSKRRqyIbKsw6Qrs7WY7CPrS
   b5SRRULwpc6rAquAIKg/ksJvUNbb3kjKE6AkUw0FRjlJBLTHGNTaviq0z
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="234938123"
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="234938123"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2022 11:39:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="683005116"
Received: from lkp-server01.sh.intel.com (HELO da3212ac2f54) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 20 Feb 2022 11:39:48 -0800
Received: from kbuild by da3212ac2f54 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nLs3g-0000fE-4h; Sun, 20 Feb 2022 19:39:48 +0000
Date:   Mon, 21 Feb 2022 03:38:54 +0800
From:   kernel test robot <lkp@intel.com>
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: [net-next:master 56/73]
 hsr_framereg.c:(.text.hsr_addr_is_self+0x18): undefined reference to
 `lockdep_is_held'
Message-ID: <202202210300.ZktP8xTj-lkp@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tree:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
head:   adfb62dbda49d66eba6340324547ff89b09a66eb
commit: e7f27420681f23e7e0f28beed38144058752112e [56/73] net: hsr: fix suspicious RCU usage warning in hsr_node_get_first()
config: mips-randconfig-r002-20220220 (https://download.01.org/0day-ci/archive/20220221/202202210300.ZktP8xTj-lkp@intel.com/config)
compiler: mips-linux-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=e7f27420681f23e7e0f28beed38144058752112e
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch --no-tags net-next master
        git checkout e7f27420681f23e7e0f28beed38144058752112e
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=mips SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   mips-linux-ld: net/hsr/hsr_framereg.o: in function `hsr_addr_is_self':
>> hsr_framereg.c:(.text.hsr_addr_is_self+0x18): undefined reference to `lockdep_is_held'
   mips-linux-ld: net/hsr/hsr_framereg.o: in function `hsr_create_self_node':
>> hsr_framereg.c:(.text.hsr_create_self_node+0x74): undefined reference to `lockdep_is_held'
   mips-linux-ld: net/hsr/hsr_framereg.o: in function `hsr_del_self_node':
>> hsr_framereg.c:(.text.hsr_del_self_node+0x1c): undefined reference to `lockdep_is_held'
   mips-linux-ld: net/hsr/hsr_framereg.o: in function `hsr_get_next_node':
>> hsr_framereg.c:(.text.hsr_get_next_node+0x7c): undefined reference to `lockdep_is_held'

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
