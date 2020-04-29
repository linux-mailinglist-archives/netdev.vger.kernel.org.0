Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F4591BE80A
	for <lists+netdev@lfdr.de>; Wed, 29 Apr 2020 22:03:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727823AbgD2UCg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 16:02:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727079AbgD2UCQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 16:02:16 -0400
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 56210C03C1AE;
        Wed, 29 Apr 2020 13:02:16 -0700 (PDT)
Received: by mail-pg1-x542.google.com with SMTP id o185so1535460pgo.3;
        Wed, 29 Apr 2020 13:02:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=IC8rInsRsfxQQkeZ96jiqZI2NB9+ZDmlgZxQ89+Ot80=;
        b=Q3tvhdURxNnI8eipt1UAAyDjRNDvN3MOcBNT/modDn4FhNs/nXY29BN63vDWNfwymx
         yOfBHJDQPmQT47fEVquMDbtT5pqnXVCS5QJ/AZ/mrL6/DaZprbDCt0/VU0kBqh4zniVV
         XNEnZXluePl5kVGSGOGttZ+Jqct5kpfKSZigh++PvWGJQTHdyDdLLulMiACzcAHHZs1Q
         B4c4w6Iwk6xFGPx1pFDo3hIxNzBw7SMlTIpPh0lRQ20O6f3PKTfOk3nnROlRBrehUtdm
         hew0i+G/hAp+KTKjyrbcaKhS9w0o57Ki0YnCl4fc9WVlVVPcBp/5fIlcPD8lgusynfYm
         uJ/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=IC8rInsRsfxQQkeZ96jiqZI2NB9+ZDmlgZxQ89+Ot80=;
        b=iJNBYsCIiDkMzpbnPpPKq6ceLnYkYBErAmwaVw5dsxp/ncil2VGTVM0AhwV8Yjns/U
         a5kHM3IbGYWMtac+sVoveCynsPrd1s3g+LKWZKIwn6AUyyvQRXj5+xPKKep4oTV/cNHq
         fD0qjj2S/IMhADNOIEXP7TW/4j+HdOZzb+bwfxivSDnsxghrZmRi/bO3PbBz5SPaMjlx
         ebCiNiPaCLGobzEhejoAGU2g/NWHc/4VM8Lko5qMsQp+6Ow5nahURpvLhnfKs7LbtVYI
         VvPjWieJ19xys2LLbIqGKf8GIjhlVrKNVEMm7202ssKg8R3sXY4dDfqnC1/M+5dN32a1
         b7LQ==
X-Gm-Message-State: AGi0PuYc9qraZULP+ElLXa9a60n08O1kXLYw7X+gpK+9Hh1j7S85T65b
        Iuam0um0d2eoX/hwCxPBDXE=
X-Google-Smtp-Source: APiQypLcivI2c+n9PIkReQk7m+dnLg8JBlSifrz4L3rmjTEVTW+cwfWf5Q6OxQrSMZo+1M3YJdY7tQ==
X-Received: by 2002:a63:5704:: with SMTP id l4mr9729669pgb.85.1588190535828;
        Wed, 29 Apr 2020 13:02:15 -0700 (PDT)
Received: from stbirv-lnx-3.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id r128sm1705817pfc.141.2020.04.29.13.02.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 29 Apr 2020 13:02:15 -0700 (PDT)
From:   Doug Berger <opendmb@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Doug Berger <opendmb@gmail.com>
Subject: [PATCH net-next v2 4/7] Revert "net: bcmgenet: remove unused function in bcmgenet.c"
Date:   Wed, 29 Apr 2020 13:02:03 -0700
Message-Id: <1588190526-2082-5-git-send-email-opendmb@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1588190526-2082-1-git-send-email-opendmb@gmail.com>
References: <1588190526-2082-1-git-send-email-opendmb@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit e2072600a24161b7ddcfb26814f69f5fbc8ef85a.

This commit restores the previous implementation of Hardware Filter
Block functions to the file for use in subsequent commits.

Signed-off-by: Doug Berger <opendmb@gmail.com>
---
 drivers/net/ethernet/broadcom/genet/bcmgenet.c | 122 +++++++++++++++++++++++++
 1 file changed, 122 insertions(+)

diff --git a/drivers/net/ethernet/broadcom/genet/bcmgenet.c b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
index 57b8608feae1..b37ef05c5083 100644
--- a/drivers/net/ethernet/broadcom/genet/bcmgenet.c
+++ b/drivers/net/ethernet/broadcom/genet/bcmgenet.c
@@ -2759,6 +2759,128 @@ static void bcmgenet_enable_dma(struct bcmgenet_priv *priv, u32 dma_ctrl)
 	bcmgenet_tdma_writel(priv, reg, DMA_CTRL);
 }
 
