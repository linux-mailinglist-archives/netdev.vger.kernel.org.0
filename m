Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0EF7F3007D3
	for <lists+netdev@lfdr.de>; Fri, 22 Jan 2021 16:54:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbhAVPvz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 10:51:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40834 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729206AbhAVPsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jan 2021 10:48:16 -0500
Received: from mail-lj1-x229.google.com (mail-lj1-x229.google.com [IPv6:2a00:1450:4864:20::229])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9508FC0617A7;
        Fri, 22 Jan 2021 07:47:35 -0800 (PST)
Received: by mail-lj1-x229.google.com with SMTP id 3so7045051ljc.4;
        Fri, 22 Jan 2021 07:47:35 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=p4oRU7lCPi/l9kAI4UjeoerSjmPOgdl0S170D2ESND4=;
        b=H6WMac2OnGBQZlpqEinwMRCUlp3iXb5Uid/6kyKPzKkijyjMFnTfJ39HSNTcPq+YP/
         iLc8WPjzoy1pvIOnql0AurCwmZXBaIyjVkzyaPvXTOeFP6rvNJSxQgdYxdqvV08RZjkT
         cd7mf2P0SFrMANsybpg3LkPPP4+7SOOeP/Y4NZ3/Clo2jN1NpbCT1cyvvaSayHZJbWWy
         JUzu9WcPQ2E/odrLXvBk+eqrGHoNgEiMzTa6Pqk5HQdvEKVWWGQZcbdK9B9Z1UyVE6NS
         IQpFgp86fSPQBZHObN+VraMTiAo/t+xoa+rYW1I+1kyWdwybAqt989dYFW1dQbmobyYB
         drcQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=p4oRU7lCPi/l9kAI4UjeoerSjmPOgdl0S170D2ESND4=;
        b=nXn3P9oNa3PZVnSu16svVxD3CUg0oZUXeuTyUlzb5gwD2qUI89ivpeOsNI/01ed1BG
         jlLL/UuyXrqI+CnBawuh+Cd7HUWB2XMg7f0g8gj4YyW3AINfqA2gBRPipI+VzKa5f0VO
         ei9pb0IuRoEy4SQdZW3enaQQllYSaE3hjBUWpC3ZVVxEuLrLBUdXdPCXh2VFy6fQtpHc
         j9uih4QrhY/FxGxC5uAMk6KFQlLjy8n8j6jzDgpELebY5pU+H/AHmSPBqffQmsv/WnG4
         Q1J1U84BWXJurcrIrBKEdIqZU7HpBMPsKnIGZkETabra+8Jg0+MrnQCNIFKIop7jcjw5
         hF8A==
X-Gm-Message-State: AOAM533KLOE7i3toP02eNN9UNl+xtzzWF2HhxpWWxfvvSnljBIIwDHAN
        z77z0ygtDaSgalPSKn7WpFhogH9udTE4+A==
X-Google-Smtp-Source: ABdhPJysOtensk2J2AU1GMupgiqXOg8sluKPx/PsDKc0PvNhodjdFNiJQV8WdBjeHUU7ytM3fd0Kfw==
X-Received: by 2002:a2e:9b47:: with SMTP id o7mr1693806ljj.99.1611330454159;
        Fri, 22 Jan 2021 07:47:34 -0800 (PST)
Received: from btopel-mobl.ger.intel.com (c213-102-90-208.bredband.comhem.se. [213.102.90.208])
        by smtp.gmail.com with ESMTPSA id w17sm928589lft.52.2021.01.22.07.47.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Jan 2021 07:47:33 -0800 (PST)
From:   =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@gmail.com>
To:     ast@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Cc:     =?UTF-8?q?Bj=C3=B6rn=20T=C3=B6pel?= <bjorn.topel@intel.com>,
        magnus.karlsson@intel.com, jonathan.lemon@gmail.com,
        ciara.loftus@intel.com, weqaar.a.janjua@intel.com
Subject: [PATCH bpf-next 03/12] selftests/bpf: fix style warnings
Date:   Fri, 22 Jan 2021 16:47:16 +0100
Message-Id: <20210122154725.22140-4-bjorn.topel@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210122154725.22140-1-bjorn.topel@gmail.com>
References: <20210122154725.22140-1-bjorn.topel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Björn Töpel <bjorn.topel@intel.com>

Silence three checkpatch style warnings.

Signed-off-by: Björn Töpel <bjorn.topel@intel.com>
---
 tools/testing/selftests/bpf/xdpxceiver.c | 14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

diff --git a/tools/testing/selftests/bpf/xdpxceiver.c b/tools/testing/selftests/bpf/xdpxceiver.c
index cd1dd2b7458f..77d1bda37afa 100644
--- a/tools/testing/selftests/bpf/xdpxceiver.c
+++ b/tools/testing/selftests/bpf/xdpxceiver.c
@@ -734,10 +734,10 @@ static void worker_pkt_validate(void)
 			break;
 		/*do not increment pktcounter if !(tos=0x9 and ipv4) */
 		if ((((struct iphdr *)(pkt_node_rx_q->pkt_frame +
-				       sizeof(struct ethhdr)))->version == IP_PKT_VER)
-		    && (((struct iphdr *)(pkt_node_rx_q->pkt_frame + sizeof(struct ethhdr)))->tos ==
+				       sizeof(struct ethhdr)))->version == IP_PKT_VER) &&
+		    (((struct iphdr *)(pkt_node_rx_q->pkt_frame + sizeof(struct ethhdr)))->tos ==
 			IP_PKT_TOS)) {
-			payloadseqnum = *((uint32_t *) (pkt_node_rx_q->pkt_frame + PKT_HDR_SIZE));
+			payloadseqnum = *((uint32_t *)(pkt_node_rx_q->pkt_frame + PKT_HDR_SIZE));
 			if (debug_pkt_dump && payloadseqnum != EOT) {
 				pkt_obj = (struct pkt_frame *)malloc(sizeof(struct pkt_frame));
 				pkt_obj->payload = (char *)malloc(PKT_SIZE);
@@ -767,10 +767,10 @@ static void worker_pkt_validate(void)
 		} else {
 			ksft_print_msg("Invalid frame received: ");
 			ksft_print_msg("[IP_PKT_VER: %02X], [IP_PKT_TOS: %02X]\n",
-				((struct iphdr *)(pkt_node_rx_q->pkt_frame +
-				       sizeof(struct ethhdr)))->version,
-				((struct iphdr *)(pkt_node_rx_q->pkt_frame +
-				       sizeof(struct ethhdr)))->tos);
+				       ((struct iphdr *)(pkt_node_rx_q->pkt_frame +
+							 sizeof(struct ethhdr)))->version,
+				       ((struct iphdr *)(pkt_node_rx_q->pkt_frame +
+							 sizeof(struct ethhdr)))->tos);
 			TAILQ_REMOVE(&head, pkt_node_rx_q, pkt_nodes);
 			free(pkt_node_rx_q->pkt_frame);
 			free(pkt_node_rx_q);
-- 
2.27.0

