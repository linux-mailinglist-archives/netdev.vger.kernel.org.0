Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 604DB3F312B
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 18:10:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236436AbhHTQKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 12:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232622AbhHTQIC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 12:08:02 -0400
Received: from mail-il1-x12f.google.com (mail-il1-x12f.google.com [IPv6:2607:f8b0:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3AE2C061A2E
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 09:01:35 -0700 (PDT)
Received: by mail-il1-x12f.google.com with SMTP id z2so10059196iln.0
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 09:01:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=+xvyCS57Ky9mXjy9GSWsgQWRoboZkVQYnv00hsJDwZ0=;
        b=sdFug4DY3//S741fPrvcmjuXsmN1mMCQe+xaHE/ZIT7g6dD4QSftvDT6wEXluYfT7h
         XZlejSColDSo/bzBoUNPnMfXaEEc6E9lZLw+KFM77XSqLeXDeLdSoObgFODtP2ZcuUjd
         pGWTabfMiZQv79TT8FJlwFxWE55sculkfW61bBlJd1fTS96rL2j2W5uHWvlE74RUML8P
         o+tlfS1iHe1hhHLWtQK958C0Jd6uYdhuAwGUdQBfQWhmFlurAEcCnDcYVu0IEGxfwP6d
         G5Tj0X+B8mhUSJSafW6OT2ryfuza1IJ0WkjLQLdvJs6sVuWrnpbSkVYz50o6PghUCAU2
         0CRg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=+xvyCS57Ky9mXjy9GSWsgQWRoboZkVQYnv00hsJDwZ0=;
        b=NCxoScTN7Vg3rsWU9oxl3YYWYLDWeCAs6KKCUzAl5GErudK4CbNKwEApnHGIqiPSpl
         iu1X3rZ3uZs7bW99naFHk/+GnAxoYjYdnkozcYEUj8GzwfZ0q/ByI0dJn1KKnTj5Ls5y
         emriYDpeUbJXkl68Flx/sid3nxainqqrNxRY+ihMk+r7t+dqTX4bI5kfSHXVqzBeNVsp
         gjTI//M+8HCVU7mx9kEBKFLF6o9ncD8iYtlJ1iZ6H1SUkmnbkUax/KJ4IgVJb8Jp0oZN
         bjxzbcFSjRq5MUQHHmdJtOqX7qW7IP/ql5LupZriAQNbhhxtlhsYT5CHN5YMK8abZbrv
         x+Ww==
X-Gm-Message-State: AOAM533dlMWes+JK/ev2rMULQrK2nvu0UZQkPVf9XDfo24bzVX6xMToO
        TFXh88UKKTaNhQXI5JqmCYecZA==
X-Google-Smtp-Source: ABdhPJywRI8c+svTbMRdCq89d+DGH5ZvU162aCpGt6eB2SvWjt6J+CBf20kYrzSlWMbsgeWIcR6blg==
X-Received: by 2002:a92:6610:: with SMTP id a16mr13534176ilc.71.1629475295431;
        Fri, 20 Aug 2021 09:01:35 -0700 (PDT)
Received: from localhost.localdomain (c-73-185-129-58.hsd1.mn.comcast.net. [73.185.129.58])
        by smtp.gmail.com with ESMTPSA id a8sm3521317ilq.63.2021.08.20.09.01.34
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 20 Aug 2021 09:01:35 -0700 (PDT)
From:   Alex Elder <elder@linaro.org>
To:     davem@davemloft.net, kuba@kernel.org
Cc:     bjorn.andersson@linaro.org, evgreen@chromium.org,
        cpratapa@codeaurora.org, subashab@codeaurora.org, elder@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH net-next 3/3] net: ipa: rename "ipa_clock.c"
Date:   Fri, 20 Aug 2021 11:01:29 -0500
Message-Id: <20210820160129.3473253-4-elder@linaro.org>
X-Mailer: git-send-email 2.27.0
In-Reply-To: <20210820160129.3473253-1-elder@linaro.org>
References: <20210820160129.3473253-1-elder@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Finally, rename "ipa_clock.c" to be "ipa_power.c" and "ipa_clock.h"
to be "ipa_power.h".

Signed-off-by: Alex Elder <elder@linaro.org>
---
 drivers/net/ipa/Makefile                     | 2 +-
 drivers/net/ipa/ipa_endpoint.c               | 2 +-
 drivers/net/ipa/ipa_main.c                   | 2 +-
 drivers/net/ipa/ipa_modem.c                  | 2 +-
 drivers/net/ipa/{ipa_clock.c => ipa_power.c} | 2 +-
 drivers/net/ipa/{ipa_clock.h => ipa_power.h} | 6 +++---
 6 files changed, 8 insertions(+), 8 deletions(-)
 rename drivers/net/ipa/{ipa_clock.c => ipa_power.c} (99%)
 rename drivers/net/ipa/{ipa_clock.h => ipa_power.h} (95%)

diff --git a/drivers/net/ipa/Makefile b/drivers/net/ipa/Makefile
index 75435d40b9200..bdfb2430ab2c7 100644
--- a/drivers/net/ipa/Makefile
+++ b/drivers/net/ipa/Makefile
@@ -1,6 +1,6 @@
 obj-$(CONFIG_QCOM_IPA)	+=	ipa.o
 
-ipa-y			:=	ipa_main.o ipa_clock.o ipa_reg.o ipa_mem.o \
+ipa-y			:=	ipa_main.o ipa_power.o ipa_reg.o ipa_mem.o \
 				ipa_table.o ipa_interrupt.o gsi.o gsi_trans.o \
 				ipa_gsi.o ipa_smp2p.o ipa_uc.o \
 				ipa_endpoint.o ipa_cmd.o ipa_modem.o \
diff --git a/drivers/net/ipa/ipa_endpoint.c b/drivers/net/ipa/ipa_endpoint.c
index f88b43d44ba10..5528d97110d56 100644
--- a/drivers/net/ipa/ipa_endpoint.c
+++ b/drivers/net/ipa/ipa_endpoint.c
@@ -21,7 +21,7 @@
 #include "ipa_modem.h"
 #include "ipa_table.h"
 #include "ipa_gsi.h"
-#include "ipa_clock.h"
+#include "ipa_power.h"
 
 #define atomic_dec_not_zero(v)	atomic_add_unless((v), -1, 0)
 
diff --git a/drivers/net/ipa/ipa_main.c b/drivers/net/ipa/ipa_main.c
index c8d9c6db0b7ed..cdfa98a76e1f4 100644
--- a/drivers/net/ipa/ipa_main.c
+++ b/drivers/net/ipa/ipa_main.c
@@ -20,7 +20,7 @@
 #include <linux/soc/qcom/mdt_loader.h>
 
 #include "ipa.h"
-#include "ipa_clock.h"
+#include "ipa_power.h"
 #include "ipa_data.h"
 #include "ipa_endpoint.h"
 #include "ipa_resource.h"
diff --git a/drivers/net/ipa/ipa_modem.c b/drivers/net/ipa/ipa_modem.c
index 2ed80855f7cf1..ad116bcc0580e 100644
--- a/drivers/net/ipa/ipa_modem.c
+++ b/drivers/net/ipa/ipa_modem.c
@@ -21,7 +21,7 @@
 #include "ipa_smp2p.h"
 #include "ipa_qmi.h"
 #include "ipa_uc.h"
-#include "ipa_clock.h"
+#include "ipa_power.h"
 
 #define IPA_NETDEV_NAME		"rmnet_ipa%d"
 #define IPA_NETDEV_TAILROOM	0	/* for padding by mux layer */
diff --git a/drivers/net/ipa/ipa_clock.c b/drivers/net/ipa/ipa_power.c
similarity index 99%
rename from drivers/net/ipa/ipa_clock.c
rename to drivers/net/ipa/ipa_power.c
index 3ebc44ea7f3c8..b1c6c0fcb654f 100644
--- a/drivers/net/ipa/ipa_clock.c
+++ b/drivers/net/ipa/ipa_power.c
@@ -12,7 +12,7 @@
 #include <linux/bitops.h>
 
 #include "ipa.h"
-#include "ipa_clock.h"
+#include "ipa_power.h"
 #include "ipa_endpoint.h"
 #include "ipa_modem.h"
 #include "ipa_data.h"
diff --git a/drivers/net/ipa/ipa_clock.h b/drivers/net/ipa/ipa_power.h
similarity index 95%
rename from drivers/net/ipa/ipa_clock.h
rename to drivers/net/ipa/ipa_power.h
index 7a6a910241c1f..2151805d7fbb0 100644
--- a/drivers/net/ipa/ipa_clock.h
+++ b/drivers/net/ipa/ipa_power.h
@@ -3,8 +3,8 @@
 /* Copyright (c) 2012-2018, The Linux Foundation. All rights reserved.
  * Copyright (C) 2018-2020 Linaro Ltd.
  */
-#ifndef _IPA_CLOCK_H_
-#define _IPA_CLOCK_H_
+#ifndef _IPA_POWER_H_
+#define _IPA_POWER_H_
 
 struct device;
 
@@ -70,4 +70,4 @@ struct ipa_power *ipa_power_init(struct device *dev,
  */
 void ipa_power_exit(struct ipa_power *power);
 
-#endif /* _IPA_CLOCK_H_ */
+#endif /* _IPA_POWER_H_ */
-- 
2.27.0

