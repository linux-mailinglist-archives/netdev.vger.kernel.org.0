Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D593EE9C2
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:29:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239419AbhHQJ3f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:29:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43522 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239274AbhHQJ3c (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 Aug 2021 05:29:32 -0400
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E9B24C06179A;
        Tue, 17 Aug 2021 02:28:58 -0700 (PDT)
Received: by mail-wm1-x331.google.com with SMTP id 79-20020a1c0452000000b002e6cf79e572so1382782wme.1;
        Tue, 17 Aug 2021 02:28:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Q6qddnNCl+ddNnMLMws7fqahAlg13r+FeqAPD2rVFjc=;
        b=R+z0fT+Ks4IyPbWRF9h2Nt22Kx4NTx5HDmqpE5CrGwDEqdYWubTKp7dcKUA5UT6Gs0
         zKIi6kB2aGkD9+djQyAgUyT6dx98Yd0igrW7OLZ7dWOCoe5fPhlUhuWMwf9HjXSTJU9p
         ETuU1N4CkE6gPvphZLsOS9YyJWZwe/qzeRZOJN16FiHkF6Qj+T+oGLK44HSnCjJOe/tQ
         0V4Qg1is96RPTA3a31SoqWh17A8t9dnLQwKR0dtSWzKScOv/QbcSusY/Sictkk11lwQg
         B98XMSmedAl1Z61mbZsUKuFdcV8h3yr+zxtPb6SSD6HEinBWEVi0OjLrpoZfpEg24LTy
         cMdg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Q6qddnNCl+ddNnMLMws7fqahAlg13r+FeqAPD2rVFjc=;
        b=jMJy3aUVlf+9JyKnIqoqM/uXkGDc9PItJl5RV0l79UOwOZL81UY3ellOxlx0KikM6M
         XceO8iGUSQkkQ4cOKWZayNfdTCxPTmaaLD0DD+JeuClgMd9gPC3mJnbf3CTo8/vbngfa
         kZvSHm9bRebtMIO/PSs68mm7jyWwLuiKVyZvxkNdDVgS9yP62ofDYpOld4sD4uuFXPrn
         4f+PXYnD0skK8ipkqXIlaHrioZnw3j4bbQiswR88v99otjWYWnVJ24OyZdYvtAK2MTIs
         xWNBhnMqRC7VUWiF/SR9bt7zIV0iL8kM/Y0SpoMhr9MkOLdZwBVqXhaQlm5q3ERz06Es
         lsRA==
X-Gm-Message-State: AOAM530Ew3tRGAPe87lAvOq6jsg4gvecMX+Fm4YGAxeaC8l2vg3jkiNa
        rexFeCvQGawKHU1CjFOt78LKifGiMoH4ZSVp9w2DIg==
X-Google-Smtp-Source: ABdhPJyytfRQWN3JJKRYgfTUs0e8mspPojlxdPbihXJvsV0avUwsCrmtNTJT7DBmv/2mNfYagBYCXw==
X-Received: by 2002:a05:600c:a05:: with SMTP id z5mr2395433wmp.73.1629192537552;
        Tue, 17 Aug 2021 02:28:57 -0700 (PDT)
Received: from localhost.localdomain (h-46-59-47-246.A165.priv.bahnhof.se. [46.59.47.246])
        by smtp.gmail.com with ESMTPSA id l2sm1462421wme.28.2021.08.17.02.28.56
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 17 Aug 2021 02:28:57 -0700 (PDT)
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
To:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com
Cc:     jonathan.lemon@gmail.com, ciara.loftus@intel.com,
        bpf@vger.kernel.org, yhs@fb.com, andrii@kernel.org
Subject: [PATCH bpf-next v2 03/16] selftests: xsk: remove unused variables
Date:   Tue, 17 Aug 2021 11:27:16 +0200
Message-Id: <20210817092729.433-4-magnus.karlsson@gmail.com>
X-Mailer: git-send-email 2.29.0
In-Reply-To: <20210817092729.433-1-magnus.karlsson@gmail.com>
References: <20210817092729.433-1-magnus.karlsson@gmail.com>
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

