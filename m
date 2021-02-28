Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93AA6327369
	for <lists+netdev@lfdr.de>; Sun, 28 Feb 2021 17:59:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231161AbhB1Q7D (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Feb 2021 11:59:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46192 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230406AbhB1Q7B (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Feb 2021 11:59:01 -0500
Received: from mail-ed1-x52a.google.com (mail-ed1-x52a.google.com [IPv6:2a00:1450:4864:20::52a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 84A99C06174A;
        Sun, 28 Feb 2021 08:58:20 -0800 (PST)
Received: by mail-ed1-x52a.google.com with SMTP id b13so8343230edx.1;
        Sun, 28 Feb 2021 08:58:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=en8tMAUOhm0zol63EybWgdjah1Cfm8+uJE0ewWMGLR8=;
        b=LjAQMb/2mLqd8I0Qr753k4njtvN0STcSPRe+194lABtpckqihzrlIsXB2V+PFPbRx3
         gsBKYMkZSk/ZxGRAmkLpvmmkKfnkvu/gUBm/M1JatsnJE8+SjcoEezLn/CNrAxH5IPFa
         0FKFQmPCSc1UEkJBAE4QaWbPA7a/ggOAxPaYo3ZPcM5mbRUwsiE6Rnf4pXzQCIOm6ZLj
         WkhmRMyU1ftbrKCocdYLXiG4JaKYoGsXSpBX8MoRKzw0tKBJxTwRGA8eKMzGJ4QD5e7c
         fYkkXdCPY3xDZPizIjoPE6tCEUuGYmF0AqtgZq5PAzT4o8OshIMRGS1q449Tbtps1Otf
         aIfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=en8tMAUOhm0zol63EybWgdjah1Cfm8+uJE0ewWMGLR8=;
        b=laB0t4iIdq57+M66Bc9E2UszmzOWkxETOx26ilz4UOucfWsN/p+zuRhH8y30apJX3w
         2RdWFBPGWhQemLyItHSOidkqGxpCfh8u4px53JcepbAnXknUNyw+8XollVzPtWNAE6QI
         q8Th2dpuClnXxp86kSB3w0waeiZXjfWXeMjF0tDdBvIbLU8+1UBbfSF/TtiicumeqABg
         Naj3StzQF1MUeS3yhvEP4Mf9CI54e7fkIgDRt2+Pc2zCpIYFJHjDKBTlE7jXvtBZCiXx
         +RX4Bj2aEqdyFCtlchx9cve0gvi3h+uJZaMJ3mvzCbpnxEpKvczsi38Wj6YR8LKmcs3M
         T8LA==
X-Gm-Message-State: AOAM530x7udMoX+0zisYniJcTXwto4z5Xoa4Ggh6Zi+ZOijoaNkYHoi4
        RZd/gn4EGpV4DhY3NFGtIVRT2PYXAA==
X-Google-Smtp-Source: ABdhPJw5P2i5visZ8O/qmxk5jr6+NrOm5mVoM3YkRYvedXG7ed+OLhlp5GvWW4DQcQMGnD2DdLKm9g==
X-Received: by 2002:aa7:c95a:: with SMTP id h26mr12800318edt.166.1614531499325;
        Sun, 28 Feb 2021 08:58:19 -0800 (PST)
Received: from localhost.localdomain ([46.53.249.223])
        by smtp.gmail.com with ESMTPSA id t21sm10446091ejc.98.2021.02.28.08.58.18
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 28 Feb 2021 08:58:19 -0800 (PST)
Date:   Sun, 28 Feb 2021 19:58:17 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     torvalds@linux-foundation.org
Cc:     linux-kernel@vger.kernel.org, akpm@linux-foundation.org,
        3chas3@gmail.com, linux-atm-general@lists.sourceforge.net,
        netdev@vger.kernel.org
Subject: [PATCH 01/11] pragma once: delete include/linux/atm_suni.h
Message-ID: <YDvLqaIUVaoP8rtm@localhost.localdomain>
References: <YDvLYzsGu+l1pQ2y@localhost.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <YDvLYzsGu+l1pQ2y@localhost.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From c17ac63e1334c742686cd411736699c1d34d45a7 Mon Sep 17 00:00:00 2001
From: Alexey Dobriyan <adobriyan@gmail.com>
Date: Wed, 10 Feb 2021 21:07:45 +0300
Subject: [PATCH 01/11] pragma once: delete include/linux/atm_suni.h

This file has been empty since 2.3.99-pre3!
Delete it instead of converting to #pragma once.

Signed-off-by: Alexey Dobriyan <adobriyan@gmail.com>
---
 drivers/atm/fore200e.c   |  1 -
 drivers/atm/suni.c       |  1 -
 include/linux/atm_suni.h | 12 ------------
 3 files changed, 14 deletions(-)
 delete mode 100644 include/linux/atm_suni.h

diff --git a/drivers/atm/fore200e.c b/drivers/atm/fore200e.c
index 9a70bee84125..0b9c99c3d218 100644
--- a/drivers/atm/fore200e.c
+++ b/drivers/atm/fore200e.c
@@ -21,7 +21,6 @@
 #include <linux/module.h>
 #include <linux/atmdev.h>
 #include <linux/sonet.h>
-#include <linux/atm_suni.h>
 #include <linux/dma-mapping.h>
 #include <linux/delay.h>
 #include <linux/firmware.h>
diff --git a/drivers/atm/suni.c b/drivers/atm/suni.c
index c920a8c52925..21e5acc766b8 100644
--- a/drivers/atm/suni.c
+++ b/drivers/atm/suni.c
@@ -21,7 +21,6 @@
 #include <linux/timer.h>
 #include <linux/init.h>
 #include <linux/capability.h>
-#include <linux/atm_suni.h>
 #include <linux/slab.h>
 #include <asm/param.h>
 #include <linux/uaccess.h>
diff --git a/include/linux/atm_suni.h b/include/linux/atm_suni.h
deleted file mode 100644
index 84f3aab54468..000000000000
--- a/include/linux/atm_suni.h
+++ /dev/null
@@ -1,12 +0,0 @@
-/* atm_suni.h - Driver-specific declarations of the SUNI driver (for use by
-		driver-specific utilities) */
-
-/* Written 1998,2000 by Werner Almesberger, EPFL ICA */
-
-
-#ifndef LINUX_ATM_SUNI_H
-#define LINUX_ATM_SUNI_H
-
-/* everything obsoleted */
-
-#endif
-- 
2.29.2

