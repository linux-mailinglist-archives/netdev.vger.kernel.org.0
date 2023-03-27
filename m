Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2BA576CAC88
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 19:58:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231928AbjC0R6S (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 13:58:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229829AbjC0R6S (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 13:58:18 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 117C9124
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 10:58:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=dKr90wBrQs4gE/DHj7edhd/WDl42/HazAE2oFN2dljQ=; b=dEqCDLUPyZ9zKOoKc6LDTFd7ve
        qmWS1rh7SZdXyv3yUv/7oarvnzzOeJJowCIL0gVoBQXQmFFXcwtECjox5DhDbMKwO1vdd1V1lzK8p
        gu3qGKLmEiCQOAV6ujCgyInGgOQunPHaLMYNf3uR2Fj0fdBfordRPLvnVfNVuevsVeZf7msTWi4F8
        PjyA9S8WS6mifMnZquiA4f0lv+Z+FO9wVoqtAva2xz3tSOQhJIKK0wSMe63TKw68PmpQtnUVBzn5Z
        p9Kf+3REmz6zbsJKKu80uPQ98SqWnD+0ywAW7nzp/f5M49PJNGFb9+EKclpgIIXlebPXvpNiNstvi
        FBjCbfdw==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51118)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1pgr6l-0004PK-DZ; Mon, 27 Mar 2023 18:58:15 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1pgr6k-0005d3-QW; Mon, 27 Mar 2023 18:58:14 +0100
Date:   Mon, 27 Mar 2023 18:58:14 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     netdev <netdev@vger.kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>
Subject: Re: [RFC/RFT 03/23] net: phy: Add helper to set EEE Clock stop
 enable bit
Message-ID: <ZCHZNrgtrASeJEj4@shell.armlinux.org.uk>
References: <20230327170201.2036708-1-andrew@lunn.ch>
 <20230327170201.2036708-4-andrew@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230327170201.2036708-4-andrew@lunn.ch>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 27, 2023 at 07:01:41PM +0200, Andrew Lunn wrote:
> The MAC driver can request that the PHY stops the clock during EEE
> LPI. This has normally been does as part of phy_init_eee(), however
> that function is overly complex and often wrongly used. Add a
> standalone helper, to aid removing phy_init_eee().
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Russell King (Oracle) <rmk+kernel@armlinux.org.uk>

Thanks!

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
