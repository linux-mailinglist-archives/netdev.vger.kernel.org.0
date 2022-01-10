Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 859694890C6
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 08:25:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239351AbiAJHZg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 02:25:36 -0500
Received: from out162-62-57-49.mail.qq.com ([162.62.57.49]:46235 "EHLO
        out162-62-57-49.mail.qq.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S239321AbiAJHYi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 02:24:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=foxmail.com;
        s=s201512; t=1641799469;
        bh=guT45DaaBfPq99fW3RlK/ojGHhcfJhuCJThAnxj4Mhg=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=Hu4GAxrM+vYt622tCgrYx2CM0MsXPLMmm0gaYi8sJ6zIDTUR4i7rlT7j6p6H5eO+E
         PODrak8XhRVxobjQjtXemuxXXq+4z+Z3oiaKex1+dgcOzOB5OlHRpqCMJsRrJKNhKT
         BiYgpJo2ygdQRxZnHUgO3Fmjp5WWv5FaLM2RtuGA=
Received: from fedora.. ([119.32.47.91])
        by newxmesmtplogicsvrsza9.qq.com (NewEsmtp) with SMTP
        id 5CD80CD5; Mon, 10 Jan 2022 15:23:13 +0800
X-QQ-mid: xmsmtpt1641799395tf7k2u2xq
Message-ID: <tencent_DA3D18DE830ADA4AA7B6AA9B3E0AF4D9DE09@qq.com>
X-QQ-XMAILINFO: MpO6L0LObisWloEqG0SxSMpje9QM4KhXo+6YQYVZmIk5DraPueklisQj71/dkj
         Z2/CLrevxr8ssAeEXnN/6Il6rKsbousK30oEex/0ozFW2ojy1g3r9VWeJOyutiELtvwJsi3FUCNS
         8gVoKuV5bM5d19QnMa9kZFmw866YvC5OjtQobV2dK3D8xoTMvqlbcslq5tt2L421vIjOE/dXRiv3
         +AsTxOmf+ARFyPNUprsgcX5YVuuOzuii+lGT21SnhWYtglhdrzrFEwYsOKB46Y3jT2BjNWftmD3N
         hGi1hHM1wA7LD2Lh8yjyanGQkMrLfDVN2gAIYziWyOmLzpIEKdC69et/cku5QUQTrV05s2orJzwx
         ifsBjfS9YTmya+hA2hYyxvKwgYgLodaM/ySkLXofcO59075R06V0dHnru/UgLF6t9EYN7OZ+3m6r
         yotH5z5zBheJ9v1QISO8VrmqJe/HTY2USQ0UAJSICRMOaLp0BXIN6gEzsB+jL6MR7qOdqAlEKW8k
         1s3lEx/hsZrzIVPohgJOFwP/if8eoWkJoBwzc2PCOs9y7MntTWEP2RdN/wsgChRB31JkWGh7sHAx
         m7jR3xCQQ65Ze9SPTOgVgmkVLk0P8w3BmZIDyLj34aRX9QgrG62Uy5cUgNWgtr9ERyXrifzRlHEm
         5TvC1Yg86VCF4Lz9r11KC9GZ9x+TAVXfPqAw7T2gLrPiOY0+njdWRbJomLuuOy1syJ4sLcrADnCY
         6uyO05fZ7lWWIf08vegIBHCDisiPOR8UFvFWGgLbHlFX6hYQSFm843aP1dlob2/MmPSOzi6/mMNa
         Qprhs+BD+i5KNm3n8MerVDUIFshA57OR0deurR7ZV7HWWd+eM+Sl8kWptjEYuETNql8gpNVv32em
         saa9jSRrpZu5eiLAAGA/db7lc7dlMSNU1ipCYxNI2ffVfbkh5xgcU=
From:   conleylee@foxmail.com
To:     davem@davemloft.net, kuba@kernel.org, mripard@kernel.org,
        wens@csie.org
Cc:     netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, conley <conleylee@foxmail.com>
Subject: [PATCH 1/2] sun4i-emac.h: add register related marcos
Date:   Mon, 10 Jan 2022 15:23:08 +0800
X-OQ-MSGID: <20220110072309.2259523-2-conleylee@foxmail.com>
X-Mailer: git-send-email 2.31.1
In-Reply-To: <20220110072309.2259523-1-conleylee@foxmail.com>
References: <20220110072309.2259523-1-conleylee@foxmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: conley <conleylee@foxmail.com>

Signed-off-by: conley <conleylee@foxmail.com>
---
 drivers/net/ethernet/allwinner/sun4i-emac.h | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.h b/drivers/net/ethernet/allwinner/sun4i-emac.h
index 38c72d9ec600..90bd9ad77607 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.h
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.h
@@ -38,6 +38,7 @@
 #define EMAC_RX_CTL_REG		(0x3c)
 #define EMAC_RX_CTL_AUTO_DRQ_EN		(1 << 1)
 #define EMAC_RX_CTL_DMA_EN		(1 << 2)
+#define EMAC_RX_CTL_FLUSH_FIFO		(1 << 3)
 #define EMAC_RX_CTL_PASS_ALL_EN		(1 << 4)
 #define EMAC_RX_CTL_PASS_CTL_EN		(1 << 5)
 #define EMAC_RX_CTL_PASS_CRC_ERR_EN	(1 << 6)
@@ -61,7 +62,21 @@
 #define EMAC_RX_IO_DATA_STATUS_OK	(1 << 7)
 #define EMAC_RX_FBC_REG		(0x50)
 #define EMAC_INT_CTL_REG	(0x54)
+#define EMAC_INT_CTL_RX_EN	(1 << 8)
+#define EMAC_INT_CTL_TX0_EN	(1)
+#define EMAC_INT_CTL_TX1_EN	(1 << 1)
+#define EMAC_INT_CTL_TX_EN	(EMAC_INT_CTL_TX0_EN | EMAC_INT_CTL_TX1_EN)
+#define EMAC_INT_CTL_TX0_ABRT_EN	(0x1 << 2)
+#define EMAC_INT_CTL_TX1_ABRT_EN	(0x1 << 3)
+#define EMAC_INT_CTL_TX_ABRT_EN	(EMAC_INT_CTL_TX0_ABRT_EN | EMAC_INT_CTL_TX1_ABRT_EN)
 #define EMAC_INT_STA_REG	(0x58)
+#define EMAC_INT_STA_TX0_COMPLETE	(0x1)
+#define EMAC_INT_STA_TX1_COMPLETE	(0x1 << 1)
+#define EMAC_INT_STA_TX_COMPLETE	(EMAC_INT_STA_TX0_COMPLETE | EMAC_INT_STA_TX1_COMPLETE)
+#define EMAC_INT_STA_TX0_ABRT	(0x1 << 2)
+#define EMAC_INT_STA_TX1_ABRT	(0x1 << 3)
+#define EMAC_INT_STA_TX_ABRT	(EMAC_INT_STA_TX0_ABRT | EMAC_INT_STA_TX1_ABRT)
+#define EMAC_INT_STA_RX_COMPLETE	(0x1 << 8)
 #define EMAC_MAC_CTL0_REG	(0x5c)
 #define EMAC_MAC_CTL0_RX_FLOW_CTL_EN	(1 << 2)
 #define EMAC_MAC_CTL0_TX_FLOW_CTL_EN	(1 << 3)
@@ -87,8 +102,11 @@
 #define EMAC_MAC_CLRT_RM		(0x0f)
 #define EMAC_MAC_MAXF_REG	(0x70)
 #define EMAC_MAC_SUPP_REG	(0x74)
+#define EMAC_MAC_SUPP_100M	(0x1 << 8)
 #define EMAC_MAC_TEST_REG	(0x78)
 #define EMAC_MAC_MCFG_REG	(0x7c)
+#define EMAC_MAC_MCFG_MII_CLKD_MASK	(0xff << 2)
+#define EMAC_MAC_MCFG_MII_CLKD_72	(0x0d << 2)
 #define EMAC_MAC_A0_REG		(0x98)
 #define EMAC_MAC_A1_REG		(0x9c)
 #define EMAC_MAC_A2_REG		(0xa0)
-- 
2.31.1

