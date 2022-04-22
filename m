Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F66A50AF5C
	for <lists+netdev@lfdr.de>; Fri, 22 Apr 2022 07:07:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1444071AbiDVFKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 01:10:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47716 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444052AbiDVFKh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 01:10:37 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53CB04BBB5;
        Thu, 21 Apr 2022 22:07:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1650604065; x=1682140065;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=zLyK1VfPZcWeTRL84aSwetNS1RsgGB8NmLFyPkDWGM0=;
  b=mV7rVfzCk9BXnOAUp3b2m/CMhmIUlNliOCRoB1z3Jf3c6BQ3tLfiRp2Q
   y3IdEQCpb/xDfyxmSmeTBrFjcU1SWkDOiEZ+Yvu408c7npXe7FzLB3KzV
   Eypmh4s6DxesIonV76hP0AeeZ5BRZbiMq06atU3yC9GjiwV3vwPOgt7vP
   0WpWf9krisspuEFGkJkNEVdcjT2Ei4AYjDn4BMYlXChxAEtTwfe/9Jhpf
   1HD5GFVqMZUTUe2EJPdJQwAkjrbGoa1J0jgQcsER9Kf8iaib7Y24sVPT9
   hAByTJ8UXOknoMVIMAn3F10e6sNEBgdd85aqQ3EY4jwJao12NWxp2iPt+
   Q==;
X-IronPort-AV: E=McAfee;i="6400,9594,10324"; a="244501170"
X-IronPort-AV: E=Sophos;i="5.90,280,1643702400"; 
   d="scan'208";a="244501170"
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 21 Apr 2022 22:07:45 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,280,1643702400"; 
   d="scan'208";a="593989379"
Received: from lkp-server01.sh.intel.com (HELO 3abc53900bec) ([10.239.97.150])
  by orsmga001.jf.intel.com with ESMTP; 21 Apr 2022 22:07:41 -0700
Received: from kbuild by 3abc53900bec with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1nhlW8-0009FA-Nd;
        Fri, 22 Apr 2022 05:07:40 +0000
Date:   Fri, 22 Apr 2022 13:07:20 +0800
From:   kernel test robot <lkp@intel.com>
To:     Yu Zhe <yuzhe@nfschina.com>, mareklindner@neomailbox.ch,
        sw@simonwunderlich.de, a@unstable.cc, sven@narfation.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com
Cc:     kbuild-all@lists.01.org, b.a.t.m.a.n@lists.open-mesh.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        liqiong@nfschina.com, kernel-janitors@vger.kernel.org,
        Yu Zhe <yuzhe@nfschina.com>
Subject: Re: [PATCH] batman-adv: remove unnecessary type castings
Message-ID: <202204221227.5z0xsJa9-lkp@intel.com>
References: <20220421154829.9775-1-yuzhe@nfschina.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220421154829.9775-1-yuzhe@nfschina.com>
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
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
config: parisc-randconfig-s031-20220421 (https://download.01.org/0day-ci/archive/20220422/202204221227.5z0xsJa9-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 11.2.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-dirty
        # https://github.com/intel-lab-lkp/linux/commit/2474b41c585e849d3546e0aba8f3c862735a04ff
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review Yu-Zhe/batman-adv-remove-unnecessary-type-castings/20220421-235254
        git checkout 2474b41c585e849d3546e0aba8f3c862735a04ff
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.2.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=parisc SHELL=/bin/bash net/batman-adv/

If you fix the issue, kindly add following tag as appropriate
Reported-by: kernel test robot <lkp@intel.com>


sparse warnings: (new ones prefixed by >>)
>> net/batman-adv/bridge_loop_avoidance.c:68:42: sparse: sparse: incorrect type in initializer (different modifiers) @@     expected struct batadv_bla_claim *claim @@     got void const *data @@
   net/batman-adv/bridge_loop_avoidance.c:68:42: sparse:     expected struct batadv_bla_claim *claim
   net/batman-adv/bridge_loop_avoidance.c:68:42: sparse:     got void const *data
>> net/batman-adv/bridge_loop_avoidance.c:68:42: sparse: sparse: incorrect type in initializer (different modifiers) @@     expected struct batadv_bla_claim *claim @@     got void const *data @@
   net/batman-adv/bridge_loop_avoidance.c:68:42: sparse:     expected struct batadv_bla_claim *claim
   net/batman-adv/bridge_loop_avoidance.c:68:42: sparse:     got void const *data
--
>> net/batman-adv/translation-table.c:109:12: sparse: sparse: incorrect type in assignment (different modifiers) @@     expected struct batadv_tt_common_entry *tt @@     got void const *data @@
   net/batman-adv/translation-table.c:109:12: sparse:     expected struct batadv_tt_common_entry *tt
   net/batman-adv/translation-table.c:109:12: sparse:     got void const *data
>> net/batman-adv/translation-table.c:109:12: sparse: sparse: incorrect type in assignment (different modifiers) @@     expected struct batadv_tt_common_entry *tt @@     got void const *data @@
   net/batman-adv/translation-table.c:109:12: sparse:     expected struct batadv_tt_common_entry *tt
   net/batman-adv/translation-table.c:109:12: sparse:     got void const *data

vim +68 net/batman-adv/bridge_loop_avoidance.c

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
