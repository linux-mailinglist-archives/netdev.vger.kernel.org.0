Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 85C512CBBE2
	for <lists+netdev@lfdr.de>; Wed,  2 Dec 2020 12:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729771AbgLBLsn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Dec 2020 06:48:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726539AbgLBLsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Dec 2020 06:48:42 -0500
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42201C0613D6;
        Wed,  2 Dec 2020 03:48:17 -0800 (PST)
Received: by mail-pj1-x1044.google.com with SMTP id l23so851459pjg.1;
        Wed, 02 Dec 2020 03:48:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=vFAjt0Td72sO7ptEv+X075oaFipYTY8EyRS2yMR9YTM=;
        b=p3/TtTGRzujYNFn/jOv92CV4UoK3prIhP3DoPoH/bN4wKxrjMd8f7a2MCfq5hwk9Ek
         PiR+naQMIYvy9hawMIlcaH5WI/1Kaqkbi2Zmb55BmiLSb1v5cWQE8ilvwc3ofCBrbXSV
         C9vST7UB6ZsOvYQDz0144xr4HCi4ZMAzJrXzAzHFwDYeKJEc4GVpdvy6/Q6D6f9/sOIN
         tF51U759PnsIGdh5cXY0VXmkY/A/q8J2vCtgpXH1eN2Xsg2pgpYuwB65TMYVfn1ACqhw
         A9AIjuzMVuP/I4KBOawhmWNhg9HgiAL1cscq8LHVz2tsn1tqdD41lbdaAWb7kh2azeEx
         G31A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=vFAjt0Td72sO7ptEv+X075oaFipYTY8EyRS2yMR9YTM=;
        b=Y0SlIrmwdJALRCL/BjicxSrVNAlscG0fgXxPZUVDu3AnXJcWYzDinDXXZoIaUm4XPS
         vqVW1iSMS8ihkg5GWVNfqOKAeFPoFcqDWcEBKJqbRpsNxl+WWHI9VqeYz426MMBbr6Yf
         fTyn6/SZPzJP9hkbdfsnhw8YN5sCQMqTKS+KyzG/jLW+yeRLC5uivwUr0ESv8lulaasW
         fmzy6i9eQI+SmRdcUwyUfzAqXAeWAaD2Otl/Jtp2UQDEaCltnQkpWMET7fLxuxmPOYbG
         3oUXE+RVJpvCozNwXGAP5Dvu/f6TSsbvKrPlGMIq9qs2lzs1CCS6rem7147J0DE5UnBd
         7/vg==
X-Gm-Message-State: AOAM5329fI0aFEQSE8iUuHLHyOE6cDpLBynuNu7jBfKssKRqgcZDdjg9
        EOvRrbZdf8zSpq6nzmMzWzqcIEcft8M=
X-Google-Smtp-Source: ABdhPJxWWVRus7qaQsLZuzKdH0maLn0ISipzCYJexmhqEAX5hDvvbkUb7WXzrwuLrSsISZh+4fFEkg==
X-Received: by 2002:a17:902:7606:b029:da:1f26:a1bf with SMTP id k6-20020a1709027606b02900da1f26a1bfmr2208232pll.53.1606909696907;
        Wed, 02 Dec 2020 03:48:16 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id q18sm2108806pfs.150.2020.12.02.03.48.14
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Wed, 02 Dec 2020 03:48:16 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     krzk@kernel.org
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v5 net-next 2/4] nfc: s3fwrn5: reduce the EN_WAIT_TIME
Date:   Wed,  2 Dec 2020 20:47:39 +0900
Message-Id: <1606909661-3814-3-git-send-email-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1606909661-3814-1-git-send-email-bongsu.jeon@samsung.com>
References: <1606909661-3814-1-git-send-email-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

The delay of 20ms is enough to enable and
wake up the Samsung's nfc chip.

Acked-by: Krzysztof Kozlowski <krzk@kernel.org>
Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 drivers/nfc/s3fwrn5/i2c.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
index ae26594..9a64eea 100644
--- a/drivers/nfc/s3fwrn5/i2c.c
+++ b/drivers/nfc/s3fwrn5/i2c.c
@@ -19,7 +19,7 @@
 
 #define S3FWRN5_I2C_DRIVER_NAME "s3fwrn5_i2c"
 
-#define S3FWRN5_EN_WAIT_TIME 150
+#define S3FWRN5_EN_WAIT_TIME 20
 
 struct s3fwrn5_i2c_phy {
 	struct i2c_client *i2c_dev;
@@ -40,7 +40,7 @@ static void s3fwrn5_i2c_set_wake(void *phy_id, bool wake)
 
 	mutex_lock(&phy->mutex);
 	gpio_set_value(phy->gpio_fw_wake, wake);
-	msleep(S3FWRN5_EN_WAIT_TIME/2);
+	msleep(S3FWRN5_EN_WAIT_TIME);
 	mutex_unlock(&phy->mutex);
 }
 
@@ -63,7 +63,7 @@ static void s3fwrn5_i2c_set_mode(void *phy_id, enum s3fwrn5_mode mode)
 	if (mode != S3FWRN5_MODE_COLD) {
 		msleep(S3FWRN5_EN_WAIT_TIME);
 		gpio_set_value(phy->gpio_en, 0);
-		msleep(S3FWRN5_EN_WAIT_TIME/2);
+		msleep(S3FWRN5_EN_WAIT_TIME);
 	}
 
 	phy->irq_skip = true;
-- 
1.9.1

