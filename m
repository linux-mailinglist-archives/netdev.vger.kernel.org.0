Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 53254475285
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 07:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236285AbhLOGIc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 01:08:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235888AbhLOGIb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 01:08:31 -0500
Received: from mail-qt1-x82b.google.com (mail-qt1-x82b.google.com [IPv6:2607:f8b0:4864:20::82b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AE0CC061574;
        Tue, 14 Dec 2021 22:08:31 -0800 (PST)
Received: by mail-qt1-x82b.google.com with SMTP id l8so20793044qtk.6;
        Tue, 14 Dec 2021 22:08:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+xwkuwluPsTZyAevpz2Dh9lbi48ybD49t0i22pstsUo=;
        b=MUWShuuikvcrA+0rjapQ+kfaaC8OO4daTxmcj53vpKqRfy0GCJ17rlrZf2IphayDeH
         hgbJ+ew4jsIb2A76M2+58uTCAjALMcQIHc/dgfOn/Tv2x0RNE+33t0g/s1SuPL11aEln
         p1RcHUdSgtwMelolcBQepmO8UUJtBw9YPBHELV55jULUylLsPXSmiV3RZYqUyP2Z5NXY
         m1ltVCQENtx0DOSusHazqKDU2v2rgRr1L8cBGaMGGXnMx2p4puxFlFG9QQPA1QnH08D/
         HYYMCHUnuOxNjQqu9cmW62ThY0eGyxeYlCmkkHkpXokMKjIztB4HAfxdsyVqRpJJJN5M
         aXaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=+xwkuwluPsTZyAevpz2Dh9lbi48ybD49t0i22pstsUo=;
        b=tFI0O6+cwajPYTliEh0POdPt/Wnwm9iyRnuHOgs6uyxuPeyIKeAuUGWsGizVjm1vSL
         5me2tGyckBCQnSvVAQQymKP+A2q0Y8yna1y9Bx1dJeENqZne0LnRxpRdI8HKgis3fNlJ
         LpVSGVhG+g2Yue2n54Z0PqgUEmENcj1iHRx5kIzAyUSLVHcZMLJB9OrZRw/fMsLr+vz1
         IPtX2oANaJCpxPhMDeMkc3PRGvCuWIfxh0eiN0nqHp/FIjCvQMe7fpriKZ0XRpybMW3Z
         cAealLjsUgK/tvqMZhp/PdIvLN9FFYYz54uL0GYEtES/mWif9vhLV6SvAxXZ95chLMxZ
         1ALA==
X-Gm-Message-State: AOAM533S1DMvviBGSJWVM5+bYuHYzo+6MUxSg8TkE8bpzrK/a7FfZYqJ
        gAN4lX057fXzeT185PHsErk=
X-Google-Smtp-Source: ABdhPJzGRc+Pbqc4GG1xJH1pXIdO7J9/hMlCKKxLkMT3CqDopyzjoYhaPjBb2Bnnkn/Hy2kHBhpEsA==
X-Received: by 2002:a05:622a:308:: with SMTP id q8mr10281691qtw.463.1639548510447;
        Tue, 14 Dec 2021 22:08:30 -0800 (PST)
Received: from localhost.localdomain ([193.203.214.57])
        by smtp.gmail.com with ESMTPSA id f12sm732059qtj.93.2021.12.14.22.08.28
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 14 Dec 2021 22:08:30 -0800 (PST)
From:   cgel.zte@gmail.com
X-Google-Original-From: chi.minghao@zte.com.cn
To:     richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Minghao Chi <chi.minghao@zte.com.cn>,
        Zeal Robot <zealci@zte.com.cn>
Subject: [PATCH ptp-next] drivers/ptp: remove redundant variable
Date:   Wed, 15 Dec 2021 06:08:25 +0000
Message-Id: <20211215060825.442247-1-chi.minghao@zte.com.cn>
X-Mailer: git-send-email 2.25.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Minghao Chi <chi.minghao@zte.com.cn>

Return value directly instead of taking this
in another redundant variable.

Reported-by: Zeal Robot <zealci@zte.com.cn>
Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
---
 drivers/ptp/ptp_pch.c | 20 ++++----------------
 1 file changed, 4 insertions(+), 16 deletions(-)

diff --git a/drivers/ptp/ptp_pch.c b/drivers/ptp/ptp_pch.c
index 8070f3fd98f0..9132aaa70a2d 100644
--- a/drivers/ptp/ptp_pch.c
+++ b/drivers/ptp/ptp_pch.c
@@ -193,11 +193,8 @@ EXPORT_SYMBOL(pch_ch_control_write);
 u32 pch_ch_event_read(struct pci_dev *pdev)
 {
 	struct pch_dev *chip = pci_get_drvdata(pdev);
-	u32 val;
-
-	val = ioread32(&chip->regs->ch_event);
 
-	return val;
+	return ioread32(&chip->regs->ch_event);
 }
 EXPORT_SYMBOL(pch_ch_event_read);
 
@@ -212,22 +209,16 @@ EXPORT_SYMBOL(pch_ch_event_write);
 u32 pch_src_uuid_lo_read(struct pci_dev *pdev)
 {
 	struct pch_dev *chip = pci_get_drvdata(pdev);
-	u32 val;
 
-	val = ioread32(&chip->regs->src_uuid_lo);
-
-	return val;
+	return ioread32(&chip->regs->src_uuid_lo);
 }
 EXPORT_SYMBOL(pch_src_uuid_lo_read);
 
 u32 pch_src_uuid_hi_read(struct pci_dev *pdev)
 {
 	struct pch_dev *chip = pci_get_drvdata(pdev);
-	u32 val;
 
-	val = ioread32(&chip->regs->src_uuid_hi);
-
-	return val;
+	return ioread32(&chip->regs->src_uuid_hi);
 }
 EXPORT_SYMBOL(pch_src_uuid_hi_read);
 
@@ -663,12 +654,9 @@ static void __exit ptp_pch_exit(void)
 
 static s32 __init ptp_pch_init(void)
 {
-	s32 ret;
-
 	/* register the driver with the pci core */
-	ret = pci_register_driver(&pch_driver);
 
-	return ret;
+	return pci_register_driver(&pch_driver);
 }
 
 module_init(ptp_pch_init);
-- 
2.25.1

