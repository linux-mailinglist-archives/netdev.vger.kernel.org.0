Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB6C920405E
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 21:29:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728622AbgFVT3d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 15:29:33 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54096 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728578AbgFVT3b (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 15:29:31 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jnS8F-001iLy-ND; Mon, 22 Jun 2020 21:29:27 +0200
Date:   Mon, 22 Jun 2020 21:29:27 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Mack <daniel@zonque.org>
Cc:     Russell King - ARM Linux admin <linux@armlinux.org.uk>,
        netdev@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com
Subject: Re: [PATCH] net: dsa: mv88e6xxx: Allow MAC configuration for ports
 with internal PHY
Message-ID: <20200622192927.GH405672@lunn.ch>
References: <20200622183443.3355240-1-daniel@zonque.org>
 <20200622184115.GE405672@lunn.ch>
 <b8a67f7d-9854-9854-3f53-983dd4eb8fda@zonque.org>
 <20200622185837.GN1551@shell.armlinux.org.uk>
 <bb89fbef-bde7-2a7f-9089-bbe86323dd63@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bb89fbef-bde7-2a7f-9089-bbe86323dd63@zonque.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> To recap, my setup features a Cadence GEM that is connected to a 88E1510
> PHY which is then connected to port 4 of the switch (which has an
> internal PHY) through a transformer-less link. I know this is not
> optimal as the speed is limited to 100M by that, but that was the only
> way as all other ports where used up.

This is the important bit you failed to mention. Given the number of
patches on netdev, you should assume anything older than three days
has been forgotten.

Back to Back PHYs for the CPU port has never really been supported.
It does however work if the PHYs are 1G and there are a few boards out
there like this, with their owns having crossed fingers this never
breaks. Because it is not really supported.

I guess you need to work out why PPU is not working for you. I would
not be too surprised if it is because it is the CPU port, it is not
supposed to have a PHY, so it is not enabled.

	 Andrew
