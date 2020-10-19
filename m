Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E37B22926E9
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 14:05:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726588AbgJSMFh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 08:05:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:34504 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726015AbgJSMFg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 19 Oct 2020 08:05:36 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kUTuw-002UQp-6t; Mon, 19 Oct 2020 14:05:34 +0200
Date:   Mon, 19 Oct 2020 14:05:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <vladimir.oltean@nxp.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "kuba@kernel.org" <kuba@kernel.org>,
        Christian Eggers <ceggers@arri.de>,
        Kurt Kanzenbach <kurt@linutronix.de>
Subject: Re: [RFC PATCH 01/13] net: dsa: add plumbing for custom netdev
 statistics
Message-ID: <20201019120534.GL456889@lunn.ch>
References: <20201017213611.2557565-2-vladimir.oltean@nxp.com>
 <06538edb-65a9-c27f-2335-9213322bed3a@gmail.com>
 <20201018121640.jwzj6ivpis4gh4ki@skbuf>
 <19f10bf4-4154-2207-6554-e44ba05eed8a@gmail.com>
 <20201018134843.emustnvgyby32cm4@skbuf>
 <2ae30988-5918-3d02-87f1-e65942acc543@gmail.com>
 <20201018225820.b2vhgzyzwk7vy62j@skbuf>
 <b43ad106-9459-0ce9-0999-a6e46af36782@gmail.com>
 <20201019002123.nzi2zhfak3r3lis3@skbuf>
 <da422046-fc3e-9aba-88d1-e7a4d3a74843@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <da422046-fc3e-9aba-88d1-e7a4d3a74843@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 18, 2020 at 08:49:31PM -0700, Florian Fainelli wrote:
> 
> 
> On 10/18/2020 5:21 PM, Vladimir Oltean wrote:
> > On Sun, Oct 18, 2020 at 04:11:14PM -0700, Florian Fainelli wrote:
> > > How about when used as a netconsole? We do support netconsole over DSA
> > > interfaces.
> > 
> > How? Who is supposed to bring up the master interface, and when?
> > 
> 
> You are right that this appears not to work when configured on the kernel
> command line:
> 
> [    6.836910] netpoll: netconsole: local port 4444
> [    6.841553] netpoll: netconsole: local IPv4 address 192.168.1.10
> [    6.847582] netpoll: netconsole: interface 'gphy'
> [    6.852305] netpoll: netconsole: remote port 9353
> [    6.857030] netpoll: netconsole: remote IPv4 address 192.168.1.254
> [    6.863233] netpoll: netconsole: remote ethernet address
> b8:ac:6f:80:af:7e
> [    6.870134] netpoll: netconsole: device gphy not up yet, forcing it
> [    6.876428] netpoll: netconsole: failed to open gphy
> [    6.881412] netconsole: cleaning up
> 
> looking at my test notes from 2015 when it was added, I had only tested
> dynamic netconsole while the network devices have already been brought up
> which is why I did not catch it. Let me see if I can fix that somehow.

Hi Florian

NFS root used to work, so there must be some code in the kernel to
bring the master interface up. Might just need copy/pasting.

      Andrew
