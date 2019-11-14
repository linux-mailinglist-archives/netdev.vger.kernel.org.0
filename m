Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2C4B8FCD5F
	for <lists+netdev@lfdr.de>; Thu, 14 Nov 2019 19:23:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727315AbfKNSXA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Nov 2019 13:23:00 -0500
Received: from mail-qt1-f196.google.com ([209.85.160.196]:42844 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727298AbfKNSW7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Nov 2019 13:22:59 -0500
Received: by mail-qt1-f196.google.com with SMTP id t20so7821348qtn.9
        for <netdev@vger.kernel.org>; Thu, 14 Nov 2019 10:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=T1blah5xyd5sXVJiOFVdIEgTonYkgKnSegRTcg6KiOs=;
        b=cNPGjxP2cFVF2KkWZKvs2l/woGjLaRYn1VuDP63Gj0g2mYraCY0oFSGqNrGuFMcXKs
         8J2PjB3w2bZtUMgVO4I/MbCsTYqb47Gi6a+jJrWwh1rn4vaYzo29wjnlceHCytr/z9/U
         rnth+YPTfRbHlgO4SG6cJq+QjnaKinsqmfsEhyto/BD0Sil37n1KgDwV2vmTlqnbEdxF
         1oVZVoaSwZJMLPSfaSvTUsc5ENLoBMLkCrx0QXrgkF7hRs5Hf8q9D6CX0BMbdIp8d/DD
         yNSJPgKf42Y8D0le1VN2o/MEJP5+rOhATtSOUKwTLypEqS3HGK+QDA/yIRdCZMHU8j7N
         6+XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=T1blah5xyd5sXVJiOFVdIEgTonYkgKnSegRTcg6KiOs=;
        b=jcnDzSqPhygEpghn3DExSczz4k/Th3T29kkS30+rKDu9WQYaQoxbCWreTGUOGE9JrY
         JvTxhqSeEIyDXcOkHEEjuydSjT/gFMOaTKR5VFCxnJaZ3vlwUNfhpXnIpq6kwD7CJBeF
         qZ4mXgEKbKJ5lfE9/hT2JKJ81i6yEf9J2HLRYA19Nt+tbjE2GKiVkCtA1Zhz6Af/5YZ8
         Zak8L0BSqIEW1Eutq9zhxwu0L6KfAl7qEm1af99DxLWe5tTsMgN6Jch+SJvXDfbj+VOC
         XEUXtop7fn0SvOpf+0adOvuV33smBk7ftOY/tpdv8HsABVpMgTUAqtGIGu0meR3PLb7D
         /qXg==
X-Gm-Message-State: APjAAAXAQ3qNzMRXbyIwNhaX+7eQqsHN4Z+wsPH4NGCza0nF0m/dqPvP
        w1wHOliQhXtMv1hPcJZIdJM8Qw==
X-Google-Smtp-Source: APXvYqySa6LvitqH0OAiOzrIPwWFoQFJJoznBhLd8pn0NBVWuLxkIWXDKEYfAtt82f0Xxszpl+0PIA==
X-Received: by 2002:aed:35f4:: with SMTP id d49mr9604950qte.20.1573755778918;
        Thu, 14 Nov 2019 10:22:58 -0800 (PST)
Received: from mojatatu.com (69-196-152-194.dsl.teksavvy.com. [69.196.152.194])
        by smtp.gmail.com with ESMTPSA id l186sm2829234qkc.58.2019.11.14.10.22.57
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Thu, 14 Nov 2019 10:22:58 -0800 (PST)
From:   Roman Mashak <mrv@mojatatu.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH iproute2 2/2] man: tc-ematch.8: documented canid() ematch rule
Date:   Thu, 14 Nov 2019 13:22:36 -0500
Message-Id: <1573755756-26556-3-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1573755756-26556-1-git-send-email-mrv@mojatatu.com>
References: <1573755756-26556-1-git-send-email-mrv@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

tc-ematch.8 was missing the description of canid() ematch rule, so document
this.

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 man/man8/tc-ematch.8 | 13 +++++++++++++
 1 file changed, 13 insertions(+)

diff --git a/man/man8/tc-ematch.8 b/man/man8/tc-ematch.8
index 4c97044a03db..3df870f03ef4 100644
--- a/man/man8/tc-ematch.8
+++ b/man/man8/tc-ematch.8
@@ -109,6 +109,19 @@ test packet against xtables matches
 
 The flag options are the same as those used by the xtable match used.
 
+.SS canid
+ematch rule to match CAN frames
+
+.IR canid "( " IDLIST " )
+
+.IR IDLIST " :=  " IDSPEC [ IDLIST ]
+
+.IR IDSPEC " := { ’sff’ " CANID " | ’eff’ " CANID " }
+
+.IR CANID " := " ID [ ":MASK" ]
+
+.IR ID ", " MASK " := hexadecimal number (i.e. 0x123)
+
 .SH CAVEATS
 
 The ematch syntax uses '(' and ')' to group expressions. All braces need to be
-- 
2.7.4

