Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9556CCA7C
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 21:16:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229851AbjC1TQ0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 15:16:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229617AbjC1TQZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 15:16:25 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57F8F3586
        for <netdev@vger.kernel.org>; Tue, 28 Mar 2023 12:16:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=gKt8/qzO0R6zBU8xl/QyC/9hdCK+K5zTRPtUCmN9i20=; b=eCdeVtitx6m5x3Q1mCDUOufoBI
        jfcK13FugWjaRSSfEOtMzqreGoOGoYNQDWI+oMnGSqd+EWGQwRqerzqNFQjxNwDcXEZNlkRRqeJfP
        cabz8YFXEmVr7MfaKhKC2Jt1jLn3jItid4c0MsEQndlzoSynU/4iDWOSBfCk9fyDpbChLp4V78sqe
        rHQx0w0o0uuiCV4mqQCrMelC3GM0AV+h8hyVWvjgBWOhEbtjx3bvANczYuVlwWbfuJexpc7AeGeaT
        iHcYQNNahYX4P+Fe4X5nctNr+sGo/Z4+BHM4LnCDVd9Ce1rRsgjGmPvbmnrksq4DVZyJ96IITg/7+
        1o8wmhXQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:35028)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1phEnj-0006xf-RG; Tue, 28 Mar 2023 20:16:11 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1phEnh-0006k5-EQ; Tue, 28 Mar 2023 20:16:09 +0100
Date:   Tue, 28 Mar 2023 20:16:09 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Frank Wunderlich <frank-w@public-files.de>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [PATCH net-next 2/2] net: sfp: add quirk for 2.5G copper SFP
Message-ID: <ZCM8+dsOo8c6TRJT@shell.armlinux.org.uk>
References: <ZBniMlTDZJQ242DP@shell.armlinux.org.uk>
 <E1pefJz-00Dn4V-Oc@rmk-PC.armlinux.org.uk>
 <ZB5YgPiZYwbf/G2u@makrotopia.org>
 <ZB7/v8oUu3lkO4yC@shell.armlinux.org.uk>
 <ZB8Upcgv8EIovPCl@makrotopia.org>
 <ZB9NKo3iXe7CZSId@shell.armlinux.org.uk>
 <ZCMDgqBSvHigTcbb@shell.armlinux.org.uk>
 <ZCMx5UBUaycq8+O/@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZCMx5UBUaycq8+O/@makrotopia.org>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 07:28:53PM +0100, Daniel Golle wrote:
> Hi Russell,
> 
> On Tue, Mar 28, 2023 at 04:10:58PM +0100, Russell King (Oracle) wrote:
> > Hi Daniel,
> > 
> > Any feedback with this patch applied? Can't move forward without that.
> 
> Sorry for the delay, I only got back to it today.
> I've tried your patch and do not see any additional output on the
> kernel log, just like it is the case for Frank's 2.5G SFP module as
> well. I conclude that the PHY is inaccessible.
> 
> I've tried with and without the sfp_quirk_oem_2_5g.
> 
> With the quirk:
> [   55.111856] mt7530 mdio-bus:1f sfp2: Link is Up - Unknown/Unknown - flow control off
> 
> Without the quirk:
> [   44.603495] mt7530 mdio-bus:1f sfp2: unsupported SFP module: no common interface modes

This is all getting really very messy, and I have no idea what's going
on and which modules you're testing from report to report.

The patch was to be used with the module which you previously reported
earlier in this thread:

[   17.344155] sfp sfp2: module TP-LINK          TL-SM410U        rev 1.0  sn    12154J6000864    dc 210606
...
[   21.653812] mt7530 mdio-bus:1f sfp2: selection of interface failed, advertisement 00,00000000,00000000,00006440

That second message - "selection of interface failed" only appears in
two places:

1) in phylink_ethtool_ksettings_set() which will be called in response
to ethtool being used, but you've said it isn't, so this can't be it.
2) in phylink_sfp_config_phy(), which will be called when we have
detected a PHY on the SFP module and we're trying to set it up.
This means we must have discovered a PHY on the TL-SM410U module.

This new message you report:

	"unsupported SFP module: no common interface modes"

is produced by phylink_sfp_config_optical(), which is called when we
think we have an optical module (in other words when sfp_may_have_phy()
returns false) or it returns true but we start the module without
having discovered a PHY.

So we can only get to this message if we think the module does not
have a PHY detected.

If it's the exact same module, that would suggest that the module does
have an accessible PHY, but there could be a hardware race between the
PHY becoming accessible and our probing for it. However, we do retry
probing for the PHY up to 12 times at 50ms intervals.

Maybe you could shed some light on what's going on? Is it the exact
same module? Maybe enable debugging in both sfp.c

At the moment I'm rather confused.

Thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
