Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24B8D27FF4D
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 14:37:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732165AbgJAMh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 08:37:29 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38050 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732031AbgJAMhE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 08:37:04 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kNxpJ-00H40x-OX; Thu, 01 Oct 2020 14:36:49 +0200
Date:   Thu, 1 Oct 2020 14:36:49 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Cc:     Russell King <linux@armlinux.org.uk>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: dsa: mv88e6xxx: serdes link without phy
Message-ID: <20201001123649.GC4050473@lunn.ch>
References: <72e8e25a-db0d-275f-e80e-0b74bf112832@alliedtelesis.co.nz>
 <20201001012410.GA4050473@lunn.ch>
 <e2c1196a-3a0f-6527-2ae0-8d53af2912df@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e2c1196a-3a0f-6527-2ae0-8d53af2912df@alliedtelesis.co.nz>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > Can you run 1000Base-X over these links?
> With some reading "1000base-x" does seem the right thing to say here. 
> It's even what is reflected in the CMODE field for those ports.

One more thing you might need is

managed = "in-band-status";

> > If you can, it is probably
> > worth chatting to Russell King about using inband-signalling, and what
> > is needed to make it work without having back to back SFPs. If i
> > remember correctly, Russell has said not much is actually needed.
> 
> That'd be ideal. The sticking point seems to be allowing it to have no PHY.

I think there is more to it than that. This is new ground to some
extent.

	Andrew
