Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8EE704D66EC
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 17:58:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350216AbiCKQ7p (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Mar 2022 11:59:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1347005AbiCKQ7o (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Mar 2022 11:59:44 -0500
Received: from mga06.intel.com (mga06.intel.com [134.134.136.31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DF69665796;
        Fri, 11 Mar 2022 08:58:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647017920; x=1678553920;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=xss8NVffgnDqny0DrevtiFdcFMiLKAGG+aI7RRI/y0o=;
  b=W8HkTavODK1O+jdAPf65T6PEwVm8q9GoGfDyPv5iG9Pka8s8Un6qtDQB
   8GKXQXNJiSCWNtV8SEfkQCNnRSvuUQdWLpmaPAzkBnvSkS4Hno9QTlBGg
   C/ZA8U+Dn4ztRkRsMecaaXQ+d1bCWtUuzFqQmlizy1UXmw9vGcQJRPxHr
   tKv1WOtCgAdBt8jJv5SXZcVb/DzY10QnbPEkdXz4FEveNKzpAEKY37fSV
   SszaieKHHlQ5cHA/7mMoClDhf9HKe8rQHd/iKq4iXcqJmaLZX+HTj7OFt
   xOS4J+IUFGlSzxa80nzGfD7EH6DvKNrncWUYjTeguwZIY9parm+JznW15
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10283"; a="316330538"
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="316330538"
Received: from fmsmga007.fm.intel.com ([10.253.24.52])
  by orsmga104.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 11 Mar 2022 08:58:40 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,174,1643702400"; 
   d="scan'208";a="548509073"
Received: from lkp-server02.sh.intel.com (HELO 89b41b6ae01c) ([10.239.97.151])
  by fmsmga007.fm.intel.com with ESMTP; 11 Mar 2022 08:58:37 -0800
Received: from kbuild by 89b41b6ae01c with local (Exim 4.92)
        (envelope-from <lkp@intel.com>)
        id 1nSib6-0006nF-Dj; Fri, 11 Mar 2022 16:58:36 +0000
Date:   Sat, 12 Mar 2022 00:58:02 +0800
From:   kernel test robot <lkp@intel.com>
To:     Sun Shouxin <sunshouxin@chinatelecom.cn>, j.vosburgh@gmail.com,
        vfalico@gmail.com, andy@greyhouse.net, davem@davemloft.net,
        kuba@kernel.org, yoshfuji@linux-ipv6.org, dsahern@kernel.org
Cc:     kbuild-all@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, huyd12@chinatelecom.cn,
        sunshouxin@chinatelecom.cn
Subject: Re: [PATCH 3/3] net:bonding:Add support for IPV6 RLB to balance-alb
 mode
Message-ID: <202203120001.k8e1fNyg-lkp@intel.com>
References: <20220311024958.7458-4-sunshouxin@chinatelecom.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220311024958.7458-4-sunshouxin@chinatelecom.cn>
User-Agent: Mutt/1.10.1 (2018-07-13)
X-Spam-Status: No, score=-4.9 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sun,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on 2a9eef868a997ec575c2e6ae885e91313f635d59]

url:    https://github.com/0day-ci/linux/commits/Sun-Shouxin/net-bonding-Add-support-for-IPV6-RLB-to-balance-alb-mode/20220311-110221
base:   2a9eef868a997ec575c2e6ae885e91313f635d59
config: i386-randconfig-a005 (https://download.01.org/0day-ci/archive/20220312/202203120001.k8e1fNyg-lkp@intel.com/config)
compiler: gcc-9 (Ubuntu 9.4.0-1ubuntu1~20.04) 9.4.0
reproduce (this is a W=1 build):
        # https://github.com/0day-ci/linux/commit/dde3df4ab3030a55968f48dc96ff2014d8f18410
        git remote add linux-review https://github.com/0day-ci/linux
        git fetch --no-tags linux-review Sun-Shouxin/net-bonding-Add-support-for-IPV6-RLB-to-balance-alb-mode/20220311-110221
        git checkout dde3df4ab3030a55968f48dc96ff2014d8f18410
        # save the config file to linux build tree
        mkdir build_dir
        make W=1 O=build_dir ARCH=i386 SHELL=/bin/bash drivers/net/bonding/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> drivers/net/bonding/bond_alb.c:986:6: warning: no previous prototype for 'rlb6_update_client' [-Wmissing-prototypes]
     986 | void rlb6_update_client(struct rlb_client_info *client_info)
         |      ^~~~~~~~~~~~~~~~~~


vim +/rlb6_update_client +986 drivers/net/bonding/bond_alb.c

   984	
   985	/*********************** ipv6 rlb specific functions ***************************/
 > 986	void rlb6_update_client(struct rlb_client_info *client_info)
   987	{
   988		int i;
   989	
   990		if (!client_info->slave || !is_valid_ether_addr(client_info->mac_dst))
   991			return;
   992	
   993		for (i = 0; i < RLB_ARP_BURST_SIZE; i++) {
   994			ndisc_bond_send_na(client_info->slave->dev,
   995					   &client_info->ip6_dst,
   996					   &client_info->ip6_src,
   997					   false, false, true, true,
   998					   client_info->vlan_id,
   999					   client_info->mac_dst,
  1000					   client_info->slave->dev->dev_addr);
  1001		}
  1002	}
  1003	

---
0-DAY CI Kernel Test Service
https://lists.01.org/hyperkitty/list/kbuild-all@lists.01.org
