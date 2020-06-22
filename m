Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 23E42203F5A
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 20:41:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730435AbgFVSlR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 14:41:17 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53974 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729605AbgFVSlR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 14:41:17 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jnRNb-001hrx-Gm; Mon, 22 Jun 2020 20:41:15 +0200
Date:   Mon, 22 Jun 2020 20:41:15 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Mack <daniel@zonque.org>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, linux@armlinux.org.uk
Subject: Re: [PATCH] net: dsa: mv88e6xxx: Allow MAC configuration for ports
 with internal PHY
Message-ID: <20200622184115.GE405672@lunn.ch>
References: <20200622183443.3355240-1-daniel@zonque.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200622183443.3355240-1-daniel@zonque.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 08:34:43PM +0200, Daniel Mack wrote:
> Ports with internal PHYs that are not in 'fixed-link' mode are currently
> only set up once at startup with a static config. Attempts to change the
> link speed or duplex settings are currently prevented by an early bail
> in mv88e6xxx_mac_config(). As the default config forces the speed to
> 1000M, setups with reduced link speed on such ports are unsupported.

Hi Daniel

How are you trying to change the speed?

Thanks
	Andrew
