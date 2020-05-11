Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 636E31CE4D0
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 21:54:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731118AbgEKTys (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 15:54:48 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54292 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729695AbgEKTys (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 15:54:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=E569LdmO3ZIRrQhhS9/1AV/GIdOvLP1T63rmCb73zOk=; b=tlUQhZfEyHzdEemgYI515uJGlh
        iwQhY/PZ1w0EnAARWH4bpHBttDUFO61G6U6qNQe90McYQHrf1TaijlitWCp5sgGl/lnMzUeQ/3one
        EIH/upCJauguRaDr8mK1lRbTQnf1GOyfHFxnwsYR7mKOsDHLS/i+i1K9NNv9CKho6Vmo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jYEVX-001tOv-Hf; Mon, 11 May 2020 21:54:35 +0200
Date:   Mon, 11 May 2020 21:54:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Herber <christian.herber@nxp.com>
Cc:     Oleksij Rempel <o.rempel@pengutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        David Jander <david@protonic.nl>,
        "kernel@pengutronix.de" <kernel@pengutronix.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        "mkl@pengutronix.de" <mkl@pengutronix.de>,
        Marek Vasut <marex@denx.de>
Subject: Re: Re: signal quality and cable diagnostic
Message-ID: <20200511195435.GF413878@lunn.ch>
References: <AM0PR04MB70410EA61C984E45615CCF8B86A10@AM0PR04MB7041.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <AM0PR04MB70410EA61C984E45615CCF8B86A10@AM0PR04MB7041.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 11, 2020 at 07:32:05PM +0000, Christian Herber wrote:
> On May 11, 2020 4:33:53 PM Andrew Lunn <andrew@lunn.ch> wrote:
> >
> > Are the classes part of the Open Alliance specification? Ideally we
> > want to report something standardized, not something proprietary to
> > NXP.
> >
> >        Andrew
> 
> Hi Andrew,
> 

> Such mechanisms are standardized and supported by pretty much all
> devices in the market. The Open Alliance specification is publicly
> available here:
> http://www.opensig.org/download/document/218/Advanced_PHY_features_for_automotive_Ethernet_V1.0.pdf
> 
> As the specification is newer than the 100BASE-T1 spec, do not
> expect first generation devices to follow the register definitions
> as per Open Alliance. But for future devices, also registers should
> be same across different vendors.

Hi Christian

Since we are talking about a kernel/user API definition here, i don't
care about the exact registers. What is important is the
naming/representation of the information. It seems like NXP uses Class
A - Class H, where as the standard calls them SQI=0 - SQI=7. So we
should name the KAPI based on the standard, not what NXP calls them.

       Andrew
