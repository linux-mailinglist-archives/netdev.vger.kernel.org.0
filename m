Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D70058A04B
	for <lists+netdev@lfdr.de>; Mon, 12 Aug 2019 16:03:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726681AbfHLODO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Aug 2019 10:03:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53420 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726560AbfHLODO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Aug 2019 10:03:14 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=z7kWGObdYOGtked0iRDHbX2Dd7dHGeiYIsDK1DuZNLk=; b=e+XL1JKIkS5n0fAPge4eF4x48d
        inE5gqqf6RbtW8+Usn5VJ/YL+ICAcRK/gDsUiPQT31kdYGtJrr0hNHo4RRb4j0GV8mE/rLVm36vu7
        INv/zxnBum4lqkNqJD6mUfwo5Lz5j5Ml6/VeyKduQWHkIyAHSEb0U5ASQxjV7k+dp+VY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hxAul-0000a4-Ho; Mon, 12 Aug 2019 16:03:11 +0200
Date:   Mon, 12 Aug 2019 16:03:11 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     "davem@davemloft.net" <davem@davemloft.net>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "f.fainelli@gmail.com" <f.fainelli@gmail.com>,
        Ioana Ciocoi Radulescu <ruxandra.radulescu@nxp.com>
Subject: Re: [PATCH] dpaa2-ethsw: move the DPAA2 Ethernet Switch driver out
 of staging
Message-ID: <20190812140311.GM14290@lunn.ch>
References: <1565366213-20063-1-git-send-email-ioana.ciornei@nxp.com>
 <20190809190459.GW27917@lunn.ch>
 <VI1PR0402MB2800FF2E5C4DE24B25E7D843E0D10@VI1PR0402MB2800.eurprd04.prod.outlook.com>
 <20190811032235.GK30120@lunn.ch>
 <VI1PR0402MB2800292DCA9CC91085E5033FE0D00@VI1PR0402MB2800.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR0402MB2800292DCA9CC91085E5033FE0D00@VI1PR0402MB2800.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >> Yes, we only support a single bridge.
> > 
> > That is a pretty severe restriction for a device of this class. Some
> > of the very simple switches DSA support have a similar restriction,
> > but in general, most do support multiple bridges.
> > 
> 
> Let me make a distinction here: we do no support multiple bridges on the 
> same DPSW object but we do support multiple DPSW objects, each with its 
> bridge.
> 
> 
> > Are there any plans to fix this?
> > 
> 
> We had some internal discussions on this, the hardware could support 
> this kind of further partitioning the switch object but, at the moment, 
> the firmware doesn't.

I assume the firmware allows you to create switch objects on the fly?

I think this was discussed a long time ago, but why not create a new
switch object when you need it? That seems like the whole point of
this dynamic hardware design of dpaa2.

     Andrew
