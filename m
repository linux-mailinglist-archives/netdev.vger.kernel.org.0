Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F23634DE900
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 16:21:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243457AbiCSPW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 11:22:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53920 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232915AbiCSPW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 11:22:59 -0400
Received: from mga14.intel.com (mga14.intel.com [192.55.52.115])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8ACA7BE23
        for <netdev@vger.kernel.org>; Sat, 19 Mar 2022 08:21:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1647703298; x=1679239298;
  h=message-id:date:mime-version:from:subject:cc:to:
   content-transfer-encoding;
  bh=Cci/gtq4kPB/FlJ15//By/GBqL4egJvzRbgnsE4ggZ8=;
  b=c/FjHaKAWZwZQP3Fht8LPeQGWiG/xgjLVFaPh+EpnXmq1FL31oq4J3lw
   hvDM1RMoRnimJ8MYXAaUmsWpgvb/ATLcY0Va83BmhfTo+Pb7wEWoRfUBl
   HS/dAHN04N7edxWJcbUCjA2X5eJ8zcL5t3j5tk75+h21aVW3N76V50VxN
   g2eFlrQVATSpcBmDAHMJmUlFqjPWeqpCUl5Tq+87UP3TimJ8RG/icyxN3
   svS2sCn2osG62L7VH7BAuoiKHDKTzX040524aEpwQgP/5c+lNFtJHiBag
   CGpEsjLqnbKFowH3NnrPZqDJ9qgY2+iz/EooWHVIdYHV32N7hjbHoSeon
   Q==;
X-IronPort-AV: E=McAfee;i="6200,9189,10291"; a="257502487"
X-IronPort-AV: E=Sophos;i="5.90,194,1643702400"; 
   d="scan'208";a="257502487"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga103.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2022 08:21:38 -0700
X-IronPort-AV: E=Sophos;i="5.90,194,1643702400"; 
   d="scan'208";a="559104028"
Received: from mckumar-mobl1.gar.corp.intel.com (HELO [10.215.142.197]) ([10.215.142.197])
  by orsmga008-auth.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 19 Mar 2022 08:21:34 -0700
Message-ID: <1eb3d9e6-2adf-7f6c-4745-481451813522@linux.intel.com>
Date:   Sat, 19 Mar 2022 20:51:27 +0530
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.1
Content-Language: en-US
From:   "Kumar, M Chetan" <m.chetan.kumar@linux.intel.com>
Subject: net: wwan: ethernet interface support
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Sudi, Krishna C" <krishna.c.sudi@intel.com>, linuxwwan@intel.com
To:     Loic Poulain <loic.poulain@linaro.org>,
        Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Johannes Berg <johannes@sipsolutions.net>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi All,

Release16 5G WWAN Device need to support Ethernet interface for TSN requirement. 
So far WWAN interface are of IP type. Is there any plan to scale it to support 
ethernet interface type ?

Any thought process on TSN requirement support.

Regards,
Chetan
