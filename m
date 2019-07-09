Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AFA4463D24
	for <lists+netdev@lfdr.de>; Tue,  9 Jul 2019 23:15:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727572AbfGIVO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Jul 2019 17:14:57 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:43238 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727032AbfGIVO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 9 Jul 2019 17:14:56 -0400
Received: by mail-wr1-f67.google.com with SMTP id p13so251227wru.10
        for <netdev@vger.kernel.org>; Tue, 09 Jul 2019 14:14:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=rj+99i2uwCJ8cSFTtOPthReWg8Dntdmo/7awzx9PpEk=;
        b=jIuK8xkW3NhYHJv+zJu/2lHhMf3mmjM6dh/a5ED2EqiVvPnikMklDD0kcC/zO8yzFy
         CW3GWHjHl+8gqUKon7MqCItdB4Ot2QtXGjBMw8HsFOQDNR8vppl9vaicpjOwJ8auADXT
         hFLWXaBTSeMwOO02njHpZl5yWjiamkSAsGHo5a7Y1T2Faek7XPF/JbKRm3kuzTr9Uohf
         X4SMmsu2HG7P15IRsYhubv8mtn7RYFqezVzK/Rg5qcs7G3X/vWj4wNO9bFmeE+E9jJ8n
         adxRgtzJjcxuKV0cjVueExVGm2C82K/AmG2pGMovGa0lPSYKSyQDQ46T+E8H2JVfJaVw
         Z1Wg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=rj+99i2uwCJ8cSFTtOPthReWg8Dntdmo/7awzx9PpEk=;
        b=RxN8JfAwmWhM5wEVQYAyTVqB9F0xxo1Bef3eEtNZUELTkV0N3dZ28AUmH20tv4S/XP
         rorHr7jCunVaLl28sdDx6EwjJUen1+vJhe/9QrpnQpKwKvtR6A6JGohOUu842lsF3E4V
         uCuI5CV9PC+IlJ1biYJFm+dAmbz329k++jnebABlrzk3jqjGz8poR13kf4F2o8pBBwpq
         Rf2GwJGULrEmcmMdEf5DvjKt/VlZHk2mtAN6ueuDnkLqgP4FL6EYvX+cOO9xJHMMMi0E
         HcsJEqqBzaWmTMCiyZzxk83C1WjRoUlVSTxhyU/nIfBChvvbiTVSSau/9mQAA9TcjrGL
         DRYg==
X-Gm-Message-State: APjAAAVsrZdupIeU5Ja+PXmDDF5RzQzHOvQPbLlg9RgPRDb0CNtl6toG
        UpRdlofhQG0ngalA2TGX7LZZFutJB90=
X-Google-Smtp-Source: APXvYqyzDsDP9KoJ7nSI20jgifBpSNZhQWhtMvF9wxUU+jQSzB2UOhTu9lr7fOiLcu/W49mrXRXcYg==
X-Received: by 2002:adf:a514:: with SMTP id i20mr28211032wrb.281.1562706893660;
        Tue, 09 Jul 2019 14:14:53 -0700 (PDT)
Received: from apalos.lan (athedsl-428434.home.otenet.gr. [79.131.225.144])
        by smtp.gmail.com with ESMTPSA id c1sm51464wrh.1.2019.07.09.14.14.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Tue, 09 Jul 2019 14:14:52 -0700 (PDT)
From:   Ilias Apalodimas <ilias.apalodimas@linaro.org>
To:     netdev@vger.kernel.org, jaswinder.singh@linaro.org,
        davem@davemloft.net
Cc:     Ilias Apalodimas <ilias.apalodimas@linaro.org>
Subject: [PATCH 2/2] net: netsec: remove static declaration for netsec_set_tx_de()
Date:   Wed, 10 Jul 2019 00:14:49 +0300
Message-Id: <1562706889-15471-2-git-send-email-ilias.apalodimas@linaro.org>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562706889-15471-1-git-send-email-ilias.apalodimas@linaro.org>
References: <1562706889-15471-1-git-send-email-ilias.apalodimas@linaro.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On commit ba2b232108d3 ("net: netsec: add XDP support") a static
declaration for netsec_set_tx_de() was added to make the diff easier
to read.  Now that the patch is merged let's move the functions around
and get rid of that

Signed-off-by: Ilias Apalodimas <ilias.apalodimas@linaro.org>
---
 drivers/net/ethernet/socionext/netsec.c | 86 ++++++++++++-------------
 1 file changed, 41 insertions(+), 45 deletions(-)

diff --git a/drivers/net/ethernet/socionext/netsec.c b/drivers/net/ethernet/socionext/netsec.c
index 7f9280f1fb28..1502fe8b0456 100644
--- a/drivers/net/ethernet/socionext/netsec.c
+++ b/drivers/net/ethernet/socionext/netsec.c
@@ -328,11 +328,6 @@ struct netsec_rx_pkt_info {
 	bool err_flag;
 };
 
