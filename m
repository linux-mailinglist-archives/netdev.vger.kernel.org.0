Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F0B3D75B8
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 15:18:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236638AbhG0NSU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 09:18:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236602AbhG0NSN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 09:18:13 -0400
Received: from mail-wr1-x42f.google.com (mail-wr1-x42f.google.com [IPv6:2a00:1450:4864:20::42f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 981D9C061760;
        Tue, 27 Jul 2021 06:18:13 -0700 (PDT)
Received: by mail-wr1-x42f.google.com with SMTP id e2so15193900wrq.6;
        Tue, 27 Jul 2021 06:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q6qddnNCl+ddNnMLMws7fqahAlg13r+FeqAPD2rVFjc=;
        b=aJqpmSLWRfHLkKwRYoek6R/vHvCoLzHN4XXBESd+RKWMSTzkjXZd/q9aFtb6jtRDCb
         1mtNaVROsFAPpufGEr2dsET42CsMzFgBd4sFg78go7wsry07frFNOvvit6UAJLvk7WtD
         RkzXmBi3EncxEszN7n63oIhKNHxSHXrL5/0riIU43jpUWOHY+/KX4Jj+beWbvh2FJVwE
         2tDNQWMqC7gwi8ygR2gpR7Xu9C0iMUWqSP5AalePVGhllGgKIALmNnj7fb2R0gZ6N00+
         T3xZrc/wGDJ0G2nXIzIDLJ/9HhRcpvZL+mMMBrf1QhY734M1QhjeKA0Pc3Qv0IexkERv
         0Yyg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q6qddnNCl+ddNnMLMws7fqahAlg13r+FeqAPD2rVFjc=;
        b=Lw8HIusWzvQYBBtpgML62D5J4eBN689MiV8NRPhA7C4L7IA2w4WiT33Z392i6eU0Rf
         62OQhrWvqFupYymkosE/agnLvwPLtK66/LXVB/CK9uE4E3D+KE56fkbNBppxt4hmnpa4
         E7H9ZXoTQy4Cvx9yknDzbx6cg6wl1ZXUiymlt1KrVUxQZ4U9W9bF2KrXYtd/AgVD/Q+8
         0qHTQ8rnXzzjrX4az7/RC18TOw8i+chmrC+oGi7c3nNvPAqAsUXMalxRlvI/f9Jx+dF1
         OncuPcTdpmneAaWjpfq4PQy+fCSTllG3KJ3J60MIdylxgbisMz526+Yh7VAvk0Ks7AaR
         VMHA==
X-Gm-Message-State: AOAM531qJA/r2MfDHyox84S39rCV8wiFgjo9WGiO8oS4jRvtQX4FkqD1
        rcMa+L1Qa5UN+l7tZruUoy4=
X-Google-Smtp-Source: ABdhPJyVHvvfNjftmENTBOs7xY3P2y0cE2sy0I1fxTuDd/VgqqYCAmA2mZylIQTYIIJ8znvSKej2cA==
X-Received: by 2002:adf:eacb:: with SMTP id o11mr25759431wrn.62.1627391892272;
        Tue, 27 Jul 2021 06:18:12 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id u11sm3277553wrr.44.2021.07.27.06.18.10
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 27 Jul 2021 06:18:11 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        joamaki@gmail.com, bpf@vger.kernel.org, yhs@fb.com,
        andrii@kernel.org
Subject: [PATCH bpf-next 03/17] selftests: xsk: remove unused variables
Date:   Tue, 27 Jul 2021 15:17:39 +0200
Message-Id: <20210727131753.10924-4-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210727131753.10924-1-magnus.karlsson@gmail.com>
References: <20210727131753.10924-1-magnus.karlsson@gmail.com>
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

