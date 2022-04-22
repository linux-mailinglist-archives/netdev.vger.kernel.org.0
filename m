Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AF0C550ADE9
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 04:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1443474AbiDVCoe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Apr 2022 22:44:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41002 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1443464AbiDVCod (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Apr 2022 22:44:33 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 326DB4C426;
        Thu, 21 Apr 2022 19:41:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650595300; x=1682131300;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ziHABANE59wRolQJClZuDMbt1HuNA/mx2V8HeNMrpkM=;
  b=Ql1FTKJtwodtMO+qh3i4hKx/UeOdNhm2Yfcy6bAVOw64ZaVCmodRx8W/
   +w/r3pjP02blguIZRDUAnDO040LaHyR0oL0Wuip4CFwGBSNenCPvAHvMB
   KHODCtT4S66MkUAOxY4O9Rf9GkBiy1H+uOvYt0xjO2OVfCwfCOsP8G5AU
   DNsm2ZDgRbcA8snWZ//C9GsFU/yx06FCLFKM38RVL4rectiW/UfZ1wnNt
   m6iOY25vQWALTQd0ESIv/Z0aMtY7gvkL6iWBG7DLQsvJpgku6lFi0kjFX
   k+iDDXCnK7aDBcnozXrevZjT9pzTDt7PxgIKyy3EgecDKxaU9Cq2s0095
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="245122193"
X-IronPort-AV: E=Sophos;i="5.90,280,1643702400"; 
   d="scan'208";a="245122193"
Received: from orsmga003.jf.intel.com ([10.7.209.27])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 19:41:39 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,280,1643702400"; 
   d="scan'208";a="511375279"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by orsmga003.jf.intel.com with ESMTP; 21 Apr 2022 19:41:35 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nhjEl-00097y-7D;
        Fri, 22 Apr 2022 02:41:35 +0000
Date:   Fri, 22 Apr 2022 10:41:00 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yu Zhe <yuzhe@nfschina.com>, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     kbuild-all@lists.01.org, b.a.t.m.a.n@lists.open-mesh.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liqiong@nfschina.com, kernel-janitors@vger.kernel.org,
        Yu Zhe <yuzhe@nfschina.com>
Subject: Re: [PATCH] batman-adv: remove unnecessary type castings
Message-ID: <202204221051.PRtLc0f7-lkp@intel.com>
References: <20220421154829.9775-1-yuzhe@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220421154829.9775-1-yuzhe@nfschina.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Yu,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on linus/master]
[also build test WARNING on v5.18-rc3 next-20220421]
[If your patch is applied to the wrong git tree, kindly drop us a note.
And when submitting patch, we suggest to use '--base' as documented in
https://git-scm.com/docs/git-format-patch]

url:    https://github.com/intel-lab-lkp/linux/commits/Yu-Zhe/batman-adv-remove-unnecessary-type-castings/20220421-235254
base:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git b253435746d9a4a701b5f09211b9c14d3370d0da
config: x86_64-randconfig-a013 (https://download.01.org/0day-ci/archive/20220422/202204221051.PRtLc0f7-lkp@intel.com/config)
compiler: gcc-11 (Debian 11.2.0-20) 11.2.0
reproduce (this is a W=1 build):
        # https://github.com/intel-lab-lkp/linux/commit/2474b41c585e849d3546e0aba8f3c862735a04ff
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yu-Zhe/batman-adv-remove-unnecessary-type-castings/20220421-235254
        git checkout 2474b41c585e849d3546e0aba8f3c862735a04ff
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        make W=1 O=build_dir ARCH=x86_64 SHELL=/bin/bash net/batman-adv/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

   net/batman-adv/bridge_loop_avoidance.c: In function 'batadv_choose_claim':
>> net/batman-adv/bridge_loop_avoidance.c:68:42: warning: initialization discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
      68 |         struct batadv_bla_claim *claim = data;
         |                                          ^~~~
--
   net/batman-adv/translation-table.c: In function 'batadv_choose_tt':
>> net/batman-adv/translation-table.c:109:12: warning: assignment discards 'const' qualifier from pointer target type [-Wdiscarded-qualifiers]
     109 |         tt = data;
         |            ^


vim +/const +68 net/batman-adv/bridge_loop_avoidance.c

    53	
    54	static void batadv_bla_periodic_work(struct work_struct *work);
    55	static void
    56	batadv_bla_send_announce(struct batadv_priv *bat_priv,
    57				 struct batadv_bla_backbone_gw *backbone_gw);
    58	
    59	/**
    60	 * batadv_choose_claim() - choose the right bucket for a claim.
    61	 * @data: data to hash
    62	 * @size: size of the hash table
    63	 *
    64	 * Return: the hash index of the claim
    65	 */
    66	static inline u32 batadv_choose_claim(const void *data, u32 size)
    67	{
  > 68		struct batadv_bla_claim *claim = data;
    69		u32 hash = 0;
    70	
    71		hash = jhash(&claim->addr, sizeof(claim->addr), hash);
    72		hash = jhash(&claim->vid, sizeof(claim->vid), hash);
    73	
    74		return hash % size;
    75	}
    76	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
