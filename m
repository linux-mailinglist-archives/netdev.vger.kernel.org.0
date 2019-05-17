Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A0B421F0E
	for <lists+netdev@lfdr.de>; Fri, 17 May 2019 22:25:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726818AbfEQUZ2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 May 2019 16:25:28 -0400
Received: from mail-pg1-f193.google.com ([209.85.215.193]:45288 "EHLO
        mail-pg1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726295AbfEQUZ1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 May 2019 16:25:27 -0400
Received: by mail-pg1-f193.google.com with SMTP id i21so3784401pgi.12
        for <netdev@vger.kernel.org>; Fri, 17 May 2019 13:25:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=from:to:cc:subject:date:message-id:in-reply-to:references:to;
        bh=RBSksU0/Pd9tM5kW/qoaE3L3r0D52GlA1KMSIgcu75Y=;
        b=I4BcuuH2MW2IdSFN3VZQTPQsmIwpzSqM07C7SLaLI7uHly6hIuA6qXqz7509JQw2s6
         aPPpFzsVAT7WXR4ugfyX3Ls8vWyQ9foDocF6n5CNEc41LwikQ0gRJfx7ANFXhLS1k4G4
         yv2hkb+iLwBmxEzvRaZUsFzN7jAVKdcKv4RnWsX84UvHgG9b08znzBjUwUbU2H+2GG2w
         XzTkr+/NrnQMhrHqqnCgandEfGcVOj8c6riDGKaUyfKSAs5kh2HZnDLf3NRkuwSj5CK+
         jlbzd44/c7Qp9uTEBJMce6Hm85fwzLFag3bW4y6KzWksDStib1G03P591dD1kIFD9/XK
         QBKA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id:in-reply-to
         :references:to;
        bh=RBSksU0/Pd9tM5kW/qoaE3L3r0D52GlA1KMSIgcu75Y=;
        b=eg13yed1oQ34PiWz3I8FuakQQdjP1ylKvpshvGp5aa3VCOzEE+H3bOiobGb9FVLNcJ
         p+F+EmUby/KLkIjv+ZmAKHkw5YtyXdJVh0GMnxlBh6jHyS6L6gNSes5scXBjYoZGN0fu
         Jus3nAkxIyduUIClC++G36QWR4jq2HXMy72WkDXqXHMiD3MEtwX/zeWfRX69k17xxbGX
         E90DEsITXQsoX2NMZdJYwS6/YoxPzOsv1XFAepu4uLsbBV7HsuZFFP7qADuaS0WII8Yx
         huUQ07WWJ+lvZ313ZbVJ0XucigW/qsVWZsgIjSsnOuCXho6iHc3HBEez+7Sg5t1K9jNr
         r+MA==
X-Gm-Message-State: APjAAAWX2xa5f71CBh6KOFHjIJ6abXOMWpvvUEW3s6vr/3Igt8GlKqPO
        tfSVurbf+7ljsPHlU2gSAQI=
X-Google-Smtp-Source: APXvYqzDE/YXN6oYC1wk5GIEw1IF8/UMra2nX8LGNwdIDa1WKn3+SFHsyTIiNZmZL4dkZpnWBT6bLw==
X-Received: by 2002:a63:5105:: with SMTP id f5mr42418593pgb.373.1558124727335;
        Fri, 17 May 2019 13:25:27 -0700 (PDT)
Received: from xplor.waratah.dyndns.org (122-58-182-39-adsl.sparkbb.co.nz. [122.58.182.39])
        by smtp.gmail.com with ESMTPSA id x28sm5752050pfo.78.2019.05.17.13.25.26
        (version=TLS1 cipher=AES128-SHA bits=128/128);
        Fri, 17 May 2019 13:25:26 -0700 (PDT)
Received: by xplor.waratah.dyndns.org (Postfix, from userid 1000)
        id C7845360079; Sat, 18 May 2019 08:25:22 +1200 (NZST)
From:   Michael Schmitz <schmitzmic@gmail.com>
To:     netdev@vger.kernel.org
Cc:     schmitz@debian.org, Michael Schmitz <schmitzmic@gmail.com>,
        sfr@canb.auug.org.au, davem@davemloft.net
Subject: [PATCH 0/3] resolve module name conflict for asix PHY and USB modules 
Date:   Sat, 18 May 2019 08:25:15 +1200
Message-Id: <1558124718-19209-1-git-send-email-schmitzmic@gmail.com>
X-Mailer: git-send-email 1.7.0.4
In-Reply-To: <20190514105649.512267cd@canb.auug.org.au>
References: <20190514105649.512267cd@canb.auug.org.au>
To:     netdev@vger.kernel.org
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Haven't heard back in a while, so here goes: 

Commit 31dd83b96641 ("net-next: phy: new Asix Electronics PHY driver")
introduced a new PHY driver drivers/net/phy/asix.c that causes a module
name conflict with a pre-existiting driver (drivers/net/usb/asix.c). 

The PHY driver is used by the X-Surf 100 ethernet card driver, and loaded
by that driver via its PHY ID. A rename of the driver looks unproblematic.
 
Rename PHY driver to ax88796b.c in order to resolve name conflict. 

Fixes: 31dd83b96641 ("net-next: phy: new Asix Electronics PHY driver")

Michael Schmitz (3):
  net: phy: new ax88796b.c Asix Electronics PHY driver
  net: 8390: switch X-Surf 100 driver to use ax88796b PHY
  net: phy: remove old Asix Electronics PHY driver

 drivers/net/ethernet/8390/Kconfig |  2 +-
 drivers/net/phy/Kconfig           |  2 +-
 drivers/net/phy/Makefile          |  2 +-
 drivers/net/phy/asix.c            | 57 ---------------------------------------
 drivers/net/phy/ax88796b.c        | 57 +++++++++++++++++++++++++++++++++++++++
 5 files changed, 60 insertions(+), 60 deletions(-)
 delete mode 100644 drivers/net/phy/asix.c
 create mode 100644 drivers/net/phy/ax88796b.c

-- 
1.9.1

