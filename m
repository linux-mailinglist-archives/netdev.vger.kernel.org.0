Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E78284A860C
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 15:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351100AbiBCOUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 09:20:49 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:55648 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235184AbiBCOUt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 09:20:49 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E673E6195E;
        Thu,  3 Feb 2022 14:20:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 12FF0C340E4;
        Thu,  3 Feb 2022 14:20:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1643898048;
        bh=2K348VVBG3EKLps4xUCnPyJaENsvksstznkGipAYxcc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ir5Pqa/efkNbEd5D7nv1SqhVwnPhocstxD3uwQg3haSqEGtUCsyeP08LZggEwvO/a
         aQiOtcFL3agtdM8tHaFAZltYKRqsXZEoXpIKdxgXPZuic0YCZ9kZXE99XXQtr1gTMY
         P3r+Q/Y/ygMYBfEAufBxubScuxMBaC4+4er9hUOQ=
Date:   Thu, 3 Feb 2022 15:20:44 +0100
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Sergey Ryazanov <ryazanov.s.a@gmail.com>,
        Oleksij Rempel <o.rempel@pengutronix.de>,
        Oliver Neukum <oneukum@suse.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, kernel@pengutronix.de,
        open list <linux-kernel@vger.kernel.org>,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        devicetree <devicetree@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Subject: Re: [PATCH net-next v1 4/4] usbnet: add support for label from
 device tree
Message-ID: <YfvkvO37IsoVNiV9@kroah.com>
References: <20220127104905.899341-1-o.rempel@pengutronix.de>
 <20220127104905.899341-5-o.rempel@pengutronix.de>
 <YfJ6lhZMAEmetdad@kroah.com>
 <20220127112305.GC9150@pengutronix.de>
 <YfKCTG7N86yy74q+@kroah.com>
 <20220127120039.GE9150@pengutronix.de>
 <YfKcYXjfhVKUKfzY@kroah.com>
 <CAHNKnsTY0cV4=V7t0Q3p4-hO5t9MbWWM-X0MJFRKCZ1SG0ucUg@mail.gmail.com>
 <YfvS3F6kHUyxs6D0@lunn.ch>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YfvS3F6kHUyxs6D0@lunn.ch>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 03, 2022 at 02:04:28PM +0100, Andrew Lunn wrote:
> On Thu, Feb 03, 2022 at 05:20:34AM +0300, Sergey Ryazanov wrote:
> > Hello Greg,
> > 
> > if I may be allowed, I would like to make a couple of points about
> > specifying network interface names in DT. As in previous mail, not to
> > defend this particular patch, but to talk about names assignment in
> > general.
> > 
> > I may be totally wrong, so consider my words as a request for
> > discussion. I have been thinking about an efficient way for network
> > device names assignment for routers with a fixed configuration and
> > have always come to a conclusion that DT is a good place for names
> > storage. Recent DSA capability to assign names from labels and this
> > patch by Oleksij show that I am not alone.
> 
> DSA doing this is not recent. The first patch implementing DSA in 2008
> had the ability to set the interface names. This was long before the
> idea that userspace should set interface names became the 'correct'
> way to do this.

udev came out in 2003, and we had the goal of having userspace do all of
the device naming way back then, so DSA was late to the game :)

thanks,

greg k-h
