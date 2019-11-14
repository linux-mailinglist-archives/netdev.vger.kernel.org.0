Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6AA1FCD5E
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:23:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727279AbfKNSW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 13:22:56 -0500
Received: from mail-qt1-f193.google.com ([209.85.160.193]:33558 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726557AbfKNSW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:22:56 -0500
Received: by mail-qt1-f193.google.com with SMTP id y39so7887869qty.0
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:22:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=DVcC9dDEn3WP219v26k+Bzlc9JahRrEvo2XCLhEHvZo=;
        b=fVF7/gphg40OA4iXphAPvX3CiQ0HI/9kZ0JkJcHNG7Fld2bDq6OMoAgz4hkNL/ChzC
         Z6SwAhyofxaHu9S1MbYGtUkXq+p8h2bdSsLEbdkN0EmzO0SWkGq9UQQ7YKTMH/JSXSCz
         RrcTY0yYvYIacJY59vTiJebKVoMsA6YdRxKeJqm8aFeCKFz7xiYAEJUNlp3pPKwQ2Tok
         /XGo4xMrIHyaRb2nEGHqy4sPsZtnKGb/FCrnGyn79nQyBl9YG8n+/Nw6Z1irYibj4e5Q
         nY9za14GGGimtKrJ4ETzUQBi0/NuKbf7oKWCx0x07u5REknfItvaGiCDiAMamCvBBVjm
         +iUA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=DVcC9dDEn3WP219v26k+Bzlc9JahRrEvo2XCLhEHvZo=;
        b=S+ssIP5Nmq4gQwb0cWAl/dnkLJ2p3bs92VwktQNxsxMd5D0wIBC9voELgE1vfCMu7N
         3zjClXjEx6GywCnN0nmPN8EmCy97k75VhJiwDFL/lhFH+SNnc05svH7Mg6rWoHNzCi81
         eszCRDiJv18DOIiWJMZBBmkbmXtIFgU0MzU7pPiIDxcMyyc4XC8tQPKBHvfSNokzpZvd
         OqmKrP+4GxK7Lm9c6lPoQDqGy51QAZ7G09aZXXg5/MOCMazAH/CMJFDD14n7LA4HLz+3
         Evkx+IE1JXzgPYJ0k8i2d/yqyF1pvacYJyWGzwIO1HMEibDKXdv2AwfxBq72E9qlJe0v
         eurg==
X-Gm-Message-State: APjAAAWPDvASrYTuPYPL6a3dEYpwVcKRII88oSA5dyax8FsEOq8aywXc
        3kLXzZRAxN/2dyeF789e5yqWMw==
X-Google-Smtp-Source: APXvYqyOTVqLwNYdmPOtcMRpIcMmOS9VnlK9HFbjk5b9MG+1bHvdUxgtGGMIWHgTVKVyx970J+mpTw==
X-Received: by 2002:ac8:177c:: with SMTP id u57mr9144907qtk.216.1573755775829;
        Thu, 14 Nov 2019 10:22:55 -0800 (PST)
Received: from mojatatu.com (69-196-152-194.dsl.teksavvy.com. [69.196.152.194])
        by smtp.gmail.com with ESMTPSA id l186sm2829234qkc.58.2019.11.14.10.22.54
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 14 Nov 2019 10:22:55 -0800 (PST)
From:   Roman Mashak <mrv@mojatatu.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH iproute2 1/2] man: tc-ematch.8: update list of filter using extended matches
Date:   Thu, 14 Nov 2019 13:22:35 -0500
Message-Id: <1573755756-26556-2-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573755756-26556-1-git-send-email-mrv@mojatatu.com>
References: <1573755756-26556-1-git-send-email-mrv@mojatatu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Extended match rules are currently supported by basic, flow and cgroup
filters, so update the man page.

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 man/man8/tc-ematch.8 | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/man/man8/tc-ematch.8 b/man/man8/tc-ematch.8
index 042f84045873..4c97044a03db 100644
--- a/man/man8/tc-ematch.8
+++ b/man/man8/tc-ematch.8
@@ -1,7 +1,7 @@
 .TH ematch 8 "6 August 2012" iproute2 Linux
 .
 .SH NAME
-ematch \- extended matches for use with "basic" or "flow" filters
+ematch \- extended matches for use with "basic", "cgroup"  or "flow" filters
 .
 .SH SYNOPSIS
 .sp
-- 
2.7.4

