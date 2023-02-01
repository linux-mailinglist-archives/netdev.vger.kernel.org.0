Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5549D686B31
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 17:11:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232398AbjBAQK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 11:10:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231895AbjBAQK6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 11:10:58 -0500
Received: from mga03.intel.com (mga03.intel.com [134.134.136.65])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 216CA40FD
        for <netdev@vger.kernel.org>; Wed,  1 Feb 2023 08:10:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1675267857; x=1706803857;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=vw5Z0glpJyiCwy0cyVA8rjsV+TX5KMmGLPplMe30Eus=;
  b=h4pI/bKehSKYI5OxHBrmS0NEvYh9eoX0yCzJ9eimVFS1TxDhIcGALx57
   atI4HdOfRvqIpZ28xM8YvOhfC4cCfNxKjrSmHc6T5J/elnkNJdOmzfnhK
   C8TWs40wFymBjnDZZPane9BLKFrJ/y3xtaCbie9JzuC0yTzUJEx0JUKBn
   qEbLuiqS89sdnETP0lpls3GitOaAQMnqcTkZZ/n4WrIhZ09b40kmCXnBf
   GqtshCcQEiPTc5MU8PuJs6Bg4h0ZYM/4cjiRqs1HsAlxq5UnAqzT5x5Qb
   8HFVS3pegTFB1yd7ALHqs03SG4SdyDQWUYG/CTDsqjG0rrDDA+kGDgPUm
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="330319877"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="330319877"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 01 Feb 2023 08:10:38 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10608"; a="658369623"
X-IronPort-AV: E=Sophos;i="5.97,263,1669104000"; 
   d="scan'208";a="658369623"
Received: from lkp-server01.sh.intel.com (HELO ffa7f14d1d0f) ([10.239.97.150])
  by orsmga007.jf.intel.com with ESMTP; 01 Feb 2023 08:10:33 -0800
Received: from kbuild by ffa7f14d1d0f with local (Exim 4.96)
        (envelope-from <lkp@intel.com>)
        id 1pNFgu-0005ZB-2v;
        Wed, 01 Feb 2023 16:10:32 +0000
Date:   Thu, 2 Feb 2023 00:09:41 +0800
From:   kernel test robot <lkp@intel.com>
To:     =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        richardcochran@gmail.com
Cc:     oe-kbuild-all@lists.linux.dev, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org,
        =?iso-8859-1?B?zfFpZ28=?= Huguet <ihuguet@redhat.com>,
        Yalin Li <yalli@redhat.com>
Subject: Re: [PATCH net 4/4] sfc: remove expired unicast PTP filters
Message-ID: <202302020019.2MT9fEOy-lkp@intel.com>
References: <20230131160506.47552-5-ihuguet@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20230131160506.47552-5-ihuguet@redhat.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Íñigo,

Thank you for the patch! Perhaps something to improve:

[auto build test WARNING on net/master]

url:    https://github.com/intel-lab-lkp/linux/commits/igo-Huguet/sfc-store-PTP-filters-in-a-list/20230201-000831
patch link:    https://lore.kernel.org/r/20230131160506.47552-5-ihuguet%40redhat.com
patch subject: [PATCH net 4/4] sfc: remove expired unicast PTP filters
config: parisc-randconfig-s033-20230129 (https://download.01.org/0day-ci/archive/20230202/202302020019.2MT9fEOy-lkp@intel.com/config)
compiler: hppa-linux-gcc (GCC) 12.1.0
reproduce:
        wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
        chmod +x ~/bin/make.cross
        # apt-get install sparse
        # sparse version: v0.6.4-39-gce1a6720-dirty
        # https://github.com/intel-lab-lkp/linux/commit/d631c3b59ac7ba7f62da245114156866ea74a15b
        git remote add linux-review https://github.com/intel-lab-lkp/linux
        git fetch --no-tags linux-review igo-Huguet/sfc-store-PTP-filters-in-a-list/20230201-000831
        git checkout d631c3b59ac7ba7f62da245114156866ea74a15b
        # save the config file
        mkdir build_dir && cp config build_dir/.config
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=parisc olddefconfig
        COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-12.1.0 make.cross C=1 CF='-fdiagnostic-prefix -D__CHECK_ENDIAN__' O=build_dir ARCH=parisc SHELL=/bin/bash

If you fix the issue, kindly add following tag where applicable
| Reported-by: kernel test robot <lkp@intel.com>

sparse warnings: (new ones prefixed by >>)
>> drivers/net/ethernet/sfc/ptp.c:1515:30: sparse: sparse: incompatible types for operation (<):
>> drivers/net/ethernet/sfc/ptp.c:1515:30: sparse:    struct efx_ptp_rxfilter *[assigned] rxfilter
>> drivers/net/ethernet/sfc/ptp.c:1515:30: sparse:    int

vim +1515 drivers/net/ethernet/sfc/ptp.c

  1493	
  1494	static int efx_ptp_insert_unicast_filter(struct efx_nic *efx,
  1495						 struct sk_buff *skb)
  1496	{
  1497		struct efx_ptp_data *ptp = efx->ptp_data;
  1498		struct efx_ptp_rxfilter *rxfilter;
  1499	
  1500		if (!efx_ptp_valid_unicast_event_pkt(skb))
  1501			return -EINVAL;
  1502	
  1503		if (skb->protocol == htons(ETH_P_IP)) {
  1504			__be32 addr = ip_hdr(skb)->saddr;
  1505	
  1506			rxfilter = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_ucast,
  1507							      addr, PTP_EVENT_PORT);
  1508			if (IS_ERR(rxfilter))
  1509				goto fail;
  1510	
  1511			rxfilter->expiry = jiffies + UCAST_FILTER_EXPIRY_JIFFIES;
  1512	
  1513			rxfilter = efx_ptp_insert_ipv4_filter(efx, &ptp->rxfilters_ucast,
  1514							      addr, PTP_GENERAL_PORT);
> 1515			if (rxfilter < 0)
  1516				goto fail;
  1517	
  1518			rxfilter->expiry = jiffies + UCAST_FILTER_EXPIRY_JIFFIES;
  1519		} else if (efx_ptp_use_mac_tx_timestamps(efx)) {
  1520			/* IPv6 PTP only supported by devices with MAC hw timestamp */
  1521			struct in6_addr *addr = &ipv6_hdr(skb)->saddr;
  1522	
  1523			rxfilter = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_ucast,
  1524							      addr, PTP_EVENT_PORT);
  1525			if (IS_ERR(rxfilter))
  1526				goto fail;
  1527	
  1528			rxfilter->expiry = jiffies + UCAST_FILTER_EXPIRY_JIFFIES;
  1529	
  1530			rxfilter = efx_ptp_insert_ipv6_filter(efx, &ptp->rxfilters_ucast,
  1531							      addr, PTP_GENERAL_PORT);
  1532			if (IS_ERR(rxfilter))
  1533				goto fail;
  1534	
  1535			rxfilter->expiry = jiffies + UCAST_FILTER_EXPIRY_JIFFIES;
  1536		} else {
  1537			return -EOPNOTSUPP;
  1538		}
  1539	
  1540		return 0;
  1541	
  1542	fail:
  1543		efx_ptp_remove_filters(efx, &ptp->rxfilters_ucast);
  1544		return PTR_ERR(rxfilter);
  1545	}
  1546	

-- 
0-DAY CI Kernel Test Service
https://github.com/intel/lkp-tests
