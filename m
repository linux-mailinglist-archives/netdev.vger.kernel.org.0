Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F23F11BB3F
	for <lists+netdev@lfdr.de>; Wed, 11 Dec 2019 19:15:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731235AbfLKSPZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Dec 2019 13:15:25 -0500
Received: from mail-yw1-f52.google.com ([209.85.161.52]:46676 "EHLO
        mail-yw1-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731213AbfLKSPX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Dec 2019 13:15:23 -0500
Received: by mail-yw1-f52.google.com with SMTP id u139so9275634ywf.13;
        Wed, 11 Dec 2019 10:15:23 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=u0Uagrgs6mVpulGeA6eJiVL8yArUOnTFSWyALd4g4YI=;
        b=ujnadWGq0oPO4Of9IgCS6nRRjtnRxlgyhTiuXznJvRjdGLIrxjGN+ZT6YSaJ/zzjF9
         gys/f3FNf1guI/EXs76WKwwYGC63+7vrBH1MNwRZ88xWKb6wtqWl7COkEKkv8FW3FXOX
         tWJ3VGYfxF17jJOgC4YnSeXBj8pCc3ac5LdI/SeqA9GR2WhRe/tyzADhh4xxKwqIX+iT
         +jCu0ebQ1nTYc5lq44r4F2MeazAcD2TfV9y52U4vKn0XDxoUOIgdemT6RYHq/wFZp/zJ
         xK3k+ujCpJ3nMoGdEPnN6+cg7Ot5AT13wBzbIDiXLuHBs8S2JsUMnK4I5qK2h0uNdTMg
         MIlA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=u0Uagrgs6mVpulGeA6eJiVL8yArUOnTFSWyALd4g4YI=;
        b=kVONOn0FC3D2DIwsZyUNzoJle4obqeOOMLHtSHnCi3Xo9gyconnhFwPlDwIWntzkLV
         4KSlS4xDngyuDhutoVW4gW1bJMpe3Um+S07Cc1nkZGDFMkaOvZ2+54ZraRPOJniLF5Jv
         dQUKewMvS77zhkCz9VP7cwApW2oLeFxTZvOD3Zlj7HYM4nGgI0U7se9UPWWDKtmrS9Xl
         ws0CLCGkxjK7Neyg0JplYhxtIE+rCKM4uQ4gH6nrkzatKNhIabkDzvTtzG7H6YGfwo2T
         zr3Em9KtOYQCqpVfNK8pnJo8FwojQJWR4WPORAB/kqsAwMX/yiEF8Cw54jCY1SlynV8X
         HbLg==
X-Gm-Message-State: APjAAAWwu6ZxS6Y3QyuiryokLDWvMr+K2cIsZCCx/n1IGmCU6IjYYFE+
        DN2Q9TQnj6Q/IhH2fKysrZ9tlfwObvNsDw==
X-Google-Smtp-Source: APXvYqxaALhyOvpU2ztGTYuOkeBXT/aFJSRD+TPM9gWmXKO27dD4VNr3Uybg0sFaUhMuVEhzABEEyg==
X-Received: by 2002:a81:85c4:: with SMTP id v187mr820499ywf.445.1576088122451;
        Wed, 11 Dec 2019 10:15:22 -0800 (PST)
Received: from karen ([2604:2d80:d68a:cf00:a4bc:8e08:1748:387f])
        by smtp.gmail.com with ESMTPSA id k30sm1328927ywh.94.2019.12.11.10.15.21
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Dec 2019 10:15:22 -0800 (PST)
From:   Scott Schafer <schaferjscott@gmail.com>
To:     gregkh@linuxfoundation.org
Cc:     Scott Schafer <schaferjscott@gmail.com>,
        Manish Chopra <manishc@marvell.com>,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2 12/23] staging: qlge: Fix WARNING: please, no space before tabs in qlge.h
Date:   Wed, 11 Dec 2019 12:12:41 -0600
Message-Id: <13546a2ebc6686da094b23ab576c4388fa61268b.1576086080.git.schaferjscott@gmail.com>
X-Mailer: git-send-email 2.20.1
In-Reply-To: <cover.1576086080.git.schaferjscott@gmail.com>
References: <cover.1576086080.git.schaferjscott@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix WARNING: please, no space before tabs in qlge.h

Signed-off-by: Scott Schafer <schaferjscott@gmail.com>
---
 drivers/staging/qlge/qlge.h | 24 ++++++++++++------------
 1 file changed, 12 insertions(+), 12 deletions(-)

