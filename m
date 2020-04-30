Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E49741BF28F
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 10:21:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726508AbgD3IVU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 04:21:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726127AbgD3IVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 04:21:20 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:3201:214:fdff:fe10:1be6])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF504C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 01:21:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:Content-Type:MIME-Version:
        Message-ID:Subject:Cc:To:From:Date:Reply-To:Content-Transfer-Encoding:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=hpQ+/6Y6CLzEutz72WVrKtqRxZ8YbRubJFsit6KHifU=; b=BgkFRdPmmWc6iOAsbbVLqghZz
        /jmZsddE4KEOUmSlNfJ7bUNRo6WDPUrpSlNpNgb+64BbOun07tDYJv4usFTmNtDwwjWfdhEtks/W3
        ozE6cDzsFf6tDxMl6X5AbciMiwnVTItOJOxHtqgnHobPS5pZ+TrKacDazR09lSLfuNlnpBHaXusS4
        JZP/jju57W9ex3AHWSFSDdSsKueiPOrgZidkoq3imtqW/q+hxxw+FxNN9UU+mHjlzij3zuGt6+bBe
        34I3gbbDOjy/ksBBNy+FMH83ld4PZYD1a7I0kRbP92VM4hxTBONFBg92mYAV84GxG6ezfShilvTWa
        ze5tKlwPw==;
Received: from shell.armlinux.org.uk ([2001:4d48:ad52:3201:5054:ff:fe00:4ec]:34134)
        by pandora.armlinux.org.uk with esmtpsa (TLSv1.2:ECDHE-RSA-AES256-GCM-SHA384:256)
        (Exim 4.90_1)
        (envelope-from <linux@armlinux.org.uk>)
        id 1jU4RQ-0004i5-35; Thu, 30 Apr 2020 09:21:08 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1jU4RM-0001xu-Cy; Thu, 30 Apr 2020 09:21:04 +0100
Date:   Thu, 30 Apr 2020 09:21:04 +0100
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: [PATCH net-next 0/2] net: dsa: mv88e6xxx: augment phylink support
 for 10G
Message-ID: <20200430082104.GO1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

This series adds phylink 10G support for the 88E6390 series switches,
as suggested by Andrew Lunn.

The first patch cleans up the code to use generic definitions for the
registers in a similar way to what was done with the initial conversion
of 1G serdes support.

The second patch adds the necessary bits 10GBASE mode to the
pcs_get_state() method.

 drivers/net/dsa/mv88e6xxx/serdes.c | 55 ++++++++++++++++++++++++++++++++------
 drivers/net/dsa/mv88e6xxx/serdes.h |  7 ++---
 2 files changed, 49 insertions(+), 13 deletions(-)

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTC broadband for 0.8mile line in suburbia: sync at 10.2Mbps down 587kbps up
