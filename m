Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6B8A5510D8D
	for <lists+netdev@lfdr.de>; Wed, 27 Apr 2022 02:57:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1356533AbiD0BAk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 21:00:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1356453AbiD0BAj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 21:00:39 -0400
Received: from mga17.intel.com (mga17.intel.com [192.55.52.151])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F365E2DD5E;
        Tue, 26 Apr 2022 17:57:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1651021051; x=1682557051;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:in-reply-to;
  bh=ZcuTdMRt4Sh+aF1R4ZTUZYM3s8YXeD0K6R2AxevhatU=;
  b=PKVpoChhpfqVoxbThACbh4L8EnmS2a2u8Vu3yQ4N/Yk5604OMQzv9g8W
   g93I7SvJGTb/j0Sa3qEkhlJiGZ6J02qv5eaPun2h+Ptqo7iZDyx6Ltg5W
   8zOCMj64BU/FBpRQmsYYoQL286gvHm6puty8TnlolpwGVClLdXDI6JhaV
   yWnFJiXdjSIovdO2J61nWquY+Sd0d3Crun/nzAnWGabGuN34p3P5EicqE
   UD/dvhU8rZ8jcURB/iVOi8k9jhtSKKR37EvnhzbwnzFYmjebYmTd5Ou2P
   OABc4/39V5BVhKVI+xuar4cM+5vIZq5T5zA9QU3R3AwpHvTYYdx8UYwEW
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10329"; a="246337157"
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="246337157"
Received: from fmsmga003.fm.intel.com ([10.253.24.29])
  by fmsmga107.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Apr 2022 17:57:18 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.90,292,1643702400"; 
   d="scan'208";a="650457655"
Received: from lkp-server01.sh.intel.com (HELO 5056e131ad90) ([10.239.97.150])
  by FMSMGA003.fm.intel.com with ESMTP; 26 Apr 2022 17:57:15 -0700
Received: from kbuild by 5056e131ad90 with local (Exim 4.95)
        (envelope-from <lkp@intel.com>)
        id 1njVzW-00048Y-Dy;
        Wed, 27 Apr 2022 00:57:14 +0000
Date:   Wed, 27 Apr 2022 08:57:08 +0800
From:   kernel test robot <lkp@intel.com>
To:     Duoming Zhou <duoming@zju.edu.cn>, krzysztof.kozlowski@linaro.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org
Cc:     kbuild-all@lists.01.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, gregkh@linuxfoundation.org,
        alexander.deucher@amd.com, broonie@kernel.org,
        akpm@linux-foundation.org, linma@zju.edu.cn,
        Duoming Zhou <duoming@zju.edu.cn>
Subject: [RFC PATCH] nfc: nfcmrvl: main: nfc_download can be static
Message-ID: <YmiU5GyeIR8W+RL7@f68e8fcc9af0>
References: <20220426155911.77761-1-duoming@zju.edu.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220426155911.77761-1-duoming@zju.edu.cn>
X-Patchwork-Hint: ignore
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

net/nfc/core.c:28:6: warning: symbol 'nfc_download' was not declared. Should it be static?

Reported-by: kernel test robot <lkp@intel.com>
Signed-off-by: kernel test robot <lkp@intel.com>
---
 net/nfc/core.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/net/nfc/core.c b/net/nfc/core.c
index da8199f67d42c..9035935e93d80 100644
--- a/net/nfc/core.c
+++ b/net/nfc/core.c
@@ -25,7 +25,7 @@
 #define NFC_CHECK_PRES_FREQ_MS	2000
 
 int nfc_devlist_generation;
-bool nfc_download;
+static bool nfc_download;
 DEFINE_MUTEX(nfc_devlist_mutex);
 
 /* NFC device ID bitmap */
