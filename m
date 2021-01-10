Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335732F0871
	for <lists+netdev@lfdr.de>; Sun, 10 Jan 2021 17:50:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726415AbhAJQuh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 Jan 2021 11:50:37 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:59924 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726080AbhAJQug (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 Jan 2021 11:50:36 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kyduc-00HL1k-Og; Sun, 10 Jan 2021 17:49:54 +0100
Date:   Sun, 10 Jan 2021 17:49:54 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Russell King <rmk+kernel@armlinux.org.uk>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH net-next] net: sfp: extend bitrate-derived mode for
 2500BASE-X
Message-ID: <X/swMh8TcD/l176c@lunn.ch>
References: <E1kyYQf-0004iY-Gh@rmk-PC.armlinux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <E1kyYQf-0004iY-Gh@rmk-PC.armlinux.org.uk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jan 10, 2021 at 10:58:37AM +0000, Russell King wrote:
> Extend the bitrate-derived support to include 2500BASE-X for modules
> that report a bitrate of 2500Mbaud.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
