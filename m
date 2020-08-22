Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6364524E9B4
	for <lists+netdev@lfdr.de>; Sat, 22 Aug 2020 22:12:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727887AbgHVULk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Aug 2020 16:11:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727005AbgHVULf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Aug 2020 16:11:35 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99634C061573;
        Sat, 22 Aug 2020 13:11:35 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id m8so2788081pfh.3;
        Sat, 22 Aug 2020 13:11:35 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references;
        bh=S67iTBPnpzxaGFReQmRpr80ikjpraPnXsf7tqbs4ukE=;
        b=YzXny30WzrI5IufFDgKZKLxLJhKiPpj5TufAmRdNyIRosvtkjAmAGh2E8xc+xlLBej
         iYXI0/dkBQsAC9RYbdKDQreNcKK4yzc5TY3z1ePZjk8n8Iq1D90Fc1ROGv7qRf1r5VtP
         AIqTTIpCRoLQqPOHt1dX6VUygzMN13ma9d4wqbUX7EC9JFhfHzD27tB2vuteHNPgyKke
         QrEsqZocQp9h2BGaLfROKJVVqPAbmoK0UMwU1lWMY7MK3aSFcDcIok5pa5lQQrEyph83
         XPJOa6U+PhU3M5OgWl60fCxivo9LQdV3iN8eLUxVEXj6PKrHc4eKSbyfYAEduKflbS4a
         Q6hA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references;
        bh=S67iTBPnpzxaGFReQmRpr80ikjpraPnXsf7tqbs4ukE=;
        b=CfD8x4pbgXYWwd4ekSAzCESTrGlGoiaV0JZvGtIqX2ZgcnRjqP26vhs+gSB+Ay3bql
         t19ZEpsIv9ZiuQHqtVExdp0wlkLvHfuBdLE3g6nAP+3vKNXyBxcikSSElIsqpGytq+/k
         etNieCJN6PYXV4rQcxok5xT08yvKaGSS6EdcEPgbeoENwwIBZAmRQxnxzWgK1PxhjJsL
         upz8644kIc9R0lRgkh7reHQGcm5APDkH78dm3sQKjRoZMT/4Jbh031eb3pCOclu/AXPJ
         S+JAgP6NRnYj/DCcee59Vc6oN7XYmZeczrXlU9xly5gmYpcIaoRWp7PsnB6DV61CgmPe
         xFfg==
X-Gm-Message-State: AOAM533Wc234zfbORa0kYTkfesaqFa6p6Hod3nQ/N2PxvBSTKKNhxULh
        xCSVezcLLy0ahFP6q2mPk/T5yuYzNgE=
X-Google-Smtp-Source: ABdhPJxaG1K4/c7BLH6CH56uNMWyHnIUAX0jLTn/48LCOwqY2YjoI+tGqA80sfb5YD2l4aX3NAxA4A==
X-Received: by 2002:a63:ee0d:: with SMTP id e13mr6066828pgi.337.1598127094797;
        Sat, 22 Aug 2020 13:11:34 -0700 (PDT)
Received: from 1G5JKC2.lan (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id na16sm4678779pjb.30.2020.08.22.13.11.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 22 Aug 2020 13:11:34 -0700 (PDT)
From:   Florian Fainelli <f.fainelli@gmail.com>
To:     netdev@vger.kernel.org
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, kuba@kernel.org,
        linux-kernel@vger.kernel.org, linux-netdev@vger.kernel.org,
        bcm-kernel-feedback-list@broadcom.com,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: [PATCH net-next 1/6] MAINTAINERS: GENET: Add missing platform data file
Date:   Sat, 22 Aug 2020 13:11:21 -0700
Message-Id: <20200822201126.8253-2-f.fainelli@gmail.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20200822201126.8253-1-f.fainelli@gmail.com>
References: <20200822201126.8253-1-f.fainelli@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

When commit b0ba512e25d7 ("net: bcmgenet: enable driver to work without
a device tree") added include/linux/platform_data/bcmgenet.h, the file
was not added to the GENET MAINTAINERS file section, add it now.

Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
---
 MAINTAINERS | 1 +
 1 file changed, 1 insertion(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index 2c8964c9b876..0c081a21a3e9 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3580,6 +3580,7 @@ L:	bcm-kernel-feedback-list@broadcom.com
 L:	netdev@vger.kernel.org
 S:	Supported
 F:	drivers/net/ethernet/broadcom/genet/
+F:	include/linux/platform_data/bcmgenet.h
 
 BROADCOM IPROC ARM ARCHITECTURE
 M:	Ray Jui <rjui@broadcom.com>
-- 
2.17.1

