Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8C1127F63
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 16:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727497AbfLTPeG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 10:34:06 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35226 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727181AbfLTPeF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Dec 2019 10:34:05 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FlEdcjqR14Yp6BDuBVePu7rcTs7oSKGfaNl9lmmWvhY=; b=zFKX5Mx6zfivGSorxUsCX27mrf
        Mdb7jKv4NoU2UpfVY45idZm7bRTqFThe+ouaRvXPd4oGnAAhXw3PSRzXQcp0PToyJj8nEk62cGtIX
        bzhUpCsvadN1+mTB6aJRnpwhbimkq4102brSkFxx2RKwX8OJwhozOOuKIRSrBfEZCeSU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1iiKHv-0003HC-5i; Fri, 20 Dec 2019 16:33:59 +0100
Date:   Fri, 20 Dec 2019 16:33:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Richard Cochran <richardcochran@gmail.com>
Cc:     netdev@vger.kernel.org, David Miller <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jacob Keller <jacob.e.keller@intel.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Miroslav Lichvar <mlichvar@redhat.com>,
        Murali Karicheri <m-karicheri2@ti.com>,
        Rob Herring <robh+dt@kernel.org>,
        Willem de Bruijn <willemb@google.com>,
        Wingman Kwok <w-kwok2@ti.com>
Subject: Re: [PATCH V6 net-next 06/11] net: Introduce a new MII time stamping
 interface.
Message-ID: <20191220153359.GA11117@lunn.ch>
References: <cover.1576511937.git.richardcochran@gmail.com>
 <28939f11b984759257167e778d0c73c0dd206a35.1576511937.git.richardcochran@gmail.com>
 <20191217092155.GL6994@lunn.ch>
 <20191220145712.GA3846@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191220145712.GA3846@localhost>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 20, 2019 at 06:57:12AM -0800, Richard Cochran wrote:
> On Tue, Dec 17, 2019 at 10:21:55AM +0100, Andrew Lunn wrote:
> > Forward declarations are considered bad.
> 
> Not by me!

Lets see what David says.

> > For the moment what you have is sufficient. I doubt anybody is using
> > the dp83640 with phylink, and the new hardware you are targeting seems
> > to be RGMII based, not SERDES, which is the main use case for PHYLINK.
> 
> Yeah, my impression is that the phyter will be the first and last phy
> time stamping device ever created.  Designers reject this part because
> it is 100 mbit only.  And there are no gigabit+ phys with time
> stamping at all.

The Marvell PHY datasheets indicate they support PTP. I've not looked
at how they implement it, and if the current model will work.

   Andrew
