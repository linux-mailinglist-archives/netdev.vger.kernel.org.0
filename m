Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53777395723
	for <lists+netdev@lfdr.de>; Mon, 31 May 2021 10:38:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230412AbhEaIkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 May 2021 04:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230400AbhEaIkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 May 2021 04:40:12 -0400
Received: from mail-yb1-xb49.google.com (mail-yb1-xb49.google.com [IPv6:2607:f8b0:4864:20::b49])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4DCE2C06174A
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 01:38:33 -0700 (PDT)
Received: by mail-yb1-xb49.google.com with SMTP id a7-20020a5b00070000b02904ed415d9d84so12932076ybp.0
        for <netdev@vger.kernel.org>; Mon, 31 May 2021 01:38:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:in-reply-to:message-id:mime-version:references:subject:from:to
         :cc;
        bh=oha3Req4PO5smWr+P0a1rzrVDS+Kl6LxFKPaoAFG81g=;
        b=Q+3E5glDrcwJ4gwXL2WKwdVztQqd2VwmSyAq4lUAEDUwQsYKH0cVUY7PLSVTw3jdXO
         uQ7cpb75AX27stPJLi34hjuB9+PJ1NN46vwYcnxiM/uZuBfw1alW+Ojr0UQ0Tyz9rkpi
         7ahkPgdMInf4iAvBt9NlzcCbdgNG1hMiGY/aynXyBxOl18vWV77J9xkwB23zLMyKmUsf
         +DiMt4kE+DIDU6njzOmETqZqzmNb+7jh9FhRpUeaKrYpdAX4S0LTOUmkp8lTMu5x1NRb
         DOi2N16VbZd2doOhhxhpreFJow8W1K25i1r6uXOSqxViqNI6NFB414hdlXtN1K3uTRzl
         spnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:message-id:mime-version
         :references:subject:from:to:cc;
        bh=oha3Req4PO5smWr+P0a1rzrVDS+Kl6LxFKPaoAFG81g=;
        b=eSu5IEbodbGVUpsGSqDfXf4xyKwO9y8S4VoYgxIm58c3m0L3axZI8CVoUzfy7E5lYy
         XLBd5bgMbr8lXJpvwUziSVOvE30DunZ5sIC68zXSRz253AeZwJmW3rzKp3B7QEv5SgQ9
         5DCHqJHCsGJd1oq2DVvQbVJGI1gI2gMmWKzPjpGhnsV9oDB0gb4aptqK+Qw4091DTPv+
         rVjlfsXoquIHrwpr2lULSWNZglFBxXXXJKzNPhCRMGVscp20RR/dPVI5vSAIwcB/cdAb
         eYmBXefPtRiZ5briu017gtMCKxcgH3zfn3ssCCZGgh/ei5BVyZFK+FEXR/B59znBgMSg
         q5hQ==
X-Gm-Message-State: AOAM530CP69ZGJV94Eq5OJp5ftocY38RZ8cIf/8GzQyHRhB60G0mHePJ
        DINMZf7H29xVkCj2RwrxdOB3lHoZGUOt
X-Google-Smtp-Source: ABdhPJxZSLMhNj2/1XeLU1eRo0bYIz3Xc/neRmJaXqRXQM4HhbA2x46IKSIKI94yWQ8BFyI1ZxHyNWH6Q3u4
X-Received: from apusaka-p920.tpe.corp.google.com ([2401:fa00:1:b:a6d1:a727:b17d:154e])
 (user=apusaka job=sendgmr) by 2002:a25:af04:: with SMTP id
 a4mr30452339ybh.131.1622450312500; Mon, 31 May 2021 01:38:32 -0700 (PDT)
