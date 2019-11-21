Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 958971048A9
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 03:43:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726765AbfKUCnE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Nov 2019 21:43:04 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:48882 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725819AbfKUCnE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Nov 2019 21:43:04 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3Ae3+l32ocPx/5mjv/9zXJ5d0VGuPTWO3G/zxBrhpo0=; b=rB8NP1RmM5laJg3FpQ+OXJzwRM
        KnnRKEhbAdz7javAGAjR1rE3fJ8qv2AISGaxvJBi6ayRbkjFMv7vvVBZ6LIGj8TFv4+W2xUu4h10U
        uLv/na3kiT4+gD4M2CPg7OLXAB/wYhepdLnY+B4MuP4ULLHpn5xv+9/YQyoEL5D96t7A=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iXcQv-00079j-6c; Thu, 21 Nov 2019 03:43:01 +0100
Date:   Thu, 21 Nov 2019 03:43:01 +0100
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
Subject: Re: [PATCH 3/5] net: mscc: ocelot: convert to use
 ocelot_port_add_txtstamp_skb()
Message-ID: <20191121024301.GM18325@lunn.ch>
References: <20191120082318.3909-1-yangbo.lu@nxp.com>
 <20191120082318.3909-4-yangbo.lu@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191120082318.3909-4-yangbo.lu@nxp.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Nov 20, 2019 at 04:23:16PM +0800, Yangbo Lu wrote:
> Convert to use ocelot_port_add_txtstamp_skb() for adding skbs which
> require TX timestamp into list. Export it so that DSA Felix driver
> could reuse it too.
> 
> Signed-off-by: Yangbo Lu <yangbo.lu@nxp.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
