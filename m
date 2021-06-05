Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37D5C39C93E
	for <lists+netdev@lfdr.de>; Sat,  5 Jun 2021 16:51:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230099AbhFEOxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Jun 2021 10:53:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47096 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229931AbhFEOxG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 5 Jun 2021 10:53:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lr5OhhF04sjk2b1S2jX68LtGPZKeqsSd9bBbnUjRzWM=; b=vuYlHOctAjCsgx60yLcGDkYydO
        4j6VrhHIIsVd+F6oOBXtayShj4E38x0uVu1ZBOmWdkKHHc0uwFGnyH1dDDg+NEm3015TvOvB6ORgi
        vYfcuDLN2Z2ZzlpVCclfgkkuXMLOrK76ie8kAdP4YgUyzBT8kqwazS8LZCtzkJluE5RE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1lpXdt-007wGY-7u; Sat, 05 Jun 2021 16:51:17 +0200
Date:   Sat, 5 Jun 2021 16:51:17 +0200
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
Message-ID: <YLuPZTXFrJ9KjNpl@lunn.ch>
References: <20210604161250.49749-1-lxu@maxlinear.com>
 <f56aa414-3002-ef85-51a9-bb36017270e6@gmail.com>
 <7834258b-5826-1c00-2754-b0b7e76b5910@maxlinear.com>
 <YLqIvGIzBIULI2Gm@lunn.ch>
 <2b9945f9-16a4-bda5-40df-d79089be3c12@maxlinear.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2b9945f9-16a4-bda5-40df-d79089be3c12@maxlinear.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >>> This does not access vendor specific registers, should not this be part
> >>> of the standard genphy_read_abilities() or moved to a helper?
> >>>
> >> genphy_read_abilities does not cover 2.5G.
> >>
> >> genphy_c45_pma_read_abilities checks C45 ids and this check fail if
> >> is_c45 is not set.
> > You appear to of ignored my comment about this. Please add the helper
> > to the core as i suggested, and then use
> > genphy_c45_pma_read_abilities().
> >
> >          Andrew
> >
> I'm new to upstream and do not know the process to change code in core.

Pretty much the same way you change code in a driver. Submit a path!

Please put it into a separate patch, so making a patch series. Please
add some kernel doc style documentation, describing what the function
does. Look at other functions in phy_device.c for examples.

Anybody can change core code. It just gets looked at closer, and need
to be generic.

   Andrew
