Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6D2011FFE4E
	for <lists+netdev@lfdr.de>; Fri, 19 Jun 2020 00:49:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730861AbgFRWs7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Jun 2020 18:48:59 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47860 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728484AbgFRWs6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Jun 2020 18:48:58 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1jm3L5-001BYP-1J; Fri, 19 Jun 2020 00:48:55 +0200
Date:   Fri, 19 Jun 2020 00:48:55 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     rentao.bupt@gmail.com
Cc:     Florian Fainelli <f.fainelli@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Rob Herring <robh+dt@kernel.org>,
        Frank Rowand <frowand.list@gmail.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        openbmc@lists.ozlabs.org, taoren@fb.com
Subject: Re: [PATCH net-next] of: mdio: preserve phy dev_flags in
 of_phy_connect()
Message-ID: <20200618224855.GF279339@lunn.ch>
References: <20200618220444.5064-1-rentao.bupt@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200618220444.5064-1-rentao.bupt@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 18, 2020 at 03:04:44PM -0700, rentao.bupt@gmail.com wrote:
> From: Tao Ren <rentao.bupt@gmail.com>
> 
> Replace assignment "=" with OR "|=" for "phy->dev_flags" so "dev_flags"
> configured in phy probe() function can be preserved.
> 
> The idea is similar to commit e7312efbd5de ("net: phy: modify assignment
> to OR for dev_flags in phy_attach_direct").
> 
> Signed-off-by: Tao Ren <rentao.bupt@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
