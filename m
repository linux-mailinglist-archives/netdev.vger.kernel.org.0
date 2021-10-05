Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EAB6422724
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 14:55:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234622AbhJEM4r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 08:56:47 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:49724 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233762AbhJEM4q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 08:56:46 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3qDoYZMzuMRzgychhmawROrxKk7RrijI3e166SN1U6k=; b=SmBTEAahJfv2ME/hJ80IGHTdbj
        Jz1KnQooxxOiTxI1QJ79XKSkWHuAdOFbxsmdpL8pO6eoQqY4vegquS2pd6yUorQBfIBlPMFDP6LA8
        T6qJu6v6kKG4tHXO1BAvdeB7yyWH/p3Bded0lMvkxsbr7pYfnWleTi4/Q1FyVR27IRkg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mXjy8-009gzL-1j; Tue, 05 Oct 2021 14:54:52 +0200
Date:   Tue, 5 Oct 2021 14:54:52 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marcel Ziswiler <marcel@ziswiler.com>
Cc:     devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Frank Rowand <frowand.list@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH v1 1/4] dt-bindings: net: dsa: marvell: fix compatible in
 example
Message-ID: <YVxLHHyxbJOS+66L@lunn.ch>
References: <20211005060334.203818-1-marcel@ziswiler.com>
 <20211005060334.203818-2-marcel@ziswiler.com>
 <YVxJt2ADMuVEwjnW@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YVxJt2ADMuVEwjnW@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 05, 2021 at 02:48:55PM +0200, Andrew Lunn wrote:
> On Tue, Oct 05, 2021 at 08:03:31AM +0200, Marcel Ziswiler wrote:
> > While the MV88E6390 switch chip exists, one is supposed to use a
> > compatible of "marvell,mv88e6190" for it. Fix this in the given example.
> > 
> > Signed-off-by: Marcel Ziswiler <marcel@ziswiler.com>
> 
> Fixes: a3c53be55c95 ("net: dsa: mv88e6xxx: Support multiple MDIO busses")
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>
> 
> Hi Marcel
> 
> Since this is a fix, it should be sent separately, and for net, not
> net-next.

Ah, i need to expand that comment a bit. This patch is effectively to
the networking subsystem, where as the reset are for
mvebu/arm-soc. They have different Maintainers. Please see:

https://www.kernel.org/doc/html/latest/networking/netdev-FAQ.html

	Andrew
