Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8AA402C5875
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 16:47:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391323AbgKZPrS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 10:47:18 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:51562 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730602AbgKZPrS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 26 Nov 2020 10:47:18 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kiJUK-008zmR-GD; Thu, 26 Nov 2020 16:47:16 +0100
Date:   Thu, 26 Nov 2020 16:47:16 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     netdev@vger.kernel.org, Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>
Subject: Re: Get MAC supported link modes for SFP port
Message-ID: <20201126154716.GN2073444@lunn.ch>
References: <87pn40uo25.fsf@tarshish>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87pn40uo25.fsf@tarshish>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 26, 2020 at 05:37:22PM +0200, Baruch Siach wrote:
> Hi netdev list,
> 
> I am trying to retrieve all MAC supported link modes
> (ETHTOOL_LINK_MODE_*) for network interfaces with SFP port. The
> 'supported' bit mask that ETHTOOL_GLINKSETTINGS provides in
> link_mode_masks[] changes to match the SFP module that happens to be
> plugged in. When no SFP module is plugged, the bit mask looks
> meaningless.

That sounds like it is doing the correct thing.

> I understand that ETHTOOL_LINK_MODE_* bits are meant to describe PHY
> level capabilities. So I would settle for a MAC level "supported rates"
> list.

What is your use cases?

A MAC without some form a PHY, be it copper, fibre, or a faked
fixed-link, is useless. You need the combination of what the MAC can
do and what the PHY can do to have any meaning information.

       Andrew
