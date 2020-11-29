Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653862C7A28
	for <lists+netdev@lfdr.de>; Sun, 29 Nov 2020 18:09:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727482AbgK2RIG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Nov 2020 12:08:06 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:55484 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725830AbgK2RIF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 29 Nov 2020 12:08:05 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kjQAU-009NIn-Bf; Sun, 29 Nov 2020 18:07:22 +0100
Date:   Sun, 29 Nov 2020 18:07:22 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jean Pihet <jean.pihet@newoldbits.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Ryan Barnett <ryan.barnett@rockwellcollins.com>,
        Conrad Ratschan <conrad.ratschan@rockwellcollins.com>,
        Hugo Cornelis <hugo.cornelis@essensium.com>,
        Arnout Vandecappelle <arnout.vandecappelle@essensium.com>
Subject: Re: [PATCH 2/2] net: dsa: ksz8795: adjust CPU link to host interface
Message-ID: <20201129170722.GC2234159@lunn.ch>
References: <20201129102400.157786-1-jean.pihet@newoldbits.com>
 <20201129102400.157786-2-jean.pihet@newoldbits.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201129102400.157786-2-jean.pihet@newoldbits.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 29, 2020 at 11:24:00AM +0100, Jean Pihet wrote:
> Add support for RGMII in 100 and 1000 Mbps.
> 
> Adjust the CPU port based on the host interface settings: interface
> MII type, speed, duplex.

Please could you add some extra information here why this is needed. I
suspect you have back to back PHYs on the CPU port?

> +void ksz8795_adjust_link(struct dsa_switch *ds, int port,
> +						 struct phy_device *phydev)
> +{
> +	struct ksz_device *dev = ds->priv;
> +	struct ksz_port *p = &dev->ports[port];
> +
> +	/* Adjust the link interface mode and speed for the CPU port */
> +	if (port == dev->cpu_port)

dsa_is_cpu_port(ds, port)

		    Andrew
