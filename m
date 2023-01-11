Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C4620665E63
	for <lists+netdev@lfdr.de>; Wed, 11 Jan 2023 15:51:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230245AbjAKOvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Jan 2023 09:51:35 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233564AbjAKOvW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Jan 2023 09:51:22 -0500
Received: from wizmail.org (wizmail.org [85.158.153.28])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45EA518694
        for <netdev@vger.kernel.org>; Wed, 11 Jan 2023 06:51:22 -0800 (PST)
DKIM-Signature: v=1; a=ed25519-sha256; q=dns/txt; c=relaxed/relaxed;
        d=wizmail.org; s=e202001; h=Content-Transfer-Encoding:MIME-Version:References
        :In-Reply-To:Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive:
        Autocrypt; bh=nF5fG4Z0bFmnI32ZWpcR3kiA7eMPVgMGqkt3LOJdwAk=; b=ojJgRLyGyYI1/Hk
        gsas9S4aPZwUTzwJOZVQTs3Xn1ZCkXvrmF/s6l1HIHvDZ+v88liY5d1Ok8Ibpwr3aPPDFDQ==;
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=wizmail.org
        ; s=r202001; h=Content-Transfer-Encoding:MIME-Version:References:In-Reply-To:
        Message-Id:Date:Subject:Cc:To:From:From:Sender:Reply-To:Subject:Date:
        Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive:
        Autocrypt; bh=nF5fG4Z0bFmnI32ZWpcR3kiA7eMPVgMGqkt3LOJdwAk=; b=hjwjtvr1CTtXUpS
        uq9Aj1g6sLMtdwpiSaHX4NKwcnXh5MbOtgo4kJRlfeidMpXvIYWIdcmxW7OASXk+HuiJn7q60adEQ
        e3cKoWdVeiugrsHPztV3ZKp7jN6EOCnCl+19h1uMSaAJ0m6qqYescLGfldcHl40pp0MXWnbCIAEUa
        sdNumPGSbg3rA/6dXigIst1H1iRIVNW9QsaeMaTz56sjRcMAoE+g07iWL6l7pfOa4zV+E5uPQPISp
        lrpkViQPwMr7AKOQsardofjKIq5YzTHMBM9xbibuPY4o0SHYSEQOa5lC5l8+uajOobthQyCQKLjfe
        y4JfImtAK0vhIMOzRCg==;
Authentication-Results: wizmail.org;
        local=pass (non-smtp, wizmail.org) u=root
Received: from root
        by [] (Exim 4.96.108)
        with local
        id 1pFcBW-004jFc-2W
        (return-path <root@w81.gulag.org.uk>);
        Wed, 11 Jan 2023 14:34:34 +0000
From:   jgh@redhat.com
To:     netdev@vger.kernel.org
Cc:     Jeremy Harris <jgh@redhat.com>
Subject: [RFC PATCH 6/7] drivers: net: bnx2: NIC driver Rx ring ECN
Date:   Wed, 11 Jan 2023 14:34:26 +0000
Message-Id: <20230111143427.1127174-7-jgh@redhat.com>
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
 drivers/net/ethernet/broadcom/bnx2.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/broadcom/bnx2.c b/drivers/net/ethernet/broadcom/bnx2.c
index 9f473854b0f4..f55ac9c7b6fd 100644
--- a/drivers/net/ethernet/broadcom/bnx2.c
+++ b/drivers/net/ethernet/broadcom/bnx2.c
@@ -3141,10 +3141,10 @@ bnx2_get_hw_rx_cons(struct bnx2_napi *bnapi)
 static int
 bnx2_rx_int(struct bnx2 *bp, struct bnx2_napi *bnapi, int budget)
 {
-	struct bnx2_rx_ring_info *rxr = &bnapi->rx_ring;
 	u16 hw_cons, sw_cons, sw_ring_cons, sw_prod, sw_ring_prod;
-	struct l2_fhdr *rx_hdr;
+	struct bnx2_rx_ring_info *rxr = &bnapi->rx_ring;
 	int rx_pkt = 0, pg_ring_used = 0;
+	struct l2_fhdr *rx_hdr;
 
 	if (budget <= 0)
 		return rx_pkt;
-- 
2.39.0

