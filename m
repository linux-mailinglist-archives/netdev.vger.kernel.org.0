Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BED5DB5DD
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:22:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2441331AbfJQSWC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:22:02 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:45202 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2441324AbfJQSWA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:22:00 -0400
Received: by mail-pf1-f193.google.com with SMTP id y72so2152670pfb.12
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:21:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=M/HWs+Prg10GgsJU8scihu/J7Hg7nIuRdtM5U73mKCI=;
        b=IwQOIoO2T1e91lhq2IZTH4AEBegnMdGXi9HT42ZY6BYFz/RjqH+ZhfKguoqnLqI0eR
         N6ax1rWQ0W/LfOb6vbGpuvdxAfDoPm+MQ4am57rZvFtovdnDpNggZyVOygYbGCBpkc2y
         /AJar6MV9lkCxXMTWXo6bxfGFf0KrnFn9Uhrz23d8Ljwo/m6lJyyLhTnNuvM4t4Al3H6
         vjGLRDrznfm4chz70022ivS2sAcoqbt4e+f+vOWYPrB7YHXzGH4u8lxBjbAeYLrpg5Pc
         QWgjKuEvEW5bbKdIcoZRyG9arJ19vstBhrxf8fXYxoTiuzQdDDTxpmE5MahRe96PoOmh
         EpIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=M/HWs+Prg10GgsJU8scihu/J7Hg7nIuRdtM5U73mKCI=;
        b=JQUDr1O0k+3GN3g8odiTdqF04V845GDiA7i2HmKRPG7LVtSzYCc6jcqvg2Grc2SvK7
         el+HOTQF8UkqFsTHGtVSSR6mHqKSfU9b6ocOAtggM98OCqSdr/geSE54E/VFpL/stdqN
         aoCWaJhlWjHBrEa1peLQB+6VZ/aXv4PnlEgER8ctEg2A2wAk1UvtkQo/02fKTsBT398W
         jdkiF1TEmwsbyaMlgS3ZgSleIu7Ldkv8BNciRVcSHIa7BwdvC5NrwjvjevDCg2S96ba+
         ++kR4gKYWC4xeGrpJNkTRRnR0Qtx8bn05gqQtBUBXGaZHW6jcUSmqGGHkFjtnsWsNMfx
         FgiA==
X-Gm-Message-State: APjAAAWTpJkvTWblM2zZBgDQ46O72ZTlDRReQH2wW5WAaqp4S1TuNfN7
        LpiGeWFFf8eP4DaRRBG6PqU=
X-Google-Smtp-Source: APXvYqzZtZd8k5AxAQK/ng0m75P0Z307zPdjzcDwEMP7DaXjM3iUUQhxAaS9jNc6M5Bu2RJ1SXb4DQ==
X-Received: by 2002:a17:90a:246e:: with SMTP id h101mr5918265pje.133.1571336519393;
        Thu, 17 Oct 2019 11:21:59 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.21.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:21:58 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 17/33] fix unused parameter warning in ixgbevf_dump_regs()
Date:   Thu, 17 Oct 2019 11:21:05 -0700
Message-Id: <20191017182121.103569-17-zenczykowski@gmail.com>
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
  external/ethtool/ixgbevf.c:6:43: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  ixgbevf_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: I6f3233ceb46bc6b96eca673578fa2a6281ea8ad7
---
 ixgbevf.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/ixgbevf.c b/ixgbevf.c
index 2a3aa6f..265e0bf 100644
--- a/ixgbevf.c
+++ b/ixgbevf.c
@@ -3,7 +3,8 @@
 #include "internal.h"
 
 int
-ixgbevf_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+ixgbevf_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+		  struct ethtool_regs *regs)
 {
 	u32 *regs_buff = (u32 *)regs->data;
 	u8 version = (u8)(regs->version >> 24);
-- 
2.23.0.866.gb869b98d4c-goog

