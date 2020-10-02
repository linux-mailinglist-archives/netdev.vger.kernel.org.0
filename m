Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF25B280FF4
	for <lists+netdev@lfdr.de>; Fri,  2 Oct 2020 11:34:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726386AbgJBJex (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 05:34:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726181AbgJBJew (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 05:34:52 -0400
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8F182C0613D0
        for <netdev@vger.kernel.org>; Fri,  2 Oct 2020 02:34:52 -0700 (PDT)
Received: by mail-wr1-x431.google.com with SMTP id x14so1009457wrl.12
        for <netdev@vger.kernel.org>; Fri, 02 Oct 2020 02:34:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HqpABpSTDJZ2ZB7kjlUf6JU5c996nXT0i3KUVjPbZRs=;
        b=W2ngTB5gTTRW61XvKSsAikHuflOU2R08Dlv5b7DDuLfxo7K4g7MiAwTkzPPbjLhTwV
         4wUdjlqkgC7t1skhrzbmdHqjvn8OSXw1tk5pwDzF9BXaF/RMr4ZF+NR+4Ug0SB99hWUe
         f/IzJ1GmHMZ6VS9+dIJ5L3eVOrDbwxhmiDy7/k8XrFyLFwRil8bK9rRg/rFkWQ0I6ac4
         HjFZWvE8z2NeV31jlf0qUpmnFuuBtV1V9p1IdJfQjMBBZuhutJo8jpu07Pp13C+X+Pfs
         IMzx1ViFgxycnSN4YCnsPtTufu9O/4iVpvSwqcQN0i+W+6nPL/wdddfEud3UMER3V7CW
         zR0g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=HqpABpSTDJZ2ZB7kjlUf6JU5c996nXT0i3KUVjPbZRs=;
        b=Ehr9cdr6/CvlEfVU1qbspUbbB6fdgXYxCJGf+/kjyhTUVlYF4kEz6I9iqPTFcGonuG
         J+AQ0cyQwZ/teRA8Bol4+IHQjrZRYS8KPVHg71P+Vr7eoEomhOtZ/X9nt1IMMtK+A2yD
         gdPG87NYQ4M4YFvILfQ27bVCDXK4JLiL3/1x1tFpuTRxfh2u9ByZG6CLgKGyjjc2Rc6w
         9PtEmMvjLoWeqTNiBYEMIx5h1EJAByOKVzUsEcVhaG/hti0TNlF1v42PRIXhkMp0UEJn
         xP6yWRB3XJqOs06k+ut9UHUNhYQa5ulwt6PflLvRPJBTBJzt9vQhqftwUt6VR0XxNLhd
         Dzcg==
X-Gm-Message-State: AOAM531izrIWpobN90MuaoE2MURsVrJQJO3Vzc21A3GQzYj5tTGmD+oD
        8x9RB37tggBH25sEgtJbihV1m6H0L5ahZA==
X-Google-Smtp-Source: ABdhPJwGHQyYOqeF1R3dRDeS/NMvvrGoasXfDIpRdjU61zb4DVkCcFA6wiK5pcQxNmUgqaO3Xvqn9Q==
X-Received: by 2002:a5d:68d1:: with SMTP id p17mr1903861wrw.378.1601631290790;
        Fri, 02 Oct 2020 02:34:50 -0700 (PDT)
Received: from jimi.localdomain ([213.57.166.51])
        by smtp.gmail.com with ESMTPSA id n21sm1111136wmi.21.2020.10.02.02.34.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 02 Oct 2020 02:34:49 -0700 (PDT)
From:   Eyal Birger <eyal.birger@gmail.com>
To:     netdev@vger.kernel.org, stephen@networkplumber.org
Cc:     Eyal Birger <eyal.birger@gmail.com>
Subject: [iproute2] ipntable: add missing ndts_table_fulls ntable stat
Date:   Fri,  2 Oct 2020 12:34:28 +0300
Message-Id: <20201002093428.2618907-1-eyal.birger@gmail.com>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Used for tracking neighbour table overflows.

Signed-off-by: Eyal Birger <eyal.birger@gmail.com>
---
 ip/ipntable.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/ip/ipntable.c b/ip/ipntable.c
index ddee4905..b5b06a3b 100644
--- a/ip/ipntable.c
+++ b/ip/ipntable.c
@@ -517,6 +517,11 @@ static void print_ndtstats(const struct ndt_stats *ndts)
 	print_u64(PRINT_ANY, "forced_gc_runs", "forced_gc_runs %llu ",
 		   ndts->ndts_forced_gc_runs);
 
+	print_string(PRINT_FP, NULL, "%s    ", _SL_);
+
+	print_u64(PRINT_ANY, "table_fulls", "table_fulls %llu ",
+		  ndts->ndts_table_fulls);
+
 	print_nl();
 }
 
-- 
2.25.1

