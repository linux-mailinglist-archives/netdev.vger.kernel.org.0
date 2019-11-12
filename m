Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7548FF90D1
	for <lists+netdev@lfdr.de>; Tue, 12 Nov 2019 14:40:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726988AbfKLNkE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Nov 2019 08:40:04 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:35794 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725834AbfKLNkD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Nov 2019 08:40:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=+0Avpo0Teljf4aILNt6r5Ct7lDNz2RJsnXEKtoXIj7U=; b=21m3PFgC3HCdhM61OLLNeFge7p
        tC+A9QpFC28GTJlrLCpMB/+GkHC36EwdBdURNHw9sbJiF0SErQJfYr7J7OnU1YraQEKOv0TlDweDz
        ZC0W/BMrGxhYGmj6vLbuMLxIuA2PCvf5SXIZCFFyHgZYK6WxWbGu3l1Zzh5t0H69dENg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iUWOl-0001cd-K2; Tue, 12 Nov 2019 14:39:59 +0100
Date:   Tue, 12 Nov 2019 14:39:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, horatiu.vultur@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 04/12] net: mscc: ocelot: create a helper for
 changing the port MTU
Message-ID: <20191112133959.GF5090@lunn.ch>
References: <20191112124420.6225-1-olteanv@gmail.com>
 <20191112124420.6225-5-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191112124420.6225-5-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 12, 2019 at 02:44:12PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Since in an NPI/DSA setup, not all ports will have the same MTU

By this, do you mean that the CPU port needs a bigger MTU because of
the extra header?

    Andrew
