Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7CEEC1453E4
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 12:36:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729148AbgAVLgE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 06:36:04 -0500
Received: from mail-pj1-f66.google.com ([209.85.216.66]:56286 "EHLO
        mail-pj1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726194AbgAVLgE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 06:36:04 -0500
Received: by mail-pj1-f66.google.com with SMTP id d5so3048172pjz.5
        for <netdev@vger.kernel.org>; Wed, 22 Jan 2020 03:36:03 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=JS/s9j8U9IeQ6/b6RxEgOuCmaH0wVa5WX2YOp3bYvgI=;
        b=aNaXY6JreA7wDkWpXWMrAiCUPOxG6v7MmuntJ61rX4ruM7FSukc++6L9QH+I3OxuhJ
         zezacT3VnhZbQmycw53BD2ptIAEDOnpd+wJo2QRPYtok32cgRL6+T/V7G9sWa9aljPHc
         VqH8t7FO48CnABjcA7IJ4mBV90NO5KBwZwFjELyzo9apSfIqLJE9l8DozKMF14xjYkKX
         sTvE2vFQt84vOuwSDLaOeV7s5eaq9r/lPyjLOJUwAZrGtpfzOQ/Pfg9iNJPT8Phc9SA8
         cBYLCp5bPcUOKyyrC11h61EiZZU4eSeFas/y/A5ORpnmiOo6a9sJoFndKCzhyvYVGdkn
         dHJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=JS/s9j8U9IeQ6/b6RxEgOuCmaH0wVa5WX2YOp3bYvgI=;
        b=s6pIJtZoXkfHWNHe3vpbpRdAbg3pYqbkdETS+4gh1mORi4duvGrxamGVcX5iIKxrjr
         5Lj9/E+bTzsaruwOoOYNRQJ4uaB/Hm8cgdT3kXj4/a8I7PdVOHBUFIYTttVAY0BS46x0
         lg/2eUSJ4Z5qdEWgWckhPtOcnNX22je5xTaTaEdMZn1/nuSVYKtNsT7TqokttUVyj1PM
         0Bpyn6/v5iVxN/gXRxFxtGctrmzGJ+raexXWDZaiSTEdwex7p7oJRUmUWUsXItsXNzEc
         R3CiDIHliXIGf54vswbvrdKHYmiWTWyw4e9psfSkMuWrwdVjP9u6BpVjiS18IO+6512Z
         YaNw==
X-Gm-Message-State: APjAAAXIim91oomt1/TItp/F1x+2DM1AV/9iGb06kZKlLIhzTgJrd4uD
        jGDm5MjafF4UODM4Syhia1p6NODCrUGqcx0V
X-Google-Smtp-Source: APXvYqxBX+EGx3Q/J+D668qSPp6TwewATEFVY4ZK1kwet+tj4AxQIj1sXz5ehSFWM/XeR9KxANmT1A==
X-Received: by 2002:a17:90a:bf0c:: with SMTP id c12mr2439361pjs.112.1579692963352;
        Wed, 22 Jan 2020 03:36:03 -0800 (PST)
Received: from localhost.localdomain ([223.186.203.82])
        by smtp.gmail.com with ESMTPSA id c6sm2145962pgk.78.2020.01.22.03.35.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 22 Jan 2020 03:36:02 -0800 (PST)
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
Subject: [PATCH net-next v6 03/10] pie: rearrange macros in order of length
Date:   Wed, 22 Jan 2020 17:05:26 +0530
Message-Id: <20200122113533.28128-4-gautamramk@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200122113533.28128-1-gautamramk@gmail.com>
References: <20200122113533.28128-1-gautamramk@gmail.com>
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

