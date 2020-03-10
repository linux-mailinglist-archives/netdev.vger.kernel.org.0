Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4EF53180605
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 19:16:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726545AbgCJSP7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 14:15:59 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:44767 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726271AbgCJSP7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 14:15:59 -0400
Received: by mail-pg1-f193.google.com with SMTP id 37so2502213pgm.11
        for <netdev@vger.kernel.org>; Tue, 10 Mar 2020 11:15:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=KZvT3kH0mroKpXQcA8D8NsOKv4Th3ymAm6/qGmz6yIM=;
        b=S11Pnnfp1mkxIJSSiECPv5cotfvB8SKzsVkE/Fp/zr+wyaAm/D+9ldMwotQTvWi9A1
         4ERGppuc0v+CjM3M6/84BLWYIUyYeXp1pbOSEz1nE0M0GTFBDLxY8s86dux5QOITh5tw
         JhqDTNhD9zNWQylEfTLMKIk7LsTqTFaUyIE6XcSFGUHf0d6wI4FvZLOmFXK4Qau9XOs7
         3PBKTLzefH2gOAMEIyxIOFOyhX/6x4F4FPEa3PE31JLqzfEdmBHlpfhahN68IivQxhY0
         4B5xbJQCpu42LhnEnwF0JN48aGn5fgTtn36pKH829/Y6zURVYxfylbIaj74cOFGCTUCd
         suMQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=KZvT3kH0mroKpXQcA8D8NsOKv4Th3ymAm6/qGmz6yIM=;
        b=t96MZTgOgkqrFYyZ5h1IzIueqFhM73UUAcwT0h7loLZkmW8BOWtwIVc81LQEotFPCl
         NSphFiKdHbflwqfhCCtfx9MPPtNBIxVWY5yfwPPrzXrZeoaCGb95qLmBmwYv3r1F478/
         6zjFXgKWR24MTh13FLyZRPX3wEx+wMA6n7iiMjg80Z6pnYYKIhLUCx2CAOVE5c/74boi
         qAVRsaRjubsrqMw9XBSJhwfDOyCcVrPt6D7tdMTlfrhBreUIbrB4CPil262oAFyHhbV8
         2SKCdXk4aAoL2Zp0icUFWsL7jRof9GPOUmtBIsmoPMPr4kL0iZb//9c451PtD2belVGG
         v2nA==
X-Gm-Message-State: ANhLgQ1tVeb6CHGqAgMlGPfsmOM8DKf9Gqk7zaZjw3CHJSvZBDKrOjAW
        LOhAZl/UMRf2kSZW8wdwHon18CBOl7U=
X-Google-Smtp-Source: ADFU+vueAEWvfu8WjBup5GpuNFwAN1BNk/UQjf5xalCbUD4ClMx8PONqWA3LL1IvECcpSvUKiI7sOQ==
X-Received: by 2002:aa7:8f38:: with SMTP id y24mr3891491pfr.226.1583864157503;
        Tue, 10 Mar 2020 11:15:57 -0700 (PDT)
Received: from localhost.localdomain ([103.89.232.186])
        by smtp.gmail.com with ESMTPSA id z63sm47539445pgd.12.2020.03.10.11.15.54
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 10 Mar 2020 11:15:56 -0700 (PDT)
From:   Leslie Monis <lesliemonis@gmail.com>
To:     Linux NetDev <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        Gautam Ramakrishnan <gautamramk@gmail.com>,
        Eric Dumazet <edumazet@google.com>
Subject: [PATCH iproute2-next] Revert "tc: pie: change maximum integer value of tc_pie_xstats->prob"
Date:   Tue, 10 Mar 2020 23:45:49 +0530
Message-Id: <20200310181549.2689-1-lesliemonis@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This reverts commit 92cfe3260e9110c3d33627847b6eaa153664c79c.

Kernel commit 3f95f55eb55d ("net: sched: pie: change tc_pie_xstats->prob")
removes the need to change the maximum integer value of
tc_pie_stats->prob here.

Suggested-by: Eric Dumazet <edumazet@google.com>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
---
 tc/q_pie.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tc/q_pie.c b/tc/q_pie.c
index e6939652..709a78b4 100644
--- a/tc/q_pie.c
+++ b/tc/q_pie.c
@@ -223,9 +223,9 @@ static int pie_print_xstats(struct qdisc_util *qu, FILE *f,
 
 	st = RTA_DATA(xstats);
 
-	/* prob is returned as a fracion of (2^56 - 1) */
+	/* prob is returned as a fracion of maximum integer value */
 	print_float(PRINT_ANY, "prob", "  prob %lg",
-		    (double)st->prob / (double)(UINT64_MAX >> 8));
+		    (double)st->prob / (double)UINT64_MAX);
 	print_uint(PRINT_JSON, "delay", NULL, st->delay);
 	print_string(PRINT_FP, NULL, " delay %s", sprint_time(st->delay, b1));
 
-- 
2.17.1