+static bool bcmgenet_hfb_is_filter_enabled(struct bcmgenet_priv *priv,
+					   u32 f_index)
+{
+	u32 offset;
+	u32 reg;
+
+	offset = HFB_FLT_ENABLE_V3PLUS + (f_index < 32) * sizeof(u32);
+	reg = bcmgenet_hfb_reg_readl(priv, offset);
+	return !!(reg & (1 << (f_index % 32)));
+}
+
+static void bcmgenet_hfb_enable_filter(struct bcmgenet_priv *priv, u32 f_index)
+{
+	u32 offset;
+	u32 reg;
+
+	offset = HFB_FLT_ENABLE_V3PLUS + (f_index < 32) * sizeof(u32);
+	reg = bcmgenet_hfb_reg_readl(priv, offset);
+	reg |= (1 << (f_index % 32));
+	bcmgenet_hfb_reg_writel(priv, reg, offset);
+}
+
+static void bcmgenet_hfb_set_filter_rx_queue_mapping(struct bcmgenet_priv *priv,
+						     u32 f_index, u32 rx_queue)
+{
+	u32 offset;
+	u32 reg;
+
+	offset = f_index / 8;
+	reg = bcmgenet_rdma_readl(priv, DMA_INDEX2RING_0 + offset);
+	reg &= ~(0xF << (4 * (f_index % 8)));
+	reg |= ((rx_queue & 0xF) << (4 * (f_index % 8)));
+	bcmgenet_rdma_writel(priv, reg, DMA_INDEX2RING_0 + offset);
+}
+
+static void bcmgenet_hfb_set_filter_length(struct bcmgenet_priv *priv,
+					   u32 f_index, u32 f_length)
+{
+	u32 offset;
+	u32 reg;
+
+	offset = HFB_FLT_LEN_V3PLUS +
+		 ((priv->hw_params->hfb_filter_cnt - 1 - f_index) / 4) *
+		 sizeof(u32);
+	reg = bcmgenet_hfb_reg_readl(priv, offset);
+	reg &= ~(0xFF << (8 * (f_index % 4)));
+	reg |= ((f_length & 0xFF) << (8 * (f_index % 4)));
+	bcmgenet_hfb_reg_writel(priv, reg, offset);
+}
+
+static int bcmgenet_hfb_find_unused_filter(struct bcmgenet_priv *priv)
+{
+	u32 f_index;
+
+	for (f_index = 0; f_index < priv->hw_params->hfb_filter_cnt; f_index++)
+		if (!bcmgenet_hfb_is_filter_enabled(priv, f_index))
+			return f_index;
+
+	return -ENOMEM;
+}
+
+/* bcmgenet_hfb_add_filter
+ *
+ * Add new filter to Hardware Filter Block to match and direct Rx traffic to
+ * desired Rx queue.
+ *
+ * f_data is an array of unsigned 32-bit integers where each 32-bit integer
+ * provides filter data for 2 bytes (4 nibbles) of Rx frame:
+ *
+ * bits 31:20 - unused
+ * bit  19    - nibble 0 match enable
+ * bit  18    - nibble 1 match enable
+ * bit  17    - nibble 2 match enable
+ * bit  16    - nibble 3 match enable
+ * bits 15:12 - nibble 0 data
+ * bits 11:8  - nibble 1 data
+ * bits 7:4   - nibble 2 data
+ * bits 3:0   - nibble 3 data
+ *
+ * Example:
+ * In order to match:
+ * - Ethernet frame type = 0x0800 (IP)
+ * - IP version field = 4
+ * - IP protocol field = 0x11 (UDP)
+ *
+ * The following filter is needed:
+ * u32 hfb_filter_ipv4_udp[] = {
+ *   Rx frame offset 0x00: 0x00000000, 0x00000000, 0x00000000, 0x00000000,
+ *   Rx frame offset 0x08: 0x00000000, 0x00000000, 0x000F0800, 0x00084000,
+ *   Rx frame offset 0x10: 0x00000000, 0x00000000, 0x00000000, 0x00030011,
+ * };
+ *
+ * To add the filter to HFB and direct the traffic to Rx queue 0, call:
+ * bcmgenet_hfb_add_filter(priv, hfb_filter_ipv4_udp,
+ *                         ARRAY_SIZE(hfb_filter_ipv4_udp), 0);
+ */
+int bcmgenet_hfb_add_filter(struct bcmgenet_priv *priv, u32 *f_data,
+			    u32 f_length, u32 rx_queue)
+{
+	int f_index;
+	u32 i;
+
+	f_index = bcmgenet_hfb_find_unused_filter(priv);
+	if (f_index < 0)
+		return -ENOMEM;
+
+	if (f_length > priv->hw_params->hfb_filter_size)
+		return -EINVAL;
+
+	for (i = 0; i < f_length; i++)
+		bcmgenet_hfb_writel(priv, f_data[i],
+			(f_index * priv->hw_params->hfb_filter_size + i) *
+			sizeof(u32));
+
+	bcmgenet_hfb_set_filter_length(priv, f_index, 2 * f_length);
+	bcmgenet_hfb_set_filter_rx_queue_mapping(priv, f_index, rx_queue);
+	bcmgenet_hfb_enable_filter(priv, f_index);
+	bcmgenet_hfb_reg_writel(priv, 0x1, HFB_CTRL);
+
+	return 0;
+}
+
 /* bcmgenet_hfb_clear
  *
  * Clear Hardware Filter Block and disable all filtering.
-- 
2.7.4

