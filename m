Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E7C2309B4
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 14:13:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729506AbgG1MNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 08:13:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728896AbgG1MNh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 08:13:37 -0400
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4AEE8C061794
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 05:13:36 -0700 (PDT)
Received: by mail-pf1-x441.google.com with SMTP id l2so4524376pff.0
        for <netdev@vger.kernel.org>; Tue, 28 Jul 2020 05:13:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=puresoftware-com.20150623.gappssmtp.com; s=20150623;
        h=from:to:cc:subject:date:message-id;
        bh=ubsNc+uvwvGXfst30oKeRj2zBjsfDGJ/GwKkkNwK6RA=;
        b=D4jK1uSmFkpteII4t6LDn0X+NBwMKqkOP1VD/copCOYecYTZ5W3UNzFY4+QTgGBTSf
         BdFONt+fBrY3QSu2plykindZ1rEWftuhLmiLAvfQVYk8N8CXjjwQTNwHSkFQxK0y5r3N
         oRZ72KdrmaUw5ixLzIxKQlt7xRkcRvQOlhiF5DfJovEzm+daVVY0RYH9L7/5t5L3cxW1
         dGPgUu3pVdU3j6VSFKq/BCCP6jrPJjcd5tUr7KIrFiuwhS6wiCHhFbL9C2Mq+TaUEn3O
         7hJR1Ea67SFaI2mqopAr57G2TSzAGYii2i/BC4qoJmo/SYQxjxctX/VG5xJDEkxy1sEe
         C40w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=ubsNc+uvwvGXfst30oKeRj2zBjsfDGJ/GwKkkNwK6RA=;
        b=F7NATuJLFoOhvOT3f3gTEc2UNkce4JJcmBqV0uOVhoqjB4dNxp8MsiWngNX809Crmi
         5EZU7s6JajEjxXKIf27TyRjGo7TsoDxLtSvjJFJDq1zQoFLD9eWQKCd54T+x+K2HKSj+
         8VLPWDuD8BURn+XWM/3ELiM7UGRce7kVkUDhGQCbe0mtezhEUpjBZJSAFWZ0syOty24+
         TsOStcGSf91vWUxobCQOFaDN1hxDyA6utI/7qqG/uTwCZwS9utoHdkidPxwafyPUoRlN
         DmBZY1qJwSWSyXG01cIjdSGOmOTkrdQ7Sco8hHEcJCGbaZ0byAPG1d8uhrkx4K5g6e7N
         QtOA==
X-Gm-Message-State: AOAM530MDhXWSJkpattSlO2pjc8+YQufAW1y8C4/TApTt0oImyiDs3Re
        EZ1nKlyGG8lRAVvxnoQfUjTEVA==
X-Google-Smtp-Source: ABdhPJxP/dkFrxVdf21AiNb1cZRu53Qzb9RZ1XynFIw/CZWPkjcyof/J8r4ND5fvKVJMSM04P1gAUw==
X-Received: by 2002:a05:6a00:224f:: with SMTP id i15mr25682522pfu.241.1595938415853;
        Tue, 28 Jul 2020 05:13:35 -0700 (PDT)
Received: from embedded-PC.puresoft.int ([125.63.92.170])
        by smtp.gmail.com with ESMTPSA id f29sm18203612pga.59.2020.07.28.05.13.32
        (version=TLS1_2 cipher=ECDHE-ECDSA-AES128-GCM-SHA256 bits=128/128);
        Tue, 28 Jul 2020 05:13:35 -0700 (PDT)
From:   Vikas Singh <vikas.singh@puresoftware.com>
To:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        linux@armlinux.org.uk, netdev@vger.kernel.org
Cc:     calvin.johnson@oss.nxp.com, kuldip.dwivedi@puresoftware.com,
        madalin.bucur@oss.nxp.com, vikas.singh@nxp.com,
        Vikas Singh <vikas.singh@puresoftware.com>
Subject: [PATCH 0/2] Add fwnode helper functions to MDIO bus driver
Date:   Tue, 28 Jul 2020 17:43:18 +0530
Message-Id: <1595938400-13279-1-git-send-email-vikas.singh@puresoftware.com>
X-Mailer: git-send-email 2.7.4
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patch add helper functions to handle fwnodes on MDIO bus in case of
ACPI probing. These helper functions will be used in DPAA MAC driver.

The patches are in below logical order:
1. Add helper function to attach MAC with PHY
2. Associate device node with fixed PHY by extending "fixed_phy_status"

Vikas Singh (2):
  net: phy: Add fwnode helper functions
  net: phy: Associate device node with fixed PHY

 drivers/net/phy/fixed_phy.c |  2 ++
 drivers/net/phy/mdio_bus.c  | 66 +++++++++++++++++++++++++++++++++++++++++++++
 include/linux/mdio.h        |  4 +++
 include/linux/phy_fixed.h   |  2 ++
 4 files changed, 74 insertions(+)

-- 
2.7.4

