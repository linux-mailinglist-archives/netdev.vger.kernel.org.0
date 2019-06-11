Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D5ECC3C26E
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 06:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391104AbfFKEk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 00:40:56 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:36397 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2391097AbfFKEky (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 00:40:54 -0400
Received: by mail-qt1-f196.google.com with SMTP id p15so5607043qtl.3
        for <netdev@vger.kernel.org>; Mon, 10 Jun 2019 21:40:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=crfOvVQhw99s20mEY/IFxnkIXUt0MpC66Bz96al6+G4=;
        b=E47A6OsF7mgaodS0tXwPgLPBfJyP/pcw+Y9FbFIZ7P6Mc5hEc4PhSSPN6XvjE3etX+
         l7ZsNbLY3zjQXee144eSTj8ycbakHtezYd6oxMh+HnQf3yPQJ9ABHCuy4VNuf4eYeKJM
         sdFbwhCDKZt0oEXTVgYXqO7VjgssDsz5NFR3ggqQeSXZCdXhjoE3sBCMmyp/gvIEETXI
         uDkeRMKeaO/bNC5IF4hdwSgDoXoxMSUSRJt8jCyYC4YZl6avDy7z7w5+yhFAYG5cN8Lu
         FSURtrKW5e2DujWPUS/CYRzoKEXoxikqcMjpHEmLA2GIEVRFPVXztR0+aHgDpfC4nFSZ
         3ytw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=crfOvVQhw99s20mEY/IFxnkIXUt0MpC66Bz96al6+G4=;
        b=QeBlMynQOqJ8pSErauQD/+Bct3fqExIDKiW7RdEPcxELffMGltpNeALH6pC13/43fv
         9t7pbsXboUM4DivPtrrzYYjpWDfOTG4msYJNZ5mYDkPJ4GHiKHplkgTc/j70cGMPK/Fg
         t23cPOQWq2c3uYyvJiSgeklTboW2pN1wm9cnmtVLc705V4/BPEBYP3Z2yhlq9UBJYigV
         4L5l3HpXanzy2b/9nwKjhTgocemwcpTvpUTEEhcw/L6x/orOzINGzyIn0Ch4PPSt6o9K
         EJ+luIfaEdhdbgNF1ADLW/m+Fh6qUZwPNI893VYnoqpHI62hXDZyz7XkaLM8Tn3XqyzJ
         Kpgg==
X-Gm-Message-State: APjAAAWTWcqOFZF57ATMi7YlaUa5x5VsxPRxKRtdhx2iwizDppdGi+tR
        GzFaxRxymkMt2c9PvgcQE52yeQ==
X-Google-Smtp-Source: APXvYqyju4IWS8FLefxzhj9cZQJy19+x5k/7Ch/NJ/seNpvRPCbEzhDfqehxxGoAPxuCKmXxcHNPiQ==
X-Received: by 2002:ac8:1a3c:: with SMTP id v57mr61836162qtj.339.1560228053758;
        Mon, 10 Jun 2019 21:40:53 -0700 (PDT)
Received: from jkicinski-Precision-T1700.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id y3sm2463375qtj.46.2019.06.10.21.40.52
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 10 Jun 2019 21:40:53 -0700 (PDT)
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        alexei.starovoitov@gmail.com, davejwatson@fb.com,
        borisp@mellanox.com, Jakub Kicinski <jakub.kicinski@netronome.com>,
        Dirk van der Merwe <dirk.vandermerwe@netronome.com>
Subject: [PATCH net-next 03/12] net/tls: rename handle_device_resync()
Date:   Mon, 10 Jun 2019 21:40:01 -0700
Message-Id: <20190611044010.29161-4-jakub.kicinski@netronome.com>
X-Mailer: git-send-email 2.21.0
In-Reply-To: <20190611044010.29161-1-jakub.kicinski@netronome.com>
References: <20190611044010.29161-1-jakub.kicinski@netronome.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

handle_device_resync() doesn't describe the function very well.
The function checks if resync should be issued upon parsing of
a new record.

Signed-off-by: Jakub Kicinski <jakub.kicinski@netronome.com>
Reviewed-by: Dirk van der Merwe <dirk.vandermerwe@netronome.com>
---
 include/net/tls.h    | 2 +-
 net/tls/tls_device.c | 2 +-
 net/tls/tls_sw.c     | 3 ++-
 3 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/include/net/tls.h b/include/net/tls.h
index 25641e2f5b96..1c512da5e4f4 100644
--- a/include/net/tls.h
+++ b/include/net/tls.h
@@ -608,6 +608,6 @@ int tls_sw_fallback_init(struct sock *sk,
 int tls_set_device_offload_rx(struct sock *sk, struct tls_context *ctx);
 
 void tls_device_offload_cleanup_rx(struct sock *sk);
-void handle_device_resync(struct sock *sk, u32 seq);
+void tls_device_rx_resync_new_rec(struct sock *sk, u32 seq);
 
 #endif /* _TLS_OFFLOAD_H */
diff --git a/net/tls/tls_device.c b/net/tls/tls_device.c
index 16635f0c829c..0ecfa0ee415d 100644
--- a/net/tls/tls_device.c
+++ b/net/tls/tls_device.c
@@ -563,7 +563,7 @@ static void tls_device_resync_rx(struct tls_context *tls_ctx,
 	clear_bit_unlock(TLS_RX_SYNC_RUNNING, &tls_ctx->flags);
 }
 
-void handle_device_resync(struct sock *sk, u32 seq)
+void tls_device_rx_resync_new_rec(struct sock *sk, u32 seq)
 {
 	struct tls_context *tls_ctx = tls_get_ctx(sk);
 	struct tls_offload_context_rx *rx_ctx;
diff --git a/net/tls/tls_sw.c b/net/tls/tls_sw.c
index c1d22290f1d0..bc3a1b188d4a 100644
--- a/net/tls/tls_sw.c
+++ b/net/tls/tls_sw.c
@@ -2015,7 +2015,8 @@ static int tls_read_size(struct strparser *strp, struct sk_buff *skb)
 		goto read_failure;
 	}
 #ifdef CONFIG_TLS_DEVICE
-	handle_device_resync(strp->sk, TCP_SKB_CB(skb)->seq + rxm->offset);
+	tls_device_rx_resync_new_rec(strp->sk,
+				     TCP_SKB_CB(skb)->seq + rxm->offset);
 #endif
 	return data_len + TLS_HEADER_SIZE;
 
-- 
2.21.0

