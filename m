Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DEF6B2D2CCD
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 15:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729784AbgLHOMX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 09:12:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729771AbgLHOMW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Dec 2020 09:12:22 -0500
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A388CC0619D6;
        Tue,  8 Dec 2020 06:10:47 -0800 (PST)
Received: by mail-pg1-x544.google.com with SMTP id w16so12262618pga.9;
        Tue, 08 Dec 2020 06:10:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=WYAUhwB4AEnUmLHEPnWWbsECh1/lymsws54jeNi8rHk=;
        b=uTE2PPQ1eqF46LhlxYJq8vLv4XFVh7FG2bCB84O6tjwSAQry7gtty2mLw9ERXclvoD
         1VHzhIw52uLaZNdlzInPZ/Ay8Ve2gBgK0tgypylJhin5Cg9VlNn0ImB5T4Oteb8Ry/5L
         sumH7i6/BuozblAdt1ALu+BepxhlUMaNmJHiSLeCzd2strcC+Ka4Fx6ZEd9H8H96N44M
         6nr5IAxKypkbXaYL+fnuWGjhTEBtcUD82fGDrDjJcGtOCogpQhq1zq0LXz4erF4O27YO
         b9H+XBWC6hKThrKoId3VCEnyfc/lf1ddflp7HWuKarmsQYDtkSgoJg6x02Tvp4OxsuQ5
         70xQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=WYAUhwB4AEnUmLHEPnWWbsECh1/lymsws54jeNi8rHk=;
        b=uenhuUzOeSGV44RYwrU+vC0v9XISzo6ZF2XvcWNNTtL5TaPkBnecwN5PnSYLLhx8bL
         6AF4l1Y3A/WTQzvop0TOzgs3QLBD0VomBrp73mblvNAKzQL3eZxXrTAVY1F5kd3Qk6a+
         9i8ncnp74X6R4qK5XWkPS4GIaZgXGfUDFDxj3oZ31klXvND42YAUMhlHiSd/D89W9PWx
         WRhJ8G8coivoD7d/JBM+wvmTpb29cJn6AE5oEPbtrzKjHq36ilEljHKPcU97a1Fn2CqK
         Bg74dCMH8yF4GptugmajG5dZ/CkPkg0RfHVGutAa40PmnlAc64YGgTdjVfRIRUpGL704
         nKZA==
X-Gm-Message-State: AOAM5321NYt3MVZgTThMGCixSuOoxz7NnTtCccwxIvcxzjNmZNvMwC6R
        LOm+yDIgsug7xJmgCHv+8Z8=
X-Google-Smtp-Source: ABdhPJxh/yD4Sij++zuYSOdPdYpmdKk6DDGc+0QAKFfSSYRYRCJvPr8riMdhXMutezXlgxbeF30Qhg==
X-Received: by 2002:a63:1616:: with SMTP id w22mr2672435pgl.13.1607436647281;
        Tue, 08 Dec 2020 06:10:47 -0800 (PST)
Received: from localhost.localdomain ([182.226.226.37])
        by smtp.googlemail.com with ESMTPSA id m15sm9071951pfa.72.2020.12.08.06.10.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 08 Dec 2020 06:10:46 -0800 (PST)
From:   Bongsu Jeon <bongsu.jeon2@gmail.com>
X-Google-Original-From: Bongsu Jeon
To:     krzk@kernel.org
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: [PATCH v2 net-next 2/2] nfc: s3fwrn5: Remove hard coded interrupt trigger type from the i2c module
Date:   Tue,  8 Dec 2020 23:10:12 +0900
Message-Id: <20201208141012.6033-3-bongsu.jeon@samsung.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201208141012.6033-1-bongsu.jeon@samsung.com>
References: <20201208141012.6033-1-bongsu.jeon@samsung.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Bongsu Jeon <bongsu.jeon@samsung.com>

For the flexible control of interrupt trigger type, remove the hard coded
interrupt trigger type in the i2c module. The trigger type will be loaded
 from a dts.

Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>
---
 drivers/nfc/s3fwrn5/i2c.c | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/nfc/s3fwrn5/i2c.c b/drivers/nfc/s3fwrn5/i2c.c
index e1bdde105f24..42f1f610ac2c 100644
--- a/drivers/nfc/s3fwrn5/i2c.c
+++ b/drivers/nfc/s3fwrn5/i2c.c
@@ -179,6 +179,8 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
 				  const struct i2c_device_id *id)
 {
 	struct s3fwrn5_i2c_phy *phy;
+	struct irq_data *irq_data;
+	unsigned long irqflags;
 	int ret;
 
 	phy = devm_kzalloc(&client->dev, sizeof(*phy), GFP_KERNEL);
@@ -212,8 +214,11 @@ static int s3fwrn5_i2c_probe(struct i2c_client *client,
 	if (ret < 0)
 		return ret;
 
+	irq_data = irq_get_irq_data(client->irq);
+	irqflags = irqd_get_trigger_type(irq_data) | IRQF_ONESHOT;
+
 	ret = devm_request_threaded_irq(&client->dev, phy->i2c_dev->irq, NULL,
-		s3fwrn5_i2c_irq_thread_fn, IRQF_TRIGGER_HIGH | IRQF_ONESHOT,
+		s3fwrn5_i2c_irq_thread_fn, irqflags,
 		S3FWRN5_I2C_DRIVER_NAME, phy);
 	if (ret)
 		s3fwrn5_remove(phy->common.ndev);
-- 
2.17.1

