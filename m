Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 945B944CCEB
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 23:32:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234174AbhKJWfO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 17:35:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55480 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234140AbhKJWfN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 17:35:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=/9jSI9XXJ0BNTrF7wiBWFlu2npPyfj2u1QvVr6UGl4k=; b=fTc2niDtnC2xPmySOUN95UWhyE
        1JAe/fwaQx23vdc+3TddqrVkfEc9As9YzYR7C8PCm+f1DJjlipYtidNH4BXhl0bbGfe/skAehHBLh
        3fnxfiRgCqtWjCEzv5ldtzu/sMWeimOYtB/uQ2oGzju7w21FhM7L/srChq0/VvMHECmk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mkw8i-00D97l-92; Wed, 10 Nov 2021 23:32:20 +0100
Date:   Wed, 10 Nov 2021 23:32:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org
Subject: Re: [RFC PATCH v3 6/8] leds: trigger: add hardware-phy-activity
 trigger
Message-ID: <YYxIdAH4JW9OMawS@lunn.ch>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
 <20211109022608.11109-7-ansuelsmth@gmail.com>
 <20211109042517.03baa809@thinkpad>
 <YYrjlHz/UgTUwQAm@lunn.ch>
 <YYwl0ursbAtsBdxX@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYwl0ursbAtsBdxX@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 09:04:34PM +0100, Ansuel Smith wrote:
> On Tue, Nov 09, 2021 at 10:09:40PM +0100, Andrew Lunn wrote:
> > > > +/* Expose sysfs for every blink to be configurable from userspace */
> > > > +DEFINE_OFFLOAD_TRIGGER(blink_tx, BLINK_TX);
> > > > +DEFINE_OFFLOAD_TRIGGER(blink_rx, BLINK_RX);
> > > > +DEFINE_OFFLOAD_TRIGGER(keep_link_10m, KEEP_LINK_10M);
> > > > +DEFINE_OFFLOAD_TRIGGER(keep_link_100m, KEEP_LINK_100M);
> > > > +DEFINE_OFFLOAD_TRIGGER(keep_link_1000m, KEEP_LINK_1000M);
> > 
> > You might get warnings about CamelCase, but i suggest keep_link_10M,
> > keep_link_100M and keep_link_1000M. These are megabits, not millibits.
> > 
> > > > +DEFINE_OFFLOAD_TRIGGER(keep_half_duplex, KEEP_HALF_DUPLEX);
> > > > +DEFINE_OFFLOAD_TRIGGER(keep_full_duplex, KEEP_FULL_DUPLEX);
> > 
> > What does keep mean in this context?
> >
> 
> LED is turned on but doesn't blink. Hint for a better name?

I would just drop the keep. You have blink_ as a prefix for those
modes that blink.

      Andrew
