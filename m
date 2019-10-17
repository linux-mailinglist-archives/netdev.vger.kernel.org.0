Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 278E3DB5EC
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:22:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503280AbfJQSW3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:22:29 -0400
Received: from mail-pl1-f195.google.com ([209.85.214.195]:43011 "EHLO
        mail-pl1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503268AbfJQSWX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:22:23 -0400
Received: by mail-pl1-f195.google.com with SMTP id f21so1512310plj.10
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:22:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=e/VTNRejakrnuFJ/Ee4y4uu2FTKbgzJ4pn5plZZCv9s=;
        b=WrcZ0RvUy7pnTKz083BXVZqojvPtMAoEbSFJ+YVy+9d9qT12emFdsliAEon73NJTBr
         A3w6H/n44JLNcEE7eZqXuntaQmGKBZ2tRoERJi1a14b/rKSETCG+31EwzqhVBae4SRa5
         CDmnVNTVDZqWF3HSblLf9tRQl5quWIUq1X3IRSQFcoG9/rEZbykgt+LH/T3/VnY3Wkkk
         CX0y8yBlP8WpBSkJ1Dm2wGVYb2TdCUjEqPOBia0vi88vPEWn4VzJwDpCyzPWzewhA7cT
         DSVCsKVgWZi9p5uAvpeGvzovfR8Y/VnwThGoIxen+D43uGoF8wMFza/2CFceTpQBwvCp
         yeSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=e/VTNRejakrnuFJ/Ee4y4uu2FTKbgzJ4pn5plZZCv9s=;
        b=YjzyW326iIUjOTLfSy82j6CfMtTlxTpAdHCg/Y81kAqACuhTOs4FAtv0lF5g8h6p5H
         X06rRaRifEjTeRWqB/LIB/3ggId7pD0X3HHE6x5bQ5VQ3N7Hyd43+ItPJzSpdayGrArW
         5uTfSEVnLJz8OsIwh08b0m/+cxyjYQOy9fL1qRiI+ipinqpwUJ0bid7SbT/dcOfXp+Wn
         IaeHP7HoAfamGzm3R/ZL1bXEUX983fypRLbaVUA9WEIyS53+KFAWVgPzOroBv6ra8qLj
         XnL0cPDXky5MelKY9m72gprE/4VmwuIGM/JK3QnMWYMrlMb6o1ux1XAvu/Ozm6hmgOsK
         uhHw==
X-Gm-Message-State: APjAAAWccF/Xb9T5BcQZVczuxdUQQ9xvjPJsDyV9LOFoUnaDKXCGhxRu
        KyJSNsZqOuiJRdkm3hIgGPgMYWBv
X-Google-Smtp-Source: APXvYqxLC8G8qj0ZwvMEk1UJXNnqUwmqnY2U5ShtZkyWOWrwu7uCQAi8dWqadFR+SZqhH4ju0bCxzg==
X-Received: by 2002:a17:902:be06:: with SMTP id r6mr5280412pls.159.1571336542908;
        Thu, 17 Oct 2019 11:22:22 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.22.20
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:22:20 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 32/33] fix unused parameter warning in fjes_dump_regs()
Date:   Thu, 17 Oct 2019 11:21:20 -0700
Message-Id: <20191017182121.103569-32-zenczykowski@gmail.com>
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
  external/ethtool/fjes.c:5:44: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  int fjes_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: Id5409c70e26f4e131a8557a9c8f0a0c921dfefde
---
 fjes.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/fjes.c b/fjes.c
index 52f7c28..4c5f6bc 100644
--- a/fjes.c
+++ b/fjes.c
@@ -2,7 +2,8 @@
 #include <stdio.h>
 #include "internal.h"
 
-int fjes_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+int fjes_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+		   struct ethtool_regs *regs)
 {
 	u32 *regs_buff = (u32 *)regs->data;
 
-- 
2.23.0.866.gb869b98d4c-goog

