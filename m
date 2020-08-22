Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C296E24E9AC
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 22:12:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728021AbgHVULv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 16:11:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727822AbgHVULo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 16:11:44 -0400
Received: from mail-pj1-x1044.google.com (mail-pj1-x1044.google.com [IPv6:2607:f8b0:4864:20::1044])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4E3DBC061574;
        Sat, 22 Aug 2020 13:11:43 -0700 (PDT)
Received: by mail-pj1-x1044.google.com with SMTP id ep8so2266210pjb.3;
        Sat, 22 Aug 2020 13:11:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=tK0Ub0vW92zQf1mG8mtQSjdxQlYiAGtq0/t0HxuRxNM=;
        b=X8ySReo4tx9KGuKMFJKINySEv/O9Rb3tq5MYdc26ikhhrxMtSvxHR4rW0D9Fvt9soi
         XwY5YkvsGPOyYWWDXytFuqljPxeZdSH3w/lct0I2TettKB1TOJO9pj9YKOfZPsAZI4dM
         yjfsTx1YeYDQljZUUff6r8SssFY2ZvMqjnYeO6qDvnrSs0OIc3lsMHjLVgEFR1byg56w
         +bocIVInuhdElO6KNZKqNHeCFskABw5q0LhwEt3qaYIXtfeefQziUtKrHoBgNGDa5ChI
         27TZ3SAwxz7SCTK7LmCCIdqGCvZDl6JHCac6Z7zbmYRxhO14PGBAebDo0VHxZIH1jU1u
         37aQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=tK0Ub0vW92zQf1mG8mtQSjdxQlYiAGtq0/t0HxuRxNM=;
        b=FhCpBGSNIk03B9Fk5u1aw18wV6rN5+Gko9HzgjdT/4GOApVoZf3WawPY3lqZt1Ap3J
         cG/VTCvmT8VeUXpWy935i3AYXSZUK/ovRirZnatEm2nFw4WPjXy2hJoaiyRFGs0PD1Do
         phGvamgqOPUBPE5X1QVaIMg6JcC1+YXOyrxR70b6PHBkYTIaOE4NC5yKbxyzhE7eNlRk
         wf50Cfsq1p9oeKSKZ0SuY+59asg1gQXonDx/irFfopgnpQtHEun8t5SamC6lrg4Bb0bD
         qA4kZjyyKfNz7Z+Q4Ad8YEo3Dzo/E6olBWCwnCxE2hyA6aIwBujGUJeb/l7PQyXfgLXH
         vgog==
X-Gm-Message-State: AOAM533DUJwtx68MfBznxrtU7inHd9mrgqQ5MCEKQNYst2pG6W1FA4Kv
        NwZiUOBu4NfFrsCSkjBUR2i9WpFs6wQ=
X-Google-Smtp-Source: ABdhPJz2E+YyYXjApTQJ28GIcOXyQciBv8/ohygMlXEry+Ak0eQLDoHzVVhCuSQLhjUYWPv2r1iXOw==
X-Received: by 2002:a17:902:b115:: with SMTP id q21mr6718024plr.191.1598127101832;
        Sat, 22 Aug 2020 13:11:41 -0700 (PDT)
Received: from 1G5JKC2.lan (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id na16sm4678779pjb.30.2020.08.22.13.11.40
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2020 13:11:41 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next 5/6] MAINTAINERS: Add entry for Broadcom Ethernet PHY drivers
Date:   Sat, 22 Aug 2020 13:11:25 -0700
Message-Id: <20200822201126.8253-6-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200822201126.8253-1-f.fainelli@gmail.com>
References: <20200822201126.8253-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add an entry for the Broadcom Ethernet PHY drivers covering the BCM63xx,
BCM7xxx, BCM87xx, BCM54140, BCM84881, the venerable broadcom.c driver
and the companion library files.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 MAINTAINERS | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 4eb5b61d374a..db4158515592 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3574,6 +3574,16 @@ L:	bcm-kernel-feedback-list@broadcom.com
 S:	Maintained
 F:	drivers/phy/broadcom/phy-brcm-usb*
 
+BROADCOM ETHERNET PHY DRIVERS
+M:	Florian Fainelli <f.fainelli@gmail.com>
+L:	bcm-kernel-feedback-list@broadcom.com
+L:	netdev@vger.kernel.org
+S:	Supported
+F:	Documentation/devicetree/bindings/net/broadcom-bcm87xx.txt
+F:	drivers/net/phy/bcm*.[ch]
+F:	drivers/net/phy/broadcom.c
+F:	include/linux/brcmphy.h
+
 BROADCOM GENET ETHERNET DRIVER
 M:	Doug Berger <opendmb@gmail.com>
 M:	Florian Fainelli <f.fainelli@gmail.com>
-- 
2.17.1

