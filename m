Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F9BD4AF8B0
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 18:47:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238420AbiBIRrm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 12:47:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235315AbiBIRrl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 12:47:41 -0500
Received: from pandora.armlinux.org.uk (pandora.armlinux.org.uk [IPv6:2001:4d48:ad52:32c8:5054:ff:fe00:142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 14E57C0613C9
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 09:47:43 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=armlinux.org.uk; s=pandora-2019; h=Sender:In-Reply-To:Content-Type:
        MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:Reply-To:
        Content-Transfer-Encoding:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=oMKnNdGWerhyD/7w0+tBGE6rpgKKyrhe4U8yo9811Xw=; b=jMJlnN5ys4sb2VxEYZNp4qWoop
        wY6cefxuoWUwZZM14mTfXt3TH0uOOZ06XrOTBn9X9xPJ0Z3jydot3Ofrx9O7trqsFdDsok9LvYoiM
        ZWZMBa7PLnqpuSEVlFeh2e4CphtRF/I5uaPxv5FUcjgzDjaIePWUVsMg3xOUiUdV+H2c7WjOAR+tm
        WU8aNrJGf4DiSqvt53tM+b/5sPvwKe5dgT39PLb+dV645Di6jxFCLPNVpLpp25Giy2412WSRCoWof
        HdxUQa7wB+Du6GrY1UEkGrY2hAdAS5+QVhF84CRcVZEolGtx1UvgF0E832e1+vCpySCQlbBYs7NFQ
        m13vdLdQ==;
Received: from shell.armlinux.org.uk ([fd8f:7570:feb6:1:5054:ff:fe00:4ec]:57172)
        by pandora.armlinux.org.uk with esmtpsa  (TLS1.3) tls TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384
        (Exim 4.94.2)
        (envelope-from <linux@armlinux.org.uk>)
        id 1nHr43-0004or-LU; Wed, 09 Feb 2022 17:47:35 +0000
Received: from linux by shell.armlinux.org.uk with local (Exim 4.94.2)
        (envelope-from <linux@shell.armlinux.org.uk>)
        id 1nHr40-0001ie-Rq; Wed, 09 Feb 2022 17:47:32 +0000
Date:   Wed, 9 Feb 2022 17:47:32 +0000
From:   "Russell King (Oracle)" <linux@armlinux.org.uk>
To:     Landen Chao <landen.chao@mediatek.com>
Cc:     DENG Qingfang <dqfext@gmail.com>,
        Sean Wang <Sean.Wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-mediatek@lists.infradead.org" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH RFC net-next 0/7] net: dsa: mt7530: updates for phylink
 changes
Message-ID: <YgP+NBeGL4MzRcYR@shell.armlinux.org.uk>
References: <YfwRN2ObqFbrw/fF@shell.armlinux.org.uk>
 <YgO8WMjc77BsOLtD@shell.armlinux.org.uk>
 <48d2d967a625c65308bff7bad03ae49779986549.camel@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <48d2d967a625c65308bff7bad03ae49779986549.camel@mediatek.com>
Sender: Russell King (Oracle) <linux@armlinux.org.uk>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 10, 2022 at 01:33:34AM +0800, Landen Chao wrote:
> On Wed, 2022-02-09 at 21:06 +0800, Russell King (Oracle) wrote:
> > On Thu, Feb 03, 2022 at 05:30:31PM +0000, Russell King (Oracle)
> > wrote:
> > > Hi,
> > > 
> > > This series is a partial conversion of the mt7530 DSA driver to the
> > > modern phylink infrastructure. This driver has some exceptional
> > > cases
> > > which prevent - at the moment - its full conversion (particularly
> > > with
> > > the Autoneg bit) to using phylink_generic_validate().
> > > 
> > > What stands in the way is this if() condition in
> > > mt753x_phylink_validate():
> > > 
> > > 	if (state->interface != PHY_INTERFACE_MODE_TRGMII ||
> > > 	    !phy_interface_mode_is_8023z(state->interface)) {
> > > 
> > > reduces to being always true. I highlight this here for the
> > > attention
> > > of the driver maintainers.
> Hi Russel,
> 
> The above behaviour is really a bug. "&&" should be used to prevent
> setting MAC_10, MAC_100 and Antoneg capability in particular interface
> mode in original code. However, these capability depend on the link
> partner of the MAC, such as Ethernet phy. It's okay to keep setting
> them.

Hi Landen,

Thanks for the response. I think you have a slight misunderstanding
about these capabilities, both in the old code and the new code.

You shouldn't care about e.g. the ethernet PHY's capabilities in the
validate() callback at all - phylink will look at the capabilities
reported by phylib, and mask out anything that the MAC says shouldn't
be supported, which has the effect of restricting what the ethernet
PHY will advertise.

In the old code, the validate() callback should only be concerned with
what the MAC and PCS can support - e.g. if the MAC isn't capable of
supportig 1G half-duplex, then the 1G HD capabilities should be masked
out.

With the new code, PCS gain their own validation function, which means
that the validate() callback then becomes very much just about the MAC,
and with phylink_generic_validate(), we can get away with just
specifying a bitmap of the supported interface types for the MAC/PCS
end of the system, and the MAC speeds that are supported.

Given your feedback, I will re-jig the series to take account of your
comments - thanks.

-- 
RMK's Patch system: https://www.armlinux.org.uk/developer/patches/
FTTP is here! 40Mbps down 10Mbps up. Decent connectivity at last!
