Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31D722E504
	for <lists+netdev@lfdr.de>; Mon, 27 Jul 2020 06:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgG0Eqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jul 2020 00:46:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60676 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725775AbgG0Eqm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jul 2020 00:46:42 -0400
Received: from mail-pl1-x644.google.com (mail-pl1-x644.google.com [IPv6:2607:f8b0:4864:20::644])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B5AE8C0619D2
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 21:46:42 -0700 (PDT)
Received: by mail-pl1-x644.google.com with SMTP id b9so7349726plx.6
        for <netdev@vger.kernel.org>; Sun, 26 Jul 2020 21:46:42 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dmhtNJG3l+OzgLxPrOkNTCrDEUaxQ7P2EQjmZ+IaKCE=;
        b=qmntBx5UFi1Es05D0hZRe/l65oUUcj0hPHlNYBALpviyoNARPQrbITvHdVQTDqb7uJ
         CDn7adT+z8yI3rA/rqQhFUzGgXcbHmCqTo9uClTr92o9y7e0ZwEmp7cBcS4ko85w9ftv
         9jpXEaJ5hnI+URxplT87z0anVmNhmosWK+FLe6hVKLu5miK9iE0Y1mvJCzEdSRCpY5me
         PICKDJWkSmgC73qbATvfufAAP9d9PcTiYVBKth8ysAuqvditZhTpMFyxt8Ce6zqPnQua
         uwnjaQF/oCdsydDtkpAkTuRCNnWaLfuWQdEZFs27YrEmW7jDH4pNvNtLikj/rvdcp/fw
         k3yg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=dmhtNJG3l+OzgLxPrOkNTCrDEUaxQ7P2EQjmZ+IaKCE=;
        b=k2uRF3yth6+6cEC7sXHxA3VgGcBu4cqIzrGSVgXVobLKCTgF4dV1ECWv0RGjWKYNrf
         Xq5uKWVYtAFrQxRVAu1gqf0JZ1H1rRjGa0D8jksABYe/SveQ+xKLcYJyn6TbriH7XSMq
         stnNuMSEemAWtSXM+aVyHuHMI5ZOSDiy3lVEwA2tRnHM+6tKOtd1sH68hhllA8ipPvQn
         a/VzEyEJZWr+ogmXQwp749cC3d80E9J6zm/tnfZGGgLhtg6q23GSIjQY4aEn3SA5UOVW
         foc1wyZM1G3z8UCBegnHgVIEQrIAPH0snwBhQJ2FdJwK+oEwJN4BkBi/FRkS+Nh4LSSo
         lg6Q==
X-Gm-Message-State: AOAM533o1L/BhmYpYL0W0t070ltFkvQdHntDri1LAiUgMav1Bu6+drkg
        KxtiJn5FRWjHZ4/iCXjpEo27e9+A4yo=
X-Google-Smtp-Source: ABdhPJySLjldwhgvDOaDpJosQLt3PaumCtz5vo7/EBX0LZFCqWPXqnkXLvFYdMnHP/+WEsiy15pifQ==
X-Received: by 2002:a17:902:be06:: with SMTP id r6mr16384955pls.143.1595825201832;
        Sun, 26 Jul 2020 21:46:41 -0700 (PDT)
Received: from oort.localdomain (035-132-134-040.res.spectrum.com. [35.132.134.40])
        by smtp.gmail.com with ESMTPSA id c188sm13464857pfc.143.2020.07.26.21.46.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 26 Jul 2020 21:46:41 -0700 (PDT)
From:   Briana Oursler <briana.oursler@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Petr Machata <petrm@mellanox.com>,
        Davide Caratti <dcaratti@redhat.com>,
        Stefano Brivio <sbrivio@redhat.com>,
        Jiri Pirko <jiri@mellanox.com>,
        Briana Oursler <briana.oursler@gmail.com>
Subject: Question Print Formatting iproute2
Date:   Sun, 26 Jul 2020 21:46:16 -0700
Message-Id: <20200727044616.735-1-briana.oursler@gmail.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I have a patch I've written to address a format specifier change that
breaks some tests in tc-testing, but I wanted to ask about the change
and for some guidance with respect to how formatters are approached in
iproute2. 

