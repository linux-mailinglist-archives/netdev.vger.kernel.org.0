Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 63B15554CA8
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 16:17:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1358141AbiFVORQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 10:17:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358138AbiFVOQz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 10:16:55 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F7AA3A5F1
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 07:16:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=P4bdtiazWP93Zinycc+UVjMzGiDv/yu0YmRzz47lS3Q=; b=kibiIXAWHgRFRaOvWPgeVcImaK
        4SXr3LYfqazKrb7asaJ/8u3FCrPzWgAkk44WLlhWCDyxxByvzKzu0nj6hgWDQH2/rpakWonHqmh9a
        sm24jcDZFmN3VrNkgXhWLM9JEVl50kELv/S3GJuRQy6VZZ51Yt9h6uFVTrNqdR3Qwht5/fXzjuJdf
        +IUq5aPCP3oVVHR8l6MdUoCUmZrcV6huZMVqFUALYrfDQB4phZseYuRiFS1LPhPoLE76RLxl8hgKz
        QqMS5+icQRZxrRkMJPBXox9/pE7QjDUY3hreADGz6rGaDOVNZEVzl8y48i8BZ+Zz4n+7xRajZS47Y
        QOgxqbfg==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:32986)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1o419C-0003gd-0d; Wed, 22 Jun 2022 15:15:57 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1o4190-0007Uz-I2; Wed, 22 Jun 2022 15:15:46 +0100
Date:   Wed, 22 Jun 2022 15:15:46 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Ong Boon Leong <boon.leong.ong@intel.com>
Subject: Re: [PATCH net-next] net: pcs: xpcs: depends on PHYLINK in Kconfig
Message-ID: <YrMkEp6EWDvd3GT/@shell.armlinux.org.uk>
References: <6959a6a51582e8bc2343824d0cee56f1db246e23.1655797997.git.pabeni@redhat.com>
 <20220621125045.7e0a78c2@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220621125045.7e0a78c2@kernel.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 21, 2022 at 12:50:45PM -0700, Jakub Kicinski wrote:
> On Tue, 21 Jun 2022 09:55:35 +0200 Paolo Abeni wrote:
> > This is another attempt at fixing:
> > 
> > >> ERROR: modpost: "phylink_mii_c22_pcs_encode_advertisement" [drivers/net/pcs/pcs_xpcs.ko] undefined!
> > >> ERROR: modpost: "phylink_mii_c22_pcs_decode_state" [drivers/net/pcs/pcs_xpcs.ko] undefined!  
> > 
> > We can't select PHYLINK, or that will trigger a circular dependency
> > PHYLINK already selects PHYLIB, which in turn selects MDIO_DEVICE:
> > replacing the MDIO_DEVICE dependency with PHYLINK will pull all the
> > required configs.
> 
> We can't use depends with PHYLINK, AFAIU, because PHYLINK is not 
> a user-visible knob. Its always "select"ed and does not show up
> in {x,n,menu}config.

I'm not sure I understand the point you're making. You seem to be
saying we can't use "depend on PHYLINK" for this PCS driver, but
then you sent a patch doing exactly that.

As these PCS drivers are only usable if PHYLINK is already enabled,
there is a clear dependency between them and phylink. The drivers
that make use of xpcs are:

stmmac, which selects both PCS_XPCS and PHYLINK.
sja1105 (dsa driver), which selects PCS_XPCS. All DSA drivers depend
on NET_DSA, and NET_DSA selects PHYLINK.

So, for PCS_XPCS, PHYLINK will be enabled whenever PCS_XPCS is
selected. No other drivers in drivers/net appear to make use of
the XPCS driver (I couldn't find any other references to
xpcs_create()) so using "depends on PHYLINK" for it should be safe.

Moreover, the user-visible nature of PCS_XPCS doesn't add anything
to the kernel - two drivers require PCS_XPCS due to code references
to the xpcs code, these two select that symbol. Offering it to the
user just gives the user an extra knob to twiddle with no useful
result (other than more files to be built.)

It could be argued that it helps compile coverage, which I think is
the only reason to make PCS_XPCS visible... but then we get compile
coverage when stmmac or sja1105 are enabled.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
