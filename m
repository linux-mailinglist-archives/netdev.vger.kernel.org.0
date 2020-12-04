Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B1F5C2CEC16
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 11:23:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387924AbgLDKVV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 05:21:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55486 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726330AbgLDKVU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Dec 2020 05:21:20 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55E00C0613D1;
        Fri,  4 Dec 2020 02:20:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=CyALSvgNYXpCyLGL7J4jQD4Lj1WdhcYdlQtfqx1dD3k=; b=t2RDh01T6jqfyvJKY96GON17K
        FvZM0e/TcQs1S1Bq78kiwPfU7r4OvLI14cil0OW1CNoPSIrWZhSx/R0L2eCbc/qGqXbGkgYeqsZU+
        8raeqyfE02XS4m3+YrxkAfHCERSTAPVqpJDN5WgwH0rRI4H475l0Kf71cTyUSRSjw1JiE+7cTzt95
        +UpQ5gUvAss3Lkt0jaYJldCorTlsp9cdv7xt3YLlZTGPTZijomlyHENo2e23ppm0k0jtMmJwsCjUC
        KeFJ2TpOPMKbjfS80U6MRT4qA1MsVGTnio+EVDUMRNT9rAgDDuFGJua/lC/JG2Px74OIFDA6v+jaJ
        PwdMKLiEQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:39620)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1kl8C4-0004BU-H8; Fri, 04 Dec 2020 10:20:04 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1kl8C3-0000a7-JL; Fri, 04 Dec 2020 10:20:03 +0000
Date:   Fri, 4 Dec 2020 10:20:03 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Alexandre Belloni <alexandre.belloni@bootlin.com>
Cc:     Steen Hegelund <steen.hegelund@microchip.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Vinod Koul <vkoul@kernel.org>,
        linux-arm-kernel@lists.infradead.org,
        Lars Povlsen <lars.povlsen@microchip.com>,
        Bjarni Jonasson <bjarni.jonasson@microchip.com>,
        Microchip UNG Driver List <UNGLinuxDriver@microchip.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v8 3/4] phy: Add Sparx5 ethernet serdes PHY driver
Message-ID: <20201204102003.GJ1551@shell.armlinux.org.uk>
References: <20201203103015.3735373-1-steen.hegelund@microchip.com>
 <20201203103015.3735373-4-steen.hegelund@microchip.com>
 <20201203215253.GL2333853@lunn.ch>
 <20201203225232.GI1551@shell.armlinux.org.uk>
 <20201204075633.GC74177@piout.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201204075633.GC74177@piout.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 04, 2020 at 08:56:33AM +0100, Alexandre Belloni wrote:
> Hi Russell,
> 
> On 03/12/2020 22:52:33+0000, Russell King - ARM Linux admin wrote:
> > You still have not Cc'd me on your patches. Please can you either:
> > 
> > 1) use get_maintainer.pl to find out whom you should be sending
> >    your patches to
> > or
> > 2) include me in your cc for this patch set as phylink maintainer in
> >    your patch set so I can review your use of phylink.
> > 
> 
> Note that this series is different from the network (switchdev) driver
> series and doesn't make use of phylink.

Oh, didn't realise that; it's difficult to tell when you don't get the
original messages, and only end up being Cc'd on a very trimmed down
reply.

Email is a broken form of communication...

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
