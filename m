Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 32D8CDB605
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:23:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441318AbfJQSW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:22:56 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:45930 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441344AbfJQSWH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:22:07 -0400
Received: by mail-pg1-f195.google.com with SMTP id r1so1804582pgj.12
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:22:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=7MJ8FuqY5rYx0yhsHv82y5ugUq0G8lPECWCsSMKMc4Q=;
        b=g/lksoTOYHKr4dkxEk9amaAq7FH1tMdzUlFSbKg4seh32mOeNrJ/BduQkEQObwy/GG
         rSJhhNAiZ0ULNDqd+OAYdzc782bLVUyx3zqUjEMtHWJAYBHBTiYxJTJ45YEuMNFz7c+f
         mIq0TreTLiFBFbQHM4MoQxJS00p/cRTereWMr35UYQZvc6Fp17YhPETVt9/5NoSnM09H
         qy/4kGj69DXdXDP0CyKhm4TzI0LkfBoixtkJqabnQFHfp+QlJKjU7NRj65Q6M+oFoo35
         MljV54vyK9Xr/1wEmrX4OND4KIwSCBaWq1jTDp3K4nyKcCxnsrVSxmZH+RFz2KnMcFAi
         gmRQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=7MJ8FuqY5rYx0yhsHv82y5ugUq0G8lPECWCsSMKMc4Q=;
        b=B8F+GcH2L6SqWN2r9h4npoDtQc0eVsbFJ9BzE5c43m+CI0VZBppRTREPkT8MAS2MAN
         0bXvI/DutzgOqEsgjLRxJCgqQ2uIn1ufLstixQPRs8O3viK406UnahbR07kv/XGNKfKo
         1TcNf5LkJttKUHheKIo0h2q6UaYV1SkYSiqwSbn8uyT7cuevBhK+ttbAiHjFNiKZ31Qa
         uzS49fcO3MQ4pJAHW96orvVFCgDsz98WqrVFDh2pPOTRJwDDlnic4roYGon7050uwXud
         4rYExW7oWa9L9WwpaxoyChBUJ7QEg318fgefqo79HD1HbsW9eh5j1fvIAxTFOgyHZhV1
         MBsw==
X-Gm-Message-State: APjAAAXtzUX1zKxeHxtL24uDFJZCuybTmUdxrrELHAoFZxUAZJ1DTZlV
        rQQtvWrP5CVCW3sHovuFlMaYwaqW
X-Google-Smtp-Source: APXvYqyW3FxCK8THKYAaEFkMvMhfqrclWiGlwdNRpIZ7NfNkWTg9WctBnc6OQPQ7Bf2QXG9wYsm1/g==
X-Received: by 2002:a63:5509:: with SMTP id j9mr5549883pgb.261.1571336525995;
        Thu, 17 Oct 2019 11:22:05 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.22.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:22:05 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 21/33] fix unused parameter warning in e100_dump_regs()
Date:   Thu, 17 Oct 2019 11:21:09 -0700
Message-Id: <20191017182121.103569-21-zenczykowski@gmail.com>
X-Mailer: git-send-email 2.23.0.866.gb869b98d4c-goog
In-Reply-To: <20191017182121.103569-1-zenczykowski@gmail.com>
References: <CAHo-Ooze4yTO_yeimV-XSD=AXvvd0BmbKdvUK4bKWN=+LXirYQ@mail.gmail.com>
 <20191017182121.103569-1-zenczykowski@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Maciej Żenczykowski <maze@google.com>

This fixes:
  external/ethtool/e100.c:40:40: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  e100_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: Idc6e3bb3fb837555425ddd6cc903e8763a4c71e1
---
 e100.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/e100.c b/e100.c
index b982e79..540ae35 100644
--- a/e100.c
+++ b/e100.c
@@ -36,8 +36,8 @@
 #define CU_CMD			0x00F0
 #define RU_CMD			0x0007
 
-int
-e100_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+int e100_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+		   struct ethtool_regs *regs)
 {
 	u32 *regs_buff = (u32 *)regs->data;
 	u8 version = (u8)(regs->version >> 24);
-- 
2.23.0.866.gb869b98d4c-goog

