Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1E500625AA
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 18:06:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2403820AbfGHQGf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 12:06:35 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:33174 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731494AbfGHQGd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 12:06:33 -0400
Received: by mail-io1-f67.google.com with SMTP id z3so21501969iog.0
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 09:06:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vFPN19sE7ysY8YvFFjusSzIZiwIbCJpLduVsj4SmypE=;
        b=H6AaTsy+LQfZZqvzl7LZjCiNYqhzclPE4mOWz8NYynYsh9TSaYWQO/TgHZYuuRPSjx
         toMhCzMhTkgPXdXO+BzEL1llC1fa4aT3puUzLgIp+Zp1fiQElM4hMv0mP2Cr5mtCANsq
         Pxoenq6Q13+zatYUxb34Ojx2H6mm9UQ3TC9CeOOGR1m2pOq4qpf++XKj36paPFcPtGlP
         XcZ5i4WNg4m8BRUGiYcD5TkbJRAE0chUMy498a7hqDhkddj1RbZut6vsg2wH2hZWZxpf
         r7YnOyC5VOT5ZMfz1OsX5L/FHbAio15QcSGYyDKEI2hGGeSGJi00+CAukIFno5fcAWne
         nAGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vFPN19sE7ysY8YvFFjusSzIZiwIbCJpLduVsj4SmypE=;
        b=EeJ7Sd7jVyUvU11qpzV4wFMG+B3IplB+vad0UYb0Mmk0BXyLD1/9w34ylJcEfPmr0j
         KG6DguAhfORVi8f6uwXWbzoLpt2fcGkLp1GLKfe4VvMlo59WkHNBieoXVifTN+K4/2JI
         GodYRPZsj9twYs/EamVbNitUZpMNe8fxcGCbLfOufoArCPEGtUztYyt2hfYeuXHmaoQ7
         zWcFr8W7gTH8u7BROQKv79ONwGCt0HVkx0OIQAWG2DxsJCp+sK841GX/zilcFlnGG75J
         mN59qz40rZ9ucEZpiDgZgvrOvbcnIg8UXLxapYvLypLTekDCBP2b3bNaU6dNI+0HVgdc
         qw/A==
X-Gm-Message-State: APjAAAVbk1uORBCAQItDA/nomf2sWog6Z/baHK53viqJ65OgEYtSxnI7
        19tPHcT2xqQBFWpGjeKdM8AHdg==
X-Google-Smtp-Source: APXvYqzEZHr++rXpm/+4LjCNYMAijW8CtJS9Cn162WoGwp318QgrRTFTYknyc7LTNjeMsMFQdZ0ZlQ==
X-Received: by 2002:a02:cd82:: with SMTP id l2mr22136386jap.96.1562601993197;
        Mon, 08 Jul 2019 09:06:33 -0700 (PDT)
Received: from mojatatu.com ([64.26.149.125])
        by smtp.gmail.com with ESMTPSA id f20sm16098738ioh.17.2019.07.08.09.06.31
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-SHA bits=128/128);
        Mon, 08 Jul 2019 09:06:32 -0700 (PDT)
From:   Roman Mashak <mrv@mojatatu.com>
To:     stephen@networkplumber.org
Cc:     netdev@vger.kernel.org, kernel@mojatatu.com, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us,
        Roman Mashak <mrv@mojatatu.com>
Subject: [PATCH iproute2 v2 2/2] tc: document 'mask' parameter in skbedit man page
Date:   Mon,  8 Jul 2019 12:06:18 -0400
Message-Id: <1562601978-3611-2-git-send-email-mrv@mojatatu.com>
X-Mailer: git-send-email 2.7.4
In-Reply-To: <1562601978-3611-1-git-send-email-mrv@mojatatu.com>
References: <1562601978-3611-1-git-send-email-mrv@mojatatu.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Signed-off-by: Roman Mashak <mrv@mojatatu.com>
---
 man/man8/tc-skbedit.8 | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/man/man8/tc-skbedit.8 b/man/man8/tc-skbedit.8
index 2459198261e6..704f63bdb061 100644
--- a/man/man8/tc-skbedit.8
+++ b/man/man8/tc-skbedit.8
@@ -9,8 +9,7 @@ skbedit - SKB editing action
 .IR QUEUE_MAPPING " ] ["
 .B priority
 .IR PRIORITY " ] ["
-.B mark
-.IR MARK " ] ["
+.BI mark " MARK\fR[\fB/\fIMASK] ] ["
 .B ptype
 .IR PTYPE " ] ["
 .BR inheritdsfield " ]"
@@ -49,12 +48,14 @@ or a hexadecimal major class ID optionally followed by a colon
 .RB ( : )
 and a hexadecimal minor class ID.
 .TP
-.BI mark " MARK"
+.BI mark " MARK\fR[\fB/\fIMASK]"
 Change the packet's firewall mark value.
 .I MARK
 is an unsigned 32bit value in automatically detected format (i.e., prefix with
 .RB ' 0x '
 for hexadecimal interpretation, etc.).
+.I MASK
+defines the 32-bit mask selecting bits of mark value. Default is 0xffffffff.
 .TP
 .BI ptype " PTYPE"
 Override the packet's type. Useful for setting packet type to host when
-- 
2.7.4

