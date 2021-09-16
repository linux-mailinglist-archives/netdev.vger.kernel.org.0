Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C07340EB1E
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 21:51:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235220AbhIPTwV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 15:52:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36998 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233659AbhIPTwU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 15:52:20 -0400
Received: from mail-oi1-x22e.google.com (mail-oi1-x22e.google.com [IPv6:2607:f8b0:4864:20::22e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F220BC061574;
        Thu, 16 Sep 2021 12:50:59 -0700 (PDT)
Received: by mail-oi1-x22e.google.com with SMTP id s69so3104909oie.13;
        Thu, 16 Sep 2021 12:50:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=sender:from:to:cc:subject:date:message-id:mime-version
         :content-transfer-encoding;
        bh=c9W6A7RbeiDK5VbKw0W/zFYhWGW764dVGPLQjzYkqYE=;
        b=OSnWIUtcT8PotAuXIAgaeo4XPTYrWC8eIrmkogQypkYPPfWVHft+oB48WWHyvdihhU
         A0Iq7oNu+O3FTwxwRkJ1c976IFlZiFNX3efsx8E6PxcCFcEhq9kFSAr+l9GXiMWmwQIL
         ZRPGPIiVFvKg/k2/fjc1691+xukG2zIN1KaB6b2NfJjwoCyW+b3WkRchMkBNVuCbNHe9
         6cTDtX/8fWXF2GLSHdwXLOu6ity/GLDOftD/n1KDmfN3qxJWQPvotzr0Mz9tykcwHLUJ
         zvHXcHqtri1udfLu8O/epwbSituTzdn3uQGCpacD+TTkDv5AYigLAOZT3rXpa5Q7DOHj
         TYnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:sender:from:to:cc:subject:date:message-id
         :mime-version:content-transfer-encoding;
        bh=c9W6A7RbeiDK5VbKw0W/zFYhWGW764dVGPLQjzYkqYE=;
        b=09JbsVCBgUIztt7gvopdDyaVpHNs7bq76KCi2usLUm2W8xDmxm8tZ1lHuU+MEh7bYg
         FRDFWJSA5czNG75TGEFrgucYJyFGmciPetNrjkbOigG9pUxInma15SDeoM+Yfx1VO5vE
         0NBjQlWC8BcAzdGjxDimGqOTwSP+ANxVb/WL46WfDqUO72YEatpMpwiQeo4u91pH5te8
         leVUz/Wlq+dwhnT+ImMbwpMZ4As1N66QeoWz7IEyR/iGCgwzN/RlkUnc5WPSJGzUKxSK
         ms5pWzoCY/fxEmzlEq8FkM1/rXqFQ3yBlm8b8DnrvdIyL1RyfZ+ZhH1py1OaqCalzd5c
         73XQ==
X-Gm-Message-State: AOAM531AxnIuiJH01l6FNNCldIrU2JGmYMYCYWhakgBWvR8CQy+4FOhJ
        bofU4u6p54fy/5uakPR3bHk=
X-Google-Smtp-Source: ABdhPJzqH8GWgtYXQra+H4tQGcWoLQFanpz8CcNr2uJTs7XQyX1G+h5uUhK62zaqoL6/aiamJb8jfA==
X-Received: by 2002:a05:6808:56:: with SMTP id v22mr10693015oic.49.1631821859411;
        Thu, 16 Sep 2021 12:50:59 -0700 (PDT)
Received: from server.roeck-us.net ([2600:1700:e321:62f0:329c:23ff:fee3:9d7c])
        by smtp.gmail.com with ESMTPSA id x4sm925683ood.2.2021.09.16.12.50.58
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 16 Sep 2021 12:50:58 -0700 (PDT)
Sender: Guenter Roeck <groeck7@gmail.com>
From:   Guenter Roeck <linux@roeck-us.net>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH] net: phy: dp83640: Drop unused PAGE0 define
Date:   Thu, 16 Sep 2021 12:50:55 -0700
Message-Id: <20210916195055.1694099-1-linux@roeck-us.net>
X-Mailer: git-send-email 2.33.0
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

parisc:allmodconfig fails to build with the following error.

In file included from drivers/net/phy/dp83640.c:23:
drivers/net/phy/dp83640_reg.h:8: error: "PAGE0" redefined

The dp83640 driver does not use this define, so just remove it.

Signed-off-by: Guenter Roeck <linux@roeck-us.net>
---
 drivers/net/phy/dp83640_reg.h | 1 -
 1 file changed, 1 deletion(-)

diff --git a/drivers/net/phy/dp83640_reg.h b/drivers/net/phy/dp83640_reg.h
index 21aa24c741b9..601e8d107723 100644
--- a/drivers/net/phy/dp83640_reg.h
+++ b/drivers/net/phy/dp83640_reg.h
@@ -5,7 +5,6 @@
 #ifndef HAVE_DP83640_REGISTERS
 #define HAVE_DP83640_REGISTERS
 
-#define PAGE0                     0x0000
 #define PHYCR2                    0x001c /* PHY Control Register 2 */
 
 #define PAGE4                     0x0004
-- 
2.33.0

