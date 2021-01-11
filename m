Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 79F912F1B58
	for <lists+netdev@lfdr.de>; Mon, 11 Jan 2021 17:47:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733230AbhAKQrw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Jan 2021 11:47:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730189AbhAKQrw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Jan 2021 11:47:52 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2A96EC061794;
        Mon, 11 Jan 2021 08:47:12 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=1fa78+yaGebU0aAjZW6gbTfMjLKj+O40E/OZ30ZHHos=; b=yRWpDWf2e432UMcJlzCTYXYJe
        HLufMCUA4WwVkLRxiAE+yv4n77ke4LQyLbFECEirI2HwAqu8/c6SpQ0BlmQHrkeguGHJH4nHrr+Qw
        ZaI6zpqmxPLdeOhgnKHw0k1rtnxfO1Bwn1oraScus6Ey3r/iPd9gGvVzdqn2rGJ9V9IiBHRIit7ys
        vUUoJzu0rZ2FlPsnOGymHZqWfsOrYWnlzUnLxPJQfBreB/ChazG6EuOXYDJKQl/gMWlX/xBRy0IuR
        6fUCQiBD6w5lMqImyAOdaw/MP5QRBD3KvVjURzCi7Wku1HpLIhScbZmlsPNCiZTkJUkkZ7zb033ov
        uIFL8c4gA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46668)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kz0LS-0007HZ-8o; Mon, 11 Jan 2021 16:47:06 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kz0LQ-0005P5-QE; Mon, 11 Jan 2021 16:47:04 +0000
Date:   Mon, 11 Jan 2021 16:47:04 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Bjarni Jonasson <bjarni.jonasson@microchip.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        UNGLinuxDriver <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH v1 1/2] net: phy: Add 100 base-x mode
Message-ID: <20210111164704.GX1551@shell.armlinux.org.uk>
References: <20210111130657.10703-1-bjarni.jonasson@microchip.com>
 <20210111130657.10703-2-bjarni.jonasson@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210111130657.10703-2-bjarni.jonasson@microchip.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 11, 2021 at 02:06:56PM +0100, Bjarni Jonasson wrote:
> Sparx-5 supports this mode and it is missing in the PHY core.
> 
> Signed-off-by: Bjarni Jonasson <bjarni.jonasson@microchip.com>

Oh, I forgot - please can we have the new PHY mode documented in
Documentation/networking/phy.rst under the "PHY interface modes"
section. Thanks.
-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
