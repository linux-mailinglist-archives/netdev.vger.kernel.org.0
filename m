Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0DF7760833
	for <lists+netdev@lfdr.de>; Fri,  5 Jul 2019 16:45:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727291AbfGEOpZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Jul 2019 10:45:25 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:56416 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725926AbfGEOpY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 5 Jul 2019 10:45:24 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EZeBhVxNapTqKm+TwpOXvO0xXIhyUhxpE2tEItylRz8=; b=RzdT0cQsutnBd57fPrKQA8JTW1
        GldevCdIm0HRpXI6Da4ODBN0o4CjiqNoJu93oqsfoxv+9q2EPFOvMKpS6o3PoTf6ZqUuOZVgD40Xf
        BrrUKZZhwHKX77ZKAJ4M5KnkzhkiD7o8BLpj8BADo4bw9H5PJMc4dYHCro1Yy3FBdMTE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hjPSf-0001fm-1w; Fri, 05 Jul 2019 16:45:17 +0200
Date:   Fri, 5 Jul 2019 16:45:17 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Antoine Tenart <antoine.tenart@bootlin.com>
Cc:     davem@davemloft.net, richardcochran@gmail.com,
        alexandre.belloni@bootlin.com, UNGLinuxDriver@microchip.com,
        ralf@linux-mips.org, paul.burton@mips.com, jhogan@kernel.org,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        thomas.petazzoni@bootlin.com, allan.nielsen@microchip.com
Subject: Re: [PATCH net-next 1/8] Documentation/bindings: net: ocelot:
 document the PTP bank
Message-ID: <20190705144517.GD4428@lunn.ch>
References: <20190701100327.6425-1-antoine.tenart@bootlin.com>
 <20190701100327.6425-2-antoine.tenart@bootlin.com>
 <20190701135214.GD25795@lunn.ch>
 <20190705133016.GD3926@kwain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190705133016.GD3926@kwain>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 05, 2019 at 03:30:16PM +0200, Antoine Tenart wrote:
> Hi Andrew,
> 
> On Mon, Jul 01, 2019 at 03:52:14PM +0200, Andrew Lunn wrote:
> > On Mon, Jul 01, 2019 at 12:03:20PM +0200, Antoine Tenart wrote:
> > > One additional register range needs to be described within the Ocelot
> > > device tree node: the PTP. This patch documents the binding needed to do
> > > so.
> > 
> > Are there any more register banks? Maybe just add them all?
> 
> I checked and there are (just a few) more. I also saw your other comment
> about interrupts, and it's also true there.
> 
> Those definitions aren't related to the PHC so I'll prepare a patch for
> a following series to add all the missing parts.

Thanks.
 
> > Also, you should probably add a comment that despite it being in the
> > Required part of the binding, it is actually optional.
> 
> I'm not sure about this: optional properties means some parts of the h/w
> can be missing or not wired. It's not the case here, it's "optional" in
> the driver only for dt compatibility (so that an older dt blob can work
> with a newer kernel image), but it's now mandatory in the binding.

Hi Antoine

If the driver can work without it, it is clearly optional. You just
get reduced functionality. That is the thing with DT. You can never
add more required properties after the first commit without breaking
backwards compatibility. To make the documentation fit the driver,
somewhere you need to state they are optional. Either by placing the
new properties in the optional section of the binding, or add a
comment.

	Andrew
