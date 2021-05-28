Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 44D89394494
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 16:56:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236309AbhE1O56 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 10:57:58 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:47137 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235511AbhE1O54 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 10:57:56 -0400
Received: from mail-ua1-f71.google.com ([209.85.222.71])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lmduO-0004AG-Nz
        for netdev@vger.kernel.org; Fri, 28 May 2021 14:56:20 +0000
Received: by mail-ua1-f71.google.com with SMTP id t19-20020ab021530000b029020bc458f62fso1993426ual.20
        for <netdev@vger.kernel.org>; Fri, 28 May 2021 07:56:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I8v9v1iXBx2jm0a7G/yvgftchrd3//zSZLWiRRhEhPU=;
        b=HLD/wrLrvlRKza0VcLcGGIuhnS01nL8qspPZ3jmPG43oc0BWmtLiRASxlcoIPrKsvC
         BO+oWhM/0GXjP3bNXwVZsvmHoeXQwOZw2QQ3h7h7YrJQbGJDh9v9a/wUUWDldri4KV6H
         b3Hcf1G4u+Kwyfedv2AOJ/lCb89EdBLEZkujLIFRXToXLyjTD66w6uoJWBDgvo2E5r2K
         teR5h8oNr4ZROMm6eSsvoKQG73KIrE4U7rpWPoS1zJqxUYRs9Q5Jr35VCLp6h1cAhily
         Y8+LEJkKPMYvw7EBb/ws1s5CTZxUQLYNNJQS3ssGyO/LWyLXX+7xNEOttD/k/MU75w0V
         OYrA==
X-Gm-Message-State: AOAM533ik9/0rdxMFazeDDa2lj3J2hyVslxE+BrlHTJwvdb328rYVYBQ
        /vA6ULNxEdt9OG0rOWm4lEUQCNENVr9iUPJvrNQ6kQKi3wP6w0psHzGY2PSA8Z6rRa45Ezd4RWh
        J1OJLMMTRkT10OjHuwznO3CXVFidcwUInFg==
X-Received: by 2002:a05:6122:c91:: with SMTP id ba17mr6680981vkb.8.1622213778184;
        Fri, 28 May 2021 07:56:18 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz1y5mM03fmgXkF7C8LSgjRHV54yuzIq1nwWqLygFyCQ6vm/mob7Yu2/zhU4jA15syS/Fff8g==
X-Received: by 2002:a05:6122:c91:: with SMTP id ba17mr6680719vkb.8.1622213775368;
        Fri, 28 May 2021 07:56:15 -0700 (PDT)
Received: from localhost.localdomain ([45.237.48.3])
        by smtp.gmail.com with ESMTPSA id c15sm743661vko.15.2021.05.28.07.56.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 28 May 2021 07:56:14 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Randy Dunlap <rdunlap@infradead.org>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Subject: [PATCH 04/11] nfc: mrvl: correct minor coding style violations
Date:   Fri, 28 May 2021 10:55:27 -0400
Message-Id: <20210528145534.125460-1-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210528145330.125055-1-krzysztof.kozlowski@canonical.com>
References: <20210528145330.125055-1-krzysztof.kozlowski@canonical.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Correct block comments and usage of tab in function definition.  No
functional change.

Signed-off-by: Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
---
 drivers/nfc/nfcmrvl/fw_dnld.c | 10 +++++-----
 drivers/nfc/nfcmrvl/nfcmrvl.h | 12 ++++++------
 drivers/nfc/nfcmrvl/uart.c    | 16 ++++++++--------
 3 files changed, 19 insertions(+), 19 deletions(-)

diff --git a/drivers/nfc/nfcmrvl/fw_dnld.c b/drivers/nfc/nfcmrvl/fw_dnld.c
index 05df7ad224d5..c84658448415 100644
--- a/drivers/nfc/nfcmrvl/fw_dnld.c
+++ b/drivers/nfc/nfcmrvl/fw_dnld.c
@@ -39,8 +39,8 @@ enum {
 };
 
 /*
-** Patterns for responses
-*/
+ * Patterns for responses
+ */
 
 static const uint8_t nci_pattern_core_reset_ntf[] = {
 	0x60, 0x00, 0x02, 0xA0, 0x01
@@ -440,7 +440,7 @@ static void fw_dnld_rx_work(struct work_struct *work)
 	}
 }
 
