Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78F743D79AD
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 17:26:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbhG0PZ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 11:25:57 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47706 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236901AbhG0PZp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 27 Jul 2021 11:25:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=dZk70SnxCgqV5ow1i0wJVGa22cxSQ4M4a5N6jVhB334=; b=yvMOVx7bbnhcjaK+bebVFBVHjb
        Zudg6uqBs082zvHsCFcf9sQkP/qAOUSut9Pn24mw+1A8kW/nCBun6z8yo0iiR+/pvpXc1DABfMnpl
        YyHlL9u45XvoCEu09u5qq0Eyk4k/SlaJFUo4GdAgey6zcklOQhF42M4mQKuUDcF+v7S4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m8Owo-00F27k-CN; Tue, 27 Jul 2021 17:24:46 +0200
Date:   Tue, 27 Jul 2021 17:24:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     Marek =?iso-8859-1?Q?Beh=FAn?= <kabel@kernel.org>,
        anthony.l.nguyen@intel.com, bigeasy@linutronix.de,
        davem@davemloft.net, dvorax.fuxbrumer@linux.intel.com,
        f.fainelli@gmail.com, hkallweit1@gmail.com,
        jacek.anaszewski@gmail.com, kuba@kernel.org, kurt@linutronix.de,
        linux-leds@vger.kernel.org, netdev@vger.kernel.org, pavel@ucw.cz,
        sasha.neftin@intel.com, vinicius.gomes@intel.com,
        vitaly.lifshits@intel.com
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <YQAlPrF2uu3Gr+0d@lunn.ch>
References: <YP9n+VKcRDIvypes@lunn.ch>
 <20210727081528.9816-1-michael@walle.cc>
 <20210727165605.5c8ddb68@thinkpad>
 <c56fd3dbe1037a5c2697b311f256b3d8@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c56fd3dbe1037a5c2697b311f256b3d8@walle.cc>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> I wasn't talking about ethN being same as the network interface name.
> For clarity I'll use ethernetN now. My question was why would you
> use ethmacN or ethphyN instead if just ethernetN for both. What is
> the reason for having two different names?

We can get into the situation where both the MAC and the PHY have LED
controllers. So we need to ensure the infrastructure we put in place
handles this, we don't get any name clashes.

	Andrew
