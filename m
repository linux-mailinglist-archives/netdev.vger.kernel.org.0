Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 146CF564A5C
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 00:47:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229963AbiGCWrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 18:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229904AbiGCWrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 18:47:40 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5DC20D0;
        Sun,  3 Jul 2022 15:47:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1656888459; x=1688424459;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=/PmK2eXzgjrBLS74JCwU82LCDUPF/ZUhbL4hF+i0b7A=;
  b=AVna/CjMbie5MysrThMy5Cw4wPGgLgD2GX3Mo8a+wcb2S/8l9dfk1Hj9
   QQXTQMiw9rD2Ma6aIyc4vRqWSv6OKwwkDGJyU6QN4VXFaaosE1GHLg3Ls
   sXkPdvpazYbGZ0cR+KIy1bYCbIcbl5e2HU0iDIRxcIbkT19StZRZqwwiI
   OoZ+1cMA0Q6F9JRfzMN8KGC3/2b2I7GBXa/hrOjh/3gcVn9RTq2Qt0Gcw
   cruPps6kOjv18V7tpTUapWQEe/emgTF9lXcWh2U2/HBsQqzc2UMplZh0Q
   vyVmOoBsYj/VNsOcfWWoWnuUEPfMc/2wlSJ4XXGwpHe/PoBqG7jnXksYh
   w==;
X-IronPort-AV: E=McAfee;i="6400,9594,10397"; a="262784482"
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="262784482"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 03 Jul 2022 15:47:38 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.92,243,1650956400"; 
   d="scan'208";a="681993479"
Received: from lkp-server01.sh.intel.com (HELO 68b931ab7ac1) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 03 Jul 2022 15:47:35 -0700
Received: from kbuild by 68b931ab7ac1 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1o88NL-000H51-Au;
        Sun, 03 Jul 2022 22:47:35 +0000
Date:   Mon, 4 Jul 2022 06:47:33 +0800
From:   kernel test robot <lkp@intel.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>, netdev@vger.kernel.org
Cc:     kbuild-all@lists.01.org, ilias.apalodimas@linaro.org,
        hawk@kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, corbet@lwn.net,
        linux-doc@vger.kernel.org, jbrouer@redhat.com,
        lorenzo.bianconi@redhat.com
Subject: Re: [PATCH v2 net-next] Documentation: update
 networking/page_pool.rst with ethtool APIs
Message-ID: <202207040608.lU2e57H3-lkp@intel.com>
References: <8c1f582d286fd5a7406dfff895eea39bb8fedca6.1654546043.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <8c1f582d286fd5a7406dfff895eea39bb8fedca6.1654546043.git.lorenzo@kernel.org>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Lorenzo,

I love your patch! Perhaps something to improve:

[auto build test WARNING on net-next/master]

url:    https://github.com/intel-lab-lkp/linux/commits/Lorenzo-Bianconi/Documentation-update-networking-page_pool-rst-with-ethtool-APIs/20220607-041741
base:   https://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git 58f9d52ff689a262bec7f5713c07f5a79e115168
reproduce: make htmldocs

If you fix the issue, kindly add following tag where applicable
Reported-by: kernel test robot <lkp@intel.com>

All warnings (new ones prefixed by >>):

>> Documentation/networking/page_pool.rst:154: WARNING: Unexpected indentation.

vim +154 Documentation/networking/page_pool.rst

   151	
   152	* page_pool_ethtool_stats_get_strings(): reports page_pool ethtool stats
   153	  strings according to the struct page_pool_stats
 > 154	     * rx_pp_alloc_fast
   155	     * rx_pp_alloc_slow
   156	     * rx_pp_alloc_slow_ho
   157	     * rx_pp_alloc_empty
   158	     * rx_pp_alloc_refill
   159	     * rx_pp_alloc_waive
   160	     * rx_pp_recycle_cached
   161	     * rx_pp_recycle_cache_full
   162	     * rx_pp_recycle_ring
   163	     * rx_pp_recycle_ring_full
   164	     * rx_pp_recycle_released_ref
   165	

-- 
0-DAY CI Kernel Test Service
https://01.org/lkp
