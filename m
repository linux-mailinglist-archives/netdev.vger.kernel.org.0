Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 697F8F9146
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 15:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727348AbfKLOBO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 09:01:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35926 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725947AbfKLOBO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 09:01:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=/RI6fmn/sUXIGU/PUViPxPFyONizIT5yqn4fGxzbWxQ=; b=kdU551XWBYrVXong2h3XiotiJw
        JEiOK35L945IH4Zcekg9kweTxxuCuNnr4G0T1uFTXjeEbSxUJbRhXRAQY4ypq1qe9FEywx8BFQPJ2
        R0pOR300JtGlbAsbLKXQXxI61kwlu+ffVZ6W9GsL5xI0UZG2io2JlKEGIPQECAXq4z9c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iUWjF-0001m2-E6; Tue, 12 Nov 2019 15:01:09 +0100
Date:   Tue, 12 Nov 2019 15:01:09 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     Marc Zyngier <maz@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        lkml <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 2/2] ARM: dts: ls1021a-tsn: Use interrupts for the SGMII
 PHYs
Message-ID: <20191112140109.GK5090@lunn.ch>
References: <20191112132010.18274-1-linux@rasmusvillemoes.dk>
 <20191112132010.18274-3-linux@rasmusvillemoes.dk>
 <CA+h21hqw16o0TqOV1WWYYcOs3YWJe=xq_K0=miU+BFTA31OTmQ@mail.gmail.com>
 <6d4292fcb0cf290837306388bdfe9b0f@www.loen.fr>
 <CA+h21hpE-Nu_Sh1fRizUoEs082ev=9nzuumSXDrk-QTXdnEbzg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+h21hpE-Nu_Sh1fRizUoEs082ev=9nzuumSXDrk-QTXdnEbzg@mail.gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > >> +               /* SGMII2_PHY_INT_B: connected to IRQ2, active low
> > >> */
> > >> +               interrupts-extended = <&extirq 2
> > >> IRQ_TYPE_EDGE_FALLING>;

> The interrupt specifier certainly works. So that points to an issue
> with the description. What do you mean, exactly? Does "active low"
> mean "level-triggered"? How would you have described this?

I would expect IRQ_TYPE_ACTIVE_LOW, or whatever it is called. Since
this is a shared interrupt, going on the edge i think opens up a race
condition and interrupts can be missed.

	  Andrew
