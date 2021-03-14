Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78C6633A7ED
	for <lists+netdev@lfdr.de>; Sun, 14 Mar 2021 21:22:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234727AbhCNUTo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Mar 2021 16:19:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234481AbhCNUTS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Mar 2021 16:19:18 -0400
Received: from mail-pj1-x102e.google.com (mail-pj1-x102e.google.com [IPv6:2607:f8b0:4864:20::102e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6BBDBC061763;
        Sun, 14 Mar 2021 13:19:17 -0700 (PDT)
Received: by mail-pj1-x102e.google.com with SMTP id q2-20020a17090a2e02b02900bee668844dso13232216pjd.3;
        Sun, 14 Mar 2021 13:19:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=SYWbeDIMHmSJqbrX6B4NaMZZl7Va6n9FxO9uDLunw2g=;
        b=qr18IxLN85Xobab2HxpXtvDDlgD20g0HkgcdY2jqYGRT1pQIVD52LtuFYqBei438iL
         TLRx7dK5nsdCCl3UkJzyaqkidoZ6gldIAG58tOa4P22a8P0/sqMPJPfcyGEjNlJE7LFu
         s1YNwDuHscGi9/8wPXLDVzJYj0TOEc6qYIdcDQS4Jb9yiVx8DPaiX6BWFJ6Ml+W5K2Wq
         R2HYk4YbVLheA2PIOI2mYJPTlfu3J2DBEYfswNDUmIKNOyxAEp9PlYkKc4abScrcm2Op
         pg48FvbmDDW9qkJl4ncdxImyW8hK3jnYL7QW7s3Ge4laRjYstUycNpyPU6I8eIHk3W4O
         kEJw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=SYWbeDIMHmSJqbrX6B4NaMZZl7Va6n9FxO9uDLunw2g=;
        b=XXZoLs8JxbMBHl1/B/sBWqPKfN3GZjLUnRkU1Uddx3KUha/ukUOndU6xicr+ru/Hoy
         jXBdlqE1y1XYtrLbhWhWDxyFQ3sply2onVZgbMF8p9MDi+AuxPpherPKRcGdE+UQzPV3
         ZQT+5X7yc1a4foGzmZIlazjx8mDztUjQw1QXFKi/Zwb7tLGTWN+IeHoUrEjOyTizYf/Z
         VAYyZlXgXUb7N2JdqiqRy0oGC8ca8wYxxvwC8TCwQXbfNLG0FbxzJP/gkLsXqaFQggs3
         MLXflsJa3mcOnEVe+SDA7y2SgS1n5x5czZZGQ5BaGLBx0ohg2SYv74rkU9tEH5hJxv+L
         /2Cw==
X-Gm-Message-State: AOAM531I2Me0uRamhqRb0iXrSP1ewpJikI03PJIpeVwUi1ye6w0b2NYp
        OVJFh30Gs9WSvp2kajIe4kk=
X-Google-Smtp-Source: ABdhPJxu/yErDHUnL/5hN2IBDSYhoRwlweW7VqAFnzlmqkdeUDWYnYxnpcWF5rtU+Pov57c7hANKUw==
X-Received: by 2002:a17:902:d684:b029:e6:27a5:839e with SMTP id v4-20020a170902d684b02900e627a5839emr8088909ply.79.1615753156915;
        Sun, 14 Mar 2021 13:19:16 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:600d:a089:acdc:a5a5:c438:c1e3])
        by smtp.googlemail.com with ESMTPSA id n10sm10943793pgk.91.2021.03.14.13.19.12
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 14 Mar 2021 13:19:16 -0700 (PDT)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     siva8118@gmail.com
Cc:     yashsri421@gmail.com, lukas.bulwahn@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        amitkarwar@gmail.com, kvalo@codeaurora.org, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 10/10] rsi: rsi_usb: fix file header comment syntax
Date:   Mon, 15 Mar 2021 01:48:18 +0530
Message-Id: <20210314201818.27380-11-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20210314201818.27380-1-yashsri421@gmail.com>
References: <20210314201818.27380-1-yashsri421@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The opening comment mark '/**' is used for highlighting the beginning of
kernel-doc comments.

The header comment used in drivers/net/wireless/rsi/rsi_usb.h
follows kernel-doc syntax, i.e. starts with '/**'. But the content
inside the comment does not comply with kernel-doc specifications (i.e.,
function, struct, etc).

This causes unwelcomed warning from kernel-doc:
"warning: Cannot understand  * @section LICENSE
 on line 2 - I thought it was a doc line"

Replace this comment syntax with general comment format, i.e. '/*' to
prevent kernel-doc from parsing it.

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
 drivers/net/wireless/rsi/rsi_usb.h | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/wireless/rsi/rsi_usb.h b/drivers/net/wireless/rsi/rsi_usb.h
index 8702f434b569..254d19b66412 100644
--- a/drivers/net/wireless/rsi/rsi_usb.h
+++ b/drivers/net/wireless/rsi/rsi_usb.h
@@ -1,4 +1,4 @@
-/**
+/*
  * @section LICENSE
  * Copyright (c) 2014 Redpine Signals Inc.
  *
-- 
2.17.1

