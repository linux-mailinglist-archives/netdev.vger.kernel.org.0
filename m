Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 583B9107DB4
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 09:26:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726634AbfKWI02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 03:26:28 -0500
Received: from mail-pg1-f194.google.com ([209.85.215.194]:37879 "EHLO
        mail-pg1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725973AbfKWI01 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 03:26:27 -0500
Received: by mail-pg1-f194.google.com with SMTP id b10so4627112pgd.4
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 00:26:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NKxffq4OzZJB+VhVeKJgeSrd7yVUhbBRMiR3ArO7ihQ=;
        b=A4X7cufaZUSAqf4WEUPz8mAnj/tZ/AjnySQ5N6fDSIbJeh3CBG9VCx3zne17mspdpH
         ez/js7xhI+l99K+N/gFezuifueCwdVYaQv4ek+ZHvLgUdnAw0459nU4mPbPj43Rg1gN6
         uVGlpbJpI9eQijB+DHhTYhIviEl9dSDcmLpmw=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NKxffq4OzZJB+VhVeKJgeSrd7yVUhbBRMiR3ArO7ihQ=;
        b=Oh80rPIxe0Epc4RAAMPp1PNd0Q4d5XNZ6o8K981RbS2hzWfUQKzn8np9L4mpQtAmo9
         ivdlwrcaSfNsvMXTvM/VwaWzZtFEwpcGinwZdnI+F/Efp7zhbMHTSADRsXiUpEuebB+Z
         sNih/dXAJ5Lbg5PnkpzQoccvSaYCqpbsZ9tu78JoKTHjotSscvO42Pe6lJaeRZzn/ZTr
         dUC0ZoC9w9gHbX2yy1PCDiuiUlgoDhOwneTe44BOkJFo8O9S9cxzb4tq7q0mUTtE5QaK
         aRP/AA0uJTGVa+4GR/jV8yWnoF0Fkj3Ai/BuShUQA6Oq6l9jNss0iTUTVRVyq2edl8mn
         PPFg==
X-Gm-Message-State: APjAAAWjys16KcfLHyHaujBqFqYpOgN2MQ9ETnHs1YrY+uO8dp7aeJMc
        x8pq0L5FYgK6m4IWTNwQxp8D+Q==
X-Google-Smtp-Source: APXvYqwZa/tXa/cBFUg5nvtlmvHH9vqf45XosSicnEMOwpS1NuMKrnC6nxYYtPMfiMBoGsyT3tNnLA==
X-Received: by 2002:a63:f716:: with SMTP id x22mr20704510pgh.351.1574497585748;
        Sat, 23 Nov 2019 00:26:25 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p16sm573236pfn.171.2019.11.23.00.26.24
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 00:26:25 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next 01/15] bnxt_en: Add chip IDs for 57452 and 57454 chips.
Date:   Sat, 23 Nov 2019 03:25:56 -0500
Message-Id: <1574497570-22102-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
References: <1574497570-22102-1-git-send-email-michael.chan@broadcom.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix BNXT_CHIP_NUM_5645X() to include 57452 and 56454 chip IDs, so
that these chips will be properly classified as P4 chips to take
advantage of the P4 fixes and features.

Signed-off-by: Michael Chan <michael.chan@broadcom.com>
---
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 7 ++++++-
 1 file changed, 6 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/broadcom/bnxt/bnxt.h b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
index 37549ca..e07311e 100644
--- a/drivers/net/ethernet/broadcom/bnxt/bnxt.h
+++ b/drivers/net/ethernet/broadcom/bnxt/bnxt.h
@@ -1443,6 +1443,8 @@ struct bnxt {
 #define CHIP_NUM_57414L		0x16db
 
 #define CHIP_NUM_5745X		0xd730
+#define CHIP_NUM_57452		0xc452
+#define CHIP_NUM_57454		0xc454
 
 #define CHIP_NUM_57508		0x1750
 #define CHIP_NUM_57504		0x1751
@@ -1475,7 +1477,10 @@ struct bnxt {
 	 ((chip_num) == CHIP_NUM_58700)
 
 #define BNXT_CHIP_NUM_5745X(chip_num)		\
-	 ((chip_num) == CHIP_NUM_5745X)
+	((chip_num) == CHIP_NUM_5745X ||	\
+	 (chip_num) == CHIP_NUM_57452 ||	\
+	 (chip_num) == CHIP_NUM_57454)
+
 
 #define BNXT_CHIP_NUM_57X0X(chip_num)		\
 	(BNXT_CHIP_NUM_5730X(chip_num) || BNXT_CHIP_NUM_5740X(chip_num))
-- 
2.5.1

