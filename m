Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 280435A6776
	for <lists+netdev@lfdr.de>; Tue, 30 Aug 2022 17:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230452AbiH3Pcq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Aug 2022 11:32:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229608AbiH3Pco (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Aug 2022 11:32:44 -0400
Received: from mga12.intel.com (mga12.intel.com [192.55.52.136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79DB213287E;
        Tue, 30 Aug 2022 08:32:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1661873563; x=1693409563;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=3xZ3Q/436z1VYacKyP5nvTwV3/1ny0fzonH0Qns2GVI=;
  b=LRZ0EyCHIPtH6VuyqXvMgMd0Qw2A89rjds1/LpQQIIFxbDIPY/ccUsCp
   PzyRrj9m3jjVAbFhqDxAz2vJi/7QT1JfPH0qXo2mnocX6Awgwiwe84LZ1
   RwlxSMhw6Sn4CmIVlcyuBldBn1GBgvXZVKlweYQ+2uCytZF3OdK67xZ4n
   l4Yq/WpCwhaz9AuntIhsWjc/hO02jNiV3GuB8SxgOv/hTyJtw+UwfY7D0
   mq0LGDfJwPUIfOPtzvXo9GonNScWXlqzYB05yMEGgBNpScTqovj36N46K
   JAEtwbCLUmSBt/b3gcxO9YmK8xZ+bnXRzEsMxzNL3fOlwAh8XN2vugAmZ
   Q==;
X-IronPort-AV: E=McAfee;i="6500,9779,10455"; a="274956341"
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="274956341"
Received: from orsmga008.jf.intel.com ([10.7.209.65])
  by fmsmga106.fm.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 30 Aug 2022 08:32:43 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.93,275,1654585200"; 
   d="scan'208";a="641421603"
Received: from black.fi.intel.com ([10.237.72.28])
  by orsmga008.jf.intel.com with ESMTP; 30 Aug 2022 08:32:40 -0700
Received: by black.fi.intel.com (Postfix, from userid 1001)
        id 5ADC5238; Tue, 30 Aug 2022 18:32:51 +0300 (EEST)
From:   Mika Westerberg <mika.westerberg@linux.intel.com>
To:     linux-usb@vger.kernel.org
Cc:     Michael Jamet <michael.jamet@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Yehezkel Bernat <YehezkelShB@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lukas Wunner <lukas@wunner.de>, netdev@vger.kernel.org
Subject: [PATCH 5/5] net: thunderbolt: Update module description with mention of USB4
Date:   Tue, 30 Aug 2022 18:32:50 +0300
Message-Id: <20220830153250.15496-6-mika.westerberg@linux.intel.com>
X-Mailer: git-send-email 2.35.1
In-Reply-To: <20220830153250.15496-1-mika.westerberg@linux.intel.com>
References: <20220830153250.15496-1-mika.westerberg@linux.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,
        SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

It is Thunderbolt/USB4 now so reflect that in the module description too
to avoid any confusion. No functional changes.

Signed-off-by: Mika Westerberg <mika.westerberg@linux.intel.com>
---
 drivers/net/thunderbolt.c | 5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

diff --git a/drivers/net/thunderbolt.c b/drivers/net/thunderbolt.c
index 8e272d2a61e5..c058eabd7b36 100644
--- a/drivers/net/thunderbolt.c
+++ b/drivers/net/thunderbolt.c
@@ -1,6 +1,7 @@
 // SPDX-License-Identifier: GPL-2.0
 /*
- * Networking over Thunderbolt cable using Apple ThunderboltIP protocol
+ * Networking over Thunderbolt/USB4 cables using USB4NET protocol
+ * (formerly Apple ThunderboltIP).
  *
  * Copyright (C) 2017, Intel Corporation
  * Authors: Amir Levy <amir.jer.levy@intel.com>
@@ -1410,5 +1411,5 @@ module_exit(tbnet_exit);
 MODULE_AUTHOR("Amir Levy <amir.jer.levy@intel.com>");
 MODULE_AUTHOR("Michael Jamet <michael.jamet@intel.com>");
 MODULE_AUTHOR("Mika Westerberg <mika.westerberg@linux.intel.com>");
-MODULE_DESCRIPTION("Thunderbolt network driver");
+MODULE_DESCRIPTION("Thunderbolt/USB4 network driver");
 MODULE_LICENSE("GPL v2");
-- 
2.35.1