-static void netsec_set_tx_de(struct netsec_priv *priv,
-			     struct netsec_desc_ring *dring,
-			     const struct netsec_tx_pkt_ctrl *tx_ctrl,
-			     const struct netsec_desc *desc, void *buf);
-
 static void netsec_write(struct netsec_priv *priv, u32 reg_addr, u32 val)
 {
 	writel(val, priv->ioaddr + reg_addr);
@@ -778,6 +773,47 @@ static void netsec_finalize_xdp_rx(struct netsec_priv *priv, u32 xdp_res,
 		netsec_xdp_ring_tx_db(priv, pkts);
 }
 
+static void netsec_set_tx_de(struct netsec_priv *priv,
+			     struct netsec_desc_ring *dring,
+			     const struct netsec_tx_pkt_ctrl *tx_ctrl,
+			     const struct netsec_desc *desc, void *buf)
+{
+	int idx = dring->head;
+	struct netsec_de *de;
+	u32 attr;
+
+	de = dring->vaddr + (DESC_SZ * idx);
+
+	attr = (1 << NETSEC_TX_SHIFT_OWN_FIELD) |
+	       (1 << NETSEC_TX_SHIFT_PT_FIELD) |
+	       (NETSEC_RING_GMAC << NETSEC_TX_SHIFT_TDRID_FIELD) |
+	       (1 << NETSEC_TX_SHIFT_FS_FIELD) |
+	       (1 << NETSEC_TX_LAST) |
+	       (tx_ctrl->cksum_offload_flag << NETSEC_TX_SHIFT_CO) |
+	       (tx_ctrl->tcp_seg_offload_flag << NETSEC_TX_SHIFT_SO) |
+	       (1 << NETSEC_TX_SHIFT_TRS_FIELD);
+	if (idx == DESC_NUM - 1)
+		attr |= (1 << NETSEC_TX_SHIFT_LD_FIELD);
+
+	de->data_buf_addr_up = upper_32_bits(desc->dma_addr);
+	de->data_buf_addr_lw = lower_32_bits(desc->dma_addr);
+	de->buf_len_info = (tx_ctrl->tcp_seg_len << 16) | desc->len;
+	de->attr = attr;
+	/* under spin_lock if using XDP */
+	if (!dring->is_xdp)
+		dma_wmb();
+
+	dring->desc[idx] = *desc;
+	if (desc->buf_type == TYPE_NETSEC_SKB)
+		dring->desc[idx].skb = buf;
+	else if (desc->buf_type == TYPE_NETSEC_XDP_TX ||
+		 desc->buf_type == TYPE_NETSEC_XDP_NDO)
+		dring->desc[idx].xdpf = buf;
+
+	/* move head ahead */
+	dring->head = (dring->head + 1) % DESC_NUM;
+}
+
 /* The current driver only supports 1 Txq, this should run under spin_lock() */
 static u32 netsec_xdp_queue_one(struct netsec_priv *priv,
 				struct xdp_frame *xdpf, bool is_ndo)
@@ -1041,46 +1077,6 @@ static int netsec_napi_poll(struct napi_struct *napi, int budget)
 	return done;
 }
 
-static void netsec_set_tx_de(struct netsec_priv *priv,
-			     struct netsec_desc_ring *dring,
-			     const struct netsec_tx_pkt_ctrl *tx_ctrl,
-			     const struct netsec_desc *desc, void *buf)
-{
-	int idx = dring->head;
-	struct netsec_de *de;
-	u32 attr;
-
-	de = dring->vaddr + (DESC_SZ * idx);
-
-	attr = (1 << NETSEC_TX_SHIFT_OWN_FIELD) |
-	       (1 << NETSEC_TX_SHIFT_PT_FIELD) |
-	       (NETSEC_RING_GMAC << NETSEC_TX_SHIFT_TDRID_FIELD) |
-	       (1 << NETSEC_TX_SHIFT_FS_FIELD) |
-	       (1 << NETSEC_TX_LAST) |
-	       (tx_ctrl->cksum_offload_flag << NETSEC_TX_SHIFT_CO) |
-	       (tx_ctrl->tcp_seg_offload_flag << NETSEC_TX_SHIFT_SO) |
-	       (1 << NETSEC_TX_SHIFT_TRS_FIELD);
-	if (idx == DESC_NUM - 1)
-		attr |= (1 << NETSEC_TX_SHIFT_LD_FIELD);
-
-	de->data_buf_addr_up = upper_32_bits(desc->dma_addr);
-	de->data_buf_addr_lw = lower_32_bits(desc->dma_addr);
-	de->buf_len_info = (tx_ctrl->tcp_seg_len << 16) | desc->len;
-	de->attr = attr;
-	/* under spin_lock if using XDP */
-	if (!dring->is_xdp)
-		dma_wmb();
-
-	dring->desc[idx] = *desc;
-	if (desc->buf_type == TYPE_NETSEC_SKB)
-		dring->desc[idx].skb = buf;
-	else if (desc->buf_type == TYPE_NETSEC_XDP_TX ||
-		 desc->buf_type == TYPE_NETSEC_XDP_NDO)
-		dring->desc[idx].xdpf = buf;
-
-	/* move head ahead */
-	dring->head = (dring->head + 1) % DESC_NUM;
-}
 
 static int netsec_desc_used(struct netsec_desc_ring *dring)
 {
-- 
2.20.1