-int	nfcmrvl_fw_dnld_init(struct nfcmrvl_private *priv)
+int nfcmrvl_fw_dnld_init(struct nfcmrvl_private *priv)
 {
 	char name[32];
 
@@ -454,12 +454,12 @@ int	nfcmrvl_fw_dnld_init(struct nfcmrvl_private *priv)
 	return 0;
 }
 
-void	nfcmrvl_fw_dnld_deinit(struct nfcmrvl_private *priv)
+void nfcmrvl_fw_dnld_deinit(struct nfcmrvl_private *priv)
 {
 	destroy_workqueue(priv->fw_dnld.rx_wq);
 }
 
-void	nfcmrvl_fw_dnld_recv_frame(struct nfcmrvl_private *priv,
+void nfcmrvl_fw_dnld_recv_frame(struct nfcmrvl_private *priv,
 				   struct sk_buff *skb)
 {
 	/* Discard command timer */
diff --git a/drivers/nfc/nfcmrvl/nfcmrvl.h b/drivers/nfc/nfcmrvl/nfcmrvl.h
index 0b4220bb91bc..a715543bc9bf 100644
--- a/drivers/nfc/nfcmrvl/nfcmrvl.h
+++ b/drivers/nfc/nfcmrvl/nfcmrvl.h
@@ -25,16 +25,16 @@
 #define NFCMRVL_NCI_MAX_EVENT_SIZE		260
 
 /*
-** NCI FW Parmaters
-*/
+ * NCI FW Parameters
+ */
 
 #define NFCMRVL_PB_BAIL_OUT			0x11
 #define NFCMRVL_PROP_REF_CLOCK			0xF0
 #define NFCMRVL_PROP_SET_HI_CONFIG		0xF1
 
 /*
-** HCI defines
-*/
+ * HCI defines
+ */
 
 #define NFCMRVL_HCI_EVENT_HEADER_SIZE		0x04
 #define NFCMRVL_HCI_EVENT_CODE			0x04
@@ -67,8 +67,8 @@ struct nfcmrvl_private {
 	bool support_fw_dnld;
 
 	/*
-	** PHY related information
-	*/
+	 * PHY related information
+	 */
 
 	/* PHY driver context */
 	void *drv_data;
diff --git a/drivers/nfc/nfcmrvl/uart.c b/drivers/nfc/nfcmrvl/uart.c
index d7ba5b5c653c..ed85645eb885 100644
--- a/drivers/nfc/nfcmrvl/uart.c
+++ b/drivers/nfc/nfcmrvl/uart.c
@@ -18,8 +18,8 @@ static unsigned int break_control;
 static int reset_n_io = -EINVAL;
 
 /*
-** NFCMRVL NCI OPS
-*/
+ * NFCMRVL NCI OPS
+ */
 
 static int nfcmrvl_uart_nci_open(struct nfcmrvl_private *priv)
 {
@@ -92,8 +92,8 @@ static int nfcmrvl_uart_parse_dt(struct device_node *node,
 }
 
 /*
-** NCI UART OPS
-*/
+ * NCI UART OPS
+ */
 
 static int nfcmrvl_nci_uart_open(struct nci_uart *nu)
 {
@@ -167,10 +167,10 @@ static void nfcmrvl_nci_uart_tx_done(struct nci_uart *nu)
 		return;
 
 	/*
-	** To ensure that if the NFCC goes in DEEP SLEEP sate we can wake him
-	** up. we set BREAK. Once we will be ready to send again we will remove
-	** it.
-	*/
+	 * To ensure that if the NFCC goes in DEEP SLEEP sate we can wake him
+	 * up. we set BREAK. Once we will be ready to send again we will remove
+	 * it.
+	 */
 	if (priv->config.break_control && nu->tty->ops->break_ctl) {
 		nu->tty->ops->break_ctl(nu->tty, -1);
 		usleep_range(1000, 3000);
-- 
2.27.0