On a recent run of tdc tests I ran ./tdc.py -c qdisc and found:

1..91
not ok 1 8b6e - Create RED with no flags
        Could not match regex pattern. Verify command output:
qdisc red 1: root refcnt 2 limit 1Mb min 100Kb max 300Kb

not ok 2 342e - Create RED with adaptive flag
        Could not match regex pattern. Verify command output:
qdisc red 1: root refcnt 2 limit 1Mb min 100Kb max 300Kbadaptive

not ok 3 2d4b - Create RED with ECN flag
        Could not match regex pattern. Verify command output:
qdisc red 1: root refcnt 2 limit 1Mb min 100Kb max 300Kbecn

not ok 4 650f - Create RED with flags ECN, adaptive
        Could not match regex pattern. Verify command output:
qdisc red 1: root refcnt 2 limit 1Mb min 100Kb max 300Kbecn adaptive

not ok 5 5f15 - Create RED with flags ECN, harddrop
        Could not match regex pattern. Verify command output:
qdisc red 1: root refcnt 2 limit 1Mb min 100Kb max 300Kbecn harddrop

not ok 6 53e8 - Create RED with flags ECN, nodrop
        Could not match regex pattern. Verify command output:
qdisc red 1: root refcnt 2 limit 1Mb min 100Kb max 300Kbecn nodrop

ok 7 d091 - Fail to create RED with only nodrop flag
not ok 8 af8e - Create RED with flags ECN, nodrop, harddrop
        Could not match regex pattern. Verify command output:
qdisc red 1: root refcnt 2 limit 1Mb min 100Kb max 300Kbecn harddrop
nodrop

I git bisected and found d0e450438571("tc: q_red: Add support for
qevents "mark" and "early_drop"), the commit that introduced the
formatting change causing the break. 

-       print_string(PRINT_FP, NULL, "max %s ", sprint_size(qopt->qth_max, b3));
+       print_string(PRINT_FP, NULL, "max %s", sprint_size(qopt->qth_max, b3));

I made a patch that adds a space after the format specifier in the
iproute2 tc/q_red.c and tested it using: tdc.py -c qdisc. After the
change, all the broken tdc qdisc red tests return ok. I'm including the
patch under the scissors line.

I wanted to ask the ML if adding the space after the specifier is preferred usage.
The commit also had: 
 -               print_uint(PRINT_ANY, "ewma", "ewma %u ", qopt->Wlog);
 +               print_uint(PRINT_ANY, "ewma", " ewma %u ", qopt->Wlog);

so I wanted to check with everyone.

Thanks 
>8------------------------------------------------------------------------8<
From 1e7bee22a799a320bd230ad959d459b386bec26d Mon Sep 17 00:00:00 2001
Subject: [RFC iproute2-next] tc: Add space after format specifier

Add space after format specifier in print_string call. Fixes broken
qdisc tests within tdc testing suite.

Fixes: d0e450438571("tc: q_red: Add support for
qevents "mark" and "early_drop")

Signed-off-by: Briana Oursler <briana.oursler@gmail.com>
---
 tc/q_red.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/tc/q_red.c b/tc/q_red.c
index dfef1bf8..7106645a 100644
--- a/tc/q_red.c
+++ b/tc/q_red.c
@@ -222,7 +222,7 @@ static int red_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	print_uint(PRINT_JSON, "min", NULL, qopt->qth_min);
 	print_string(PRINT_FP, NULL, "min %s ", sprint_size(qopt->qth_min, b2));
 	print_uint(PRINT_JSON, "max", NULL, qopt->qth_max);
-	print_string(PRINT_FP, NULL, "max %s", sprint_size(qopt->qth_max, b3));
+	print_string(PRINT_FP, NULL, "max %s ", sprint_size(qopt->qth_max, b3));
 
 	tc_red_print_flags(qopt->flags);
 

base-commit: 1ca65af1c5e131861a3989cca3c7ca8b067e0833
-- 
2.27.0

