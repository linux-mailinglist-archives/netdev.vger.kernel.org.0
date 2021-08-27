Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A42153FA054
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 22:11:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231565AbhH0UMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 16:12:15 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45358 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231472AbhH0UMO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 16:12:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=BvwakT2Cfp9jgzCeUu5YYEs3eBCl3SoatPDmjRaP9Sg=; b=beNjMWkrBSiEsBTnKNKqJPbVJF
        EQI1TqVxeY476KyyZRFSNF5IvKRd13m3/7K+7pB9mQ8OCOD9Ih8HlZk8UZSIh7tD+LTDcpfPzaK5a
        fad9iq0xYpmb/YSJph+skbSgoBWrO/lMZMlniYATR2Nax34ZQHvIN+9LgBYtfADpcVE0=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mJiC1-004ABt-F0; Fri, 27 Aug 2021 22:11:13 +0200
Date:   Fri, 27 Aug 2021 22:11:13 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Saravana Kannan <saravanak@google.com>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, Len Brown <lenb@kernel.org>,
        Alvin Sipraga <ALSI@bang-olufsen.dk>, kernel-team@android.com,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: Re: [PATCH v1 1/2] driver core: fw_devlink: Add support for
 FWNODE_FLAG_BROKEN_PARENT
Message-ID: <YSlG4XRGrq5D1/WU@lunn.ch>
References: <20210826074526.825517-1-saravanak@google.com>
 <20210826074526.825517-2-saravanak@google.com>
 <YSeTdb6DbHbBYabN@lunn.ch>
 <CAGETcx-pSi60NtMM=59cve8kN9ff9fgepQ5R=uJ3Gynzh=0_BA@mail.gmail.com>
 <YSf/Mps9E77/6kZX@lunn.ch>
 <CAGETcx_h6moWbS7m4hPm6Ub3T0tWayUQkppjevkYyiA=8AmACw@mail.gmail.com>
 <YSg+dRPSX9/ph6tb@lunn.ch>
 <CAGETcx_r8LSxV5=GQ-1qPjh7qGbCqTsSoSkQfxAKL5q+znRoWg@mail.gmail.com>
 <YSjsQmx8l4MXNvP+@lunn.ch>
 <CAGETcx_vMNZbT-5vCAvvpQNMMHy-19oR-mSfrg6=eSO49vLScQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAGETcx_vMNZbT-5vCAvvpQNMMHy-19oR-mSfrg6=eSO49vLScQ@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > I've not yet looked at plain Ethernet drivers. This pattern could also
> > exist there. And i wonder about other complex structures, i2c bus
> > multiplexors, you can have interrupt controllers as i2c devices,
> > etc. So the general case could exist in other places.
> 
> I haven't seen any generic issues like this reported so far. It's only
> after adding phy-handle that we are hitting these issues with DSA
> switches.

Can you run your parser over the 2250 DTB blobs and see how many
children have dependencies on a parent? That could give us an idea how
many moles need whacking. And maybe, where in the tree they are
hiding?

    Andrew
