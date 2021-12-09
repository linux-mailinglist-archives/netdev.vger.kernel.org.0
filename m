Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A7B146E087
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 02:55:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229379AbhLIB6t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 20:58:49 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58480 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhLIB6s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 20:58:48 -0500
Received: from mail-pl1-x635.google.com (mail-pl1-x635.google.com [IPv6:2607:f8b0:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 400F8C0617A1;
        Wed,  8 Dec 2021 17:55:14 -0800 (PST)
Received: by mail-pl1-x635.google.com with SMTP id u17so2777766plg.9;
        Wed, 08 Dec 2021 17:55:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YEXD1s+NFhBSKjutCA1VJqcOl+uAy1tfOQHHqha6RjM=;
        b=YdkmMDfj7LPDAi0hTeZnxs0ThF5IgGjrkKMeJwG2DUO0m+RBFvFCEWw9BVr6nwSKfp
         t7bu7XLM8EH1AN0q4gtNp+NgoE5cP/A0NVgTd1GDREtR9MCbjJewnLS2aXF+BxqAmtvC
         THg7FRyMzKnYRSCAjE2pf5iGFuUSD9H6nG1VPqMo5PxJ9lk7teIYCCjtNlboVYeeFp9l
         3Ihk2i+RNZZH6sALo1V6HBjr5byqQpB0xz+UpHtBocGSlDkp/uHzSsexWuKY4p1P2bLW
         ochrgd2yyeCNgw+9W7p+volXFcSZudNsNkJyZtsc/UlWZo0P4jSb7vFMWXENoeWDxX/s
         PKng==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=YEXD1s+NFhBSKjutCA1VJqcOl+uAy1tfOQHHqha6RjM=;
        b=Pvg18e78mkERqd7toL1sRx2BY7tiOBd74Ps1ylNxrj0WgM1sGjhjlKYITpEaX/tlz3
         9x3vWiKaun+qE9H3rP2Gps2BkGhUnBxp1HVKXEckVSKJm+InSr6UoZijbzDix1Lnze1Y
         fLL67JLzzTuz5VKkI1m2KjmqN5ikIIlRzieODfoRAMRmAKV/GBlKlv4OXHufi6rKIQla
         jNRaj96b4GhhLb5OAmeVaEaDWIzrgXlRaDkWX7cLT1p34L1azao5TYbl0sbs4J46jpPU
         xpzGSGbleFr/nDrVsnGc3fWR2S5RqOtFK7wdk8iIYSxPxntb21k/VmCZCdt5tCQ0Ugfa
         rQBw==
X-Gm-Message-State: AOAM533ykCmayZlpit1FiGguVtxob8GtMk71ni/X90hcNZTzwI9P1uti
        DL1U3jJdEzJIscLgh+tPsNw=
X-Google-Smtp-Source: ABdhPJz8L76/yvBRMCYjs5IFPo3cj1HP/cd4HoZRcMxcTrEo3nxoUApgKTwjyZtYg2vL+5Q0iI+qmw==
X-Received: by 2002:a17:90b:2412:: with SMTP id nr18mr12297648pjb.233.1639014913760;
        Wed, 08 Dec 2021 17:55:13 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id me7sm8799786pjb.9.2021.12.08.17.55.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 08 Dec 2021 17:55:12 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     ast@kernel.org
Cc:     daniel@iogearbox.net, davem@davemloft.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, chiminghao <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cm>
Subject: [PATCH] samples:bpf:remove unneeded variable
Date:   Thu,  9 Dec 2021 01:55:05 +0000
Message-Id: <20211209015505.409691-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: chiminghao <chi.minghao@zte.com.cn>

return value form directly instead of
taking this in another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cm>
Signed-off-by: chiminghao <chi.minghao@zte.com.cn>
---
 samples/bpf/xdp_redirect_cpu.bpf.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

diff --git a/samples/bpf/xdp_redirect_cpu.bpf.c b/samples/bpf/xdp_redirect_cpu.bpf.c
index f10fe3cf25f6..25e3a405375f 100644
--- a/samples/bpf/xdp_redirect_cpu.bpf.c
+++ b/samples/bpf/xdp_redirect_cpu.bpf.c
@@ -100,7 +100,6 @@ u16 get_dest_port_ipv4_udp(struct xdp_md *ctx, u64 nh_off)
 	void *data     = (void *)(long)ctx->data;
 	struct iphdr *iph = data + nh_off;
 	struct udphdr *udph;
-	u16 dport;
 
 	if (iph + 1 > data_end)
 		return 0;
@@ -111,8 +110,7 @@ u16 get_dest_port_ipv4_udp(struct xdp_md *ctx, u64 nh_off)
 	if (udph + 1 > data_end)
 		return 0;
 
-	dport = bpf_ntohs(udph->dest);
-	return dport;
+	return bpf_ntohs(udph->dest);
 }
 
 static __always_inline
-- 
2.25.1

