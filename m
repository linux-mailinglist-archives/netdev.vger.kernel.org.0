Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A378C665E61
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 15:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237863AbjAKOve (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 09:51:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232216AbjAKOvU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 09:51:20 -0500
Received: from wizmail.org (wizmail.org [85.158.153.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3E44EF5A4
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 06:51:17 -0800 (PST)
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=wizmail.org; s=e202001; h=Content-Transfer-Encoding:MIME-Version:References
        :In-Reply-To:Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive:
        Autocrypt; bh=ok5czZbkkypXa0JaIzVeYiVljvx1YVL7uiV8dKrH0bM=; b=4muDTv1u3dSxsvL
        OgQhw4cRiZL0D1e6jMjnXv3TlTZ0HJ9ThEalI/s/WPfRKvuujnZ3IhxUp6sJctYpF1jzmBQ==;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=wizmail.org
        ; s=r202001; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive:
        Autocrypt; bh=ok5czZbkkypXa0JaIzVeYiVljvx1YVL7uiV8dKrH0bM=; b=RY8C3GeXh3BHQbZ
        HgeM1/ayetue0F+guxv7sjg4jVD9d7rcT96inLPbn+olFR9fXGfFKPiLmY7AjBZxBbD7ZIW3fgVlX
        FYo25755/75v3bsmGnxyxt98zfssKvilwemyXDX3EAyYbfJkx3O01H7dxyr6BLUN5VUra1qRil9QZ
        8GFgRmoHOQykQ9esXeVyVZo/gNaX5gVaMovg3yBqf1Ka3zgH+60z6jhLSyiHetYcPnWKf5XY/mktE
        UPtwdcxlU82BYn3IXhMpoeTwCTEwDHj5tm/z/T+2YKcTL1tMD4W5HGMXgBX5gt5OpBa1eKL2oKsFB
        scuRnZfyum8HlVv9RMQ==;
Authentication-Results: wizmail.org;
        local=pass (non-smtp, wizmail.org) u=root
Received: from root
        by [] (Exim 4.96.108)
        with local
        id 1pFcBW-004jFS-1k
        (return-path <root@w81.gulag.org.uk>);
        Wed, 11 Jan 2023 14:34:34 +0000
From:   jgh@redhat.com
To:     netdev@vger.kernel.org
Cc:     Jeremy Harris <jgh@redhat.com>
Subject: [RFC PATCH 4/7] drivers: net: bnx2x: NIC driver Rx ring ECN
Date:   Wed, 11 Jan 2023 14:34:24 +0000
Message-Id: <20230111143427.1127174-5-jgh@redhat.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20230111143427.1127174-1-jgh@redhat.com>
References: <20230111143427.1127174-1-jgh@redhat.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-1.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,HEADER_FROM_DIFFERENT_DOMAINS,SPF_HELO_NONE,SPF_NONE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jeremy Harris <jgh@redhat.com>

Reformat local variables as reverse-christmas-tree.
No functional change.

Signed-off-by: Jeremy Harris <jgh@redhat.com>
---
 drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
index 16c490692f42..145e338487b6 100644
--- a/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
+++ b/drivers/net/ethernet/broadcom/bnx2x/bnx2x_cmn.c
@@ -880,12 +880,12 @@ void bnx2x_csum_validate(struct sk_buff *skb, union eth_rx_cqe *cqe,
 
 static int bnx2x_rx_int(struct bnx2x_fastpath *fp, int budget)
 {
-	struct bnx2x *bp = fp->bp;
 	u16 bd_cons, bd_prod, bd_prod_fw, comp_ring_cons;
+	struct eth_fast_path_rx_cqe *cqe_fp;
 	u16 sw_comp_cons, sw_comp_prod;
-	int rx_pkt = 0;
+	struct bnx2x *bp = fp->bp;
 	union eth_rx_cqe *cqe;
-	struct eth_fast_path_rx_cqe *cqe_fp;
+	int rx_pkt = 0;
 
 #ifdef BNX2X_STOP_ON_ERROR
 	if (unlikely(bp->panic))
-- 
2.39.0

