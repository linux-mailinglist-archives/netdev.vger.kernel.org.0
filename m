Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42B684687A0
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 22:06:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234688AbhLDVJc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 4 Dec 2021 16:09:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232749AbhLDVJc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 4 Dec 2021 16:09:32 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D17BAC061751;
        Sat,  4 Dec 2021 13:06:05 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=JMDfMLkmy9vZ+DWnVm3H854hWHUeVhzdVnP8kYwWhWw=; b=YTLEawqfbScqsn20pWtQNsfSNj
        EvcnePg4REVrqzqP/Dn/dnygAsYHl2yvWml9F3e+jmH+cmYdtpqQwkg+FDHO0A7MHVyCK9Is4Sb55
        OEUOUSfEG0plmTSjQ3F7aqggXGEVqQn8ADQKSv82VM/e2s2gYc7wo6jOo4GnGnmgufWIY/DjznM4q
        /rLqSG+RJPaqKQOdgYhXnOkCkxwnq0/FFXjhyZyGJpbcQn4oNNp3XMEABdc/7XXgT5s2ZXonkEkP/
        FCcca97gg/cJZVdGXYSfo3lgOqDf3AykfHNo2WFNuD5odngsT63BlsWwvLY73MhUoaSPwUv6psGka
        XyJsEJ8g==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56066)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1mtcEK-0003XU-0K; Sat, 04 Dec 2021 21:06:00 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1mtcEF-0002ix-7E; Sat, 04 Dec 2021 21:05:55 +0000
Date:   Sat, 4 Dec 2021 21:05:55 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Yinbo Zhu <zhuyinbo@loongson.cn>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kbuild@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Michal Marek <michal.lkml@markovi.net>,
        Nick Desaulniers <ndesaulniers@google.com>
Subject: Re: [PATCH v3 1/2] modpost: file2alias: make mdio alias configure
 match mdio uevent
Message-ID: <YavYM2cs0RuY0JdM@shell.armlinux.org.uk>
References: <1638260517-13634-1-git-send-email-zhuyinbo@loongson.cn>
 <YaXrP1AyZ3AWaQzt@shell.armlinux.org.uk>
 <ea3f6904-c610-0ee6-fbab-913ba6ae36c5@loongson.cn>
 <Yas2+yq3h5/Bfvy9@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Yas2+yq3h5/Bfvy9@shell.armlinux.org.uk>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Dec 04, 2021 at 09:38:03AM +0000, Russell King (Oracle) wrote:
> I have told you several times to separate out the change to the name
> used in bus_type. You have completely ignored that. I will quite simply
> NAK that patch every time you post it as long as you have not made that
> change.
> 
> I have told you that your patch will cause regressions. You continue
> to repost it. I will NAK your patch as long as it contains a known
> regression because causing a regression is totally _unacceptable_.

Here is a patch that stands a far better chance of being acceptable
and resolving your issue. Please test this patch and check whether
it solves your issue.

If it does not solve your issue, then please post a _full_ kernel
boot log and provide your kernel configuration (the .config file).

Thanks.

8<====
From: "Russell King (Oracle)" <rmk+kernel@armlinux.org.uk>
Subject: [PATCH net-next] net: phy: generate PHY mdio modalias

The modalias string provided in the uevent sysfs file does not conform
to the format used in PHY driver modules. One of the reasons is that
udev loading of PHY driver modules has not been an expected use case.

This patch changes the MODALIAS entry for only PHY devices from:
	MODALIAS=of:Nethernet-phyT(null)
to:
	MODALIAS=mdio:00000000001000100001010100010011

Other MDIO devices (such as DSA) remain as before.

However, having udev automatically load the module has the advantage
of making use of existing functionality to have the module loaded
before the device is bound to the driver, thus taking advantage of
multithreaded boot systems, potentially decreasing the boot time.

However, this patch will not solve any issues with the driver module
not being loaded prior to the network device needing to use the PHY.
This is something that is completely out of control of any patch to
change the uevent mechanism.

Reported-by: Yinbo Zhu <zhuyinbo@loongson.cn>
Signed-off-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>
---
 drivers/net/phy/mdio_bus.c   |  8 ++++++++
 drivers/net/phy/phy_device.c | 14 ++++++++++++++
 include/linux/mdio.h         |  2 ++
 3 files changed, 24 insertions(+)

diff --git a/drivers/net/phy/mdio_bus.c b/drivers/net/phy/mdio_bus.c
index 9b6f2df07211..68cf59ce7343 100644
--- a/drivers/net/phy/mdio_bus.c
+++ b/drivers/net/phy/mdio_bus.c
@@ -994,8 +994,16 @@ static int mdio_bus_match(struct device *dev, struct device_driver *drv)
 
 static int mdio_uevent(struct device *dev, struct kobj_uevent_env *env)
 {
+	struct mdio_device *mdio = to_mdio_device(dev);
 	int rc;
 
+	/* Use the device-specific uevent if specified */
+	if (mdio->bus_uevent) {
+		rc = mdio->bus_uevent(mdio, env);
+		if (rc != -ENODEV)
+			return rc;
+	}
+
 	/* Some devices have extra OF data and an OF-style MODALIAS */
 	rc = of_device_uevent_modalias(dev, env);
 	if (rc != -ENODEV)
diff --git a/drivers/net/phy/phy_device.c b/drivers/net/phy/phy_device.c
index 74d8e1dc125f..208ef5342798 100644
--- a/drivers/net/phy/phy_device.c
+++ b/drivers/net/phy/phy_device.c
@@ -565,6 +565,19 @@ static int phy_request_driver_module(struct phy_device *dev, u32 phy_id)
 	return 0;
 }
 
+static int phy_bus_uevent(struct mdio_device *mdiodev,
+			  struct kobj_uevent_env *env)
+{
+	struct phy_device *phydev;
+
+	phydev = container_of(mdiodev, struct phy_device, mdio);
+
+	add_uevent_var(env, "MODALIAS=" MDIO_MODULE_PREFIX MDIO_ID_FMT,
+		       MDIO_ID_ARGS(phydev->phy_id));
+
+	return 0;
+}
+
 struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 				     bool is_c45,
 				     struct phy_c45_device_ids *c45_ids)
@@ -584,6 +597,7 @@ struct phy_device *phy_device_create(struct mii_bus *bus, int addr, u32 phy_id,
 	mdiodev->dev.type = &mdio_bus_phy_type;
 	mdiodev->bus = bus;
 	mdiodev->bus_match = phy_bus_match;
+	mdiodev->bus_uevent = phy_bus_uevent;
 	mdiodev->addr = addr;
 	mdiodev->flags = MDIO_DEVICE_FLAG_PHY;
 	mdiodev->device_free = phy_mdio_device_free;
diff --git a/include/linux/mdio.h b/include/linux/mdio.h
index 9f3587a61e14..fb97cbf65ec7 100644
--- a/include/linux/mdio.h
+++ b/include/linux/mdio.h
@@ -38,6 +38,8 @@ struct mdio_device {
 	char modalias[MDIO_NAME_SIZE];
 
 	int (*bus_match)(struct device *dev, struct device_driver *drv);
+	int (*bus_uevent)(struct mdio_device *mdiodev,
+			  struct kobj_uevent_env *env);
 	void (*device_free)(struct mdio_device *mdiodev);
 	void (*device_remove)(struct mdio_device *mdiodev);
 
-- 
2.30.2


-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
