Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3F38044CCB6
	for <lists+netdev@lfdr.de>; Wed, 10 Nov 2021 23:29:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233655AbhKJWcO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Nov 2021 17:32:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55458 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233569AbhKJWcN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Nov 2021 17:32:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CQp3sJnWCgQNkvm7ChGXxG1WwznWPcDLEIyWH0r1PmM=; b=XAl/F94XLVrlMxYh0nNeM8Srlt
        X7mGUkrqoxrOKL0pfD9P2iFpbuX/zxXOB4vdgQAat5VXHfMEfG/WX3yBvnZIQj8mXvIXRoKHQmFFD
        MeAG1lLz58gbUEn0fvPonTu3b29ehGkC+deBlzl157o3qyClPWsDjypJXLToJJmE+2Yc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mkw5o-00D96S-HT; Wed, 10 Nov 2021 23:29:20 +0100
Date:   Wed, 10 Nov 2021 23:29:20 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>, Pavel Machek <pavel@ucw.cz>,
        John Crispin <john@phrozen.org>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-leds@vger.kernel.org,
        Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>
Subject: Re: [RFC PATCH v3 4/8] leds: trigger: netdev: rename and expose
 NETDEV trigger enum modes
Message-ID: <YYxHwJLdNpDLPLd4@lunn.ch>
References: <20211109022608.11109-1-ansuelsmth@gmail.com>
 <20211109022608.11109-5-ansuelsmth@gmail.com>
 <YYrg870zccL13+Mk@lunn.ch>
 <YYwkJPQeej3/eRUl@Ansuel-xps.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YYwkJPQeej3/eRUl@Ansuel-xps.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 10, 2021 at 08:57:24PM +0100, Ansuel Smith wrote:
> On Tue, Nov 09, 2021 at 09:58:27PM +0100, Andrew Lunn wrote:
> > On Tue, Nov 09, 2021 at 03:26:04AM +0100, Ansuel Smith wrote:
> > > Rename NETDEV trigger enum modes to a more simbolic name and move them
> > 
> > symbolic. Randy is slipping :-)
> > 
> > > in leds.h to make them accessible by any user.
> > 
> > any user? I would be more specific than that. Other triggers dealing
> > with netdev states?
> >
> 
> Ok will be more specific. A LED driver require to explicitly support the
> trigger to run in hardware mode. The LED driver will take the
> trigger_data and elaborate his struct to parse all the option
> (blink_mode bitmap, interval)
> 
> So the user would be a LED driver that adds support for that specific
> trigger. That is also the reason we need to export them.

Say i have a SATA controller where i can configure it to blink on
reads, or writes, or both. It also needs to understand these netdev
modes? I was meaning you need to narrow the comment down to a trigger
which has something to do with netdev. I assume other sorts of
hardware offloads will appear in the future, once the generic
infrastructure is there.

	 Andrew
