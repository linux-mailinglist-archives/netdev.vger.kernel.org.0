Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C7A24CEEA
	for <lists+netdev@lfdr.de>; Fri, 21 Aug 2020 09:20:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbgHUHTw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Aug 2020 03:19:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728289AbgHUHSX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Aug 2020 03:18:23 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7ED59C0612F1
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:24 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id a15so987028wrh.10
        for <netdev@vger.kernel.org>; Fri, 21 Aug 2020 00:17:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=3GcXWK42EOat9gpnv8yfBhBVK1TNbXyjHRD+03gi2Dk=;
        b=zKIGuyNS9dEpgui3o1oAewVdt7OZLZGMe4NfJiyTtqzGaBaiFU/KqDyDWUPAMxtUhT
         hrmQQAQAe/ON2srwrzflXkvaBBAP6AFcaSY7svkz+oazdd3o+xdVZlPXvR6m+rkYZzli
         BVV1p+m6HBVNJxlCnSdqYwVKv70l5WkNoDiR4grhO1LqVYLv1IIDOtwwwVXREwTLfSQj
         jfO0aeuOLn3k0QTp8Ei+/ntORcg/UHjP3uHxFS6Zn3mN4vaKZQ7yw1l+MStMtNokpFfB
         FrjyH9aNTzZJCdnU0MwBvVq61+OnYAYpibR1NvR36gN5AlkjOGiguVkkqeVRcjqYnWIn
         KiQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=3GcXWK42EOat9gpnv8yfBhBVK1TNbXyjHRD+03gi2Dk=;
        b=hJ/zTNPof8BT4nFxGfT37jW5atnEDI4IslF473U5xxagD6Y+d4NotxX2nfLxaKf8EX
         Dlh/JX1n/0pUSEKLRMc9B/LYHjqd8qhMN7zRnWybNowQG809qYBoxDuDfKkGODMDZ1Q9
         uTM9aHmlWAvHZCNO9kwZxiFuTKel4VNYtsagjJrLIG08oH712EXOxmN+LfoBYE8DMGRW
         NMFftMGV/AzDvtNexafZJEnifgNi/HeQhkfTI+TsE7O4JuKbE6Kot9rQAEeu4dboBLPD
         EoJsXX3cL3NwqW8dIkad76sVIUbTdUR7U2Djs1NyLFe99UvT851EHiaTggMVAsKmrjVy
         iXcQ==
X-Gm-Message-State: AOAM533hEvDmnPxBlrOg1WVO/iVnkBksoVPagD9e6bcmluEINjs5PhGM
        AcfP1VYcLRwzc5FfbmC4XZN9Rw==
X-Google-Smtp-Source: ABdhPJyno6qESJCJyD/bb2OUFMm5wB39EeK0xwRj1yRHwjS8+ZfoYNIIYaKpFzBo/7N0ZNP3x9pv1Q==
X-Received: by 2002:adf:ba10:: with SMTP id o16mr1424734wrg.100.1597994243109;
        Fri, 21 Aug 2020 00:17:23 -0700 (PDT)
Received: from dell.default ([95.149.164.62])
        by smtp.gmail.com with ESMTPSA id y24sm2667957wmi.17.2020.08.21.00.17.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 21 Aug 2020 00:17:22 -0700 (PDT)
From:   Lee Jones <lee.jones@linaro.org>
To:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org
Cc:     linux-kernel@vger.kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, Lee Jones <lee.jones@linaro.org>,
        Maya Erez <merez@codeaurora.org>, wil6210@qti.qualcomm.com
Subject: [PATCH 28/32] wireless: ath: wil6210: txrx_edma: Demote comments which are clearly not kernel-doc
Date:   Fri, 21 Aug 2020 08:16:40 +0100
Message-Id: <20200821071644.109970-29-lee.jones@linaro.org>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20200821071644.109970-1-lee.jones@linaro.org>
References: <20200821071644.109970-1-lee.jones@linaro.org>
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
 drivers/net/wireless/ath/wil6210/txrx_edma.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/wireless/ath/wil6210/txrx_edma.c b/drivers/net/wireless/ath/wil6210/txrx_edma.c
index 7bfe867c7509e..1eb1a309a0264 100644
--- a/drivers/net/wireless/ath/wil6210/txrx_edma.c
+++ b/drivers/net/wireless/ath/wil6210/txrx_edma.c
@@ -147,7 +147,7 @@ static int wil_tx_init_edma(struct wil6210_priv *wil)
 	return rc;
 }
 
-/**
+/*
  * Allocate one skb for Rx descriptor RING
  */
 static int wil_ring_alloc_skb_edma(struct wil6210_priv *wil,
@@ -1152,7 +1152,7 @@ wil_get_next_tx_status_msg(struct wil_status_ring *sring, u8 *dr_bit,
 	*msg = *_msg;
 }
 
-/**
+/*
  * Clean up transmitted skb's from the Tx descriptor RING.
  * Return number of descriptors cleared.
  */
@@ -1314,7 +1314,7 @@ int wil_tx_sring_handler(struct wil6210_priv *wil,
 	return desc_cnt;
 }
 
-/**
+/*
  * Sets the descriptor @d up for csum and/or TSO offloading. The corresponding
  * @skb is used to obtain the protocol and headers length.
  * @tso_desc_type is a descriptor type for TSO: 0 - a header, 1 - first data,
-- 
2.25.1

