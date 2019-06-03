Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7504533347
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 17:16:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729366AbfFCPQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 11:16:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50778 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729171AbfFCPQL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 3 Jun 2019 11:16:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=fPn2jgXxehD/h+yYF5fK2Ud2Xt3zX9OgX9H3wnmo/ig=; b=F2ra5yoDEWJ3UCbYraOBznnZ+y
        p6/BIq4obLb1xi0ctNuB/oTN8LyGtJnX/9uVf4jHufC7+3kNYD4SY9rVV41WgP+zH4nzOQy2i+Z5Y
        ugPk07bYwdqaS2lKz2zD+dFOtPb+z8FgFqH93oyYzcKOG7iZG08kcON8fqISMSxeoU/s=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hXogw-00064L-4s; Mon, 03 Jun 2019 17:16:06 +0200
Date:   Mon, 3 Jun 2019 17:16:06 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next v3 08/10] net: dsa: mv88e6xxx: add support for
 mv88e6250
Message-ID: <20190603151606.GG19627@lunn.ch>
References: <20190603144112.27713-1-rasmus.villemoes@prevas.dk>
 <20190603144112.27713-9-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190603144112.27713-9-rasmus.villemoes@prevas.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> The chip has four per port 16-bits statistics registers, two of which
> correspond to the existing "sw_in_filtered" and "sw_out_filtered" (but
> at offsets 0x13 and 0x10 rather than 0x12 and 0x13, because why should
> this be easy...).

This is Marvell. Nothing is easy, they keep making subtle changes like
this.

> Wiring up those four statistics seems to require
> introducing a STATS_TYPE_PORT_6250 bit or similar, which seems a tad
> ugly, so for now this just allows access to the STATS_TYPE_BANK0 ones.

I don't think it will be too ugly. We have the abstraction in place to
support it. So feel free to add a follow up patch adding these
statistics if you want.
 
> The chip does have ptp support, and the existing
> mv88e6352_{gpio,avb,ptp}_ops at first glance seem like they would work
> out-of-the-box, but for simplicity (and lack of testing) I'm eliding
> this.

Fine, you can add this later, if you do get a test system.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
