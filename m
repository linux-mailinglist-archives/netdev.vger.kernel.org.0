Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AC31B102E5F
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 22:43:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727336AbfKSVnK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 16:43:10 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46684 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727007AbfKSVnK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Nov 2019 16:43:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=sY0Xv3qN7kP96iQzm1/rv0Wz0YD45r1gLOqB8C7oMmQ=; b=nQ0f8YFsbfPQllPPSNUXErqSgK
        rT2YEftf0HV56mKBV9+YQUpnBamRumJhe+UqU9ad9tNRUYMUHiMdoFH4Ob/CDs8YQN/dQ0wEf4swT
        CCd8s9ljdCqT5RtshxpEB5P/j/Yg/IySdEcHgZPDaegJ3B6wMOjZqZfREfEBshfXzq74=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iXBGz-0002Fm-V3; Tue, 19 Nov 2019 22:42:57 +0100
Date:   Tue, 19 Nov 2019 22:42:57 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Joergen Andreasen <joergen.andreasen@microchip.com>,
        "Allan W. Nielsen" <allan.nielsen@microchip.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        "Y.b. Lu" <yangbo.lu@nxp.com>, netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next 0/2] Convert Ocelot and Felix switches to PHYLINK
Message-ID: <20191119214257.GB19542@lunn.ch>
References: <20191118181030.23921-1-olteanv@gmail.com>
 <20191118231339.ztotkr536udxuzsl@soft-dev3.microsemi.net>
 <CA+h21hpKN+7ifvFUt6KMYARf19i=Jfw_dwciuPxPC6ZyHRF2XQ@mail.gmail.com>
 <20191119204855.vgiwtrzx3426hbrc@soft-dev3.microsemi.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191119204855.vgiwtrzx3426hbrc@soft-dev3.microsemi.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Before this commit it was ok to use PHY_INTERFACE_MODE_NA but now that
> is not true anymore. In this case we have 4 ports that have phy and
> then 6 sfp ports. So I was looking to describe this in DT but without
> any success. If you have any advice that would be great.

Is it the copper ports causing the trouble, or the SFP?  Ideally, you
should describe the SFPs as SFPs. But i don't think the driver has the
needed support for that yet. So you might need to use fixed-link for
the moment.

   Andrew
