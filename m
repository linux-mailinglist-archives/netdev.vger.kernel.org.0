Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C64196DC5C9
	for <lists+netdev@lfdr.de>; Mon, 10 Apr 2023 12:37:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229615AbjDJKhd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Apr 2023 06:37:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36870 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229535AbjDJKhc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Apr 2023 06:37:32 -0400
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD35A358B
        for <netdev@vger.kernel.org>; Mon, 10 Apr 2023 03:37:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=pUjmIBPACy511H0pNJxBVRxcKsIlj4L0oE87vk6DYsU=; b=icpvE1diCBYEcU8rnFyapVO64x
        MRzyQImBfmZxaPLdbSCMsUi50cHoDPTg1slSI8nmSl1mi/D4T4UBV3fXBhyqY4CQOXAqjt6pivdFv
        VrvkUeVBqhKXgjmzqQKSsUCRSQHuuuqS0OPopN00YRqJ4mLLRq1T50RlWOCQTioS1VVm0FCZ9/My1
        Cam8/datUwqeZUT/WPwHgaoUj24DtpnHHg7W4Q8lz+MQ8Yk39w+1veGByK73StR8xhlHtKOv0qAzH
        tHW/pSu6sq4/IYHAiSj1Z+2zZdX2sytwyhEhtV444CaAvURpBVboAav24py/mqi1guja0910JostH
        Dwt6zLoQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:56814)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1plotj-0004eI-7w; Mon, 10 Apr 2023 11:37:19 +0100
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1plotg-00030c-1M; Mon, 10 Apr 2023 11:37:16 +0100
Date:   Mon, 10 Apr 2023 11:37:15 +0100
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     Andrew Lunn <andrew@lunn.ch>, shawnguo@kernel.org,
        s.hauer@pengutronix.de, arm-soc <arm@kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/3] ARM: dts: imx51: ZII: Add missing phy-mode
Message-ID: <ZDPm28C7xXulpG1L@shell.armlinux.org.uk>
References: <20230407152503.2320741-1-andrew@lunn.ch>
 <20230407152503.2320741-2-andrew@lunn.ch>
 <20230407154159.upribliycphlol5u@skbuf>
 <b5e96d31-6290-44e5-b829-737e40f0ef35@lunn.ch>
 <20230410100012.esudvvyik3ck7urr@skbuf>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230410100012.esudvvyik3ck7urr@skbuf>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 10, 2023 at 01:00:12PM +0300, Vladimir Oltean wrote:
> On Fri, Apr 07, 2023 at 06:10:31PM +0200, Andrew Lunn wrote:
> > On Fri, Apr 07, 2023 at 06:41:59PM +0300, Vladimir Oltean wrote:
> > > In theory, an MII MAC-to-MAC connection should have phy-mode = "mii" on
> > > one end and phy-mode = "rev-mii" on the other, right?
> > 
> > In theory, yes. As far as i understand, it makes a difference to where
> > the clock comes from. rev-mii is a clock provider i think.
> > 
> > But from what i understand of the code, and the silicon, this property
> > is going to be ignored, whatever value you give it. phy-mode is only
> > used and respected when the port can support 1000Base-X, SGMII, and
> > above, or use its built in PHY. For MII, GMII, RMII, RGMII the port
> > setting is determined by strapping resistors.
> > 
> > The DSA core however does care that there is a phy-mode, even if it is
> > ignored. I hope after these patches land we can turn that check into
> > enforce mode, and that then unlocks Russell to make phylink
> > improvement.
> 
> Actually, looking at mv88e6xxx_translate_cmode() right now, I guess it's
> not exactly true that the value is going to be ignored, whatever it is.
> A CMODE of MV88E6XXX_PORT_STS_CMODE_MII_PHY is not going to be translated
> into "rev-mii", but into "mii", same as MV88E6XXX_PORT_STS_CMODE_MII.
> Same for MV88E6XXX_PORT_STS_CMODE_RMII_PHY ("rmii" and not "rev-rmii").
> So, when given "rev-mii" or "rev-rmii" as phy modes in the device tree,
> the generic phylink validation procedure should reject them for being
> unsupported.
> 
> This means either the patch set moves forward with v1, or the driver is
> fixed to accept the dedicated PHY modes for PHY roles.
> 
> Russell, what do you think?

I'm afraid I didn't bother trying to understand all the *MII modes
that Marvell document poorly in their functional specification,
especially when they document that e.g. RMII_PHY mode can also be
used to connect to a PHY. I took their table with a pinch of salt
and did what I thought was best.

It is entirely possible that some are wrong, especially as we don't
document what the various PHY_INTERFACE_MODE_* mean in the kernel
(remember that I started doing that).

As far as phylink, it treats REV*MII and the corresponding *MII
mode the same way in terms of their capabilities, but as you say
it will determine which mode will be acceptable.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 80Mbps down 10Mbps up. Decent connectivity at last!
