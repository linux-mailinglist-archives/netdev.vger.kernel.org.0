Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35A0745608E
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 17:33:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233444AbhKRQgh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 11:36:37 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40902 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233095AbhKRQgh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 11:36:37 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=WNQ2VojbMizWPrgZTqZX9GEK2YmXEOCVr703H4Xn9FU=; b=XdEEHA0kP7PFfClvltChSSp03s
        xWHzXH2PE78b0oPy/2qKX4DUtdrBg2qGWYFUAB7zlZIPA5PyuGgvQzeb8++95bWmJkbA1ANyn7tIG
        ILLxxf7VjU1HfasPo9+KDi0843NtE9mCFS96/5ABzZAKqlYf4LCDg6BBfcPxqjGhquJs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mnkLt-00E0BP-R9; Thu, 18 Nov 2021 17:33:33 +0100
Date:   Thu, 18 Nov 2021 17:33:33 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     "Russell King (Oracle)" <linux@armlinux.org.uk>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 4/8] net: phylink: update supported_interfaces
 with modes from fwnode
Message-ID: <YZaAXadMIduFZr08@lunn.ch>
References: <20211117225050.18395-1-kabel@kernel.org>
 <20211117225050.18395-5-kabel@kernel.org>
 <YZYXctnC168PrV18@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YZYXctnC168PrV18@shell.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > +	/* If supported is empty, just copy modes defined in fwnode. */
> > +	if (phy_interface_empty(supported))
> > +		return phy_interface_copy(supported, modes);
> 
> Doesn't this mean we always end up with the supported_interfaces field
> filled in, even for drivers that haven't yet been converted? It will
> have the effect of locking the driver to the interface mode in "modes"
> where only one interface mode is mentioned in DT.
> 
> At the moment, I think the only drivers that would be affected would be
> some DSA drivers, stmmac and macb as they haven't yet been converted.

Hi Russell

What do you think the best way forward is? Got those converted before
merging this?

	Andrew
