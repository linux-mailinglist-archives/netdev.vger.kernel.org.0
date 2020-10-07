Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 14D2D285F01
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 14:21:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728282AbgJGMVW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 08:21:22 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47856 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727927AbgJGMVV (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 08:21:21 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kQ8RP-000WzQ-RP; Wed, 07 Oct 2020 14:21:07 +0200
Date:   Wed, 7 Oct 2020 14:21:07 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Christian Eggers <ceggers@arri.de>
Cc:     Woojung Huh <woojung.huh@microchip.com>,
        Microchip Linux Driver Support <UNGLinuxDriver@microchip.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: microchip: add ksz9563 to ksz9477 I2C
 driver
Message-ID: <20201007122107.GA112961@lunn.ch>
References: <20201007093049.13078-1-ceggers@arri.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201007093049.13078-1-ceggers@arri.de>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 07, 2020 at 11:30:49AM +0200, Christian Eggers wrote:
> Add support for the KSZ9563 3-Port Gigabit Ethernet Switch to the
> ksz9477 driver. The KSZ9563 supports both SPI (already in) and I2C. The
> ksz9563 is already in the device tree binding documentation.

Hi Christian

What chip_id values does it use? I don't see it listed in
ksz9477_switch_chips.

Thanks
	Andrew
