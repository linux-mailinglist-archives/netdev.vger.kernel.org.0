Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2AEEC143F06
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 15:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729256AbgAUONT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 09:13:19 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:37264 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729162AbgAUONT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 09:13:19 -0500
Received: by mail-pg1-f196.google.com with SMTP id q127so1565736pga.4
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 06:13:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JS/s9j8U9IeQ6/b6RxEgOuCmaH0wVa5WX2YOp3bYvgI=;
        b=fbJKPW6+ukxnEcRWrHQkv+g/W32eD9IDKig1zZMNNU5Qije+FyJKvmNTUjj1QTBcMF
         3nZwkF3LI0FipVkWpMucP0kXjLKaW8vnnzmURwffu1da3S/nHIVU9PASIxC8zW1OE1gN
         L2Hb0y2qucIR7SuYS/VofH7MjsIjqMVXTl80RZpbYND4PxBJKbo1YhaVXYur1z1tgCY8
         S86s56nnE6OKDDcgfk88h8cXDUhJrge2bb+x7OIAuSyBzRsCoOb4UN+ss/h2GzV54tkQ
         j3c8GA74w9sI7UIQ4Hu1h9tUfM7qAM1A6j7wNtYvbj4fMzvIExAFUkQkd1oqj/KyUHEu
         07Xg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JS/s9j8U9IeQ6/b6RxEgOuCmaH0wVa5WX2YOp3bYvgI=;
        b=bGECaTmJ8a/JCjiLEuDHCitCZ8l5jEP/KmxqchCNIxBYQUzTXqUHFdg4tBNEEfObW0
         EE+KWyGXepUxnY5xAuAJu8kfovLkoVPpyO/ekH7o1dPV8VBqNZxlOmfvxS9PK8ZiD78z
         wY0G8FBEOWhwahTKob9SWMCLA5xvG/8lNyWp83fejM/+XGQwLRSP1n3ltYw4XF0PHHQx
         wkBQjttwaMoruTrje8DBloXHc5cddhi1y0yAfBbg7HBT483WvPFKw/idgnBV81nj3TOf
         DPIeAawYeuA0IpbjN8a8tG2MtUt6991bxD1EnRpH0zACZiR0JvBmWoGywFJBXx+9UQj3
         2FgA==
X-Gm-Message-State: APjAAAWzLYiKCtLx1SSdyzConxnbfJQGphdy1LLd+6boZcl5LFgfJDlc
        dP3k/zFl1sCQ+07A+SqOES7X2XHBaojoig==
X-Google-Smtp-Source: APXvYqw5oqoblN/4DPJM8+v7/kJkoIqjbtrqrLF7ust6JQcjFmKUNMXfRIugvZw1WhJB3BFOGLpFlQ==
X-Received: by 2002:a63:184d:: with SMTP id 13mr5643823pgy.132.1579615998366;
        Tue, 21 Jan 2020 06:13:18 -0800 (PST)
Received: from localhost.localdomain ([223.186.212.224])
        by smtp.gmail.com with ESMTPSA id y203sm44836443pfb.65.2020.01.21.06.13.14
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 06:13:17 -0800 (PST)
From:   gautamramk@gmail.com
To:     netdev@vger.kernel.org
Cc:     "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        "David S . Miller" <davem@davemloft.net>,
        Dave Taht <dave.taht@gmail.com>,
        =?UTF-8?q?Toke=20H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Stephen Hemminger <stephen@networkplumber.org>,
        Leslie Monis <lesliemonis@gmail.com>,
        Gautam Ramakrishnan <gautamramk@gmail.com>
Subject: [PATCH net-next v4 03/10] pie: rearrange macros in order of length
Date:   Tue, 21 Jan 2020 19:42:42 +0530
Message-Id: <20200121141250.26989-4-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200121141250.26989-1-gautamramk@gmail.com>
References: <20200121141250.26989-1-gautamramk@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>

Rearrange macros in order of length and align the values to
improve readability.

Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
---
 include/net/pie.h | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/include/net/pie.h b/include/net/pie.h
index 7ef375db5bab..397c7abf0879 100644
--- a/include/net/pie.h
+++ b/include/net/pie.h
@@ -8,11 +8,11 @@
 #include <net/inet_ecn.h>
 #include <net/pkt_sched.h>
 
-#define QUEUE_THRESHOLD 16384
-#define DQCOUNT_INVALID -1
-#define DTIME_INVALID U64_MAX
-#define MAX_PROB U64_MAX
-#define PIE_SCALE 8
+#define MAX_PROB	U64_MAX
+#define DTIME_INVALID	U64_MAX
+#define QUEUE_THRESHOLD	16384
+#define DQCOUNT_INVALID	-1
+#define PIE_SCALE	8
 
 /* parameters used */
 struct pie_params {
-- 
2.17.1

