Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 918A02301A7
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 07:22:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726391AbgG1FV6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 01:21:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgG1FV6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 01:21:58 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48255C061794
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 22:21:58 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id y206so118pfb.10
        for <netdev@vger.kernel.org>; Mon, 27 Jul 2020 22:21:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=R/4X/8k2tJggQ9nVAlbjy5NkMm1E7b7v277SRYF4fgY=;
        b=gn0EoSFLj5zXHTEeTmdkshjwOQje6BSiEzYT0mfXSznIOcp7VIiV47WricRNy4F11y
         VosaJNOUAD/kO6MFVEV13V+Spbh5DKi2eUGPvip0qsnSpdGU52G7rQ/VCV+mQZos6NxX
         rRxzlJFxevsZ45f9seupHg7ngbnA9cUd4djmkBKriJLbDH5MKsW04YQlPlMlEcA4J7o8
         hYhjEu4tnylQrynlOifhd9Bw4UwiP8M79p9NQyNae5ZpToWCY2QSALdasvj2Cv1gxQD/
         GXiDAF5NxngmgFSSlXUTEYMEozVg5+xc8/rTy9v+ZfbfrFEVKbCIbdpJ2NH9JikQZ+tr
         dDyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=R/4X/8k2tJggQ9nVAlbjy5NkMm1E7b7v277SRYF4fgY=;
        b=a6aXFEomgpY8ZYZazYTgzk50v9hCikyJsezK2oj9EmItyK3N0y4pQOsFKieUW5l+hE
         fVRyKYXwtp/xdhXFoMIP91Xeveb9G+5b0MbUC0DEVnnZ0l6dOZJE9wKEX7cD9aDIvFwG
         MU7rtDIuB++jHWRaJPlT7Hbt1uAfSW33l6yjgl75eZrew9cYcEMnFBUn6D15Zf/Iplul
         Z30zySE3do8D+gj+Sg4n3kQQOZVfiPm/+qPDc+yxiHlgnIJura7YLF1SnUF08jAech1w
         PEfxCJsI9WYkhbZ3di9O+FJ8+xVb4c4QP1RkvZRaw8/1rjyMDN6rg+1iVL0tCdmCQPci
         ShkQ==
X-Gm-Message-State: AOAM531riRu3j8V4abwceeKNuc/W8hgClrjOx/7AcIO1UUks6U/5mBUK
        7jGyFWjoMMxI9j9huQMdgtw=
X-Google-Smtp-Source: ABdhPJxyyBf9uJ2rX+JLLRx0XgJ401QYvXM2usSLI4psc0JTNrTSsj1UqLY+8o8r/w+5nTo/mPfhCg==
X-Received: by 2002:a63:144c:: with SMTP id 12mr22761358pgu.189.1595913717575;
        Mon, 27 Jul 2020 22:21:57 -0700 (PDT)
Received: from nebula.localdomain (035-132-134-040.res.spectrum.com. [35.132.134.40])
        by smtp.gmail.com with ESMTPSA id 76sm17180033pfu.139.2020.07.27.22.21.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jul 2020 22:21:57 -0700 (PDT)
From:   Briana Oursler <briana.oursler@gmail.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     Petr Machata <petrm@mellanox.com>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Davide Caratti <dcaratti@redhat.com>,
        Stefano Brivio <sbrivio@redhat.com>, netdev@vger.kernel.org,
        Briana Oursler <briana.oursler@gmail.com>
Subject: [PATCH iproute2] tc: Add space after format specifier
Date:   Mon, 27 Jul 2020 22:20:48 -0700
Message-Id: <20200728052048.7485-1-briana.oursler@gmail.com>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20200727164714.6ee94a11@hermes.lan>
References: <20200727164714.6ee94a11@hermes.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add space after format specifier in print_string call. Fixes broken
qdisc tests within tdc testing suite. Per suggestion from Petr Machata,
remove a space and change spacing in tc/q_event.c to complete the fix.

Tested fix in tdc using:
./tdc.py -c qdisc

All qdisc RED tests return ok.

Fixes: d0e450438571("tc: q_red: Add support for
qevents "mark" and "early_drop")

Signed-off-by: Briana Oursler <briana.oursler@gmail.com>
---
 tc/q_red.c     | 4 ++--
 tc/tc_qevent.c | 3 ++-
 2 files changed, 4 insertions(+), 3 deletions(-)

diff --git a/tc/q_red.c b/tc/q_red.c
index dfef1bf8..df788f8f 100644
--- a/tc/q_red.c
+++ b/tc/q_red.c
@@ -222,12 +222,12 @@ static int red_print_opt(struct qdisc_util *qu, FILE *f, struct rtattr *opt)
 	print_uint(PRINT_JSON, "min", NULL, qopt->qth_min);
 	print_string(PRINT_FP, NULL, "min %s ", sprint_size(qopt->qth_min, b2));
 	print_uint(PRINT_JSON, "max", NULL, qopt->qth_max);
-	print_string(PRINT_FP, NULL, "max %s", sprint_size(qopt->qth_max, b3));
+	print_string(PRINT_FP, NULL, "max %s ", sprint_size(qopt->qth_max, b3));
 
 	tc_red_print_flags(qopt->flags);
 
 	if (show_details) {
-		print_uint(PRINT_ANY, "ewma", " ewma %u ", qopt->Wlog);
+		print_uint(PRINT_ANY, "ewma", "ewma %u ", qopt->Wlog);
 		if (max_P)
 			print_float(PRINT_ANY, "probability",
 				    "probability %lg ", max_P / pow(2, 32));
diff --git a/tc/tc_qevent.c b/tc/tc_qevent.c
index 2c010fcf..34568070 100644
--- a/tc/tc_qevent.c
+++ b/tc/tc_qevent.c
@@ -82,8 +82,9 @@ void qevents_print(struct qevent_util *qevents, FILE *f)
 			}
 
 			open_json_object(NULL);
-			print_string(PRINT_ANY, "kind", " qevent %s", qevents->id);
+			print_string(PRINT_ANY, "kind", "qevent %s", qevents->id);
 			qevents->print_qevent(qevents, f);
+			print_string(PRINT_FP, NULL, "%s", " ");
 			close_json_object();
 		}
 	}
-- 
2.27.0

