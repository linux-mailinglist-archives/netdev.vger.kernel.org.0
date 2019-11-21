Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D36421048A1
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 03:41:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726265AbfKUClq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 21:41:46 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48868 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725842AbfKUClq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 21:41:46 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=1+l8TVKqe32YfHdkD7sq/2YUT1lS5WcZqS7yW1fZvhw=; b=Mrh+D09MXJO57rNynqmQ9pZAQ1
        sfxQV7EXQDf6jmfuSFhDJwkLKR9Ckfl0+EuxS0YlP+2PavhgFgdtjNuPrFtfETvzrWS1fctMlUcB/
        GL/Zxp4GFmQeMzyHrZ1jyD4dA/UAa6W+cdafygbcKsgnB9muhMDuOJjYKEn2jvHw1LFc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iXcPf-00078z-KA; Thu, 21 Nov 2019 03:41:43 +0100
Date:   Thu, 21 Nov 2019 03:41:43 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Yangbo Lu <yangbo.lu@nxp.com>
Cc:     netdev@vger.kernel.org,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        "David S . Miller" <davem@davemloft.net>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>
Subject: Re: [PATCH 2/5] net: mscc: ocelot: convert to use
 ocelot_get_txtstamp()
Message-ID: <20191121024143.GL18325@lunn.ch>
References: <20191120082318.3909-1-yangbo.lu@nxp.com>
 <20191120082318.3909-3-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120082318.3909-3-yangbo.lu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 04:23:15PM +0800, Yangbo Lu wrote:
> The method getting TX timestamp by reading timestamp FIFO and
> matching skbs list is common for DSA Felix driver too.
> So move code out of ocelot_board.c, convert to use
> ocelot_get_txtstamp() function and export it.
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
