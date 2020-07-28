Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6CE072311DE
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 20:41:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732403AbgG1Slp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 14:41:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60420 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729448AbgG1Slp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 Jul 2020 14:41:45 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1k0UXm-007K23-Mq; Tue, 28 Jul 2020 20:41:42 +0200
Date:   Tue, 28 Jul 2020 20:41:42 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Bruno Thomsen <bruno.thomsen@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Fabio Estevam <festevam@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Russell King - ARM Linux <linux@armlinux.org.uk>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Lars Alex Pedersen <laa@kamstrup.com>,
        Bruno Thomsen <bth@kamstrup.com>
Subject: Re: [PATCH 1/2] net: mdiobus: reset deassert delay
Message-ID: <20200728184142.GA1745134@lunn.ch>
References: <20200728090203.17313-1-bruno.thomsen@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200728090203.17313-1-bruno.thomsen@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 28, 2020 at 11:02:02AM +0200, Bruno Thomsen wrote:
> The current reset logic only has a delay during assert.
> This reuses the delay value as deassert delay to ensure
> PHYs are ready for commands. Delays are typically needed
> when external hardware slows down reset release with a
> RC network. This solution does not need any new device
> tree bindings.
> It also improves handling of long delays (>20ms) by using
> the generic fsleep() for selecting appropriate delay
> function.
> 
> Signed-off-by: Bruno Thomsen <bruno.thomsen@gmail.com>

Hi Bruno

In netdev, it is normal to include a [patch 0/2] for a patchset which
explains the big picture. Also, please use [patch net-next ..] to
indicate this is for the net-next tree. If you think these are fixes
for stable, please base them on net, and use [patch net ..], and
include Fixes: tags.

    Andrew
