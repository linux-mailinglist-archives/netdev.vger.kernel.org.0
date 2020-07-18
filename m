Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A089C224BFC
	for <lists+netdev@lfdr.de>; Sat, 18 Jul 2020 16:44:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727795AbgGROoo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Jul 2020 10:44:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:42656 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726574AbgGROoo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 18 Jul 2020 10:44:44 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jwo4p-005lvq-12; Sat, 18 Jul 2020 16:44:35 +0200
Date:   Sat, 18 Jul 2020 16:44:35 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     John Crispin <john@phrozen.org>,
        Matthew Hagan <mnhagan88@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Jonathan McDowell <noodles@earth.li>,
        Rob Herring <robh+dt@kernel.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH 2/2] dt-bindings: net: dsa: qca8k: Add PORT0_PAD_CTRL
 properties
Message-ID: <20200718144435.GA1375379@lunn.ch>
References: <2e1776f997441792a44cd35a16f1e69f848816ce.1594668793.git.mnhagan88@gmail.com>
 <ea0a35ed686e6dace77e25cb70a8f39fdd1ea8ad.1594668793.git.mnhagan88@gmail.com>
 <20200716150925.0f3e01b8@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <ac7f5f39-9f83-64c0-d8d5-9ea059619f67@gmail.com>
 <53851852-0efe-722e-0254-8652cdfea8fc@phrozen.org>
 <20200718132011.GQ1551@shell.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200718132011.GQ1551@shell.armlinux.org.uk>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jul 18, 2020 at 02:20:11PM +0100, Russell King - ARM Linux admin wrote:
> On Fri, Jul 17, 2020 at 10:44:19PM +0200, John Crispin wrote:
> > in regards to the sgmii clk skew. I never understood the electrics fully I
> > am afraid, but without the patch it simply does not work. my eletcric foo is
> > unfortunately is not sufficient to understand the "whys" I am afraid.
> 
> Do you happen to know what frequency the clock is?  Is it 1.25GHz or
> 625MHz?  It sounds like it may be 1.25GHz if the edge is important.

I'm also a bit clueless when it comes to these systems.

I thought the clock was embedded into the SERDES signal? You recover
it from the signal?

Florian, does the switch have a separate clock input/output?

   Andrew
