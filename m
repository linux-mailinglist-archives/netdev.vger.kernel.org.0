Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CDF7C36EF76
	for <lists+netdev@lfdr.de>; Thu, 29 Apr 2021 20:29:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241183AbhD2Sae (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Apr 2021 14:30:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233705AbhD2Sab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Apr 2021 14:30:31 -0400
Received: from mail-qv1-xf31.google.com (mail-qv1-xf31.google.com [IPv6:2607:f8b0:4864:20::f31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 281D4C06138B
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 11:29:43 -0700 (PDT)
Received: by mail-qv1-xf31.google.com with SMTP id x27so33109880qvd.2
        for <netdev@vger.kernel.org>; Thu, 29 Apr 2021 11:29:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=tyson.me; s=g;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pGjEDIrz7m5nUl3owUTD4iY3Jq1aBLqTu1lgE/2h7vo=;
        b=UsW1P1rE8eu4vAczUN4xysqCorTJlPEh3faXkrMAtp3xH7i5HgO4EW51299294Q3dv
         4P2hlOJ3Ub21iP4wrWil60RG59o5n5r1KQ0uxxxPoVrYQ8vyqIElaoqyGjjaoRtmHDEC
         wOqC1dwA10rWBraBF5KdRIm1hkkBOxVSONi4Y=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=pGjEDIrz7m5nUl3owUTD4iY3Jq1aBLqTu1lgE/2h7vo=;
        b=UG1rGdncL4wQ10HQ4+s/n3rUW8tY5TycWZAf4tr7G908fsNHKDQsAA93G28qmelUNN
         cPg0EJ+QpJuqJlaXfEkoz26PdyKhgmm0SztRq3OmgmZkHFtg+/cxHUI+vugHgIpnSWEq
         jrvi07eRbsrLWSPFkRYlf2gdtZamtOOImhjdzxy44Ija/SCUMx2z25gdBpyp/0mv47tt
         WqenSOXPHpn63pQL3cHL7Sw27uVP4JHSac0gVieJEYv6ecaa3yviMmw79nQyRL5biB3q
         NhIg1ywPko5BsNsopovm/RlMP3L1JxQYEcSNuwt+dySZ1o1DA7vXPsHNQmBxVEgI9ro5
         zqEg==
X-Gm-Message-State: AOAM533Kcn9q4TDTUIxGNnUGWEgo12P/93HbxbG9Nhx6O37xwBoNMzGD
        YjiDuTf9QKxTPqz7BMEwilUhYEjeYl6MgWNi
X-Google-Smtp-Source: ABdhPJy7StTgVZzxU79qBkELYS+uICdoJJG7mURklRulcV+UPcVT1m/eAyUMvCc60gYNJSiX5UwjyQ==
X-Received: by 2002:a0c:dc08:: with SMTP id s8mr932937qvk.12.1619720982253;
        Thu, 29 Apr 2021 11:29:42 -0700 (PDT)
Received: from norquay.oak.tppnw.com ([2607:f2c0:f00f:7f03:cbf4:90df:8a53:7862])
        by smtp.gmail.com with ESMTPSA id y21sm2671945qki.103.2021.04.29.11.29.39
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 29 Apr 2021 11:29:40 -0700 (PDT)
From:   Tyson Moore <tyson@tyson.me>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, Tyson Moore <tyson@tyson.me>
Subject: [PATCH iproute2] tc-cake: update docs to include LE diffserv
Date:   Thu, 29 Apr 2021 14:28:47 -0400
Message-Id: <20210429182847.10892-1-tyson@tyson.me>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Linux kernel commit b8392808eb3fc28e ("sch_cake: add RFC 8622 LE PHB
support to CAKE diffserv handling") added packets with LE diffserv to
the Bulk priority tin. Update the documentation to reflect this change.

Signed-off-by: Tyson Moore <tyson@tyson.me>
---
 man/man8/tc-cake.8 | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/man/man8/tc-cake.8 b/man/man8/tc-cake.8
index cb67d15f..ced9ac78 100644
--- a/man/man8/tc-cake.8
+++ b/man/man8/tc-cake.8
@@ -509,7 +509,7 @@ preset on the modern Internet is firmly discouraged.
 .br
 	Provides a general-purpose Diffserv implementation with four tins:
 .br
-		Bulk (CS1), 6.25% threshold, generally low priority.
+		Bulk (CS1, LE in kernel v5.9+), 6.25% threshold, generally low priority.
 .br
 		Best Effort (general), 100% threshold.
 .br
@@ -522,7 +522,7 @@ preset on the modern Internet is firmly discouraged.
 .br
 	Provides a simple, general-purpose Diffserv implementation with three tins:
 .br
-		Bulk (CS1), 6.25% threshold, generally low priority.
+		Bulk (CS1, LE in kernel v5.9+), 6.25% threshold, generally low priority.
 .br
 		Best Effort (general), 100% threshold.
 .br
-- 
2.31.1

