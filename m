Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9E4731453E8
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 12:36:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729242AbgAVLgZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 06:36:25 -0500
Received: from mail-pg1-f196.google.com ([209.85.215.196]:36871 "EHLO
        mail-pg1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729012AbgAVLgZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 06:36:25 -0500
Received: by mail-pg1-f196.google.com with SMTP id q127so3357859pga.4
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 03:36:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7QJ7r6VCbJ5yiJne5YJbfLdcih0PR3cC3oHUxUnk3EU=;
        b=nBz5U6MkGQghgoM+/oianKmyfUEMUS9qGHuEOJDad1hkeuTM77VhajN4G/XcT5Cd+7
         ldBzcit8wYIdMLFLeUJ8foKReqmEG2aOsTUoK8+IEJyN1F76Dnx8mpb05SFU7OwN6EM5
         KxkrVNX8UX7baeNRC15WO4QlIzYeT9kCwkJdJUlc3/2O4TUvhrscplEhR0WNzcHpHSwT
         bcrSRRT1oAeHCU0jeyTeQfjqDnwR4wKNGX0CIkUnVN1pLZagC1kUHjIxogJ2rHKZlQ5c
         wT/N8FE2i9uAFM8X3IacfZQ4Ie7V2VqkzY1VCR9n2vEuyhb8zZyVet9TuXWhuOyB+QS1
         oK7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7QJ7r6VCbJ5yiJne5YJbfLdcih0PR3cC3oHUxUnk3EU=;
        b=qGKsAUi00vctK0EfOVUdo20PMXG6A7b89ARrgShVUvw1yHAeOlqbnmPHcOM3mehXVJ
         xCMiLGVHBFb2ag4ZeV+VZoxdkUVWBCk6lQ+MDN7AeP4vu/9SPt4vRfS5GAFWWqR8Zajn
         nEvQxPKVVZRSFpXHDGa9wtcD+278/GW5lW6+cw7ac1JXiSwMovrxT5LsfjOOxRLo6by0
         tclQu9lT19CUVIpFyWw3scpH2FQa4Z0bG8PiSjSAU/ohYuNzJ0W1bMhd5SkKdvZFATaG
         flX5eWnmdTR4XyMZo4KuKT8ZXfHtbx6nSLxAp/i4lPNeLolQgB3Gh3QivdzvG/3NPAK3
         qNjg==
X-Gm-Message-State: APjAAAWOa6jS0YMu8Mahbcom5moSZNWywo+q5esY3trmyVOW5+KFqyKG
        EConSeGivDNXe9SIccqL5T4/HAh41VSkkNfD
X-Google-Smtp-Source: APXvYqysON5fujS33cj6T4u0xP/S0KBmqxkmcm8hjyJYODMzLrIHF8qDcsK7HL0+7tRTh4gRq6/Wrg==
X-Received: by 2002:aa7:92c7:: with SMTP id k7mr2234096pfa.8.1579692984412;
        Wed, 22 Jan 2020 03:36:24 -0800 (PST)
Received: from localhost.localdomain ([223.186.203.82])
        by smtp.gmail.com with ESMTPSA id c6sm2145962pgk.78.2020.01.22.03.36.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 03:36:23 -0800 (PST)
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
Subject: [PATCH net-next v6 07/10] net: sched: pie: fix commenting
Date:   Wed, 22 Jan 2020 17:05:30 +0530
Message-Id: <20200122113533.28128-8-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200122113533.28128-1-gautamramk@gmail.com>
References: <20200122113533.28128-1-gautamramk@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>

Fix punctuation and logical mistakes in the comments. The
logical mistake was that "dequeue_rate" is no longer the default
way to calculate queuing delay and is not needed. The default
way to calculate queue delay was changed in commit cec2975f2b70
("net: sched: pie: enable timestamp based delay calculation").

Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
---
 net/sched/sch_pie.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index 0c583cc148f3..024f55569a38 100644
--- a/net/sched/sch_pie.c
+++ b/net/sched/sch_pie.c
@@ -248,10 +248,10 @@ static void pie_process_dequeue(struct Qdisc *sch, struct sk_buff *skb)
 		q->vars.dq_count = 0;
 	}
 
-	/* Calculate the average drain rate from this value.  If queue length
-	 * has receded to a small value viz., <= QUEUE_THRESHOLD bytes,reset
+	/* Calculate the average drain rate from this value. If queue length
+	 * has receded to a small value viz., <= QUEUE_THRESHOLD bytes, reset
 	 * the dq_count to -1 as we don't have enough packets to calculate the
-	 * drain rate anymore The following if block is entered only when we
+	 * drain rate anymore. The following if block is entered only when we
 	 * have a substantial queue built up (QUEUE_THRESHOLD bytes or more)
 	 * and we calculate the drain rate for the threshold here.  dq_count is
 	 * in bytes, time difference in psched_time, hence rate is in
@@ -329,8 +329,8 @@ static void calculate_probability(struct Qdisc *sch)
 		qdelay_old = q->vars.qdelay_old;
 	}
 
-	/* If qdelay is zero and qlen is not, it means qlen is very small, less
-	 * than dequeue_rate, so we do not update probabilty in this round
+	/* If qdelay is zero and qlen is not, it means qlen is very small,
+	 * so we do not update probabilty in this round.
 	 */
 	if (qdelay == 0 && qlen != 0)
 		update_prob = false;
-- 
2.17.1

