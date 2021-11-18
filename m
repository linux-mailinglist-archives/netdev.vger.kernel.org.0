Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BB42456064
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 17:27:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233054AbhKRQaG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 11:30:06 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:40844 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231667AbhKRQaF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Nov 2021 11:30:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=kIfB6YWBINgpWaKB3P/c+CX/TTD7r5bPv1PSUCx4Cy0=; b=WkOTLu4EDNKlmw0e0BYdrj3ZD4
        xc4AIwjPR2H/lsM5+7VjIyOjbQ/pLwwpRP7/NWz9Z1yQwb1I645fTCYj1tCGLDxAmxcKhSL/fV+pd
        Ix+joClGsNcSqctw4zcLtP2N1ItKl94BTqBK6QTBdpVlPIFZblVGQJpr6IB8MeEnXpZQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mnkFY-00E07U-LI; Thu, 18 Nov 2021 17:27:00 +0100
Date:   Thu, 18 Nov 2021 17:27:00 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        David Miller <davem@davemloft.net>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 5/8] net: phylink: pass supported PHY interface
 modes to phylib
Message-ID: <YZZ+1LBrTxHzMJpP@lunn.ch>
References: <20211117225050.18395-1-kabel@kernel.org>
 <20211117225050.18395-6-kabel@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211117225050.18395-6-kabel@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> +static int __init phylink_init(void)
> +{
> +	__set_bit(PHY_INTERFACE_MODE_USXGMII, phylink_sfp_interfaces);
> +	__set_bit(PHY_INTERFACE_MODE_10GBASER, phylink_sfp_interfaces);
> +	__set_bit(PHY_INTERFACE_MODE_10GKR, phylink_sfp_interfaces);
> +	__set_bit(PHY_INTERFACE_MODE_5GBASER, phylink_sfp_interfaces);
> +	__set_bit(PHY_INTERFACE_MODE_2500BASEX, phylink_sfp_interfaces);
> +	__set_bit(PHY_INTERFACE_MODE_SGMII, phylink_sfp_interfaces);
> +	__set_bit(PHY_INTERFACE_MODE_1000BASEX, phylink_sfp_interfaces);

Do we need to include PHY_INTERFACE_MODE_100BASEX here for 100BaseFX?
Not sure we actually have any systems using it.

   Andrew
