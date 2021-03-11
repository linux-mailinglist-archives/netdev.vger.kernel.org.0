Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2F29336BCD
	for <lists+netdev@lfdr.de>; Thu, 11 Mar 2021 06:59:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229776AbhCKF7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Mar 2021 00:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229684AbhCKF6h (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Mar 2021 00:58:37 -0500
Received: from mail-qk1-x72d.google.com (mail-qk1-x72d.google.com [IPv6:2607:f8b0:4864:20::72d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED06BC061574;
        Wed, 10 Mar 2021 21:58:36 -0800 (PST)
Received: by mail-qk1-x72d.google.com with SMTP id l132so19549822qke.7;
        Wed, 10 Mar 2021 21:58:36 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W7+ryEOPr4htGHfpEZu6tu2vifH0/XuOxm+pB4VdUpQ=;
        b=NkcNmK795IB4N2XSLz+eVmHLJW9SjsFF2XmZFRzttwyu0H+yR4U2rpBuRJhpnQD3KM
         wYQvN4LAh/tVpyW3pDEKjnRQPdlmAhG2kza425NbfaYRpYRtYXOVD2MX7vFtdPwOMfjp
         NxHDsz+V2b6V2lDNHLeygIEr51yXrwyio+4WLEkf8NvDBIO3Y58L7AYrBQQ+1CjYUE8W
         hPJahm+aEURCYk9vuPmX86WIZ4nWodGOp5ogk0Q9E/+Ef4/zY5fLLEN/ndcmEzHQalpT
         u4oMeBsUv18fJQdqJe/xyYcFCGyrPtC2M7DK/yeXvmKmRK1Lx/4CVefph0YsWntPss/9
         LyFg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=W7+ryEOPr4htGHfpEZu6tu2vifH0/XuOxm+pB4VdUpQ=;
        b=KhN2I9VlJMfxecj25HDSmXH2MkjjK63xo9ZaJDHocWzbrMc2hhyGoK7zffDRr9zLKk
         ivXA2gG5BU21JIvDLuLTht6jSOLNX7MNhOXmWQNiila5uq0coEtdNXYY/1MQSS335HQe
         aFav7CvNCRCkIgMUVwqXs6plx8s9+LCgQHZX/xcHtZcZlDDJzWs2oy99vSHhDqMc2EYP
         0ZEjqcXKlDJjGoSzwdTaoHg1Wbu6Ji2RaqC4r22IOs+8Nx+YTGRRppSvT8/x+LEeqVZP
         1wzgyhtL8LSIYTrU6cuNgAYLbfQcfTYxxDvDa6eGwpFK7QfWTq2SB4SVA/T8bJ/SWLoB
         QkTw==
X-Gm-Message-State: AOAM532lGFpwuL7qUK5ycN3XbtvouRfIKyXzvyruJDId9XY39Vb2hVWQ
        urekMlHPmG4D1UbTRwd42lE=
X-Google-Smtp-Source: ABdhPJzer/BndQBOUTW/8WKB36XFlkEgazUxDK21lU6rPHCyR0d/6EaPzhEDBUg8+noSYTmzXVnx5A==
X-Received: by 2002:a05:620a:144a:: with SMTP id i10mr6097746qkl.431.1615442316011;
        Wed, 10 Mar 2021 21:58:36 -0800 (PST)
Received: from localhost.localdomain ([156.146.55.115])
        by smtp.gmail.com with ESMTPSA id f8sm1111492qth.6.2021.03.10.21.58.29
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 10 Mar 2021 21:58:35 -0800 (PST)
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org, davem@davemloft.net,
        kuba@kernel.org, hawk@kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     rdunlap@infradead.org, Bhaskar Chowdhury <unixbhaskar@gmail.com>
Subject: [PATCH] net: core: Few absolutely rudimentary typo fixes throughout the file filter.c
Date:   Thu, 11 Mar 2021 11:26:08 +0530
Message-Id: <20210311055608.12956-1-unixbhaskar@gmail.com>
X-Mailer: git-send-email 2.26.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Trivial spelling fixes throughout the file.

Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
---
 net/core/filter.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/net/core/filter.c b/net/core/filter.c
index 255aeee72402..931ee5f39ae7 100644
--- a/net/core/filter.c
+++ b/net/core/filter.c
@@ -2927,7 +2927,7 @@ BPF_CALL_4(bpf_msg_pop_data, struct sk_msg *, msg, u32, start,
 	 *
 	 * Then if B is non-zero AND there is no space allocate space and
 	 * compact A, B regions into page. If there is space shift ring to
-	 * the rigth free'ing the next element in ring to place B, leaving
+	 * the right freeing the next element in ring to place B, leaving
 	 * A untouched except to reduce length.
 	 */
 	if (start != offset) {
@@ -3710,7 +3710,7 @@ static inline int __bpf_skb_change_tail(struct sk_buff *skb, u32 new_len,
 	 * be the one responsible for writing buffers.
 	 *
 	 * It's really expected to be a slow path operation here for
-	 * control message replies, so we're implicitly linearizing,
+	 * control message replies, so we're implicitly linearising,
 	 * uncloning and drop offloads from the skb by this.
 	 */
 	ret = __bpf_try_make_writable(skb, skb->len);
@@ -3778,7 +3778,7 @@ static inline int __bpf_skb_change_head(struct sk_buff *skb, u32 head_room,
 		 * allow to expand on mac header. This means that
 		 * skb->protocol network header, etc, stay as is.
 		 * Compared to bpf_skb_change_tail(), we're more
-		 * flexible due to not needing to linearize or
+		 * flexible due to not needing to linearise or
 		 * reset GSO. Intention for this helper is to be
 		 * used by an L3 skb that needs to push mac header
 		 * for redirection into L2 device.
--
2.26.2

