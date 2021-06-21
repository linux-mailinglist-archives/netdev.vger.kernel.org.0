Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23F7F3AE965
	for <lists+netdev@lfdr.de>; Mon, 21 Jun 2021 14:48:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230006AbhFUMvG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Jun 2021 08:51:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47500 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229640AbhFUMvF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 21 Jun 2021 08:51:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=rUyQk3yoW9NXwQ+YnSBUagkXImneZQ9YSpSYesCXmdk=; b=eldbcd/U6YqbWILz9FfaWBFOMA
        sKcBYoPl8Lz5NeliMY4elp7vFhKxKy8QFK9Dxs/4OSxPR4m0WtxJCsjTxgjaz1WFv/cW9HHgLh6k9
        c0XFcgv8W4LbXr9gUm8fg++McspSaEtPoXZJ/JMVyr6mL6yrtKQDJcp18XGEhmpLtRO0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lvJM8-00AVFN-AL; Mon, 21 Jun 2021 14:48:48 +0200
Date:   Mon, 21 Jun 2021 14:48:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Liang Xu <lxu@maxlinear.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        "hkallweit1@gmail.com" <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "vee.khee.wong@linux.intel.com" <vee.khee.wong@linux.intel.com>,
        "linux@armlinux.org.uk" <linux@armlinux.org.uk>,
        Hauke Mehrtens <hmehrtens@maxlinear.com>,
        Thomas Mohren <tmohren@maxlinear.com>
Subject: Re: [PATCH v3] net: phy: add Maxlinear GPY115/21x/24x driver
Message-ID: <YNCKsPiIQP/ov39V@lunn.ch>
References: <7834258b-5826-1c00-2754-b0b7e76b5910@maxlinear.com>
 <YLqIvGIzBIULI2Gm@lunn.ch>
 <2b9945f9-16a4-bda5-40df-d79089be3c12@maxlinear.com>
 <YLuPZTXFrJ9KjNpl@lunn.ch>
 <9a838afe-83e7-b575-db49-f210022966d5@maxlinear.com>
 <334b52a6-30e8-0869-6ffb-52e9955235ff@maxlinear.com>
 <YMynL9c9MpfdC7Se@lunn.ch>
 <2f6c23fd-724e-c9e0-83f2-791cb747d846@maxlinear.com>
 <YM/5z1hgIkx6Fq6I@lunn.ch>
 <298d6268-00d0-cfcf-3689-bd074cbd8e16@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <298d6268-00d0-cfcf-3689-bd074cbd8e16@maxlinear.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 21, 2021 at 05:05:06AM +0000, Liang Xu wrote:
> On 21/6/2021 10:30 am, Andrew Lunn wrote:
> > This email was sent from outside of MaxLinear.
> >
> >
> > On Fri, Jun 18, 2021 at 03:36:35PM +0000, Liang Xu wrote:
> >> On 18/6/2021 10:01 pm, Andrew Lunn wrote:
> >>> This email was sent from outside of MaxLinear.
> >>>
> >>>
> >>>> Net-next:
> >>>>
> >>>> int genphy_loopback(struct phy_device *phydev, bool enable)
> >>>> {
> >>>>        if (enable) {
> >>>>            u16 val, ctl = BMCR_LOOPBACK;
> >>>>            int ret;
> >>>>
> >>>>            if (phydev->speed == SPEED_1000)
> >>>>                ctl |= BMCR_SPEED1000;
> >>>>            else if (phydev->speed == SPEED_100)
> >>>>                ctl |= BMCR_SPEED100;
> >> The problem happens in the speed change no matter it's forced or
> >> auto-neg in our device.
> > You say speed change. So do you just need to add support for 10Mbps,
> > so there is no speed change? Or are you saying phydev->speed does not
> > match the actual speed?
> >
> >        Andrew
> >
> We have 2.5G link speed, so mismatch happens.

Ah, yes.  Sorry.

Please implement it in your driver.

       Andrew