diff --git a/drivers/staging/qlge/qlge.h b/drivers/staging/qlge/qlge.h
index ede767a70b10..63642cb9e624 100644
--- a/drivers/staging/qlge/qlge.h
+++ b/drivers/staging/qlge/qlge.h
@@ -16,8 +16,8 @@
 /*
  * General definitions...
  */
-#define DRV_NAME  	"qlge"
-#define DRV_STRING 	"QLogic 10 Gigabit PCI-E Ethernet Driver "
+#define DRV_NAME	"qlge"
+#define DRV_STRING	"QLogic 10 Gigabit PCI-E Ethernet Driver "
 #define DRV_VERSION	"1.00.00.35"
 
 #define WQ_ADDR_ALIGN	0x3	/* 4 byte alignment */
@@ -1076,8 +1076,8 @@ struct tx_buf_desc {
  * IOCB Definitions...
  */
 
-#define OPCODE_OB_MAC_IOCB 			0x01
-#define OPCODE_OB_MAC_TSO_IOCB		0x02
+#define OPCODE_OB_MAC_IOCB			0x01
+#define OPCODE_OB_MAC_TSO_IOCB			0x02
 #define OPCODE_IB_MAC_IOCB			0x20
 #define OPCODE_IB_MPI_IOCB			0x21
 #define OPCODE_IB_AE_IOCB			0x3f
@@ -1179,8 +1179,8 @@ struct ib_mac_iocb_rsp {
 #define IB_MAC_IOCB_RSP_M_MASK	0x60	/* Multicast info */
 #define IB_MAC_IOCB_RSP_M_NONE	0x00	/* Not mcast frame */
 #define IB_MAC_IOCB_RSP_M_HASH	0x20	/* HASH mcast frame */
-#define IB_MAC_IOCB_RSP_M_REG 	0x40	/* Registered mcast frame */
-#define IB_MAC_IOCB_RSP_M_PROM 	0x60	/* Promiscuous mcast frame */
+#define IB_MAC_IOCB_RSP_M_REG	0x40	/* Registered mcast frame */
+#define IB_MAC_IOCB_RSP_M_PROM	0x60	/* Promiscuous mcast frame */
 #define IB_MAC_IOCB_RSP_B	0x80	/* Broadcast frame */
 	u8 flags2;
 #define IB_MAC_IOCB_RSP_P	0x01	/* Promiscuous frame */
@@ -1200,8 +1200,8 @@ struct ib_mac_iocb_rsp {
 #define IB_MAC_IOCB_RSP_M_NONE	0x00	/* No RSS match */
 #define IB_MAC_IOCB_RSP_M_IPV4	0x04	/* IPv4 RSS match */
 #define IB_MAC_IOCB_RSP_M_IPV6	0x02	/* IPv6 RSS match */
-#define IB_MAC_IOCB_RSP_M_TCP_V4 	0x05	/* TCP with IPv4 */
-#define IB_MAC_IOCB_RSP_M_TCP_V6 	0x03	/* TCP with IPv6 */
+#define IB_MAC_IOCB_RSP_M_TCP_V4	0x05	/* TCP with IPv4 */
+#define IB_MAC_IOCB_RSP_M_TCP_V6	0x03	/* TCP with IPv6 */
 #define IB_MAC_IOCB_RSP_V4	0x08	/* IPV4 */
 #define IB_MAC_IOCB_RSP_V6	0x10	/* IPV6 */
 #define IB_MAC_IOCB_RSP_IH	0x20	/* Split after IP header */
@@ -1238,10 +1238,10 @@ struct ib_ae_iocb_rsp {
 #define SOFT_ECC_ERROR_EVENT       0x07
 #define MGMT_ERR_EVENT             0x08
 #define TEN_GIG_MAC_EVENT          0x09
-#define GPI0_H2L_EVENT       	0x10
-#define GPI0_L2H_EVENT       	0x20
-#define GPI1_H2L_EVENT       	0x11
-#define GPI1_L2H_EVENT       	0x21
+#define GPI0_H2L_EVENT		0x10
+#define GPI0_L2H_EVENT		0x20
+#define GPI1_H2L_EVENT		0x11
+#define GPI1_L2H_EVENT		0x21
 #define PCI_ERR_ANON_BUF_RD        0x40
 	u8 q_id;
 	__le32 reserved[15];
-- 
2.20.1

