Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C0AEE1640CE
	for <lists+netdev@lfdr.de>; Wed, 19 Feb 2020 10:51:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726496AbgBSJv4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Feb 2020 04:51:56 -0500
Received: from mail-pf1-f196.google.com ([209.85.210.196]:43669 "EHLO
        mail-pf1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726210AbgBSJvz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Feb 2020 04:51:55 -0500
Received: by mail-pf1-f196.google.com with SMTP id s1so12236692pfh.10
        for <netdev@vger.kernel.org>; Wed, 19 Feb 2020 01:51:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=qxv+o69qcyjBuou3AIBbEy0JXezqnoK9posUaRRF8jY=;
        b=bdPNRB5JbB1azZRrcQDikso4+Etdx34rLLuFfce1+gPf0kZ6y2ZPmb+3Eg9HDEdJSK
         69mzBtFI1oRKGETENL6PpIiXuGExHERE6N9ZWh9yHwK3pKVySPuNw1S+GhKcmX5f0Vhj
         i9+W8ld5LZ2qyUaZAPnKoiaj9FgqSLHgX7T1N3ZcaTeekVF6S1TmkudYGI4A7wLHpTwH
         heP312La8rBi6t2BvEoezx4FCRL1xxzedOVlTIjSQu6wNs759ij+U8CWFCEq+1YAKodW
         eG1+AiZXVk0KRbFAheWD+DFRUebRBiT4mJqqjYKM/9f+pKX/XSKmlf5OCwby+4Wsu7xU
         BjIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=qxv+o69qcyjBuou3AIBbEy0JXezqnoK9posUaRRF8jY=;
        b=LfqcO/d3QqEqGrmHWWYLdmlBrPfI1jpgK5Jj3XhYIIRfZwAm/0om2sghhgm2ePEjLv
         tSdQbvAvGdueWIAcW8aRZ7TrLZhNVnhvvJSFfiuI+Ggl2YPbwbaU+j2SXX2uCAA5ytCG
         PRn5IvIjzJq1szJekWKJO5FE7jX5o4DR+rX8Mflx0rK1i7V4Fgt2uqcaIQMRuW/ZkczI
         SxyS9YRHnHwpHecgJ+9xNDsi4Yxo5O0LL4UtLLswb7Z39Op9HD104FOrZbAvKxgy2NVu
         S6rJHb/kF2DkhyFhkGyDLL+aMihzlUJn3ffpfZPIgyLNjG+juS63JHTUlb99ojMf6Li1
         6HmA==
X-Gm-Message-State: APjAAAU7i/bYUJ3TFa1riPKxb3KGZdQHsqeef0H4mXNUSFG8I+EmM6OM
        OcMALA3Adjgv7b6degHet85fHsihrwk=
X-Google-Smtp-Source: APXvYqx+g1f94qParGPcAqyoovVqj5ERIRqkTJ0ctNzM5Rz+wR50BsBxJAVLn6c9eOfzfaKB9UqLDA==
X-Received: by 2002:a63:fe4f:: with SMTP id x15mr27863422pgj.30.1582105914663;
        Wed, 19 Feb 2020 01:51:54 -0800 (PST)
Received: from machine421.marvell.com ([115.113.156.2])
        by smtp.googlemail.com with ESMTPSA id w11sm2023724pgh.5.2020.02.19.01.51.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Wed, 19 Feb 2020 01:51:54 -0800 (PST)
From:   sunil.kovvuri@gmail.com
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, Sunil Goutham <sgoutham@marvell.com>
Subject: [PATCH 1/3] octeontx2-af: Remove unnecessary export symbols in CGX driver
Date:   Wed, 19 Feb 2020 15:21:06 +0530
Message-Id: <1582105868-29012-2-git-send-email-sunil.kovvuri@gmail.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1582105868-29012-1-git-send-email-sunil.kovvuri@gmail.com>
References: <1582105868-29012-1-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Sunil Goutham <sgoutham@marvell.com>

Since CGX driver and AF driver are built into a single module
the export symbols in CGX driver are not needed. This patch
gets rid of them.

Signed-off-by: Sunil Goutham <sgoutham@marvell.com>
---
 drivers/net/ethernet/marvell/octeontx2/af/cgx.c | 18 ------------------
 1 file changed, 18 deletions(-)

diff --git a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
index 5ca7886..9f5b722 100644
--- a/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
+++ b/drivers/net/ethernet/marvell/octeontx2/af/cgx.c
@@ -113,7 +113,6 @@ int cgx_get_cgxcnt_max(void)
 
 	return idmax + 1;
 }
-EXPORT_SYMBOL(cgx_get_cgxcnt_max);
 
 int cgx_get_lmac_cnt(void *cgxd)
 {
@@ -124,7 +123,6 @@ int cgx_get_lmac_cnt(void *cgxd)
 
 	return cgx->lmac_count;
 }
-EXPORT_SYMBOL(cgx_get_lmac_cnt);
 
 void *cgx_get_pdata(int cgx_id)
 {
@@ -136,7 +134,6 @@ void *cgx_get_pdata(int cgx_id)
 	}
 	return NULL;
 }
