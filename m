Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B66922B848
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 23:02:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726390AbgGWVCu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 17:02:50 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52188 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726115AbgGWVCu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 23 Jul 2020 17:02:50 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jyiMP-006ZxW-B2; Thu, 23 Jul 2020 23:02:37 +0200
Date:   Thu, 23 Jul 2020 23:02:37 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Cc:     "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 3/4] net: dsa: mv88e6xxx: Implement
 .port_change_mtu/.port_max_mtu
Message-ID: <20200723210237.GJ1553578@lunn.ch>
References: <20200723035942.23988-1-chris.packham@alliedtelesis.co.nz>
 <20200723035942.23988-4-chris.packham@alliedtelesis.co.nz>
 <20200723133122.GB1553578@lunn.ch>
 <e10da452-c04a-b519-6c30-c94e60101f92@alliedtelesis.co.nz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <e10da452-c04a-b519-6c30-c94e60101f92@alliedtelesis.co.nz>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 23, 2020 at 08:50:27PM +0000, Chris Packham wrote:
> 
> On 24/07/20 1:31 am, Andrew Lunn wrote:
> > On Thu, Jul 23, 2020 at 03:59:41PM +1200, Chris Packham wrote:
> >> Add implementations for the mv88e6xxx switches to connect with the
> >> generic dsa operations for configuring the port MTU.
> > Hi Chris
> >
> > What tree is this against?
> $ git config remote.origin.url
> git://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
> $ git describe `git merge-base HEAD origin/master`

Hi Chris

Networking patches are expected to be against net-next. Or net if they
are fixes. Please don't submit patches to netdev against other trees.

	   Andrew
