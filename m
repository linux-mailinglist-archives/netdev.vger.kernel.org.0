Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A451B424777
	for <lists+netdev@lfdr.de>; Wed,  6 Oct 2021 21:49:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239285AbhJFTvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 15:51:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:38152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229810AbhJFTvN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 15:51:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 8A39D610A2;
        Wed,  6 Oct 2021 19:49:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633549761;
        bh=fIzE6ERIklxmcWuCrWzrrE3Y+yQgRsjs9i1rdqSmBbo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MfF7kkiyCZsLGtDBR7KVuBVxt65Wek2MDpiA6ZoB7bRJK/GLXUCaTep9/PZlpwan4
         4QKSxgFK5uO4XeK/ljb6n1+dS9M8tPDh2pAHyA4u5mgDDaSXFOBPT8Plwjr0qO+vut
         bBYVnCBhnJWmDDRfCxC9NW2anQQX2XCQPv5Ku2X0BgsssqI9/Q1HDL4NTJp4ukSr9W
         eX+DJjztGH44AT+GU/JkR5+Mah69kFO8+jd1rxnxuIfoxZX73zXYwXC3p5wZ929rWc
         GVUvZBd6lOnIFhYqb6xspI3utaXnMkvyNOH9ENxCT68cfFtV1MUkO/2kE+FVo/9Ttk
         hbx9K5s8qCn0A==
Date:   Wed, 6 Oct 2021 12:49:19 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rob Herring <robh+dt@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Saravana Kannan <saravanak@google.com>,
        Marcin Wojtas <mw@semihalf.com>,
        Jeremy Linton <jeremy.linton@arm.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Frank Rowand <frowand.list@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next v2 1/9] of: net: move of_net under net/
Message-ID: <20211006124919.48b46660@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAL_JsqK81knMX5i2DJDsxEALFjwoj3pijjT9ZMJ73aOCjYFhMQ@mail.gmail.com>
References: <20211006154426.3222199-1-kuba@kernel.org>
        <20211006154426.3222199-2-kuba@kernel.org>
        <CAL_JsqK6YzaD0wB0BsP5tghnYMbZzDHq2p6Z_ZGr99EFWhWggw@mail.gmail.com>
        <YV3QAzAWiYdKFB3m@lunn.ch>
        <CAL_JsqLRQRmhXZm25WKzUSBUyK6q5d-BspW4zQcztW3Qf56EKg@mail.gmail.com>
        <20211006101203.4337e9a4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAL_JsqK81knMX5i2DJDsxEALFjwoj3pijjT9ZMJ73aOCjYFhMQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 Oct 2021 14:02:42 -0500 Rob Herring wrote:
> > > Okay, then just move it for now.
> > >
> > > I suspect though that most of these can either be dropped or replaced
> > > with just 'OF' dependency.  
> >
> > I have something that builds with allmodconfig :) see below.  
> 
> Sparc is the arch to try. That's generally we we get tripped up with OF options.

Thanks for the hint, sparc (non-64) allmodconfig builds fine (well, it
spits out this:

  <stdin>:1515:2: warning: #warning syscall clone3 not implemented [-Wcpp] 
  arch/sparc/boot/Makefile:26: FORCE prerequisite is missing

but that seems unrelated).

Is there any other sparc config worth building?
