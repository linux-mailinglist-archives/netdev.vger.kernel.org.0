Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6665742315D
	for <lists+netdev@lfdr.de>; Tue,  5 Oct 2021 22:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235894AbhJEUOA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Oct 2021 16:14:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:50718 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235581AbhJEUN7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 5 Oct 2021 16:13:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=Wq7nrL82/L3EOLhn+avQUN00z2EQ2FcNnYuF4o5Vwxc=; b=AV/VFhOx8CPCsEz+WuHkHFZ7pH
        3D7Sa/E0gSDzXv38L0ZyfveGdnlyDeZQSSSifGFbhZFlgWu2U2XrcYpVjGXqHAwOtKKebb5b73rKd
        gf1YjkWeejx3bP7apHZ7GC7Ta8vB/+amiGOkfjGzjD1jLXCUGy/I+1DkXUJtIDUAWtG8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mXqnE-009k7C-1I; Tue, 05 Oct 2021 22:12:04 +0200
Date:   Tue, 5 Oct 2021 22:12:04 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jacek Anaszewski <jacek.anaszewski@gmail.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Rob Herring <robh+dt@kernel.org>, Pavel Machek <pavel@ucw.cz>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: lets settle the LED `function` property regarding the netdev
 trigger
Message-ID: <YVyxlEVQ7TvMs5DH@lunn.ch>
References: <20211001143601.5f57eb1a@thinkpad>
 <YVn815h7JBtVSfwZ@lunn.ch>
 <20211003212654.30fa43f5@thinkpad>
 <YVsUodiPoiIESrEE@lunn.ch>
 <20211004170847.3f92ef48@thinkpad>
 <0b1bc2d7-6e62-5adb-5aed-48b99770d80d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <0b1bc2d7-6e62-5adb-5aed-48b99770d80d@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > > There are two different ways this can be implemented. There can be two
> > > independent LEDs within the same package. So you can generate three
> > > colours. Or there can be two cross connected LEDs within the
> > > package. Apply +ve you get one colour, apply -ve you get a different
> > > colour. Since you cannot apply both -ve and +ve at the same time, you
> > > cannot get both colours at once.
> > > 
> > > If you have two independent LEDs, I would define two LEDs in DT.
> > 
> > No, we have multicolor LED API which is meant for exactly this
> > situation: a multicolor LED.

> What do you mean by dependency here?

https://www.youtube.com/watch?v=5M9p25OfKdg

There are two different ways you can two LEDs in one package.

Some Ethernet PHY RJ45 connector housings have bi-colour LEDs. Some
have tri-colour LEDs, and some have mono-colour LEDs.

      Andrew
