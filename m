Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4B7031A95D
	for <lists+netdev@lfdr.de>; Sat, 13 Feb 2021 02:13:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232592AbhBMBKp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 20:10:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232554AbhBMBJz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 20:09:55 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C87CCC061574
        for <netdev@vger.kernel.org>; Fri, 12 Feb 2021 17:09:14 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=NRG8Mfc8PYf4whLiYKWeIaVusMxM1Lw9bdpB5hM/wek=; b=pk+D4l5ONUzZJcgDL42qZwsdA
        p2dyxhUe8sEHeNPd5ctcSnMIjOV8OqEp1yzGAmlDZqzvTMwbihAerVNNSvLlHCNPKY+WMlP5Smcr+
        y8ctlesqUPEIvgvOUpVsoVKNm37YcgXBkZ2za/m5y1p9OMaaPnR3tmLqJDGcdZe4wYHE4nH+l9f20
        Z2P5LIzO+1UmRxoSPvwI4w791xhOQjLkU4LARK6Ih9UFD+EEwYAuCWvm9xuPqfuOoE82z2FZiLb1Q
        Lblx2UbVk90mqFVhUslWIt5/yiN3D87CscPEdGIdNab1Lj8oaKFxxeLuQWBKHHbKXHdkRK2EF8Biu
        fKSZhFcIA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:42664)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lAjQs-0007q5-KM; Sat, 13 Feb 2021 01:09:10 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lAjQq-0007ah-FX; Sat, 13 Feb 2021 01:09:08 +0000
Date:   Sat, 13 Feb 2021 01:09:08 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Robert Hancock <robert.hancock@calian.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: phy: marvell: Ensure SGMII
 auto-negotiation is enabled for 88E1111
Message-ID: <20210213010908.GO1463@shell.armlinux.org.uk>
References: <20210213002629.2557315-1-robert.hancock@calian.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210213002629.2557315-1-robert.hancock@calian.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Feb 12, 2021 at 06:26:29PM -0600, Robert Hancock wrote:
> When 88E111 is operating in SGMII mode, auto-negotiation should be enabled

88E1111.

> on the SGMII side so that the link will come up properly with PCSes which
> normally have auto-negotiation enabled. This is normally the case when the
> PHY defaults to SGMII mode at power-up, however if we switched it from some
> other mode like 1000BaseX, as may happen in some SFP module situations,
> it may not be.

Do you actually have a module where this applies?

I have modules that do come up in 1000base-X mode, but do switch to
SGMII mode with AN just fine. So I'm wondering what the difference is.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
