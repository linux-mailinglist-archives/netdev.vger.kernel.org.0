Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 786A31056DD
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 17:21:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726881AbfKUQVX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 11:21:23 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49956 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726690AbfKUQVW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 Nov 2019 11:21:22 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3pIki6C84ovYY9R1F02y29fR6d/hbyFJmQZDnip3xUY=; b=wQbc2GHlYkrBsAHbKiAW16v8ed
        0b0bt2jH+0cx59xFKQhGaaousfOtDyhKWkcW72RdHTh48XGpJw4HbB5ehQ4NM2PZekn4lddy8RTyi
        UNdNJytJoCg81cSY9rFlZ+56DsI30OaYD7KZqXe3o7cDiVGNdm5IVyPBp/NB98oJvTEg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iXpCj-0001NR-LP; Thu, 21 Nov 2019 17:21:13 +0100
Date:   Thu, 21 Nov 2019 17:21:13 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next v2] net: sfp: soft status and control support
Message-ID: <20191121162113.GL19542@lunn.ch>
References: <E1iXP7P-0006DS-47@rmk-PC.armlinux.org.uk>
 <DB6PR0402MB27891CA467D04389FA68B0CFE04E0@DB6PR0402MB2789.eurprd04.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <DB6PR0402MB27891CA467D04389FA68B0CFE04E0@DB6PR0402MB2789.eurprd04.prod.outlook.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 21, 2019 at 03:51:07PM +0000, Ioana Ciornei wrote:
> > Subject: [PATCH net-next v2] net: sfp: soft status and control support
> > 
> > Add support for the soft status and control register, which allows TX_FAULT
> > and RX_LOS to be monitored and TX_DISABLE to be set.  We make use of this
> > when the board does not support GPIOs for these signals.
> 
> Hi Russell,
> 
> With this addition, shouldn't the following print be removed?
> 
> [    2.967583] sfp sfp-mac4: No tx_disable pin: SFP modules will always be emitting.

Hi Ioana

Does the SFP you are using actually support soft status?

     Andrew
