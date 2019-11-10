Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22EDEF6A86
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 18:16:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726958AbfKJRQR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 12:16:17 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59188 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726651AbfKJRQR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 12:16:17 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=4uJkyjXWX2BREWfUcl63DkiPPqGrm/HDdRWgcq2ZqRQ=; b=IAwjTBhZ4W40T2DwRrsgr4D1kx
        YqKj9b3TakV85m6Mh+4qTeC5d2AmSVGOrirxq0PxWce3hGSnXf0fvyemgqY4gBfdIL9v5hcE4bMh6
        spOQCxQT8xyoIHaIT6O4KB5QI73vnN0WY723hjoP8VCtNJLGvvWz6OZNQY8m0aan9vis=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iTqot-00072p-Iu; Sun, 10 Nov 2019 18:16:11 +0100
Date:   Sun, 10 Nov 2019 18:16:11 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, horatiu.vultur@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org
Subject: Re: [PATCH net-next 00/15] Accomodate DSA front-end into Ocelot
Message-ID: <20191110171611.GI25889@lunn.ch>
References: <20191109130301.13716-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191109130301.13716-1-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 09, 2019 at 03:02:46PM +0200, Vladimir Oltean wrote:
> After the nice "change-my-mind" discussion about Ocelot, Felix and
> LS1028A (which can be read here: https://lkml.org/lkml/2019/6/21/630),
> we have decided to take the route of reworking the Ocelot implementation
> in a way that is DSA-compatible.
> 
> This is a large series, but hopefully is easy enough to digest, since it
> contains mostly code refactoring.

I just skimmed over the patches. Apart from the naming confusion at
the end, it all looks O.K.

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

> It also means that Ocelot practically re-implements large parts of
> DSA (although it is not a DSA switch per se)

Would it make sense to refactor parts of the DSA core and export them
as helper function?

   Andrew