Date:   Mon, 31 May 2021 16:37:21 +0800
In-Reply-To: <20210531083726.1949001-1-apusaka@google.com>
Message-Id: <20210531163500.v2.2.I0564cdade0879f3f2b192ae73d01a0135baf8050@changeid>
Mime-Version: 1.0
References: <20210531083726.1949001-1-apusaka@google.com>
X-Mailer: git-send-email 2.32.0.rc0.204.g9fa02ecfa5-goog
Subject: [PATCH v2 2/8] Bluetooth: use inclusive language in hci_core.h
From:   Archie Pusaka <apusaka@google.com>
To:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>
Cc:     CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        Miao-chen Chou <mcchou@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Archie Pusaka <apusaka@chromium.org>

This patch replaces some non-inclusive terms based on the appropriate
language mapping table compiled by the Bluetooth SIG:
https://specificationrefs.bluetooth.com/language-mapping/Appropriate_Language_Mapping_Table.pdf

Specifically, these terms are replaced:
master -> central
slave  -> peripheral

These attributes are not used elsewhere in the code.

Signed-off-by: Archie Pusaka <apusaka@chromium.org>
Reviewed-by: Miao-chen Chou <mcchou@chromium.org>

---

Changes in v2:
* Add details in commit message

 include/net/bluetooth/hci.h | 44 ++++++++++++++++++-------------------
 1 file changed, 22 insertions(+), 22 deletions(-)

diff --git a/include/net/bluetooth/hci.h b/include/net/bluetooth/hci.h
index 18742f4471ff..c3efef266d6d 100644
--- a/include/net/bluetooth/hci.h
+++ b/include/net/bluetooth/hci.h
@@ -1839,23 +1839,23 @@ struct hci_rp_le_read_iso_tx_sync {
 #define HCI_OP_LE_SET_CIG_PARAMS		0x2062
 struct hci_cis_params {
 	__u8    cis_id;
-	__le16  m_sdu;
-	__le16  s_sdu;
-	__u8    m_phy;
-	__u8    s_phy;
-	__u8    m_rtn;
-	__u8    s_rtn;
+	__le16  c_sdu;
+	__le16  p_pdu;
+	__u8    c_phy;
+	__u8    p_phy;
+	__u8    c_rtn;
+	__u8    p_rtn;
 } __packed;
 
 struct hci_cp_le_set_cig_params {
 	__u8    cig_id;
-	__u8    m_interval[3];
-	__u8    s_interval[3];
-	__u8    sca;
+	__u8    c_interval[3];
+	__u8    p_interval[3];
+	__u8    wc_sca;
 	__u8    packing;
 	__u8    framing;
-	__le16  m_latency;
-	__le16  s_latency;
+	__le16  c_latency;
+	__le16  p_latency;
 	__u8    num_cis;
 	struct hci_cis_params cis[];
 } __packed;
@@ -2260,7 +2260,7 @@ struct hci_ev_sync_train_complete {
 	__u8	status;
 } __packed;
 
-#define HCI_EV_SLAVE_PAGE_RESP_TIMEOUT	0x54
+#define HCI_EV_PERIPHERAL_PAGE_RESP_TIMEOUT	0x54
 
 #define HCI_EV_LE_CONN_COMPLETE		0x01
 struct hci_ev_le_conn_complete {
@@ -2418,17 +2418,17 @@ struct hci_evt_le_cis_established {
 	__le16 handle;
 	__u8  cig_sync_delay[3];
 	__u8  cis_sync_delay[3];
-	__u8  m_latency[3];
-	__u8  s_latency[3];
-	__u8  m_phy;
-	__u8  s_phy;
+	__u8  c_latency[3];
+	__u8  p_latency[3];
+	__u8  c_phy;
+	__u8  p_phy;
 	__u8  nse;
-	__u8  m_bn;
-	__u8  s_bn;
-	__u8  m_ft;
-	__u8  s_ft;
-	__le16 m_mtu;
-	__le16 s_mtu;
+	__u8  c_bn;
+	__u8  p_bn;
+	__u8  c_ft;
+	__u8  p_ft;
+	__le16 c_mtu;
+	__le16 p_mtu;
 	__le16 interval;
 } __packed;
 
-- 
2.32.0.rc0.204.g9fa02ecfa5-goog

