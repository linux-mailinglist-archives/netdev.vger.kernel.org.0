Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6D4CC892B2
	for <lists+netdev@lfdr.de>; Sun, 11 Aug 2019 18:51:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726053AbfHKQvL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 11 Aug 2019 12:51:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51350 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725870AbfHKQvL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 11 Aug 2019 12:51:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=IJ/2YbIXEYc513IBNKIdIOt+IolKh9GpuJxI2GwtnRE=; b=wnar0mvST+7qIwCLfQmPjsqNz1
        osKoKqNpjYe/GVLITgw+Rhb6lJXyTBpS7y96NHtceTUrfmrFI64go6YjR+p8upQDemsa8nbNJ27WJ
        RgMUAmeU4kUmOciU3AwgNnqJYpUdSkFrIK0oSF94tUFpT+oRDOeKJ7ZD7NB7UohyTw1Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hwr3k-0004Jw-28; Sun, 11 Aug 2019 18:51:08 +0200
Date:   Sun, 11 Aug 2019 18:51:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Marek Behun <marek.behun@nic.cz>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Sebastian Reichel <sebastian.reichel@collabora.co.uk>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 1/2] net: dsa: mv88e6xxx: fix RGMII-ID port setup
Message-ID: <20190811165108.GG14290@lunn.ch>
References: <20190811150812.6780-1-marek.behun@nic.cz>
 <20190811153153.GB14290@lunn.ch>
 <20190811181445.71048d2c@nic.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190811181445.71048d2c@nic.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> what if we added a phy_mode member to struct mv88e6xxx_port, and either
> set it to PHY_INTERFACE_MODE_NA in mv88e6xxx_setup, or implemented
> methods for converting the switch register values to
> PHY_INTERFACE_MODE_* values.

We should read the switch registers. I think you can set the defaults
using strapping pins. And in general, the driver always reads state
from the hardware rather than caching it.

     Andrew
