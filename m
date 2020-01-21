Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 092B8143F0D
	for <lists+netdev@lfdr.de>; Tue, 21 Jan 2020 15:13:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729212AbgAUONh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jan 2020 09:13:37 -0500
Received: from mail-pl1-f194.google.com ([209.85.214.194]:41480 "EHLO
        mail-pl1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728904AbgAUONh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jan 2020 09:13:37 -0500
Received: by mail-pl1-f194.google.com with SMTP id t14so1389247plr.8
        for <netdev@vger.kernel.org>; Tue, 21 Jan 2020 06:13:37 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=fLMSzwn105nQG1k0Bcg5PrK+NSb62h11DDA8BpA28gE=;
        b=Y9ld0TgoGtzFYQ4NGnfF+GIRzSzEpoO4uEPZjupsz0woSF8ICj4k9RTSqXkVTr6n7+
         Y8VEyNv+5yqfeN1IrNBVzIx3+qgAJVYD3BhLUPfiHVw10/2Hp7Oed188DGV/HdXNLiLz
         o9Mk2mNmbfqO+p8cPT3fTERVzPuUaHAnY3u3oXCe2z2jspJEyK6+AwDEQacSxcGCI8al
         l9nxrCNBkONC0du54+TDFwHjY79WiP85NlQD/vdBbvvmWrsesWI2+hBpLepzVQtw9bns
         rDJiqGAwxY8lsCxrIqkttzkkokPDEnVul3yNucPGrfr+RpXV8ilOH9bWKthkLt4CciVn
         R/sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=fLMSzwn105nQG1k0Bcg5PrK+NSb62h11DDA8BpA28gE=;
        b=OCOAgOZDDJ2hwjdMQUlXpkp8F8URDDrELFFvoAMNzyh3opvKgUa9JaCLQmqBO1hKAD
         li/0rvPGZNGC84KXNzm/MZ8+c1r0784X2TB3zGlwheEQWEKfFTuL5vDOnr/CsePuBry8
         njeXXi/PcFnNR32mRbT4O48xnDVgFsBBY5r3JGGp7eb/UiasyTJW+rG1NoXWhVMW91Cr
         IlBPAOWXyWhOCyiuI+35f8KlZ9lEpwQvelIgk/cy3/Mi/lAl10hl9sdqhlWKaqKrCe/s
         IOML2ALVzTsuLFz82D3X6rtFGlwZyMjy4o/NrqF5uLEYIzGLSBSgAeEKP7GCp+xWmPTu
         21Ig==
X-Gm-Message-State: APjAAAUfJU5ZkCQP1HwyaEWBHqg29ewaHX9i6YgVeQ8R1bM7NL06ka1T
        LXi5J8U0/8SQW0bhkjrEX0LFIEMy+u9rRw==
X-Google-Smtp-Source: APXvYqyWPVK66MS6g6AxyIcwC+MDtKFXD6IoJ1TdadBT+h2EnHvEyB42+S97MQrS95BiAn8iah4FRQ==
X-Received: by 2002:a17:90a:8a0c:: with SMTP id w12mr5557925pjn.61.1579616016622;
        Tue, 21 Jan 2020 06:13:36 -0800 (PST)
Received: from localhost.localdomain ([223.186.212.224])
        by smtp.gmail.com with ESMTPSA id y203sm44836443pfb.65.2020.01.21.06.13.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 21 Jan 2020 06:13:36 -0800 (PST)
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
Subject: [PATCH net-next v4 07/10] net: sched: pie: fix commenting
Date:   Tue, 21 Jan 2020 19:42:46 +0530
Message-Id: <20200121141250.26989-8-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200121141250.26989-1-gautamramk@gmail.com>
References: <20200121141250.26989-1-gautamramk@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: "Mohit P. Tahiliani" <tahiliani@nitk.edu.in>

Fix punctuation and logical mistakes in the comments.
The logical mistake was that "dequeue_rate" is no longer
the default way to calculate queuing delay and is not
needed. The default way to calculate queue delay was
changed in commit cec2975f2b70 ("net: sched: pie:
enable timestamp based delay calculation").

Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
---
 net/sched/sch_pie.c | 10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/net/sched/sch_pie.c b/net/sched/sch_pie.c
index 7197bcaa14ba..c0a4df01c0a0 100644
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