-EXPORT_SYMBOL(cgx_get_pdata);
 
 int cgx_get_cgxid(void *cgxd)
 {
@@ -164,7 +161,6 @@ int cgx_get_link_info(void *cgxd, int lmac_id,
 	*linfo = lmac->link_info;
 	return 0;
 }
-EXPORT_SYMBOL(cgx_get_link_info);
 
 static u64 mac2u64 (u8 *mac_addr)
 {
@@ -195,7 +191,6 @@ int cgx_lmac_addr_set(u8 cgx_id, u8 lmac_id, u8 *mac_addr)
 
 	return 0;
 }
-EXPORT_SYMBOL(cgx_lmac_addr_set);
 
 u64 cgx_lmac_addr_get(u8 cgx_id, u8 lmac_id)
 {
@@ -205,7 +200,6 @@ u64 cgx_lmac_addr_get(u8 cgx_id, u8 lmac_id)
 	cfg = cgx_read(cgx_dev, 0, CGXX_CMRX_RX_DMAC_CAM0 + lmac_id * 0x8);
 	return cfg & CGX_RX_DMAC_ADR_MASK;
 }
-EXPORT_SYMBOL(cgx_lmac_addr_get);
 
 int cgx_set_pkind(void *cgxd, u8 lmac_id, int pkind)
 {
@@ -217,7 +211,6 @@ int cgx_set_pkind(void *cgxd, u8 lmac_id, int pkind)
 	cgx_write(cgx, lmac_id, CGXX_CMRX_RX_ID_MAP, (pkind & 0x3F));
 	return 0;
 }
-EXPORT_SYMBOL(cgx_set_pkind);
 
 static inline u8 cgx_get_lmac_type(struct cgx *cgx, int lmac_id)
 {
@@ -255,7 +248,6 @@ int cgx_lmac_internal_loopback(void *cgxd, int lmac_id, bool enable)
 	}
 	return 0;
 }
-EXPORT_SYMBOL(cgx_lmac_internal_loopback);
 
 void cgx_lmac_promisc_config(int cgx_id, int lmac_id, bool enable)
 {
@@ -289,7 +281,6 @@ void cgx_lmac_promisc_config(int cgx_id, int lmac_id, bool enable)
 			  (CGXX_CMRX_RX_DMAC_CAM0 + lmac_id * 0x8), cfg);
 	}
 }
-EXPORT_SYMBOL(cgx_lmac_promisc_config);
 
 /* Enable or disable forwarding received pause frames to Tx block */
 void cgx_lmac_enadis_rx_pause_fwding(void *cgxd, int lmac_id, bool enable)
@@ -318,7 +309,6 @@ void cgx_lmac_enadis_rx_pause_fwding(void *cgxd, int lmac_id, bool enable)
 		cgx_write(cgx, lmac_id,	CGXX_SMUX_RX_FRM_CTL, cfg);
 	}
 }
-EXPORT_SYMBOL(cgx_lmac_enadis_rx_pause_fwding);
 
 int cgx_get_rx_stats(void *cgxd, int lmac_id, int idx, u64 *rx_stat)
 {
@@ -329,7 +319,6 @@ int cgx_get_rx_stats(void *cgxd, int lmac_id, int idx, u64 *rx_stat)
 	*rx_stat =  cgx_read(cgx, lmac_id, CGXX_CMRX_RX_STAT0 + (idx * 8));
 	return 0;
 }
-EXPORT_SYMBOL(cgx_get_rx_stats);
 
 int cgx_get_tx_stats(void *cgxd, int lmac_id, int idx, u64 *tx_stat)
 {
@@ -340,7 +329,6 @@ int cgx_get_tx_stats(void *cgxd, int lmac_id, int idx, u64 *tx_stat)
 	*tx_stat = cgx_read(cgx, lmac_id, CGXX_CMRX_TX_STAT0 + (idx * 8));
 	return 0;
 }
-EXPORT_SYMBOL(cgx_get_tx_stats);
 
 int cgx_lmac_rx_tx_enable(void *cgxd, int lmac_id, bool enable)
 {
@@ -358,7 +346,6 @@ int cgx_lmac_rx_tx_enable(void *cgxd, int lmac_id, bool enable)
 	cgx_write(cgx, lmac_id, CGXX_CMRX_CFG, cfg);
 	return 0;
 }
-EXPORT_SYMBOL(cgx_lmac_rx_tx_enable);
 
 int cgx_lmac_tx_enable(void *cgxd, int lmac_id, bool enable)
 {
@@ -379,7 +366,6 @@ int cgx_lmac_tx_enable(void *cgxd, int lmac_id, bool enable)
 		cgx_write(cgx, lmac_id, CGXX_CMRX_CFG, cfg);
 	return !!(last & DATA_PKT_TX_EN);
 }
-EXPORT_SYMBOL(cgx_lmac_tx_enable);
 
 /* CGX Firmware interface low level support */
 static int cgx_fwi_cmd_send(u64 req, u64 *resp, struct lmac *lmac)
@@ -610,7 +596,6 @@ int cgx_get_mkex_prfl_info(u64 *addr, u64 *size)
 
 	return 0;
 }
-EXPORT_SYMBOL(cgx_get_mkex_prfl_info);
 
 static irqreturn_t cgx_fwi_event_handler(int irq, void *data)
 {
@@ -676,7 +661,6 @@ int cgx_lmac_evh_register(struct cgx_event_cb *cb, void *cgxd, int lmac_id)
 
 	return 0;
 }
-EXPORT_SYMBOL(cgx_lmac_evh_register);
 
 int cgx_lmac_evh_unregister(void *cgxd, int lmac_id)
 {
@@ -695,7 +679,6 @@ int cgx_lmac_evh_unregister(void *cgxd, int lmac_id)
 
 	return 0;
 }
-EXPORT_SYMBOL(cgx_lmac_evh_unregister);
 
 static int cgx_fwi_link_change(struct cgx *cgx, int lmac_id, bool enable)
 {
@@ -769,7 +752,6 @@ int cgx_lmac_linkup_start(void *cgxd)
 
 	return 0;
 }
-EXPORT_SYMBOL(cgx_lmac_linkup_start);
 
 static int cgx_lmac_init(struct cgx *cgx)
 {
-- 
2.7.4

