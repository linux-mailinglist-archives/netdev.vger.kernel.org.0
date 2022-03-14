Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162D04D83F5
	for <lists+netdev@lfdr.de>; Mon, 14 Mar 2022 13:21:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241032AbiCNMWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Mar 2022 08:22:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243861AbiCNMVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Mar 2022 08:21:20 -0400
Received: from mail2-relais-roc.national.inria.fr (mail2-relais-roc.national.inria.fr [192.134.164.83])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 847E2BE5;
        Mon, 14 Mar 2022 05:17:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
  d=inria.fr; s=dc;
  h=from:to:cc:subject:date:message-id:in-reply-to:
   references:mime-version:content-transfer-encoding;
  bh=yAh5dhSWoezDHAmIMKrnf1fmCmAoJ/u8UhSQGN/+5rg=;
  b=AOnEnK5rwCG4310Vpj8R+iKPhl+ZQD+1cDacCSAMGCta6CgsSn9yBslL
   Y1TrJpCX8hv7jCgskW7U1RQ8F6ZnlT4GCA0nKToZhZGvR2wQ42o/C7TAp
   6Uwkpl70GJ0CwzNzwB5HL+SwW86rfOZM88KpUW0hoMBFN0ZoFvJLVt9bZ
   Y=;
Authentication-Results: mail2-relais-roc.national.inria.fr; dkim=none (message not signed) header.i=none; spf=SoftFail smtp.mailfrom=Julia.Lawall@inria.fr; dmarc=fail (p=none dis=none) d=inria.fr
X-IronPort-AV: E=Sophos;i="5.90,180,1643670000"; 
   d="scan'208";a="25997353"
Received: from i80.paris.inria.fr (HELO i80.paris.inria.fr.) ([128.93.90.48])
  by mail2-relais-roc.national.inria.fr with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 14 Mar 2022 12:54:00 +0100
From:   Julia Lawall <Julia.Lawall@inria.fr>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     kernel-janitors@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 20/30] airo: fix typos in comments
Date:   Mon, 14 Mar 2022 12:53:44 +0100
Message-Id: <20220314115354.144023-21-Julia.Lawall@inria.fr>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <20220314115354.144023-1-Julia.Lawall@inria.fr>
References: <20220314115354.144023-1-Julia.Lawall@inria.fr>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        RCVD_IN_MSPIKE_H4,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Various spelling mistakes in comments.
Detected with the help of Coccinelle.

Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>

---
 drivers/net/wireless/cisco/airo.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/cisco/airo.c b/drivers/net/wireless/cisco/airo.c
index 452d08545d31..10daef81c355 100644
--- a/drivers/net/wireless/cisco/airo.c
+++ b/drivers/net/wireless/cisco/airo.c
@@ -545,7 +545,7 @@ struct ConfigRid {
 #define MODE_CFG_MASK cpu_to_le16(0xff)
 #define MODE_ETHERNET_HOST cpu_to_le16(0<<8) /* rx payloads converted */
 #define MODE_LLC_HOST cpu_to_le16(1<<8) /* rx payloads left as is */
-#define MODE_AIRONET_EXTEND cpu_to_le16(1<<9) /* enable Aironet extenstions */
+#define MODE_AIRONET_EXTEND cpu_to_le16(1<<9) /* enable Aironet extensions */
 #define MODE_AP_INTERFACE cpu_to_le16(1<<10) /* enable ap interface extensions */
 #define MODE_ANTENNA_ALIGN cpu_to_le16(1<<11) /* enable antenna alignment */
 #define MODE_ETHER_LLC cpu_to_le16(1<<12) /* enable ethernet LLC */

