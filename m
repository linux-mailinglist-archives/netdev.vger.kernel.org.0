Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E10DF12D89
	for <lists+netdev@lfdr.de>; Fri,  3 May 2019 14:29:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727817AbfECM3X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 May 2019 08:29:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53282 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727523AbfECM3X (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 May 2019 08:29:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=R6e6QMt4Ry7Ciu1Kvg2pPK4dklAxRHwK6AKu5GkzKCU=; b=ojHPNQP/rDkJLkCCTKgFGjvMMp
        r6BF6jbtmMUYw+qiHA0GQKTDkj7yRabYDhGOxREUrQvokSpX5Fr9BZuLGdhV9PdpZu6+2NsWx4g4e
        WTiMK3Oj/AdU5d72l0unGGETlh4mur5J7qreOrsikuz7n9WilhtXjLOarDv5jd1mb2Uc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hMXJO-0001AD-GE; Fri, 03 May 2019 14:29:10 +0200
Date:   Fri, 3 May 2019 14:29:10 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Nicolas Ferre <nicolas.ferre@microchip.com>
Cc:     Claudiu Beznea <claudiu.beznea@microchip.com>,
        linux-arm-kernel@lists.infradead.org,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        harini.katakam@xilinx.com,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        linux-kernel@vger.kernel.org, michal.simek@xilinx.com
Subject: Re: [PATCH] net: macb: remove redundant struct phy_device declaration
Message-ID: <20190503122910.GB1941@lunn.ch>
References: <20190503103628.17160-1-nicolas.ferre@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190503103628.17160-1-nicolas.ferre@microchip.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 03, 2019 at 12:36:28PM +0200, Nicolas Ferre wrote:
> While moving the chunk of code during 739de9a1563a
> ("net: macb: Reorganize macb_mii bringup"), the declaration of
> struct phy_device declaration was kept. It's not useful in this
> function as we alrady have a phydev pointer.
> 
> Signed-off-by: Nicolas Ferre <nicolas.ferre@microchip.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
