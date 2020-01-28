Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF53014AD46
	for <lists+netdev@lfdr.de>; Tue, 28 Jan 2020 01:38:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgA1Aim (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 19:38:42 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:36985 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725955AbgA1Aim (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 19:38:42 -0500
Received: by mail-wr1-f67.google.com with SMTP id w15so14011511wru.4
        for <netdev@vger.kernel.org>; Mon, 27 Jan 2020 16:38:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=broadcom.com; s=google;
        h=from:to:cc:subject:date:message-id;
        bh=BvCx+GGin1m9Xq7Oj/YFcqGJi/zTNFOV1E+5/BsLcV8=;
        b=XOxGeOfM/jYivd+YFd6WlQpnRSlifN0chcYNtl+1Bahviwc0N1ArYy88KYynhnfnwJ
         5aMBZc4JAS8zpfGP6u5kMpRH1/5lzgm97NR4WpbPqYG33F5Cw/IdHK+NbMFV2GpbzoBo
         NSBaunbWoIgLs0c7UpC5TlGwNO9fss5eSR2TM=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:date:message-id;
        bh=BvCx+GGin1m9Xq7Oj/YFcqGJi/zTNFOV1E+5/BsLcV8=;
        b=RyM06dpvXRX7GoyhKgFEIuyidxowb04lydbS1edjjBBwkI5473NWTbq31PqSvju3Jf
         BeYyRHBsUrDhGF/81svHo6PHJIfoYXWneLxw7oTlOU23Tyiwc86iEBvzn0ViDhdMdEF9
         dSKtlWFTuGcfhHELltXANT1vHrP9xAfOTLPcAqJmEtws0bdMzYVZIN6fObF1VuXkvN3N
         NyvyQE1uIq41c+lg261Ma6as2UFvDc3xMtmB4WQjBz7nT5E8s16hd6BYLC4WAFnAKEZL
         pMZcPpCf7r9QfV+EtZ9WvdRHZYj2kzWNWXRUgVdhFt6NPzCX2sNdejURALzrgbO68kAU
         +N7g==
X-Gm-Message-State: APjAAAUi5R6DcXqaeTt+XbDZnPxPH0KE+k5sUff6kMzx1prz0F9ZTDJd
        UDdHs3pqfnpj/N15hSsW1afPIg==
X-Google-Smtp-Source: APXvYqz+T7/gzM41/abtTH9r6AoYnsKVJxrhCNkNFgKDrdKjW5d53iyNfSywkRM1kFINyWTmImx3Qw==
X-Received: by 2002:adf:f10a:: with SMTP id r10mr24938413wro.202.1580171920707;
        Mon, 27 Jan 2020 16:38:40 -0800 (PST)
Received: from lbrmn-lnxub113.broadcom.net ([192.19.228.250])
        by smtp.gmail.com with ESMTPSA id l7sm22659156wrq.61.2020.01.27.16.38.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 27 Jan 2020 16:38:40 -0800 (PST)
From:   Scott Branden <scott.branden@broadcom.com>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     BCM Kernel Feedback <bcm-kernel-feedback-list@broadcom.com>,
        Russell King <linux@armlinux.org.uk>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Scott Branden <scott.branden@broadcom.com>
Subject: [PATCH 1/1] net: phy: add default ARCH_BCM_IPROC for MDIO_BCM_IPROC
Date:   Mon, 27 Jan 2020 16:38:28 -0800
Message-Id: <20200128003828.20439-1-scott.branden@broadcom.com>
X-Mailer: git-send-email 2.17.1
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Add default MDIO_BCM_IPROC Kconfig setting such that it is default
on for IPROC family of devices.

Signed-off-by: Scott Branden <scott.branden@broadcom.com>
---
 drivers/net/phy/Kconfig | 1 +
 1 file changed, 1 insertion(+)

diff --git a/drivers/net/phy/Kconfig b/drivers/net/phy/Kconfig
index 8dc461f7574b..b6315a01f36e 100644
--- a/drivers/net/phy/Kconfig
+++ b/drivers/net/phy/Kconfig
@@ -38,6 +38,7 @@ config MDIO_BCM_IPROC
 	tristate "Broadcom iProc MDIO bus controller"
 	depends on ARCH_BCM_IPROC || COMPILE_TEST
 	depends on HAS_IOMEM && OF_MDIO
+	default ARCH_BCM_IPROC
 	help
 	  This module provides a driver for the MDIO busses found in the
 	  Broadcom iProc SoC's.
-- 
2.17.1

