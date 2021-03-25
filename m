Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 67A0F3485DC
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 01:29:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232165AbhCYA2m (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 20:28:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239245AbhCYA2T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Mar 2021 20:28:19 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC555C06174A;
        Wed, 24 Mar 2021 17:28:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:
        Content-Transfer-Encoding:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=RDMloiwS8QeRYSgJpsKnGNRjIxDTe91A8bdtkvSkcHo=; b=ZBQtkbgneGMa/vHtAGMuKZo6O
        VF6mA+3Gk24hy8huT3wOnc0AS94lPCSFjMDQ/CvKxrKuUqj3cxCofOP3SpeBMqmrrZQilmY03SoPz
        3+X1Nxyax5J5KrPD3SGzNA4vo8NLLB5I6LCjh3Vk9CnIF6u8dCMxcu2hqT4zDYd+18apd8fRNGjmD
        Kzge5XSNRpfOZDtl8zTNkgc677kvuxCWEf1Xc+KQcVeQ5luHVOp0E4ZtmzezDQ4Ip9WWMfEHMJHsz
        9UF4IvU7vh1sMoF4RxRm/SFAf3i7Ft3IwJGQ9I84j3kvH2kXQe2MGwNEo4IQqtCyPb1me6EuQLcng
        Sx3yLgkTA==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:51688)
        by pandora.armlinux.org.uk with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.92)
        (envelope-from <linux@armlinux.org.uk>)
        id 1lPDr3-00013U-G9; Thu, 25 Mar 2021 00:28:05 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.92)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1lPDr2-0005U4-5u; Thu, 25 Mar 2021 00:28:04 +0000
Date:   Thu, 25 Mar 2021 00:28:04 +0000
From:   Russell King - ARM Linux admin <linux@armlinux.org.uk>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     Florian Fainelli <f.fainelli@gmail.com>, netdev@vger.kernel.org,
        Andrew Lunn <andrew@lunn.ch>,
        "David S . Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Rob Herring <robh@kernel.org>, devicetree@vger.kernel.org,
        pali@kernel.org
Subject: Re: [PATCH net-next 0/2] dt-bindings: define property describing
 supported ethernet PHY modes
Message-ID: <20210325002803.GI1463@shell.armlinux.org.uk>
References: <20210324103556.11338-1-kabel@kernel.org>
 <e4e088a4-1538-1e7d-241d-e43b69742811@gmail.com>
 <20210325000007.19a38bce@thinkpad>
 <755130b4-2fab-2b53-456f-e2304b1922f2@gmail.com>
 <20210325004525.734f3040@thinkpad>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210325004525.734f3040@thinkpad>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: Russell King - ARM Linux admin <linux@armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 25, 2021 at 12:45:25AM +0100, Marek Behún wrote:
> On Wed, 24 Mar 2021 16:16:41 -0700
> Florian Fainelli <f.fainelli@gmail.com> wrote:
> 
> > On 3/24/2021 4:00 PM, Marek Behún wrote:
> > > On Wed, 24 Mar 2021 14:19:28 -0700
> > > Florian Fainelli <f.fainelli@gmail.com> wrote:
> > >   
> > >>> Another problem is that if lower modes are supported, we should
> > >>> maybe use them in order to save power.    
> > >>
> > >> That is an interesting proposal but if you want it to be truly valuable,
> > >> does not that mean that an user ought to be able to switch between any
> > >> of the supported PHY <=> MAC interfaces at runtime, and then within
> > >> those interfaces to the speeds that yield the best power savings?  
> > > 
> > > If the code determines that there are multiple working configurations,
> > > it theoretically could allow the user to switch between them.
> > > 
> > > My idea was that this should be done by kernel, though.
> > > 
> > > But power saving is not the main problem I am trying to solve.
> > > What I am trying to solve is that if a board does not support all modes
> > > supported by the MAC and PHY, because they are not wired or something,
> > > we need to know about that so that we can select the correct mode for
> > > PHYs that change this mode at runtime.  
> > 
> > OK so the runtime part comes from plugging in various SFP modules into a
> > cage but other than that, for a "fixed" link such as a SFF or a soldered
> > down PHY, do we agree that there would be no runtime changing of the
> > 'phy-mode'?
> 
> No, we do not. The PHY can be configured (by strapping pins or by
> sw) to change phy-mode depending on the autonegotiated copper speed.
> 
> So if you plug in an ethernet cable where on the otherside is only 1g
> capable device, the PHY will change mode to sgmii. But if you then plug
> a 5g capable device, the PHY will change mode to 5gbase-r.
> 
> This happens if the PHY is configured into one of these changing
> configurations. It can also be configured to USXGMII, or 10GBASER with
> rate matching.
> 
> Not many MACs in kernel support USXGMII currently.
> 
> And if you use rate matching mode, and the copper side is
> linked in lower speed (2.5g for example), and the MAC will start
> sending too many packets, the internal buffer in the PHY is only 16 KB,
> so it will fill up quickly. So you need pause frames support. But this
> is broken for speeds <= 1g, according to erratum.

Also, the sending of pause frames is only supported for 88x3310P
devices, not the 88x3310. The plain 88x3310 requires the MAC to
rate-limit in this mode.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
