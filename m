Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAAD633C44A
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 18:33:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236267AbhCORdX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 13:33:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234049AbhCORdK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 13:33:10 -0400
Received: from mail-pl1-x62c.google.com (mail-pl1-x62c.google.com [IPv6:2607:f8b0:4864:20::62c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F487C06174A;
        Mon, 15 Mar 2021 10:33:10 -0700 (PDT)
Received: by mail-pl1-x62c.google.com with SMTP id z5so15668620plg.3;
        Mon, 15 Mar 2021 10:33:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=JVL1LdnC9riyRpbnJrHgoR/ByMBICezHbJM/3f4VGqk=;
        b=l/8CHKwpbPpr5pQct7s45rPhRAXpdacnGnqYDPhksHU/+rHlvCB8KxPX4wZ5z/Bq9a
         wTrxF8wYseMXjOFCYxVbsrvlniJanpcrgdanJr2qYjlLCa2UDFDOhBm3rsajfSAQhBJM
         UhU+Qi7XkMXu38SwM6g7yGIuAEwt6hbYmeJaR8AffwZuAQ1VUE5Ej08laKe9bh3Ne4E7
         Ytm1jILF31M2hGEkBxh14AgPh3oLZeXaQqzv4mhl3HlmmdUErnQ6Je2tVfhd00Gal9iA
         j3Yt0WQuhoskEmJq8on/ludZ6o+IDaTjT1eS2ePSx9qH7YgkQNW3Nnmaz/leA+YbbIgH
         6fIQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=JVL1LdnC9riyRpbnJrHgoR/ByMBICezHbJM/3f4VGqk=;
        b=DMnH189pfaPON9t+apJR/cVxErmV52yWAhTdF3pqvU11ei2jRHnlg5ZrH6ES2tt6tX
         /Zwn159dUGSq8C8LRJH3wxP9mZ+ma+/dQZ/iJlVgW2mooqqz6CbHUCNdeNgxuDIqEEqR
         hQiLbxYFAr4QGsRmUov1viC2ggTgcA0f0nqcHk6kZWrXxxgZ2diWW8udMeQUPJcqwvwI
         Eze9VPJvtAlTDfNUgHz2yJPIaZpX+lw+RZLV+skiAwcXGFKdTOUiLmFnmS9CVTM82Uj6
         qpeIenpHRgXE8l4+cZ69uLJdseUqnr0ZHA7ArLrw8Qu/FRNawnQS/Yf7yQJv659Hj/Yq
         fDUA==
X-Gm-Message-State: AOAM532bf16jTzTF4SMSebbVWv7eV4amMBZSBBDIzKQJo2BSCIm6kPVo
        rTrVSkrIpQGlcCW15x9MGCk=
X-Google-Smtp-Source: ABdhPJw4d1C0VzZto8nQ3ly7wtLCvTXvYzyjwc3JUJn6MHoOyC5o0PS4i+ywz2rBHxPREp7OxQvBUQ==
X-Received: by 2002:a17:90a:ec15:: with SMTP id l21mr177524pjy.164.1615829589493;
        Mon, 15 Mar 2021 10:33:09 -0700 (PDT)
Received: from localhost.localdomain ([2405:201:600d:a089:d096:1684:81a3:45b7])
        by smtp.googlemail.com with ESMTPSA id 184sm13450898pgj.93.2021.03.15.10.33.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 15 Mar 2021 10:33:09 -0700 (PDT)
From:   Aditya Srivastava <yashsri421@gmail.com>
To:     kvalo@codeaurora.org
Cc:     yashsri421@gmail.com, lukas.bulwahn@gmail.com,
        linux-kernel-mentees@lists.linuxfoundation.org,
        amitkarwar@gmail.com, siva8118@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH v2] rsi: fix comment syntax in file headers
Date:   Mon, 15 Mar 2021 23:02:59 +0530
Message-Id: <20210315173259.8757-1-yashsri421@gmail.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The opening comment mark '/**' is used for highlighting the beginning of
kernel-doc comments.
There are some files in drivers/net/wireless/rsi which follow this syntax
in their file headers, i.e. start with '/**' like comments, which causes
unexpected warnings from kernel-doc.

E.g., running scripts/kernel-doc -none on drivers/net/wireless/rsi/rsi_coex.h
causes this warning:
"warning: wrong kernel-doc identifier on line:
 * Copyright (c) 2018 Redpine Signals Inc."

Similarly for other files too.

Provide a simple fix by replacing such occurrences with general comment
format, i.e., "/*", to prevent kernel-doc from parsing it.

Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>
---
- Applies perfectly on next-20210312

Changes in v2:
- Convert the patch series to a single patch as suggested by Lukas and Kalle

 drivers/net/wireless/rsi/rsi_boot_params.h | 2 +-
 drivers/net/wireless/rsi/rsi_coex.h        | 2 +-
 drivers/net/wireless/rsi/rsi_common.h      | 2 +-
 drivers/net/wireless/rsi/rsi_debugfs.h     | 2 +-
 drivers/net/wireless/rsi/rsi_hal.h         | 2 +-
 drivers/net/wireless/rsi/rsi_main.h        | 2 +-
 drivers/net/wireless/rsi/rsi_mgmt.h        | 2 +-
 drivers/net/wireless/rsi/rsi_ps.h          | 2 +-
 drivers/net/wireless/rsi/rsi_sdio.h        | 2 +-
 drivers/net/wireless/rsi/rsi_usb.h         | 2 +-
 10 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/drivers/net/wireless/rsi/rsi_boot_params.h b/drivers/net/wireless/rsi/rsi_boot_params.h
index c1cf19d1e376..30e03aa6a529 100644
--- a/drivers/net/wireless/rsi/rsi_boot_params.h
+++ b/drivers/net/wireless/rsi/rsi_boot_params.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright (c) 2014 Redpine Signals Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
diff --git a/drivers/net/wireless/rsi/rsi_coex.h b/drivers/net/wireless/rsi/rsi_coex.h
index 0fdc67f37a56..2c14e4c651b9 100644
--- a/drivers/net/wireless/rsi/rsi_coex.h
+++ b/drivers/net/wireless/rsi/rsi_coex.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright (c) 2018 Redpine Signals Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
diff --git a/drivers/net/wireless/rsi/rsi_common.h b/drivers/net/wireless/rsi/rsi_common.h
index 60f1f286b030..7aa5124575cf 100644
--- a/drivers/net/wireless/rsi/rsi_common.h
+++ b/drivers/net/wireless/rsi/rsi_common.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright (c) 2014 Redpine Signals Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
diff --git a/drivers/net/wireless/rsi/rsi_debugfs.h b/drivers/net/wireless/rsi/rsi_debugfs.h
index 580ad3b3f710..a6a28640ad40 100644
--- a/drivers/net/wireless/rsi/rsi_debugfs.h
+++ b/drivers/net/wireless/rsi/rsi_debugfs.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright (c) 2014 Redpine Signals Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
diff --git a/drivers/net/wireless/rsi/rsi_hal.h b/drivers/net/wireless/rsi/rsi_hal.h
index 46e36df9e8e3..d044a440fa08 100644
--- a/drivers/net/wireless/rsi/rsi_hal.h
+++ b/drivers/net/wireless/rsi/rsi_hal.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright (c) 2017 Redpine Signals Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
diff --git a/drivers/net/wireless/rsi/rsi_main.h b/drivers/net/wireless/rsi/rsi_main.h
index 73a19e43106b..a1065e5a92b4 100644
--- a/drivers/net/wireless/rsi/rsi_main.h
+++ b/drivers/net/wireless/rsi/rsi_main.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright (c) 2014 Redpine Signals Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
diff --git a/drivers/net/wireless/rsi/rsi_mgmt.h b/drivers/net/wireless/rsi/rsi_mgmt.h
index 2ce2dcf57441..236b21482f38 100644
--- a/drivers/net/wireless/rsi/rsi_mgmt.h
+++ b/drivers/net/wireless/rsi/rsi_mgmt.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright (c) 2014 Redpine Signals Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
diff --git a/drivers/net/wireless/rsi/rsi_ps.h b/drivers/net/wireless/rsi/rsi_ps.h
index 98ff6a4ced57..0be2f1e201e5 100644
--- a/drivers/net/wireless/rsi/rsi_ps.h
+++ b/drivers/net/wireless/rsi/rsi_ps.h
@@ -1,4 +1,4 @@
-/**
+/*
  * Copyright (c) 2017 Redpine Signals Inc.
  *
  * Permission to use, copy, modify, and/or distribute this software for any
diff --git a/drivers/net/wireless/rsi/rsi_sdio.h b/drivers/net/wireless/rsi/rsi_sdio.h
index 1c756263cf15..7c91b126b350 100644
--- a/drivers/net/wireless/rsi/rsi_sdio.h
+++ b/drivers/net/wireless/rsi/rsi_sdio.h
@@ -1,4 +1,4 @@
-/**
+/*
  * @section LICENSE
  * Copyright (c) 2014 Redpine Signals Inc.
  *
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

