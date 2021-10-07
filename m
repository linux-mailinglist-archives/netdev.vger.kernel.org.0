Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E6B26424AFC
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 02:14:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232303AbhJGAQP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 20:16:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53242 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232178AbhJGAQO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 20:16:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=ziGfV3EhoyA+YqFQkMPP1+RYZyJ9AyQKelot5eKnRTQ=; b=tshFQK/ogBkCZfKvwqaut6Iu79
        MBGadhIdnrw4lPjqoStzj4WrsBHTf73MmQrZm1r7nVajZ3WlzFgJ/dS5GME4I21Wsz4Apq4HcdiXT
        uMAncGpdxrYv131NxZMyvd8U8VFnyh0l3Ujz9duivl1mt57irlby4AdDqkIyYqxWfkgU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mYH3C-009tDC-MD; Thu, 07 Oct 2021 02:14:18 +0200
Date:   Thu, 7 Oct 2021 02:14:18 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Matthew Hagan <mnhagan88@gmail.com>
Subject: Re: [net-next PATCH 07/13] net: dsa: qca8k: add support for
 mac6_exchange, sgmii falling edge
Message-ID: <YV472otG4JTeppou@lunn.ch>
References: <20211006223603.18858-1-ansuelsmth@gmail.com>
 <20211006223603.18858-8-ansuelsmth@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211006223603.18858-8-ansuelsmth@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 12:35:57AM +0200, Ansuel Smith wrote:
> Some device set the switch to exchange the mac0 port with mac6 port. Add
> support for this in the qca8k driver. Also add support for SGMII rx/tx
> clock falling edge. This is only present for pad0, pad5 and pad6 have
> these bit reserved from Documentation.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>
> Signed-off-by: Matthew Hagan <mnhagan88@gmail.com>

Who wrote this patch? The person submitting it should be last. If
Matthew actually wrote it, you want to play with git commit --author=
to set the correct author.

   Andrew
