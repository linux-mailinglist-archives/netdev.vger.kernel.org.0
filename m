Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3E5FE17AA7B
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 17:25:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726164AbgCEQZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 11:25:50 -0500
Received: from mail-pj1-f67.google.com ([209.85.216.67]:37443 "EHLO
        mail-pj1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726049AbgCEQZt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 11:25:49 -0500
Received: by mail-pj1-f67.google.com with SMTP id o2so2731590pjp.2
        for <netdev@vger.kernel.org>; Thu, 05 Mar 2020 08:25:49 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=vl3DHB/+PTRzi82UZ8uro1UKCDK3H0ggLxaSahF9x+g=;
        b=UuV0qXtn8mJczjLcYfjOPIuEjveJlZpU+jd/6N5VKhdLVATPY+60oBbQTkE7zfozzz
         KSA4QSxlS6AzpXShHWfoNEwDt8FInIC4nB2hUqAaaLtVwiZ3L05Wb56EcasBaGqa8IZM
         p2fCerfHMBuu+9s4tB/3rQGnrXX9VUTMJaYegXlpNdZ2WA+s6wxshA5Oi9HyQGXAuYvT
         tcxWaPd7C14qyyF6vJCaAO+d7YjVhQQACIwljX72BigHYCSGfHF/4Xq6GL+7yH8Fz31X
         +p6TMqhMtB6d1su3dGe34axNVlBDrtKQ6SA17JisOQcT63uxukc3PEzKxwkAEgFGDjiV
         m0Cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=vl3DHB/+PTRzi82UZ8uro1UKCDK3H0ggLxaSahF9x+g=;
        b=bSdPV4FJfIFX3WeRjGEN/SZnD0hMBZ52UDN9gWHKqNJElNepq3Tga0YpxO0N9n/ECn
         lbypMqoGBswjHA5Lnzse3yBOR//7iGb3A+/WyTGKE/1TIyvyqsMib86aRYunrn9x7TZa
         vThv8CukVVHO7CsEMrFAGyblPpCC7pz/iIdihYAHv7TVlZwjh6tpj3+442jrLjBdD+HA
         engy/WXs2OJjk8zU6WpVlLikAKd+OC9zI4mZDuSWdFSrH4RdN7N5oYBE16Wd/gDOUlSL
         jXZbnBmZ9AIX6A7L7xGIk1KRkUV0N9m07/0MutoKMJA2HmYkmgrywQJZyWt+NqXvIQzV
         5pRg==
X-Gm-Message-State: ANhLgQ2cG3n+WiqCQwCUKgmJGUFKquoiNVIZpoD+WPNRWPXMfTY7OC9S
        M/jS14o7EgTyHEUKp676kJueIAKX
X-Google-Smtp-Source: ADFU+vsq39v+vkgfA+VdeP01yeaHHthf+f+Z5KAe6BbbWXrG/LLuOWdjTu3Xinsva7Kb0CCSxLqMvw==
X-Received: by 2002:a17:902:b210:: with SMTP id t16mr8612920plr.65.1583425548100;
        Thu, 05 Mar 2020 08:25:48 -0800 (PST)
Received: from localhost.localdomain ([103.89.235.106])
        by smtp.gmail.com with ESMTPSA id p21sm32475604pfn.103.2020.03.05.08.25.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 05 Mar 2020 08:25:47 -0800 (PST)
From:   Leslie Monis <lesliemonis@gmail.com>
To:     Linux NetDev <netdev@vger.kernel.org>
Cc:     David Ahern <dsahern@gmail.com>,
        Stephen Hemminger <stephen@networkplumber.org>,
        "Mohit P . Tahiliani" <tahiliani@nitk.edu.in>,
        Gautam Ramakrishnan <gautamramk@gmail.com>
Subject: [PATCH iproute2-next] tc: pie: change maximum integer value of tc_pie_xstats->prob
Date:   Thu,  5 Mar 2020 21:55:40 +0530
Message-Id: <20200305162540.4363-1-lesliemonis@gmail.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Kernel commit 105e808c1da2 ("pie: remove pie_vars->accu_prob_overflows"),
changes the maximum value of tc_pie_xstats->prob from (2^64 - 1) to
(2^56 - 1).

Signed-off-by: Mohit P. Tahiliani <tahiliani@nitk.edu.in>
Signed-off-by: Gautam Ramakrishnan <gautamramk@gmail.com>
Signed-off-by: Leslie Monis <lesliemonis@gmail.com>
---
 tc/q_pie.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tc/q_pie.c b/tc/q_pie.c
index 709a78b4..e6939652 100644
--- a/tc/q_pie.c
+++ b/tc/q_pie.c
@@ -223,9 +223,9 @@ static int pie_print_xstats(struct qdisc_util *qu, FILE *f,
 
 	st = RTA_DATA(xstats);
 
-	/* prob is returned as a fracion of maximum integer value */
+	/* prob is returned as a fracion of (2^56 - 1) */
 	print_float(PRINT_ANY, "prob", "  prob %lg",
-		    (double)st->prob / (double)UINT64_MAX);
+		    (double)st->prob / (double)(UINT64_MAX >> 8));
 	print_uint(PRINT_JSON, "delay", NULL, st->delay);
 	print_string(PRINT_FP, NULL, " delay %s", sprint_time(st->delay, b1));
 
-- 
2.17.1

