Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A9C9E437AC1
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 18:17:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233369AbhJVQT1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 12:19:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233186AbhJVQT0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Oct 2021 12:19:26 -0400
Received: from mail-pg1-x534.google.com (mail-pg1-x534.google.com [IPv6:2607:f8b0:4864:20::534])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 97845C061764;
        Fri, 22 Oct 2021 09:17:08 -0700 (PDT)
Received: by mail-pg1-x534.google.com with SMTP id q187so3772250pgq.2;
        Fri, 22 Oct 2021 09:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=from:to:cc:subject:date:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=Uk58drJFO2v53jvqlvnd1UXuMSoipvawt1I25ukhZag=;
        b=Q/TyobwEExbtOHj632B0PGSyw4un/DzPapYHxXlYZ1wa+eY8NAboWCK2VWZw+lLMev
         8ZcW1Cd6n6DYcdHOr8qbJSRIQIlz0Uz3yNPevsWxK/VC8qkwGnVHipDHOR9guk9oOdad
         CvgeUS/JeCoM+82x1B78cunnSdxBDsEUdle9N9D1Vpe4jJ5VsJGSHfGbFOp8EAAgF965
         uSWObIrwmjmbMmIU54a2QtIrzGryR23BI8umO927fi9Oip+Ojf5r9U4RCxRzO0jCNwHd
         EQMcTpykqZdo4vACRYGSl72fU6VnQ1BcxBOaDWIZxYBvSjYCNeJcnl+TojzatykuMAHm
         BJpw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=Uk58drJFO2v53jvqlvnd1UXuMSoipvawt1I25ukhZag=;
        b=xFnWOoZSEoc+9jGmD2ZE/nEBhve73ddbhMzHt36M3ZNWXpBz5V7uvlQQtYDjIqD0Cn
         Ff1TG8Hg/C1kaoWyq5E0MxoVmc5VvgtZw83sstWmn41BkFN9KvHn75vWETUU034CCgo/
         2tUFen3NP7A5Qw40tbORrVbkUPaHQBMS75dpaOkJ1rH9r8hKq0TcLd31D5SqR8cCoB1D
         bM8lNF1pYVOAZx17H+52ARD2cRpu5uY7sl5TniODYwGtOzJt0tJ8x9FFFr6YFNfXimkh
         ZrWc8OyBoSmndZgqdsfBKeXRaPX0KKFq00CNHBwhuqZSzzI3Viwp84ZI2LCd0ceahRBo
         apqg==
X-Gm-Message-State: AOAM530KldANlvJ+xKlQeXxIrc7lU9fLX7LoPp/VZTRAu0jjv0ESTTqf
        l1MxA1pwM09KTLnWLWexLdAOzhH1vIs=
X-Google-Smtp-Source: ABdhPJzwo2/4oFYRTKpNbtatK4cqhx4KggGw75NANSUpOa2P8uwM5IKOCccDM7k45PkbH4ex0EvARg==
X-Received: by 2002:aa7:983a:0:b0:44d:8bc8:b0ac with SMTP id q26-20020aa7983a000000b0044d8bc8b0acmr664680pfl.83.1634919427749;
        Fri, 22 Oct 2021 09:17:07 -0700 (PDT)
Received: from fainelli-desktop.igp.broadcom.net ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id nn14sm9866556pjb.27.2021.10.22.09.17.06
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 22 Oct 2021 09:17:07 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Doug Berger <opendmb@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        bcm-kernel-feedback-list@broadcom.com (open list:BROADCOM GENET
        ETHERNET DRIVER), linux-kernel@vger.kernel.org (open list)
Subject: [PATCH net-next 1/3] net: phy: bcm7xxx: Add EPHY entry for 7712
Date:   Fri, 22 Oct 2021 09:17:01 -0700
Message-Id: <20211022161703.3360330-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.25.1
In-Reply-To: <20211022161703.3360330-1-f.fainelli@gmail.com>
References: <20211022161703.3360330-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

7712 is a 16nm process SoC with a 10/100 integrated Ethernet PHY,
utilize the recently defined 16nm EPHY macro to configure that PHY.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 drivers/net/phy/bcm7xxx.c | 2 ++
 include/linux/brcmphy.h   | 1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/phy/bcm7xxx.c b/drivers/net/phy/bcm7xxx.c
index 6ceadd2a0082..75593e7d1118 100644
--- a/drivers/net/phy/bcm7xxx.c
+++ b/drivers/net/phy/bcm7xxx.c
@@ -936,6 +936,7 @@ static struct phy_driver bcm7xxx_driver[] = {
 	BCM7XXX_40NM_EPHY(PHY_ID_BCM7425, "Broadcom BCM7425"),
 	BCM7XXX_40NM_EPHY(PHY_ID_BCM7429, "Broadcom BCM7429"),
 	BCM7XXX_40NM_EPHY(PHY_ID_BCM7435, "Broadcom BCM7435"),
+	BCM7XXX_16NM_EPHY(PHY_ID_BCM7712, "Broadcom BCM7712"),
 };
 
 static struct mdio_device_id __maybe_unused bcm7xxx_tbl[] = {
@@ -958,6 +959,7 @@ static struct mdio_device_id __maybe_unused bcm7xxx_tbl[] = {
 	{ PHY_ID_BCM7439, 0xfffffff0, },
 	{ PHY_ID_BCM7435, 0xfffffff0, },
 	{ PHY_ID_BCM7445, 0xfffffff0, },
+	{ PHY_ID_BCM7712, 0xfffffff0, },
 	{ }
 };
 
diff --git a/include/linux/brcmphy.h b/include/linux/brcmphy.h
index 27d9b6683f0e..747fad264033 100644
--- a/include/linux/brcmphy.h
+++ b/include/linux/brcmphy.h
@@ -50,6 +50,7 @@
 #define PHY_ID_BCM7439			0x600d8480
 #define PHY_ID_BCM7439_2		0xae025080
 #define PHY_ID_BCM7445			0x600d8510
+#define PHY_ID_BCM7712			0x35905330
 
 #define PHY_ID_BCM_CYGNUS		0xae025200
 #define PHY_ID_BCM_OMEGA		0xae025100
-- 
2.25.1

