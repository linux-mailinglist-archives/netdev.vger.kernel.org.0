Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E6F16555DC
	for <lists+netdev@lfdr.de>; Sat, 24 Dec 2022 00:03:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230490AbiLWXDK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Dec 2022 18:03:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48060 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230383AbiLWXDJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 23 Dec 2022 18:03:09 -0500
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A9A791FCD2
        for <netdev@vger.kernel.org>; Fri, 23 Dec 2022 15:03:08 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=3HtaAEcc/uBAdWpNuLhr+dJ0yXgZ8VnGLfkx72TUtUs=; b=IeisfcdIVebxyXXKgR7+9MCDGm
        xXTpwqMaVXGhXWaWKMlGmPVA6E+bBDoR/xzXW1SX2pZLXN60QzhW0yTRUeckiDv7VvX8otU15oz+a
        fJRrJV19s3dUZGFq22Crtfu1NiyH0XXFLKDkKiTaTKRC35DeGD0jVlrCaNE1yCQWPMvY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1p8r4B-000Mni-Tq; Sat, 24 Dec 2022 00:03:03 +0100
Date:   Sat, 24 Dec 2022 00:03:03 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Colin Foster <colin.foster@in-advantage.com>
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org
Subject: Re: Crosschip bridge functionality
Message-ID: <Y6Yzp84WW1tQLdsB@lunn.ch>
References: <Y6YDi0dtiKVezD8/@euler>
 <Y6YKBzDJfs8LP0ny@lunn.ch>
 <Y6YVhWSTg4zgQ6is@euler>
 <Y6YbPiI+pRjOQcxZ@lunn.ch>
 <Y6YtiwqJWyv3yW9r@euler>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y6YtiwqJWyv3yW9r@euler>
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Fair question. We have a baseboard configuration with cards that offer
> customization / expansion. An example might be a card that offers
> additional fibre / copper ports, which would lend itself very nicely to
> a DSA configuration... more cards == more ports.
> 
> We can see some interesting use of vlans for all sorts of things. I
> haven't been the boots on the ground, so I don't know all the use-cases.
> My main hope is to be able to offer as much configurability for the
> system integrators as possible. Maybe sw2p2 is a tap of sw1p2, while
> sw2p3, sw2p4, and sw1p3 are bridged, with the CPU doing IGMP snooping
> and running RSTP.
> 
> > 
> > I know people have stacked switches before, and just operated them as
> > stacked switches. So you need to configure each switch independently.
> > What Marvell DSA does is make it transparent, so to some extent it
> > looks like one big switch, not a collection of switches.
> 
> That is definitely possible. It might make the people doing any system
> integration have a lot more knowledge than a simple "add this port to
> that bridge". My goal is to make their lives as easy as can be.
> 
> It sounds like that all exists with Marvell hardware...

You might want get hold of a Turris Mox system, with a few different
cards in it. That will give you a Marvell D in DSA system to play
with. And your system seems quite similar in some ways.

    Andrew
