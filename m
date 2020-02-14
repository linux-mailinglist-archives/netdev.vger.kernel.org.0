Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2771315F826
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 21:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389819AbgBNUuL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 15:50:11 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:50596 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388650AbgBNUs6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 15:48:58 -0500
Received: by mail-wm1-f66.google.com with SMTP id a5so11325884wmb.0;
        Fri, 14 Feb 2020 12:48:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=QfadLLWZFDK0HW1MeHL/yYg616BevIp9ZGw1GPPO0/0=;
        b=HUhU9ihKMpebXnodYzcr6vYwtC8bdpB8oxQa8rtJBmB+xksqy8O2aLAF5UvjeiPmul
         LC1xq8Ngplhb4m01IXk/MPBsKXi6Oi5iFFiwnrJ6glSe0/YsYX7ttf8UOqS2Z4ZeLoT7
         HhngVua4KhpJ8+4hbEIxVgypcvHitU+7cOwW0zswVD1CsYtzLiAVAjNVpRm8kzdvf9Tt
         pg5C/5oQLIHwWxSWbI522Fn8yRQELqi0baz07ePgjCufAVKiTf3c6Oi9kZYzz+D6oGxP
         RqRPoIjR/a8pS0OsONbxqrgBwLEWwal///NREZDYCIev3zgbaHic/A7kdhUpqm1kkPA+
         TWPA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=QfadLLWZFDK0HW1MeHL/yYg616BevIp9ZGw1GPPO0/0=;
        b=TwSQ/WqOixe4ukkOZ5ZJtZEuH/UDGBTuXxJswV52P7vABBwo6df752UasOTcm0tkaC
         wLgG9uba5vbSC3qWOn193mQ/a9MVxXfdT44oSpgoVNldpJ6QdZtch4xgyQgLMNPfICE2
         Ckdwn5jqiiCecePtujdmRlT0FrMDKbJTL1maqZCwzA1ONGP23cuuO57SC2tlNXG4Ip6q
         J0KVECGnLexB8O3gj0e8ZDvzwGPIvUuoCW/lggvX77MZcD7ZxnWu4QM8gMXWnDqBYYUU
         ZuEXOkzvD7I9q9qkNeCWqg5NqHqkpyC+PM9h2/2PckSGKJR7GPvAO2RBfZNIS6OzR4Cr
         u0KA==
X-Gm-Message-State: APjAAAUlcmkldXVMPupsJkMaE723ro+7ezQjln45E/jZ/rS90HfeIW/+
        4EHEFGsBSwB6/6K6xhA208U1+8QOXQPE
X-Google-Smtp-Source: APXvYqxniUnwEd16DVrtt5snPqjC+/Ihrq2d/flim0WgiDRCJIaJFWNV03e83MZL/2lm6myw25ihTg==
X-Received: by 2002:a7b:c851:: with SMTP id c17mr6313167wml.71.1581713335973;
        Fri, 14 Feb 2020 12:48:55 -0800 (PST)
Received: from ninjahost.lan (host-2-102-13-223.as13285.net. [2.102.13.223])
        by smtp.googlemail.com with ESMTPSA id y12sm8660782wmj.6.2020.02.14.12.48.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 14 Feb 2020 12:48:55 -0800 (PST)
From:   Jules Irenge <jbi.octave@gmail.com>
To:     linux-kernel@vger.kernel.org
Cc:     boqun.feng@gmail.com, Jules Irenge <jbi.octave@gmail.com>,
        Don Fry <pcnet32@frontier.com>,
        "David S. Miller" <davem@davemloft.net>,
        netdev@vger.kernel.org (open list:PCNET32 NETWORK DRIVER)
Subject: [PATCH 20/30] pcnet32: Add missing annotation for pcnet32_suspend()
Date:   Fri, 14 Feb 2020 20:47:31 +0000
Message-Id: <20200214204741.94112-21-jbi.octave@gmail.com>
X-Mailer: git-send-email 2.24.1
In-Reply-To: <20200214204741.94112-1-jbi.octave@gmail.com>
References: <0/30>
 <20200214204741.94112-1-jbi.octave@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sparse reports a warning at pcnet32_suspend()

warning: context imbalance in pcnet32_suspend() - unexpected unlock

The root cause is the missing annotation at pcnet32_suspend()
Add the missing __must_hold(&lp->lock) annotattion

Signed-off-by: Jules Irenge <jbi.octave@gmail.com>
---
 drivers/net/ethernet/amd/pcnet32.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/amd/pcnet32.c b/drivers/net/ethernet/amd/pcnet32.c
index dc7d88227e76..ac6c19441932 100644
--- a/drivers/net/ethernet/amd/pcnet32.c
+++ b/drivers/net/ethernet/amd/pcnet32.c
@@ -684,7 +684,7 @@ static void pcnet32_poll_controller(struct net_device *dev)
  * lp->lock must be held.
  */
 static int pcnet32_suspend(struct net_device *dev, unsigned long *flags,
-			   int can_sleep)
+			   int can_sleep) __must_hold(&lp->lock)
 {
 	int csr5;
 	struct pcnet32_private *lp = netdev_priv(dev);
-- 
2.24.1

