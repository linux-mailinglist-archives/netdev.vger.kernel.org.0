Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 06F9E1D1CD1
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 20:02:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390016AbgEMSBt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 14:01:49 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58502 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732488AbgEMSBs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 13 May 2020 14:01:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dA0dBS/M2ZOOg0j3lay3GFmcbsWG9ZBUT4mX89gO5Zk=; b=SYsl/DgykWYBa+3iZ+2Ezs8zK+
        kRxfI7UBuSxWHB82HFivrmaO8bnGbV1KeH/x9sOesVMUcJtRAxRRVlHYsSETD34kmT91yW6Pp3n+a
        oDB76jwIQHc2GVrH4QdsAY/+RtwmbEfeiYhtxeucIMfB/JbYshb2aUC2Kvcy36PB41f4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jYvhM-002Bsq-CQ; Wed, 13 May 2020 20:01:40 +0200
Date:   Wed, 13 May 2020 20:01:40 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Oleksij Rempel <o.rempel@pengutronix.de>
Cc:     Mark Rutland <mark.rutland@arm.com>, Marek Vasut <marex@denx.de>,
        Florian Fainelli <f.fainelli@gmail.com>,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Pengutronix Kernel Team <kernel@pengutronix.de>,
        David Jander <david@protonic.nl>,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
Subject: Re: [PATCH net-next v1] net: phy: tja11xx: add cable-test support
Message-ID: <20200513180140.GK499265@lunn.ch>
References: <20200513123440.19580-1-o.rempel@pengutronix.de>
 <20200513133925.GD499265@lunn.ch>
 <20200513174011.kl6l767cimeo6dpy@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200513174011.kl6l767cimeo6dpy@pengutronix.de>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> What would be the best place to do a test before the link is getting up?
> Can it be done in the phy core, or it should be done in the PHY driver?
> 
> So far, no action except of logging these errors is needed. 

You could do it in the config_aneg callback.

A kernel log entry is not very easy to use. You might want to see how
easy it is to send a cable test result to userspace. Anything which is
interested in this information can then listen for it. All the needed
code is there, you will just need to rearrange it a bit.

	   Andrew
