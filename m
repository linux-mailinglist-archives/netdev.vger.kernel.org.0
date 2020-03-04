Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 89BF3179875
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 19:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388317AbgCDS4Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 13:56:25 -0500
Received: from mail-pj1-f65.google.com ([209.85.216.65]:53845 "EHLO
        mail-pj1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388307AbgCDS4Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Mar 2020 13:56:24 -0500
Received: by mail-pj1-f65.google.com with SMTP id cx7so1297889pjb.3
        for <netdev@vger.kernel.org>; Wed, 04 Mar 2020 10:56:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=Br6c2Y1AI7IGoOUT9S32pmgk6z94hhBAZwhijTHQ5mg=;
        b=iHHDmMhIUk0szPbyAcCEG3xw95H3qN7AmXIiT4YxxFSVsD4mfMVPbutf7TOKZcqqE/
         585RsSd9ZqQVrlnZS5BTcWAF2kKBDfYwUsFkhhRjiDssGZXv7yx84MQxlnWPEzMG6CYz
         FzFpeyM5/+8Pjr0Blf6pBBdVKMKtp34fX1K7tGbqAVbAFrsCdUIbw33/g5Joz3DgnLDV
         86NU+Hslqu0Mq3QOLuMPwnHUuNLaDHR1QoTYmENW8+gyKQBPor+VzAD6HLGB+mYwX33n
         rVjt1WKkcYCPm4xa132VMjCZS6y2M3fzlqxN/kLRiGxVsfd8PCZQ+tWzWe5Reiw6r7P9
         EpgQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=Br6c2Y1AI7IGoOUT9S32pmgk6z94hhBAZwhijTHQ5mg=;
        b=qMR1vPnSTr/0Ix/WTW7akiHu9892YPYsGxMVCqYIkmuJ3mmj2+Zbfuc1avLW+MEsx+
         OCYfr+6PiCt97tbsMcAGDUrYYUvh4972rprIzczA4rnirzfIx9EJTwqLTMF1Mo7iV4VK
         mNK64C7/8EKv9L5Is0YUDY7nAohSXhfTrAymckYmFiIkkgezyDJ4vHg9EoNcBa5WvOAj
         u/R6mhoulZMvA0Wdtrh49m6bzCpJGuCt1rtlVv6eCBuEHBNz6xLGobE+bvWLXAk2UYW5
         AEQYNGbvVvBCK3cb0V8a1vg3FLnmQhRADPSb/RRbp3yp0nY/ppXe/7taodGY9v6mBcRS
         05yA==
X-Gm-Message-State: ANhLgQ2Z1nBR20XKvNROHJHnd2LKB3Yqi1bBbB6XkdlEWFVmnbOuaCSi
        6VleLLvEpGvvnO3eMz4MGSPfUxj9
X-Google-Smtp-Source: ADFU+vsQvz8ITA+8zi139jwo+5e1RxUvMAJzQgQOxJRz2J2dBpWlfULWuIERKbqN9LgWAY8rJ8Jdxw==
X-Received: by 2002:a17:902:b497:: with SMTP id y23mr4258722plr.81.1583348183259;
        Wed, 04 Mar 2020 10:56:23 -0800 (PST)
Received: from localhost.localdomain ([103.89.235.106])
        by smtp.gmail.com with ESMTPSA id h12sm12720021pfk.124.2020.03.04.10.56.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 04 Mar 2020 10:56:22 -0800 (PST)
From:   Leslie Monis <lesliemonis@gmail.com>
To:     netdev@vger.kernel.org
Cc:     davem@davemloft.net, tahiliani@nitk.edu.in, gautamramk@gmail.com
Subject: [PATCH net-next v2 4/4] pie: realign comment
Date:   Thu,  5 Mar 2020 00:26:02 +0530
Message-Id: <20200304185602.2540-5-lesliemonis@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200304185602.2540-1-lesliemonis@gmail.com>
References: <20200304185602.2540-1-lesliemonis@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Realign a comment after the change introduced by the
previous patch.

Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
---
 include/net/pie.h | 18 +++++++++---------
 1 file changed, 9 insertions(+), 9 deletions(-)

diff --git a/include/net/pie.h b/include/net/pie.h
index 1c645b76a2ed..3fe2361e03b4 100644
--- a/include/net/pie.h
+++ b/include/net/pie.h
@@ -38,15 +38,15 @@ struct pie_params {
 
 /**
  * struct pie_vars - contains pie variables
- * @qdelay:			current queue delay
- * @qdelay_old:			queue delay in previous qdelay calculation
- * @burst_time:			burst time allowance
- * @dq_tstamp:			timestamp at which dq rate was last calculated
- * @prob:			drop probability
- * @accu_prob:			accumulated drop probability
- * @dq_count:			number of bytes dequeued in a measurement cycle
- * @avg_dq_rate:		calculated average dq rate
- * @backlog_old:		queue backlog during previous qdelay calculation
+ * @qdelay:		current queue delay
+ * @qdelay_old:		queue delay in previous qdelay calculation
+ * @burst_time:		burst time allowance
+ * @dq_tstamp:		timestamp at which dq rate was last calculated
+ * @prob:		drop probability
+ * @accu_prob:		accumulated drop probability
+ * @dq_count:		number of bytes dequeued in a measurement cycle
+ * @avg_dq_rate:	calculated average dq rate
+ * @backlog_old:	queue backlog during previous qdelay calculation
  */
 struct pie_vars {
 	psched_time_t qdelay;
-- 
2.17.1

