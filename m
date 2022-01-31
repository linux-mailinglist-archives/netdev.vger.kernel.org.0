Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 007D64A4613
	for <lists+netdev@lfdr.de>; Mon, 31 Jan 2022 12:49:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377293AbiAaLtW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Jan 2022 06:49:22 -0500
Received: from mga04.intel.com ([192.55.52.120]:5841 "EHLO mga04.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1377354AbiAaLrY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 31 Jan 2022 06:47:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1643629644; x=1675165644;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=JgrmgKu2ltoPrTRYP35s5M5YCdv3Ln8H/OSyyhoOzFU=;
  b=fiGjendbQI4KyccXTUZztZ5H2JzjDF7it9RuZa6avCXEzgEtf+0NP7dy
   AUBaaWtg3myjTWs883nn1Sqm27ZkzNMQVO9wsk6DLL999ruiUBcOPoq1V
   Se9MzAnyOfRYMI49eWzeiqP4KjcQ8jPrlyTp53e14Bvtsnjqxgp63IH4E
   XalIbpysDlx4gCfb7GRIK0xemQB9I2PTIfLIV56n3roeqS4UpgArZG58v
   gISK1UkDnrx/i8wisRKi4YlLAAgZQH6BEUUGNaA8SdMbjj1p2LIBPtS2v
   bgGmH7NhH5fhEcF7lsdqedOFSKqLvH5S+Lt2qfShvPfdTf/ttmE7ouEku
   g==;
X-IronPort-AV: E=McAfee;i="6200,9189,10243"; a="246278270"
X-IronPort-AV: E=Sophos;i="5.88,330,1635231600"; 
   d="scan'208";a="246278270"
Received: from fmsmga001.fm.intel.com ([10.253.24.23])
  by fmsmga104.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 31 Jan 2022 03:47:24 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.88,330,1635231600"; 
   d="scan'208";a="675703348"
Received: from lkp-server01.sh.intel.com (HELO 276f1b88eecb) ([10.239.97.150])
  by fmsmga001.fm.intel.com with ESMTP; 31 Jan 2022 03:47:23 -0800
Received: from kbuild by 276f1b88eecb with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nEV9W-000Rrb-Bs; Mon, 31 Jan 2022 11:47:22 +0000
Date:   Mon, 31 Jan 2022 19:46:40 +0800
From:   kernel test robot <lkp@intel.com>
To:     Juhee Kang <claudiajkang@gmail.com>, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, arvid.brodin@alten.se
Cc:     kbuild-all@lists.01.org
Subject: Re: [PATCH net-next] net: hsr: use hlist_head instead of list_head
 for mac addresses
Message-ID: <202201311904.frzcODO4-lkp@intel.com>
References: <20220131090307.2654-1-claudiajkang@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220131090307.2654-1-claudiajkang@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Juhee,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/0day-ci/linux/commits/Juhee-Kang/net-hsr-use-hlist_head-instead-of-list_head-for-mac-addresses/20220131-170414
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git ff58831fa02deb42fd731f830d8d9ec545573c7c
config: nios2-randconfig-s031-20220131 (https://download.01.org/0day-ci/archive/20220131/202201311904.frzcODO4-lkp@intel.com/config)
compiler: nios2-linux-gcc (GCC) 11.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/0day-ci/linux/commit/4610359df4a1f524fe7c2b85702a561ebf53fee8
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Juhee-Kang/net-hsr-use-hlist_head-instead-of-list_head-for-mac-addresses/20220131-170414
        git checkout 4610359df4a1f524fe7c2b85702a561ebf53fee8
        # save the config file to linux build tree
        mkdir build_dir
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=nios2 SHELL=/bin/bash net/hsr/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> net/hsr/hsr_framereg.c:52:17: sparse: sparse: cast removes address space '__rcu' of expression
   net/hsr/hsr_framereg.c:101:33: sparse: sparse: cast removes address space '__rcu' of expression
   net/hsr/hsr_framereg.c:122:25: sparse: sparse: cast removes address space '__rcu' of expression
   net/hsr/hsr_framereg.c:595:25: sparse: sparse: cast removes address space '__rcu' of expression

vim +/__rcu +52 net/hsr/hsr_framereg.c

    46	
    47	bool hsr_addr_is_self(struct hsr_priv *hsr, unsigned char *addr)
    48	{
    49		struct hsr_node *node;
    50	
    51		node = hlist_empty(&hsr->self_node_db) ? NULL :
  > 52			hlist_entry(hlist_first_rcu(&hsr->self_node_db),
    53				    struct hsr_node, mac_list);
    54		if (!node) {
    55			WARN_ONCE(1, "HSR: No self node\n");
    56			return false;
    57		}
    58	
    59		if (ether_addr_equal(addr, node->macaddress_A))
    60			return true;
    61		if (ether_addr_equal(addr, node->macaddress_B))
    62			return true;
    63	
    64		return false;
    65	}
    66	

---
0-DAY CI Kernel Test Service, Intel Corporation
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
