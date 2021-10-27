Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C75A43D76A
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 01:18:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230089AbhJ0XUg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Oct 2021 19:20:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52576 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229836AbhJ0XUf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Oct 2021 19:20:35 -0400
Received: from mail-pl1-x64a.google.com (mail-pl1-x64a.google.com [IPv6:2607:f8b0:4864:20::64a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABF95C061570
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 16:18:09 -0700 (PDT)
Received: by mail-pl1-x64a.google.com with SMTP id r11-20020a170902be0b00b0013f4f30d71cso1749007pls.21
        for <netdev@vger.kernel.org>; Wed, 27 Oct 2021 16:18:09 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=date:message-id:mime-version:subject:from:to:cc;
        bh=UqOACvA/GAkBlx6nI88hGu6zlyCJ7sQcYLTjddCacic=;
        b=qIJBnjiVYU+VbQ9QVyiZwIzZ4VV1R58qP7+8LI2fJOCdwSO6LQdnY2JohZX+a56DQV
         Uj0jTqY+BagZiJoclE3pFYBTvkiaU008xsdPlruovpG0WDRKldh5SXu6TpFCJXxzj4c0
         iTZcH3PqZsOSAYgJEVT5GTrwL2Ey+DIFNPDSdahqmJ5U2dWcQn3Oe2YPhriazosUi/uT
         IkQo+m7VieGPdrUFJ4q3sS8LwhtB6WE6w+iyt5Okd29h/BOrbS0zoUmtmGRaC7xbHka2
         tUYZT+mcAO7JhUjijw5DVp3W8rOryaw2Sh7P2/Pa4g64hjrYtkN7iczxtHUM2hLQrmvE
         AKXQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:message-id:mime-version:subject:from:to:cc;
        bh=UqOACvA/GAkBlx6nI88hGu6zlyCJ7sQcYLTjddCacic=;
        b=Oh25EJkYXtvOU7/VgA6zpMKLW5SDjiIVo+E9PaKMyjjsZ1p1b7XBPb1P+2yqJ+86fP
         71cFRNr8m95f4CJHQfeoufbZM9bCJ+VQYih8MB5vnhtAuwUzkg44/ghXuhwS5dECWxdV
         vJesqQmg+ehG829R+6oEqBO+47fVIFN8U1qRyozRBFpc0aDJTJOgmGkldsOC4G/uz5rx
         vHAw6kmHnZ0GZiJ6OCrRx/ZNsKF3V3HgNcN5fiyQGrqCpNWiwd2duFqECx6VSg0+X7Iy
         uOwEdOSAXc07HFLSJJA27ACSOAtLH5Ko1K7I7QKTQgYlB4wwblPkspUA7Fb47/fYwikc
         MfzA==
X-Gm-Message-State: AOAM530AmXhdpiCuxVXENOnjWmK+gMgWO0MMOCicb9UYxn9j/x9SXLv7
        h07YHet1TaR6nBnWHzE9NLT1FtDkguH+sA==
X-Google-Smtp-Source: ABdhPJw4QylC3Ps+oNmTML3fbSxd7m/TYjApDzns2/MnfhSbCUkBSzqeFl1LTdfMByzlviPIFnV7n72HrjbqQA==
X-Received: from xllamas.c.googlers.com ([fda3:e722:ac3:cc00:7f:e700:c0a8:b1])
 (user=cmllamas job=sendgmr) by 2002:a62:3808:0:b0:47b:d1da:e734 with SMTP id
 f8-20020a623808000000b0047bd1dae734mr686437pfa.2.1635376689115; Wed, 27 Oct
 2021 16:18:09 -0700 (PDT)
Date:   Wed, 27 Oct 2021 23:18:02 +0000
Message-Id: <20211027231802.2844313-1-cmllamas@google.com>
Mime-Version: 1.0
X-Mailer: git-send-email 2.33.0.1079.g6e70778dc9-goog
Subject: [PATCH net] ptp: fix code indentation issues
From:   Carlos Llamas <cmllamas@google.com>
To:     Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Cc:     Yang Yingliang <yangyingliang@huawei.com>, netdev@vger.kernel.org,
        kernel-team@android.com, linux-kernel@vger.kernel.org,
        Carlos Llamas <cmllamas@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This fixes the following checkpatch.pl errors:

ERROR: code indent should use tabs where possible
+^I        if (ptp->pps_source)$

ERROR: code indent should use tabs where possible
+^I                pps_unregister_source(ptp->pps_source);$

ERROR: code indent should use tabs where possible
+^I                kthread_destroy_worker(ptp->kworker);$

Fixes: 4225fea1cb28 ("ptp: Fix possible memory leak in ptp_clock_register()")
Signed-off-by: Carlos Llamas <cmllamas@google.com>
---
 drivers/ptp/ptp_clock.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index f9b2d66b0443..0e4bc8b9329d 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -284,11 +284,11 @@ struct ptp_clock *ptp_clock_register(struct ptp_clock_info *info,
 	/* Create a posix clock and link it to the device. */
 	err = posix_clock_register(&ptp->clock, &ptp->dev);
 	if (err) {
-	        if (ptp->pps_source)
-	                pps_unregister_source(ptp->pps_source);
+		if (ptp->pps_source)
+			pps_unregister_source(ptp->pps_source);
 
 		if (ptp->kworker)
-	                kthread_destroy_worker(ptp->kworker);
+			kthread_destroy_worker(ptp->kworker);
 
 		put_device(&ptp->dev);
 
-- 
2.33.0.1079.g6e70778dc9-goog

