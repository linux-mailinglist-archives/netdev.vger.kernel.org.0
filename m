Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E4961395640
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 09:36:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230404AbhEaHhV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 03:37:21 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60538 "EHLO
        youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230235AbhEaHhM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 03:37:12 -0400
Received: from mail-wr1-f72.google.com ([209.85.221.72])
        by youngberry.canonical.com with esmtps  (TLS1.2) tls TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256
        (Exim 4.93)
        (envelope-from <krzysztof.kozlowski@canonical.com>)
        id 1lncSS-0002ht-8l
        for netdev@vger.kernel.org; Mon, 31 May 2021 07:35:32 +0000
Received: by mail-wr1-f72.google.com with SMTP id j33-20020adf91240000b029010e4009d2ffso3657700wrj.0
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 00:35:32 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=I8v9v1iXBx2jm0a7G/yvgftchrd3//zSZLWiRRhEhPU=;
        b=ISexMt3wn0ja9aqcgQOCQ9/0CKYrEPqZeFU0h+UJDpjHxPekr565zck2aZPbVOYMnV
         JE3AEQ2r2EFUjneXKBifwRSEITI4yzHIagCb9Xir4wA/a3/so3VRFZWBdZA8c61d/lrS
         cvmI/lmshbgRNd+gt/j4G2ZsrchzwreZzzOjWBBUXz/Ix68E4QH9Hp8d05N2SWbfcy2k
         mm3gYgoB7wUUCv+PkpmH7IoOZgbOP5TOJOs8uB9of9GHa4mDGi34JdpAFDHScpRu95wf
         8U+/e48qPQk1L6mTJJAsavvAMKBQ3SwUIaswyajgWc+CW3cSqwCIfXbmBSPEzXJlw90J
         QfCQ==
X-Gm-Message-State: AOAM533unN/0G/XONyaDg0MSxlFTuZuTCuCE/Ilbn+AOYXNIzViCoO26
        wbWMxnH6XB1FwA4+8bUHLkfU3/xrpHrINeAHECqOzj7zpnUeBmOdfKCNEhrUKL18KXJ8LJ0a0eb
        TjXx7Z+L5DSK991R6c+6Gwow06P3OuKB+Vg==
X-Received: by 2002:a5d:638b:: with SMTP id p11mr20588804wru.90.1622446531821;
        Mon, 31 May 2021 00:35:31 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJyN8l014nNSn/nR7ANz8+qDfBqJHPKgzAKmFbf7KYei5XSqunWARV9KN/pEJy19j+LeR5n4+w==
X-Received: by 2002:a5d:638b:: with SMTP id p11mr20588793wru.90.1622446531657;
        Mon, 31 May 2021 00:35:31 -0700 (PDT)
Received: from localhost.localdomain (xdsl-188-155-185-9.adslplus.ch. [188.155.185.9])
        by smtp.gmail.com with ESMTPSA id g10sm17217780wrq.12.2021.05.31.00.35.31
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 31 May 2021 00:35:31 -0700 (PDT)
From:   Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>
To:     Krzysztof Kozlowski <krzysztof.kozlowski@canonical.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, linux-nfc@lists.01.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RESEND PATCH 04/11] nfc: mrvl: correct minor coding style violations
Date:   Mon, 31 May 2021 09:35:15 +0200
Message-Id: <20210531073522.6720-4-krzysztof.kozlowski@canonical.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210531073522.6720-1-krzysztof.kozlowski@canonical.com>
References: <20210531073522.6720-1-krzysztof.kozlowski@canonical.com>
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

