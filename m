Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8DC84DB5E9
	for <lists+netdev@lfdr.de>; Thu, 17 Oct 2019 20:22:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2503265AbfJQSWY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Oct 2019 14:22:24 -0400
Received: from mail-pl1-f193.google.com ([209.85.214.193]:33750 "EHLO
        mail-pl1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2503264AbfJQSWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Oct 2019 14:22:21 -0400
Received: by mail-pl1-f193.google.com with SMTP id d22so1533404pls.0
        for <netdev@vger.kernel.org>; Thu, 17 Oct 2019 11:22:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=lzLYxMQPuX3j0S+19BebHHddmc9aRk1+XTwrLPXj5D8=;
        b=ecMgGXCZBY+SjJCsBYm1XLMZJQP0Fif+3xYd0vzGAVISWDlxfnmYLnx6iIBb/cnTm3
         dDzjbX95SK+vKQxyCJAyokX/dxJYfwOyOFQFB4KBbae4k2W+i+HM5PnjZoOROKDajGDW
         W8+SPZIlfY5VeEMRz7XfQyXuPGkBxU6+C07bFbGNA4uKmDdkIPs95fVAWmbD0HIP0wo8
         DEoHSCNWg8tkE5Rf6qgZHq84x9+pxOEzx8RJk8msN5ztCv/GTkmHB0oVuEBwdOvgi697
         IXHYzzyDmwbRYD4ypVd05BBrVOqQaRKwRIqeA+slVOdvnuqdOYJ3uxl90JwJXnC2Ynde
         b8eQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=lzLYxMQPuX3j0S+19BebHHddmc9aRk1+XTwrLPXj5D8=;
        b=kOLqaP9rqtM5UxoHAJQ3AURRqcVcY4zh6ysSa1Xry29XARLdvr7Rx6dkvqH9MWsDXn
         jxbKIqTPNtJwcWhfZKNtfACKjwsbsJiMv5E9tlUpBGCU7mvOibpK/X3AuC9sCJ4DcDTG
         zt2jPHrfJ5EDdA+rrgJ5fQmtPQypXvjs9mHuc+8nBqpRbTvudqlcfOoaDrcbP6l/ro6c
         7xYciOGbBqRQkpm0NvOn3Q6KQCCG918eDIms6iv0MKrJnrjAbjd9VYL3dSAX8I6jD3kF
         kmGQlNnSHF/DmOtJqhFz0TUk2BcOzehSJmmY1kbCwz1UVZu0DL1pNrMbY4ZR/+bXTO6U
         F7rA==
X-Gm-Message-State: APjAAAUC3mr5DoFWO1sDCByDWqrdr+ZFOK43eqfcnUgQR8P3zRPgZIVA
        eHZTc+3eZlGNu3em4AtdRRs=
X-Google-Smtp-Source: APXvYqzX9oPvBrtMkzrEovrXzpn+suF3mIACqkcJ2cQ1oflbbK4clJFO6SvCO4nJTya5pfp1KKCaxA==
X-Received: by 2002:a17:902:968d:: with SMTP id n13mr5571723plp.261.1571336540205;
        Thu, 17 Oct 2019 11:22:20 -0700 (PDT)
Received: from athina.mtv.corp.google.com ([2620:15c:211:0:c786:d9fd:ab91:6283])
        by smtp.gmail.com with ESMTPSA id p24sm6174603pgc.72.2019.10.17.11.22.19
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 17 Oct 2019 11:22:19 -0700 (PDT)
From:   =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <zenczykowski@gmail.com>
To:     =?UTF-8?q?Maciej=20=C5=BBenczykowski?= <maze@google.com>,
        "John W . Linville" <linville@tuxdriver.com>
Cc:     netdev@vger.kernel.org
Subject: [PATCH 31/33] fix unused parameter warning in ixgb_dump_regs()
Date:   Thu, 17 Oct 2019 11:21:19 -0700
Message-Id: <20191017182121.103569-31-zenczykowski@gmail.com>
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
  external/ethtool/ixgb.c:42:40: error: unused parameter 'info' [-Werror,-Wunused-parameter]
  ixgb_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)

Signed-off-by: Maciej Żenczykowski <maze@google.com>
Change-Id: I674e03805dc9a4633d0299d9f4e88bd4ddb61359
---
 ixgb.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/ixgb.c b/ixgb.c
index 8687c21..7c16c6e 100644
--- a/ixgb.c
+++ b/ixgb.c
@@ -38,8 +38,8 @@
 #define IXGB_RAH_ASEL_SRC         0x00010000
 #define IXGB_RAH_AV               0x80000000
 
-int
-ixgb_dump_regs(struct ethtool_drvinfo *info, struct ethtool_regs *regs)
+int ixgb_dump_regs(struct ethtool_drvinfo *info maybe_unused,
+		   struct ethtool_regs *regs)
 {
 	u32 *regs_buff = (u32 *)regs->data;
 	u8 version = (u8)(regs->version >> 24);
-- 
2.23.0.866.gb869b98d4c-goog

