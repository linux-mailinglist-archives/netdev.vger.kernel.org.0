Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BDEA12D8C99
	for <lists+netdev@lfdr.de>; Sun, 13 Dec 2020 11:15:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388973AbgLMKNR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Dec 2020 05:13:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725835AbgLMKNR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 13 Dec 2020 05:13:17 -0500
Received: from mail-pg1-x543.google.com (mail-pg1-x543.google.com [IPv6:2607:f8b0:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E7AEC0613CF;
        Sun, 13 Dec 2020 02:12:52 -0800 (PST)
Received: by mail-pg1-x543.google.com with SMTP id f17so10450821pge.6;
        Sun, 13 Dec 2020 02:12:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id;
        bh=lsVx0n4zixxira9lv35hWS/y6k/uVu6Aq4wNzOSEerQ=;
        b=B3g/XyLF32jvXzIhBauVCSIK+Cap/WLc88FRLJ5wVQGa3ZaXCbY2lGzwymWFc6eI47
         kHQ1QP3eFu0wRjC2WO33G1ppzdYYAVEZc2DtWss/zzlTuCfEpOdtTTd2lmyxQP93eTFC
         CalyUGpr9FFgokvmbfxAFbcGqGy3ksNkCdfvFFsHloDzkR4H/0BeyalJDWLyFwaJ7rEQ
         Ks7wYV2L34HvbLwSPS101yDczdG6fetkKBcPcvTS6EjL32P2ozTRHpNILZL7AYy7xaze
         YBaYMgSGx5ItCXb8uZbhCSTdLvLgBf6HynTPwzKAxAK1tidmyehe3hkHpNoQnd1aSLGw
         crBQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=lsVx0n4zixxira9lv35hWS/y6k/uVu6Aq4wNzOSEerQ=;
        b=ff0Cuj/okhzWQZesmcU84O5n7IbCbqtMPHEgzSDs8EzoQHxsSmrFihEDeEocJpUZ7m
         Wq8czpWqVXEUoB+QZhiqlNFoMiQJo1mxFCA9O9DiiBqqXHr+qT5f4vZKy1Tu540feM9y
         FWHq1tA40sincK4lwqM75cLtcyQxspuIJKOG6YnWppymFKDoKrQtpWokAYjUwzMNZPyq
         RtayhGUqjEQ/g+a7rG+3jf4KNTeN1XoLDMbbo5DJNt7pOxzwkV4G2qAU1Y6DMkqOJqr+
         IxnFxLCS4A9lyrIEvAdpoVLjhlS0DnV7POp+S0gCXmJZNuzyQmZo1cPoSdIwc8CiU8qH
         5Rbw==
X-Gm-Message-State: AOAM531U75SYYY7ZZ9Ef4VUkOlreie2Yx4ddo8W4Kh9VXtAAQREARZxg
        PIF/IYu7QPcSuROyJEq5Ww8=
X-Google-Smtp-Source: ABdhPJwLJ2zQO1VWY3ErJTxneKfBu7E+i00lhvxlMuSU3DTPBNxZOpv7HPhddCEBfFAYYqJq7ssY0w==
X-Received: by 2002:a65:55c1:: with SMTP id k1mr19135135pgs.130.1607854371734;
        Sun, 13 Dec 2020 02:12:51 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id s7sm16973115pfh.207.2020.12.13.02.12.49
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sun, 13 Dec 2020 02:12:50 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     krzk@kernel.org
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH net-next] nfc: s3fwrn5: Remove the delay for nfc sleep
Date:   Sun, 13 Dec 2020 19:12:38 +0900
Message-Id: <20201213101238.28373-1-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

remove the delay for nfc sleep because nfc doesn't need the sleep delay.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 drivers/nfc/s3fwrn5/phy_common.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/s3fwrn5/phy_common.c b/drivers/nfc/s3fwrn5/phy_common.c
index 497b02b30ae7..81318478d5fd 100644
--- a/drivers/nfc/s3fwrn5/phy_common.c
+++ b/drivers/nfc/s3fwrn5/phy_common.c
@@ -20,7 +20,8 @@ void s3fwrn5_phy_set_wake(void *phy_id, bool wake)
 
 	mutex_lock(&phy->mutex);
 	gpio_set_value(phy->gpio_fw_wake, wake);
-	msleep(S3FWRN5_EN_WAIT_TIME);
+	if (wake)
+		msleep(S3FWRN5_EN_WAIT_TIME);
 	mutex_unlock(&phy->mutex);
 }
 EXPORT_SYMBOL(s3fwrn5_phy_set_wake);
-- 
2.17.1

