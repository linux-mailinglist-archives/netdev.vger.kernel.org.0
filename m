Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 42E181BAA2A
	for <lists+netdev@lfdr.de>; Mon, 27 Apr 2020 18:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728260AbgD0QhH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Apr 2020 12:37:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:38752 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727084AbgD0QhG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 27 Apr 2020 12:37:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=EXDgFlIQg95FpO1rp1eJS6vNX5VTmSzpmKbz12aQB9E=; b=sQ84kiHGWeh+4Iwn+g/GNJ6fnl
        3kiqVR0H54Ir4YMXPYl4GXgnZYvRZzFM7euWvbjFWsbrEGxj+Rq/61SSv+xQ4IxjlFQmatyGBbXJC
        4yzjBKPOhhYT/HUOr2M5jvMIgJHvTY3D8d+WgxxQQQ9RRhkDjWhgaGH93rihQAzdRFm8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jT6kh-005FKH-Id; Mon, 27 Apr 2020 18:37:03 +0200
Date:   Mon, 27 Apr 2020 18:37:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Leonard Crestez <leonard.crestez@nxp.com>
Cc:     Andy Duan <fugang.duan@nxp.com>,
        David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Chris Healy <Chris.Healy@zii.aero>,
        dl-linux-imx <linux-imx@nxp.com>
Subject: Re: [PATCH] net: ethernet: fec: Replace interrupt driven MDIO with
 polled IO
Message-ID: <20200427163703.GC1250287@lunn.ch>
References: <20200414004551.607503-1-andrew@lunn.ch>
 <VI1PR04MB6941D611F6EF67BB42826D4EEEAF0@VI1PR04MB6941.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <VI1PR04MB6941D611F6EF67BB42826D4EEEAF0@VI1PR04MB6941.eurprd04.prod.outlook.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 27, 2020 at 03:19:54PM +0000, Leonard Crestez wrote:

Hi Leanard

> GOOD:
> [    9.100485] mdio_access: 30be0000.ethernet-1 read  phy:0x00 reg:0x02 
> val:0x004d
> [    9.108271] mdio_access: 30be0000.ethernet-1 read  phy:0x00 reg:0x03 
> val:0xd074

You PHY is an ATH8031? If i'm reading these IDs correctly?

Thanks
	Andrew
