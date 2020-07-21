Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78BDD2289F8
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 22:34:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730817AbgGUUeV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jul 2020 16:34:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730482AbgGUUeT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jul 2020 16:34:19 -0400
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1B280C061794
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:34:19 -0700 (PDT)
Received: by mail-pg1-x530.google.com with SMTP id p3so13725pgh.3
        for <netdev@vger.kernel.org>; Tue, 21 Jul 2020 13:34:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=pensando.io; s=google;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=L8T7hdDCmaxYXiC5V2hOLLpYbtzwS9t4Z6YDnWGQMxQ=;
        b=e8jZc6Rs6/UHv6ZbQ5p0n71QJ2Hr6PTs5pAE187GX48hv8F9HednISIB5qF7EvwA/C
         TyfcpHPu4epnDOcaxodCHMFl3J2Unzs5SS+FS7ImHj0O7rcIUUrKdn1ZgaDazaWHySHP
         qURAaSfFCo4IMd+Qh8KreG08sEg/8cvHxHpJNpXF2VPQegaAnlZ01AezpGmvaJQ0ZG8v
         tN0Z67qqCQhM2pWd+R/qjP6etWduseUbHJdyBDorn7Cdap0JWkStQkxmIM3BAL/LraPg
         n9JRoXzuIgxJZ/KpEWHJlJjiK0gRBvKPG9r7b5qFZ5USgVglAvqV4RDq9zJYnNKsbCPN
         Ws5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=L8T7hdDCmaxYXiC5V2hOLLpYbtzwS9t4Z6YDnWGQMxQ=;
        b=a5JNgqmFWyUYqVs3ndV2TbNcFMux0UAKsULuVT4Tjsyvbf4hQiJR/nv/LMbAHlMrYy
         NoU/gN0m8dTSvcErov1izX9vsJY4V9BuM+0p3PHNTRKLGVnkYQK+0QZiZfHAevLH3EYP
         pUqCp3cPYj1N6FzDmz8EPe26WAByL+acmnA+FIUwEWz3ePSxt51f6bq38g9De23HDx4k
         BG8AD1Trn3L5ohjhjcaL+8f9KOD/KTOQmYGahNu7FMSoHeO73tQ2/bSlxEqisPzOV+Qt
         AHVL4c5DGlEk6TTZvs/WKoWL5I2gPf0GCKs6QgIoS6HKE78JPsgXVTmqL8BRN4htZzlp
         vRMw==
X-Gm-Message-State: AOAM533vLqQttOAV8dsCwji4a9M2iO8dAqvutDlNSk2UaARZikabl+Ea
        GH/vggNPtop738WX78JMwVxfeSiDPx8=
X-Google-Smtp-Source: ABdhPJwVn0KKpaK3OohNwRyC3/gkErIoUWzAmiMrfZFKbSgLK0hrvAzlcKQYwciAGpsaUQVghYaqGg==
X-Received: by 2002:aa7:9422:: with SMTP id y2mr26404874pfo.211.1595363658341;
        Tue, 21 Jul 2020 13:34:18 -0700 (PDT)
Received: from driver-dev1.pensando.io ([12.226.153.42])
        by smtp.gmail.com with ESMTPSA id p11sm4075107pjb.3.2020.07.21.13.34.17
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 21 Jul 2020 13:34:17 -0700 (PDT)
From:   Shannon Nelson <snelson@pensando.io>
To:     netdev@vger.kernel.org, davem@davemloft.net
Cc:     Shannon Nelson <snelson@pensando.io>
Subject: [PATCH net-next 3/6] ionic: remove unused ionic_coal_hw_to_usec
Date:   Tue, 21 Jul 2020 13:34:06 -0700
Message-Id: <20200721203409.3432-4-snelson@pensando.io>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200721203409.3432-1-snelson@pensando.io>
References: <20200721203409.3432-1-snelson@pensando.io>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Clean up some unused code.

Signed-off-by: Shannon Nelson <snelson@pensando.io>
---
 drivers/net/ethernet/pensando/ionic/ionic_lif.h | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/net/ethernet/pensando/ionic/ionic_lif.h b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
index 949f96dc9cd8..f1e7d3ef1c58 100644
--- a/drivers/net/ethernet/pensando/ionic/ionic_lif.h
+++ b/drivers/net/ethernet/pensando/ionic/ionic_lif.h
@@ -236,19 +236,6 @@ static inline u32 ionic_coal_usec_to_hw(struct ionic *ionic, u32 usecs)
 	return (usecs * mult) / div;
 }
 
-static inline u32 ionic_coal_hw_to_usec(struct ionic *ionic, u32 units)
-{
-	u32 mult = le32_to_cpu(ionic->ident.dev.intr_coal_mult);
-	u32 div = le32_to_cpu(ionic->ident.dev.intr_coal_div);
-
-	/* Div-by-zero should never be an issue, but check anyway */
-	if (!div || !mult)
-		return 0;
-
-	/* Convert from device units to usec */
-	return (units * div) / mult;
-}
-
 typedef void (*ionic_reset_cb)(struct ionic_lif *lif, void *arg);
 
 void ionic_link_status_check_request(struct ionic_lif *lif);
-- 
2.17.1

