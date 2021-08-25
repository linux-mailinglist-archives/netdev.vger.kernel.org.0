Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 449553F71DE
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 11:38:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233076AbhHYJiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 05:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239735AbhHYJio (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Aug 2021 05:38:44 -0400
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4BE53C06179A;
        Wed, 25 Aug 2021 02:37:57 -0700 (PDT)
Received: by mail-wr1-x42d.google.com with SMTP id v10so24196567wrd.4;
        Wed, 25 Aug 2021 02:37:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q6qddnNCl+ddNnMLMws7fqahAlg13r+FeqAPD2rVFjc=;
        b=vchVMbl8Wp0tBl7cQY3VM7H/TPLTsI6oRVZWkoUkIM5uCIbDZXRe13Zit9Yymjgaaa
         Xwe2WzvzquMzoOWWX1++3X0yzcklXBJnZuBVwVJ77sA+tf2ALze58iLduqhyd5ec6uZu
         q6R2wMHLWGfUz3krqnKMsqMxuqTWTN5F0WE+FsWF0JVTKUCGz9c+xZTNGGxmHAxDz41R
         0ZChUARavAy0uyV5rShk8eH6k+Y5hCoS2SVc1AGUQTlt/SKmH8BpnxaK6w+YcexR3S2N
         R0cDOAQEycNA6846xF6sigxcJglkZ6tW2/Njpp1a89fRF5RiazoXZXaq1zjvq3cg24aY
         LT5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q6qddnNCl+ddNnMLMws7fqahAlg13r+FeqAPD2rVFjc=;
        b=J6qrp5z5O2UVsQaZ7jPhkvgtXV3UTKlABHXyQpMaXwTTJJqPsRqyWSYNILa63/E8Rt
         8ze6+ZMGPRAjmN9ZXwXrQDqbPSfIlhOGHy0hhcwKW+otSUiJKWlGeiiaahhq+pxLb357
         ioeVZ1ZZlavX6pDWtZYTF3hsfecWUdCDyxCQ5b1alkL+IITaUu1Y9IY7RK9N8vP1YKHE
         ZiX66/gK0JHPKqM/U2AtaQQ3CF0/V3xKNAMte9xqhZI0B8r42AIiGVlw32utpkFWsXnV
         zHYI5tXnENxnresYdKvRyzmQQGFd7Zd0figoRYUWBAuuap0xTDJ0mrpL9iUL4ImJqnZl
         9APA==
X-Gm-Message-State: AOAM5336ZLPWNoA2UBU1piYN0TNhcsQdw+fG8V2w/kq8EIxfHp2zr/K9
        HukIbDjaUnD90k3kOrM9xws=
X-Google-Smtp-Source: ABdhPJzZ56YEXzGbkAOqbUwVfCoAEMu6/yWc9LKrW4u8oRSUbq7RJ5uRTRsMUXZdFnjZPhd9XEjzWA==
X-Received: by 2002:a05:6000:18a:: with SMTP id p10mr20116694wrx.40.1629884275899;
        Wed, 25 Aug 2021 02:37:55 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id k18sm4767910wmi.25.2021.08.25.02.37.54
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 25 Aug 2021 02:37:55 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v3 03/16] selftests: xsk: remove unused variables
Date:   Wed, 25 Aug 2021 11:37:09 +0200
Message-Id: <20210825093722.10219-4-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210825093722.10219-1-magnus.karlsson@gmail.com>
References: <20210825093722.10219-1-magnus.karlsson@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Magnus Karlsson <magnus.karlsson@intel.com>

Remove unused variables and typedefs. The *_npkts variables are
incremented but never used.

Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 3 ---
 tools/testing/selftests/bpf/xdpxceiver.h | 8 --------
 2 files changed, 11 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index 1b0efe566278..4d8ee636fc24 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -70,7 +70,6 @@
 #include <errno.h>
 #include <getopt.h>
 #include <asm/barrier.h>
-typedef __u16 __sum16;
 #include <linux/if_link.h>
 #include <linux/if_ether.h>
 #include <linux/ip.h>
@@ -454,7 +453,6 @@ static void complete_tx_only(struct xsk_socket_info *xsk, int batch_size)
 	if (rcvd) {
 		xsk_ring_cons__release(&xsk->umem->cq, rcvd);
 		xsk->outstanding_tx -= rcvd;
-		xsk->tx_npkts += rcvd;
 	}
 }
 
@@ -512,7 +510,6 @@ static void rx_pkt(struct xsk_socket_info *xsk, struct pollfd *fds)
 
 	xsk_ring_prod__submit(&xsk->umem->fq, rcvd);
 	xsk_ring_cons__release(&xsk->rx, rcvd);
-	xsk->rx_npkts += rcvd;
 }
 
 static void tx_only(struct xsk_socket_info *xsk, u32 *frameptr, int batch_size)
diff --git a/tools/testing/selftests/bpf/xdpxceiver.h b/tools/testing/selftests/bpf/xdpxceiver.h
index 4ce5a18b32e7..02b7d0d6f45d 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.h
+++ b/tools/testing/selftests/bpf/xdpxceiver.h
@@ -44,10 +44,6 @@
 
 #define print_verbose(x...) do { if (opt_verbose) ksft_print_msg(x); } while (0)
 
-typedef __u32 u32;
-typedef __u16 u16;
-typedef __u8 u8;
-
 enum TEST_MODES {
 	TEST_MODE_UNCONFIGURED = -1,
 	TEST_MODE_SKB,
@@ -104,10 +100,6 @@ struct xsk_socket_info {
 	struct xsk_ring_prod tx;
 	struct xsk_umem_info *umem;
 	struct xsk_socket *xsk;
-	unsigned long rx_npkts;
-	unsigned long tx_npkts;
-	unsigned long prev_rx_npkts;
-	unsigned long prev_tx_npkts;
 	u32 outstanding_tx;
 };
 
-- 
2.29.0

