Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37CB73C5B74
	for <lists+netdev@lfdr.de>; Mon, 12 Jul 2021 13:44:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229677AbhGLLZp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Jul 2021 07:25:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42156 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230148AbhGLLZo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Jul 2021 07:25:44 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D197FC0613E5;
        Mon, 12 Jul 2021 04:22:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=R1bDTEiXqtXpyrbQHqtEVr9M9V6VmpOGvNF7p83EW/U=; b=KR7gN3dPpayrdOqoboOmpNssM
        x6B9tl7MCmiLi1hdEE6Cid+zaaWV7l9prKwwQk32omDJ+dHqeN/XmFBqDEyE7+WhelX4oFFqnF/km
        6CbZo8UvXhPTvKbSdn+OBpZXNIEAi9C6v/ILX56XPGekvcEHV11t2/RpINuwaiGGdLESAH0PtnuOk
        NxHwttx7tb87ixKM+5w2G2Is8ProVewwEW40gPCJpn19iNiRQtP0ebXbUBLrBMBvyNtp05rocxIuA
        JdJONF//VSYGqdKippGqRRRmbynfQ6HLcCI6QMFfHsT9Ip8zh0hRo1HvKBfTiEkdtJDRBfMaCtuQs
        wEDtMsVlg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:46004)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1m2u1N-0004eU-43; Mon, 12 Jul 2021 12:22:45 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1m2u1J-0007jR-Ou; Mon, 12 Jul 2021 12:22:41 +0100
Date:   Mon, 12 Jul 2021 12:22:41 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     hauke@hauke-m.de, martin.blumenstingl@googlemail.com,
        f.fainelli@gmail.com, andrew@lunn.ch, hkallweit1@gmail.com,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5] net: phy: intel-xway: Add RGMII internal
 delay configuration
Message-ID: <20210712112241.GC22278@shell.armlinux.org.uk>
References: <20210712072413.11490-1-ms@dev.tdt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210712072413.11490-1-ms@dev.tdt.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 12, 2021 at 09:24:13AM +0200, Martin Schiller wrote:
> This adds the possibility to configure the RGMII RX/TX clock skew via
> devicetree.
> 
> Simply set phy mode to "rgmii-id", "rgmii-rxid" or "rgmii-txid" and add
> the "rx-internal-delay-ps" or "tx-internal-delay-ps" property to the
> devicetree.
> 
> Furthermore, a warning is now issued if the phy mode is configured to
> "rgmii" and an internal delay is set in the phy (e.g. by pin-strapping),
> as in the dp83867 driver.
> 
> Signed-off-by: Martin Schiller <ms@dev.tdt.de>

Acked-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks.
-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
