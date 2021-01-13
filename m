Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 481B42F5805
	for <lists+netdev@lfdr.de>; Thu, 14 Jan 2021 04:01:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbhANCMv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jan 2021 21:12:51 -0500
Received: from us-smtp-delivery-124.mimecast.com ([63.128.21.124]:35397 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1729220AbhAMV5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jan 2021 16:57:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1610574973;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=TcMhDFu40M2vbcmXTpEq5AfXfYVWbjvJciRmB33PZNI=;
        b=aShgT3fgYyh3204GRR1UHMm4H/WffVKP8JgdEOykPeu2mZBEnjQyaUF7eXiFSHKPuso4pQ
        gE+jZNfx9oPn0r4A+lX8ud+2Z7oNuKabUlfQuxP/dFWInCaMUAaiRzOE2EKJ6S+MQcxkVa
        /mm85c9zJ5IoX+oTgIspdKfdFVxJ0WU=
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com
 [209.85.222.197]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-152-WmXdQCPXP1ab26WDLknm7w-1; Wed, 13 Jan 2021 16:56:11 -0500
X-MC-Unique: WmXdQCPXP1ab26WDLknm7w-1
Received: by mail-qk1-f197.google.com with SMTP id g26so2639561qkk.13
        for <netdev@vger.kernel.org>; Wed, 13 Jan 2021 13:56:11 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=TcMhDFu40M2vbcmXTpEq5AfXfYVWbjvJciRmB33PZNI=;
        b=dfo0WJbDIAv2rUqlMyaNJbZmIqR4MbvdiE3AKQHkb5ACkqCyTppll2GDxgl17QNVNr
         YvbIUsUWwhq4Nzki4yg8B9oyFk7B8Ixd+SYPENYtTQbIFR/IE9jr9hP4T1kU3NHJ8feg
         bDxkuy3TM+vcMD9UESQXxHUEiR2/9M44NidvLp6rAObEtFhW5WLVYe8MByqf6sqn4m/M
         /iRfqXS1OuqFEmxgq+NrWFtlT/QCjQpV7l+GZnkLxtfNqe/T3GN2GIXLdJ1oyEDUyLkI
         KQPSjElQ/izUBgakx/OMeERTYHqRRpmNmzYqgblSGu8QiAFf4o8mnM3dFI4dfGOoVSmp
         46fw==
X-Gm-Message-State: AOAM531wYyjV6goDRDfro3jtx6CFUHkIOMm3J7tR1Ju6fGVF8wz3vKX1
        lvZuJJJvB9k2hasrvpHek7Y1Le4GosAi4yl5ugGwhk4E9fvZEkGmImsPkKUfgaf4716X1BRm1uf
        H85pcvJ4MyprrHBct
X-Received: by 2002:a05:6214:1230:: with SMTP id p16mr4305623qvv.47.1610574970924;
        Wed, 13 Jan 2021 13:56:10 -0800 (PST)
X-Google-Smtp-Source: ABdhPJzZW1vCbp2lWzBVZ/9CHzZnH8/2XiV+QNphgjQ5RHwl/EwUN+7SzCeUi4g+9Mvjrek/eLuusA==
X-Received: by 2002:a05:6214:1230:: with SMTP id p16mr4305603qvv.47.1610574970679;
        Wed, 13 Jan 2021 13:56:10 -0800 (PST)
Received: from trix.remote.csb (075-142-250-213.res.spectrum.com. [75.142.250.213])
        by smtp.gmail.com with ESMTPSA id p6sm1803386qtl.21.2021.01.13.13.56.09
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 13 Jan 2021 13:56:10 -0800 (PST)
From:   trix@redhat.com
To:     claudiu.manoil@nxp.com, davem@davemloft.net, kuba@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Tom Rix <trix@redhat.com>
Subject: [PATCH] gianfar: remove definition of DEBUG
Date:   Wed, 13 Jan 2021 13:56:03 -0800
Message-Id: <20210113215603.1721958-1-trix@redhat.com>
X-Mailer: git-send-email 2.27.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Tom Rix <trix@redhat.com>

Defining DEBUG should only be done in development.
So remove DEBUG.

Signed-off-by: Tom Rix <trix@redhat.com>
---
 drivers/net/ethernet/freescale/gianfar.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/ethernet/freescale/gianfar.c b/drivers/net/ethernet/freescale/gianfar.c
index d391a45cebb6..541de32ea662 100644
--- a/drivers/net/ethernet/freescale/gianfar.c
+++ b/drivers/net/ethernet/freescale/gianfar.c
@@ -58,7 +58,6 @@
  */
 
 #define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
-#define DEBUG
 
 #include <linux/kernel.h>
 #include <linux/string.h>
-- 
2.27.0

