Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADD5F6A12
	for <lists+netdev@lfdr.de>; Sun, 10 Nov 2019 17:26:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726888AbfKJQ0I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Nov 2019 11:26:08 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59068 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726710AbfKJQ0I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Nov 2019 11:26:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gnlZ7Nrh8b9VQD8LwAHrmLrhng6BLht73/N3JunucT0=; b=kQE0u/oVwV6bP6ARlg65SDf8hv
        mBnQdd3EOVopeISMZrneiZMoLEG3O8Sre/R3BJW791AAtHfdelSOUZoTBuozMS1Y9GrzGUA3CJ2qc
        YPRQVC5qXlAuniYPZliTPuWv2hDdR/qBG5KP7OyRNv9iniOKlaJaZWQ0TI8FBCA4PkyI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iTq2J-0006qo-GL; Sun, 10 Nov 2019 17:25:59 +0100
Date:   Sun, 10 Nov 2019 17:25:59 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     jakub.kicinski@netronome.com, davem@davemloft.net,
        alexandre.belloni@bootlin.com, f.fainelli@gmail.com,
        vivien.didelot@gmail.com, joergen.andreasen@microchip.com,
        allan.nielsen@microchip.com, horatiu.vultur@microchip.com,
        claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Subject: Re: [PATCH net-next 09/15] net: mscc: ocelot: limit vlan ingress
 filtering to actual number of ports
Message-ID: <20191110162559.GD25889@lunn.ch>
References: <20191109130301.13716-1-olteanv@gmail.com>
 <20191109130301.13716-10-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191109130301.13716-10-olteanv@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Nov 09, 2019 at 03:02:55PM +0200, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The VSC7514 switch (Ocelot) is a 10-port device, while VSC9959 (Felix)
> is 6-port. Therefore the VLAN filtering mask would be out of bounds when
> calling for this new switch. Fix that.

Hi Vladimir

Is this a real fix? Should it be posted to net?

Thanks
	Andrew
