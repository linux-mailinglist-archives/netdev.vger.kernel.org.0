Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E2BB710818D
	for <lists+netdev@lfdr.de>; Sun, 24 Nov 2019 04:32:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726912AbfKXDbM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 Nov 2019 22:31:12 -0500
Received: from mail-pj1-f68.google.com ([209.85.216.68]:39461 "EHLO
        mail-pj1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726676AbfKXDbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 Nov 2019 22:31:12 -0500
Received: by mail-pj1-f68.google.com with SMTP id v93so1622400pjb.6
        for <netdev@vger.kernel.org>; Sat, 23 Nov 2019 19:31:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=NKxffq4OzZJB+VhVeKJgeSrd7yVUhbBRMiR3ArO7ihQ=;
        b=CklH4SXy+aNNbvpnBdmsugorY06NU23n54M3BFr2lpFEamnLH6m1MYe0Ogsaeallhu
         RcW+CohV+c/Bex4h/0mn146sgJmbPxJZhr/UXkcuZBtK6rBrLJSrx4zOoH4kIteScNUZ
         cUBlOOwu/bA5wXYAJb1W8Yox9Q02CpDFVXy50=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=NKxffq4OzZJB+VhVeKJgeSrd7yVUhbBRMiR3ArO7ihQ=;
        b=EFSXD8JW+FaDaDg1zZ7f3yDofDcm153Dw7T4PTvPL33LJK3qCs2K00EsCA4hgKfdVL
         t0nSwEvHqSGX5XiLx5TF5n21gfWPze5+2SiUsaGzdeDTMEJIkd45j/4FN8/ynhdtT0CU
         EI2s5e1r9jplhoLvxlAQlUVG559ifOZPZhhKa08rOQEChdbJwQpMrI0rSDr8uz2Ryb0g
         ANEL7spv6+jz850ogUqc52FE8wfUtUypT6tHtoCHP1o3DNU1SnZ0kFdGEsUakx/6drm+
         6ykpFHAexdRQX2P+KQkG5R7/4j4YXlgtESy51iC1bix4P3pmzhCnP+pcPo0T7wVkDPG8
         pISg==
X-Gm-Message-State: APjAAAWGEJpatYnzxh1dPK97+xaQ6eLEJYlZE8JtZ7iS3J/M1BxuLF2Y
        dqDgSUgZOGDlY2Xv6H6NUqLFLB60jRY=
X-Google-Smtp-Source: APXvYqzlM1Rv0wAFJIrULyfV1KV+8FemIAn3w+2sYcCE3Lw4uzrhuNGXFgJXpJa9676Qd+bjUki84Q==
X-Received: by 2002:a17:902:9a92:: with SMTP id w18mr21982543plp.91.1574566271228;
        Sat, 23 Nov 2019 19:31:11 -0800 (PST)
Received: from localhost.swdvt.lab.broadcom.com ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id v63sm3111901pfb.181.2019.11.23.19.31.09
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 23 Nov 2019 19:31:10 -0800 (PST)
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net, jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org
Subject: [PATCH net-next v2 01/13] bnxt_en: Add chip IDs for 57452 and 57454 chips.
Date:   Sat, 23 Nov 2019 22:30:38 -0500
Message-Id: <1574566250-7546-2-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1574566250-7546-1-git-send-email-michael.chan@broadcom.com>
References: <1574566250-7546-1-git-send-email-michael.chan@broadcom.com>
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

