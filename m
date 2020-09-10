Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB74263E44
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 09:14:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730257AbgIJHOL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 03:14:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730251AbgIJG6c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 02:58:32 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE65DC061357
        for <netdev@vger.kernel.org>; Wed,  9 Sep 2020 23:55:16 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id o5so5363212wrn.13
        for <netdev@vger.kernel.org>; Wed, 09 Sep 2020 23:55:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=y3aNmNMSAAKySSaB5bb9ahC7IKT1fIK3BKBDgaZqfos=;
        b=j0p5N0IoFnkC0jPzzxrex1C4xZe5aqi7g6j7/iQDrX3ZY1pp2W9F2bfHuZYIRNydrj
         KlOKCcnfhmEoNdCXqyyG17AKOphxep4Vd4sIUaMX3x4JDf0n45cBzPGc1pVDmxZYVkcT
         DdK4cwwSNEQcSQRQtDfbjaFUSWibF+0u30DoOXwBI2pDXDPy+CzzOl7TqK1vjMACZOsd
         ajwsR0fa5ZIQjHWY8iMNVui88rI0EiJLA7avrXk9qYWqQ8PDHmNnFAJzShdUAyRXW3Ab
         O1rF88b8mqzTArTf4DnuTfbti2t432HCpO/IXwpbSS0+sYI+MaiDSo+lcirO860FBW6Y
         DL/w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=y3aNmNMSAAKySSaB5bb9ahC7IKT1fIK3BKBDgaZqfos=;
        b=C7z3hLIe+TqaxanE2lWJP6SEdlu/z6wogOtQCXH34n59OopYMzWhgukdyHQGBDP7WS
         8CqTf3yJIvebFo1pIiGwWKgvPA6b0jG9gVGE+CEq8UWfgUjZWY4HFxF7PjxbCXCOKOxb
         vzSCQTJ4Hi2HKmGPkFRESlpFvBBPtjWz9H7rqJXyeoVuLfVW4Zf+6mHdI3ga5rgrjPAQ
         oCbBtUBpK6QzSPSzntEjDfqtkBdTn+6X3dkhHTJmhmHt0YGUyHQIiviqXSxF7ORUfGZr
         me+sYg5JpwNjD0rBGwJeZAngM3LAd/4Gwt6fE2VwQHXimfpJ3YZelJjD/Wym4BY6ybKu
         /Qxw==
X-Gm-Message-State: AOAM532dTyDTxMA9jGgQX8nAooTx27vRi1moiCbFE3Ewyq60Jk+HmUYz
        CwnspIxy91zPWrDHXJbculnR9g==
X-Google-Smtp-Source: ABdhPJw8WdgjAdlbjKyt7zp/MFuJRDOMnvlzlEGu++DwdtfGl2isZmmqMtKJ3OjPn4EJz6D4Sk3YAA==
X-Received: by 2002:a5d:40c7:: with SMTP id b7mr7393943wrq.300.1599720915498;
        Wed, 09 Sep 2020 23:55:15 -0700 (PDT)
Received: from dell.default ([91.110.221.246])
        by smtp.gmail.com with ESMTPSA id m3sm2444028wme.31.2020.09.09.23.55.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Sep 2020 23:55:14 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Maya Erez <merez@codeaurora.org>, wil6210@qti.qualcomm.com
Subject: [PATCH 19/29] wil6210: txrx_edma: Demote comments which are clearly not kernel-doc
Date:   Thu, 10 Sep 2020 07:54:21 +0100
Message-Id: <20200910065431.657636-20-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200910065431.657636-1-lee.jones@linaro.org>
References: <20200910065431.657636-1-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fixes the following W=1 kernel build warning(s):

 drivers/net/wireless/ath/wil6210/txrx_edma.c:155: warning: Function parameter or member 'wil' not described in 'wil_ring_alloc_skb_edma'
 drivers/net/wireless/ath/wil6210/txrx_edma.c:155: warning: Function parameter or member 'ring' not described in 'wil_ring_alloc_skb_edma'
 drivers/net/wireless/ath/wil6210/txrx_edma.c:155: warning: Function parameter or member 'i' not described in 'wil_ring_alloc_skb_edma'
 drivers/net/wireless/ath/wil6210/txrx_edma.c:1161: warning: Function parameter or member 'wil' not described in 'wil_tx_sring_handler'
 drivers/net/wireless/ath/wil6210/txrx_edma.c:1161: warning: Function parameter or member 'sring' not described in 'wil_tx_sring_handler'
 drivers/net/wireless/ath/wil6210/txrx_edma.c:1328: warning: Function parameter or member 'd' not described in 'wil_tx_desc_offload_setup_tso_edma'
 drivers/net/wireless/ath/wil6210/txrx_edma.c:1328: warning: Function parameter or member 'tso_desc_type' not described in 'wil_tx_desc_offload_setup_tso_edma'
 drivers/net/wireless/ath/wil6210/txrx_edma.c:1328: warning: Function parameter or member 'is_ipv4' not described in 'wil_tx_desc_offload_setup_tso_edma'
 drivers/net/wireless/ath/wil6210/txrx_edma.c:1328: warning: Function parameter or member 'tcp_hdr_len' not described in 'wil_tx_desc_offload_setup_tso_edma'
 drivers/net/wireless/ath/wil6210/txrx_edma.c:1328: warning: Function parameter or member 'skb_net_hdr_len' not described in 'wil_tx_desc_offload_setup_tso_edma'
 drivers/net/wireless/ath/wil6210/txrx_edma.c:1328: warning: Function parameter or member 'mss' not described in 'wil_tx_desc_offload_setup_tso_edma'

Cc: Maya Erez <merez@codeaurora.org>
Cc: Kalle Valo <kvalo@codeaurora.org>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <kuba@kernel.org>
Cc: linux-wireless@vger.kernel.org
Cc: wil6210@qti.qualcomm.com
Cc: netdev@vger.kernel.org
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/net/wireless/ath/wil6210/txrx_edma.c | 10 +++-------
 1 file changed, 3 insertions(+), 7 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index 7bfe867c7509e..8ca2ce51c83ef 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -147,9 +147,7 @@ static int wil_tx_init_edma(struct wil6210_priv *wil)
 	return rc;
 }
 
-/**
- * Allocate one skb for Rx descriptor RING
- */
+/* Allocate one skb for Rx descriptor RING */
 static int wil_ring_alloc_skb_edma(struct wil6210_priv *wil,
 				   struct wil_ring *ring, u32 i)
 {
@@ -1152,8 +1150,7 @@ wil_get_next_tx_status_msg(struct wil_status_ring *sring, u8 *dr_bit,
 	*msg = *_msg;
 }
 
-/**
- * Clean up transmitted skb's from the Tx descriptor RING.
+/* Clean up transmitted skb's from the Tx descriptor RING.
  * Return number of descriptors cleared.
  */
 int wil_tx_sring_handler(struct wil6210_priv *wil,
@@ -1314,8 +1311,7 @@ int wil_tx_sring_handler(struct wil6210_priv *wil,
 	return desc_cnt;
 }
 
-/**
- * Sets the descriptor @d up for csum and/or TSO offloading. The corresponding
+/* Sets the descriptor @d up for csum and/or TSO offloading. The corresponding
  * @skb is used to obtain the protocol and headers length.
  * @tso_desc_type is a descriptor type for TSO: 0 - a header, 1 - first data,
  * 2 - middle, 3 - last descriptor.
-- 
2.25.1

