Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 24799597678
	for <lists+netdev@lfdr.de>; Wed, 17 Aug 2022 21:31:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241481AbiHQTad (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Aug 2022 15:30:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241353AbiHQTaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Aug 2022 15:30:30 -0400
Received: from mx23lb.world4you.com (mx23lb.world4you.com [81.19.149.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CA7165A830
        for <netdev@vger.kernel.org>; Wed, 17 Aug 2022 12:30:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=engleder-embedded.com; s=dkim11; h=Content-Transfer-Encoding:MIME-Version:
        References:In-Reply-To:Message-Id:Date:Subject:Cc:To:From:Sender:Reply-To:
        Content-Type:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=uYX1VBWwuDII4p2en8HOOOvbuPJmySyPp4LcFDX5qvM=; b=eXx4gG0XkNIVpQw0f6kCVjZiMK
        XE9EMCNkUg8soLZimitmGi99gxzfKYWU6ukLeCXe61b8PyazYUMtAbiVVbzXSqwk80RdmdYBMwHqj
        EenvtQ3lnwJT5U1oEvSDuBM0RvMKcddmIhwQ5N2SAFUtNCyWYyUaXzISOOR6fZhc3kYU=;
Received: from 88-117-52-3.adsl.highway.telekom.at ([88.117.52.3] helo=hornet.engleder.at)
        by mx23lb.world4you.com with esmtpsa  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <gerhard@engleder-embedded.com>)
        id 1oOOkB-0006Vi-R7; Wed, 17 Aug 2022 21:30:23 +0200
From:   Gerhard Engleder <gerhard@engleder-embedded.com>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org,
        Gerhard Engleder <gerhard@engleder-embedded.com>
Subject: [PATCH net-next 1/5] tsnep: Fix TSNEP_INFO_TX_TIME register define
Date:   Wed, 17 Aug 2022 21:30:13 +0200
Message-Id: <20220817193017.44063-2-gerhard@engleder-embedded.com>
X-Mailer: git-send-email 2.30.2
In-Reply-To: <20220817193017.44063-1-gerhard@engleder-embedded.com>
References: <20220817193017.44063-1-gerhard@engleder-embedded.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-AV-Do-Run: Yes
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixed register define is not used, but register definition shall be kept
in sync.

Fixes: 403f69bbdbad ("tsnep: Add TSN endpoint Ethernet MAC driver")
Signed-off-by: Gerhard Engleder <gerhard@engleder-embedded.com>
---
 drivers/net/ethernet/engleder/tsnep_hw.h | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/engleder/tsnep_hw.h b/drivers/net/ethernet/engleder/tsnep_hw.h
index 916ceac3ada2..e03aaafab559 100644
--- a/drivers/net/ethernet/engleder/tsnep_hw.h
+++ b/drivers/net/ethernet/engleder/tsnep_hw.h
@@ -92,8 +92,7 @@
 
 /* tsnep register */
 #define TSNEP_INFO 0x0100
-#define TSNEP_INFO_RX_ASSIGN 0x00010000
-#define TSNEP_INFO_TX_TIME 0x00020000
+#define TSNEP_INFO_TX_TIME 0x00010000
 #define TSNEP_CONTROL 0x0108
 #define TSNEP_CONTROL_TX_RESET 0x00000001
 #define TSNEP_CONTROL_TX_ENABLE 0x00000002
-- 
2.30.2

