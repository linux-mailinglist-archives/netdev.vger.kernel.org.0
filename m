Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2814B4BD110
	for <lists+netdev@lfdr.de>; Sun, 20 Feb 2022 20:41:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244664AbiBTTkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Feb 2022 14:40:13 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:53118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243945AbiBTTkN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Feb 2022 14:40:13 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9267925C60
        for <netdev@vger.kernel.org>; Sun, 20 Feb 2022 11:39:51 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1645385991; x=1676921991;
  h=date:from:to:cc:subject:message-id:mime-version;
  bh=qjekddgomPlWrcOcPDtHLL4sz4eoL+bsL9lRIDNoD1Y=;
  b=ND7btxec7U0RBmAErO4pLhYFU9zxOnkOFHpmzRKWJYA6MU7Zoej4Q6Aw
   BWR5GW60KSZybcfzHB5HYmJqqgd7KeU2CGMqvF13SXzMl+/9lbyybiQaB
   0eN39YbivpgBn2iWHmoAnVeiXiDjoB3RKFKAKOgqJYU6TtFh+/tbuDWLY
   7ONQMJV+/Zhhh5PdVMGZ3JTS43raIDdGxcbYGn/EV9TqVQZrROmjI5Li3
   ijPrL0CQo14vMLTXiyN1SdnHYnA+RMoVZHQ6bl66QbxEl92w8FIK+vlpc
   1DNEEyxwGuKkh4dIoFjLmlY0QY1mNLaVq9NE5/4U9qqL60/wew1U+6bvT
   w==;
X-IronPort-AV: E=McAfee;i="6200,9189,10264"; a="234938125"
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="234938125"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 20 Feb 2022 11:39:49 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,384,1635231600"; 
   d="scan'208";a="490230904"
Received: from lkp-server01.sh.intel.com (HELO da3212ac2f54) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 20 Feb 2022 11:39:48 -0800
Received: from kbuild by da3212ac2f54 with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nLs3g-0000f8-37; Sun, 20 Feb 2022 19:39:48 +0000
Date:   Mon, 21 Feb 2022 03:38:50 +0800
From:   kernel test robot <lkp@intel.com>
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org
Subject: [net-next:master 56/73] hsr_framereg.c:undefined reference to
 `lockdep_is_held'
Message-ID: <202202210326.nqMpt9hG-lkp@intel.com>
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
config: arm-randconfig-r001-20220220 (https://download.01.org/0day-ci/archive/20220221/202202210326.nqMpt9hG-lkp@intel.com/config)
compiler: arm-linux-gnueabi-gcc (GCC) 11.2.0
reproduce (this is a W=1 build):
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git/commit/?id=e7f27420681f23e7e0f28beed38144058752112e
        git remote add net-next https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git
        git fetch --no-tags net-next master
        git checkout e7f27420681f23e7e0f28beed38144058752112e
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross O=build_dir ARCH=arm SHELL=/bin/bash

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All errors (new ones prefixed by >>):

   arm-linux-gnueabi-ld: net/hsr/hsr_framereg.o: in function `hsr_addr_is_self':
>> hsr_framereg.c:(.text+0x226): undefined reference to `lockdep_is_held'
   arm-linux-gnueabi-ld: net/hsr/hsr_framereg.o: in function `hsr_create_self_node':
   hsr_framereg.c:(.text+0x2ca): undefined reference to `lockdep_is_held'
   arm-linux-gnueabi-ld: net/hsr/hsr_framereg.o: in function `hsr_del_self_node':
   hsr_framereg.c:(.text+0x3b2): undefined reference to `lockdep_is_held'
   arm-linux-gnueabi-ld: net/hsr/hsr_framereg.o: in function `hsr_get_next_node':
   hsr_framereg.c:(.text+0xb4c): undefined reference to `lockdep_is_held'

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
