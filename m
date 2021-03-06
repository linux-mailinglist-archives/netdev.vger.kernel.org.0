Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF4B32FD7A
	for <lists+netdev@lfdr.de>; Sat,  6 Mar 2021 22:24:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhCFVYC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Mar 2021 16:24:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36444 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229642AbhCFVXb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Mar 2021 16:23:31 -0500
Received: from mail-qk1-x72a.google.com (mail-qk1-x72a.google.com [IPv6:2607:f8b0:4864:20::72a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0400DC06174A;
        Sat,  6 Mar 2021 13:23:31 -0800 (PST)
Received: by mail-qk1-x72a.google.com with SMTP id s7so5712084qkg.4;
        Sat, 06 Mar 2021 13:23:30 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GxYmWP6UfMGkoRjBgDhPVyqMXEF3+SwvgBqew9251Ew=;
        b=V0+tM6DTQg3pSj0L4RxszCrI9NtPbofGp+uu3T8jgevaSWOBk1lz/aoHIPs1Y+uE6A
         YVv77mRj1P2iNRp+inFNSzAxMWrG3zxtCBJeX46wkMu0TTYrnbNUHCd/6Ud3ZUwcdH3b
         EgiF8R+AnwMJL9Ulpf3Kwf72SAp+f7IIjx1IR31oYu9Eosd+VMeBJBl04eRe+ZolsoiH
         Iqtws/pw3JwkqmicdsuC0RsXlbZYSfi1xPnIjwvJBgQPblvOJY6GoLTYn9wToBOXPvsC
         NSx/nPxV3jOMpcjPCjyHa31swho6qCoILeJTxLQWnY0bYh+OdjOw505RfEtr28Vi7I4l
         SYXA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=GxYmWP6UfMGkoRjBgDhPVyqMXEF3+SwvgBqew9251Ew=;
        b=o+OaP9r7DyQohR8Q1c3oveFZHqPqDmwb68b5Y1HWn2IWGlmIypgtfj67EsS8tuxBe8
         CB2odKotOrvD7C1CWo+2wbq3/t14DDHQ110oPJ/RqHODkEUpyGhLwhdTGCkP6edsjFwn
         7fZxFaDZLPh8aAISKoalbiRIDypEgRpxhUHXBZnEglrEhyA21QkyhoBp30dxZb5HgycF
         tg5L+6HCiKlOgiXBL5165ZAV30lCtYVlvpNnZsZhTTc0NHgsoYIgIskVn8evpK2+A5js
         tO+LRJA7LLQmioZwLC/2snPk3HPS8Ag3kHsXhufvOZ9OcOzxRhMOtPnfHvqOUnQRp/o1
         h02Q==
X-Gm-Message-State: AOAM530gEZByCi8rYBnW+bTI26AfBAY0yXTDRjrzzAc+xNyIwR7tJqG3
        tTO4zaUfqV0ovqNVRrDjBGg=
X-Google-Smtp-Source: ABdhPJxdgWkrSRGo6BLggMDI1OxJCyuWL3kWRHbfmfLRIIYw0cHCTb0X6bxA3BJozQp3pafhuV49tA==
X-Received: by 2002:a37:4b52:: with SMTP id y79mr14907392qka.132.1615065810141;
        Sat, 06 Mar 2021 13:23:30 -0800 (PST)
Received: from localhost.localdomain ([138.199.13.185])
        by smtp.gmail.com with ESMTPSA id r133sm4705642qke.20.2021.03.06.13.23.25
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 06 Mar 2021 13:23:29 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     ayush.sawal@chelsio.com, vinay.yadav@chelsio.com,
        rohitm@chelsio.com, davem@davemloft.net, kuba@kernel.org,
        arnd@arndb.de, yuehaibing@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] net: ethernet: chelsio: inline_crypto: Mundane typos fixed throughout the file chcr_ktls.c
Date:   Sun,  7 Mar 2021 02:50:28 +0530
Message-Id: <20210306212028.3860-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



Mundane typos fixes throughout the file.

s/establised/established/
s/availbale/available/
s/vaues/values/
s/Incase/In case/

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 .../ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c    | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
index 1b7e8c91b541..6a9c6aa73eb4 100644
--- a/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
+++ b/drivers/net/ethernet/chelsio/inline_crypto/ch_ktls/chcr_ktls.c
@@ -677,7 +677,7 @@ static int chcr_ktls_cpl_act_open_rpl(struct adapter *adap,
 	if (tx_info->pending_close) {
 		spin_unlock(&tx_info->lock);
 		if (!status) {
-			/* it's a late success, tcb status is establised,
+			/* it's a late success, tcb status is established,
 			 * mark it close.
 			 */
 			chcr_ktls_mark_tcb_close(tx_info);
@@ -935,7 +935,7 @@ chcr_ktls_get_tx_flits(u32 nr_frags, unsigned int key_ctx_len)
 }

 /*
- * chcr_ktls_check_tcp_options: To check if there is any TCP option availbale
+ * chcr_ktls_check_tcp_options: To check if there is any TCP option available
  * other than timestamp.
  * @skb - skb contains partial record..
  * return: 1 / 0
@@ -1120,7 +1120,7 @@ static int chcr_ktls_xmit_wr_complete(struct sk_buff *skb,
 	}

 	if (unlikely(credits < ETHTXQ_STOP_THRES)) {
-		/* Credits are below the threshold vaues, stop the queue after
+		/* Credits are below the threshold values, stop the queue after
 		 * injecting the Work Request for this packet.
 		 */
 		chcr_eth_txq_stop(q);
@@ -2011,7 +2011,7 @@ static int chcr_ktls_xmit(struct sk_buff *skb, struct net_device *dev)

 	/* TCP segments can be in received either complete or partial.
 	 * chcr_end_part_handler will handle cases if complete record or end
-	 * part of the record is received. Incase of partial end part of record,
+	 * part of the record is received. In case of partial end part of record,
 	 * we will send the complete record again.
 	 */

--
2.26.2

