Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E56582CC292
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 17:39:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389179AbgLBQiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 11:38:00 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:39238 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1730654AbgLBQh7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 11:37:59 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1606926993;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc; bh=nkggMGIr/fNLsjvFVvgNGVKzUhHj8eEEu5x0O/XgnNM=;
        b=Y/DXtGjAKhhoiPpoKTRS5mFs4/8j3QiKOEoKNfCHUr9RKkSSl8KBIkyAnVxENeAI8na6Du
        2gwez0WUfS2wwLm8Z6utAJKrGPazgmKDBqx1KqInAAgmtMcA47ImlHyvKL0tEWZOr1TOkB
        m2UXjhH7PNWK/7hA48tICmoSZPZmOSA=
Received: from mail-qt1-f198.google.com (mail-qt1-f198.google.com
 [209.85.160.198]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-130-lHBELDYBMeqG-dNKGhB-hg-1; Wed, 02 Dec 2020 11:36:30 -0500
X-MC-Unique: lHBELDYBMeqG-dNKGhB-hg-1
Received: by mail-qt1-f198.google.com with SMTP id i20so1852330qtr.0
        for <netdev@vger.kernel.org>; Wed, 02 Dec 2020 08:36:30 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=nkggMGIr/fNLsjvFVvgNGVKzUhHj8eEEu5x0O/XgnNM=;
        b=nCQSzqnRYklkYFqY2sca2hMGi2fJTm//MkLGYlICYE+eKsnVJhDaZOfg/4c9HkXe9b
         BHRLEOZVYr4CHsUyFYx2XkjR7eex6Y0nTYiYLtd+KCzpmZJ+WkVXjIqh5bnLzIGR10qy
         fCbArwY6+scBZNmecU6OJy2EeYo4A5Q2mW/d1NdhYJDWZe2nr40WEf1JI4zPrTxFhJ3W
         A6EhDHtm2NlOneyLWk3R/STyuE0WHr9wmpfHf/4tHKeV3pmZ3RVjtw8KKMsB3N+vMw9l
         1nuvWbRyBeRutw7vilpxX5bUdidIXzsKPxx9/WTfR0wjcjj9aeNAYFz5UGZxw3Wgadie
         N01Q==
X-Gm-Message-State: AOAM5324Q17xyZvxsaML16+KEnK/VRB2lVe6wfTtWjjupgVmN2bL5tzG
        G+RW0BWi+ydzxxvabTOjmkGdVMKU1U+I2UEoGJXHcMq2eTiNt/cLZO0YOU5IWsDbBAkAFfmRtZl
        Q3RSIKaxoT7kOMkvG
X-Received: by 2002:ac8:714e:: with SMTP id h14mr3384336qtp.301.1606926990046;
        Wed, 02 Dec 2020 08:36:30 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzw8fV5pHHGhPuzLW2i7fsxWcIqWWg2TySDbNZOqPf0CTQV9Q/jqMvn31r7ktr9lM0A3T6a7Q==
X-Received: by 2002:ac8:714e:: with SMTP id h14mr3384321qtp.301.1606926989830;
        Wed, 02 Dec 2020 08:36:29 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id q20sm2045416qke.0.2020.12.02.08.36.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 02 Dec 2020 08:36:29 -0800 (PST)
From:   trix@redhat.com
To:     rmody@marvell.com, skalluru@marvell.com, davem@davemloft.net,
        kuba@kernel.org
Cc:     GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Tom Rix <trix@redhat.com>
Subject: [PATCH v2] net: bna: remove trailing semicolon in macro definition
Date:   Wed,  2 Dec 2020 08:36:22 -0800
Message-Id: <20201202163622.3733506-1-trix@redhat.com>
X-Mailer: git-send-email 2.18.4
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

The macro use will already have a semicolon.
Clean up escaped newlines.

Signed-off-by: Tom Rix <trix@redhat.com>
---
v2: fix other macros, cleanup newlines
---
 drivers/net/ethernet/brocade/bna/bna_hw_defs.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/drivers/net/ethernet/brocade/bna/bna_hw_defs.h b/drivers/net/ethernet/brocade/bna/bna_hw_defs.h
index f335b7115c1b..dc34e38f97c7 100644
--- a/drivers/net/ethernet/brocade/bna/bna_hw_defs.h
+++ b/drivers/net/ethernet/brocade/bna/bna_hw_defs.h
@@ -218,17 +218,17 @@ do {									\
 
 /* Set the coalescing timer for the given ib */
 #define bna_ib_coalescing_timer_set(_i_dbell, _cls_timer)		\
-	((_i_dbell)->doorbell_ack = BNA_DOORBELL_IB_INT_ACK((_cls_timer), 0));
+	((_i_dbell)->doorbell_ack = BNA_DOORBELL_IB_INT_ACK((_cls_timer), 0))
 
 /* Acks 'events' # of events for a given ib while disabling interrupts */
 #define bna_ib_ack_disable_irq(_i_dbell, _events)			\
-	(writel(BNA_DOORBELL_IB_INT_ACK(0, (_events)), \
-		(_i_dbell)->doorbell_addr));
+	(writel(BNA_DOORBELL_IB_INT_ACK(0, (_events)),			\
+		(_i_dbell)->doorbell_addr))
 
 /* Acks 'events' # of events for a given ib */
 #define bna_ib_ack(_i_dbell, _events)					\
-	(writel(((_i_dbell)->doorbell_ack | (_events)), \
-		(_i_dbell)->doorbell_addr));
+	(writel(((_i_dbell)->doorbell_ack | (_events)),		\
+		(_i_dbell)->doorbell_addr))
 
 #define bna_ib_start(_bna, _ib, _is_regular)				\
 {									\
@@ -259,12 +259,12 @@ do {									\
 }
 
 #define bna_txq_prod_indx_doorbell(_tcb)				\
-	(writel(BNA_DOORBELL_Q_PRD_IDX((_tcb)->producer_index), \
-		(_tcb)->q_dbell));
+	(writel(BNA_DOORBELL_Q_PRD_IDX((_tcb)->producer_index),		\
+		(_tcb)->q_dbell))
 
 #define bna_rxq_prod_indx_doorbell(_rcb)				\
-	(writel(BNA_DOORBELL_Q_PRD_IDX((_rcb)->producer_index), \
-		(_rcb)->q_dbell));
+	(writel(BNA_DOORBELL_Q_PRD_IDX((_rcb)->producer_index),		\
+		(_rcb)->q_dbell))
 
 /* TxQ, RxQ, CQ related bits, offsets, macros */
 
-- 
2.18.4

