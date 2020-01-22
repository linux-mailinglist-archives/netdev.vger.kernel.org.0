Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A5884145B84
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 19:23:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728939AbgAVSXW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 13:23:22 -0500
Received: from mail-pf1-f195.google.com ([209.85.210.195]:44361 "EHLO
        mail-pf1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725883AbgAVSXV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 13:23:21 -0500
Received: by mail-pf1-f195.google.com with SMTP id 62so223110pfu.11
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 10:23:21 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=7QJ7r6VCbJ5yiJne5YJbfLdcih0PR3cC3oHUxUnk3EU=;
        b=MqTmKmX68FSUXivmnfAgOeoAhBX6Jc1+nQC+0OJIm4+T6UXr0/mytC/7WVE6lJccs4
         JGvMH+m2P8JZcxq5IY37Ed7HZJJQgsvQgPS0sbo8TmsPBlffiBMU/58U/zZgeExjwy7G
         dtk6KtG4PG9Bwp41IuLX8wveSkFJN/sH9nSU+2h+uLPCA/VtYaiKl2nl660emn9RMlj3
         xw/rcF15bxBW64mdJExzwyttXfQBfvaAz87+EA2j8SG/2o1tbwN0SIbkZ4njyk9SLj04
         FcJwknREQbpsJDzGz8cklooHZKTYMospL3s/yiNBrqPG/ZKYpRaSCSte3ljwgptYA5Wu
         GW4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=7QJ7r6VCbJ5yiJne5YJbfLdcih0PR3cC3oHUxUnk3EU=;
        b=btb8IHbWoZRKGQxX7/sF+XKtztdLionWDBd2mHzOHhmAG6HNXHSzYrHEPYPd158zM5
         CUTMrBe3JTlrupygGfSbaW0zlPoqcJVkjLrQdQ5RcPGfN/DdbQS/dcrqxUJxCD3EjczN
         jPI6nqalckxHlY+RDRMFgMz+ERf/ORXhso77u4n03ALCzGb6EwGm9YadOXMzr8ASQa2Q
         dgPPXJdE/CzP6bwbhqTO4XTxRvSumeS0mnm3oTIA2/b1KOQx0L3Ap6/qp7e+JwnYZ5eI
         5M3e2gCp+ygoEtC0KPcKp1CuNJlaHG1Y1DFZWWm9Fr+fsI+wiywnlxxKLFL6XFuGRmqt
         26Cg==
X-Gm-Message-State: APjAAAWgXqZ4NLI9u2DvYFXdwD4Md6qgCkhQrzId8w8O0manJmDNSoFk
        NuX5nNznYWvKcDhC8Nq05/hnoBkOu5kGQXKW
X-Google-Smtp-Source: APXvYqztFKQnHa8HKTM59tdf+qqB387G5lay/rUCzpS/mS2lEQrpPX7pVo8EAeCS5h8mB6vragGGyA==
X-Received: by 2002:a63:6fca:: with SMTP id k193mr12920551pgc.416.1579717400769;
        Wed, 22 Jan 2020 10:23:20 -0800 (PST)
Received: from localhost.localdomain ([223.186.203.82])
        by smtp.gmail.com with ESMTPSA id o17sm3996532pjq.1.2020.01.22.10.23.16
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 10:23:20 -0800 (PST)
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
Subject: [PATCH net-next v7 07/10] net: sched: pie: fix commenting
Date:   Wed, 22 Jan 2020 23:52:30 +0530
Message-Id: <20200122182233.3940-8-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200122182233.3940-1-gautamramk@gmail.com>
References: <20200122182233.3940-1-gautamramk@gmail.com>
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

