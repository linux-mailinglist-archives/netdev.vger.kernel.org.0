Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5B2B2285FF0
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 15:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbgJGNUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 09:20:11 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:47980 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728403AbgJGNUL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Oct 2020 09:20:11 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1kQ9MQ-000XUT-KW; Wed, 07 Oct 2020 15:20:02 +0200
Date:   Wed, 7 Oct 2020 15:20:02 +0200
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
Message-ID: <20201007132002.GG56634@lunn.ch>
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
> 
> Signed-off-by: Christian Eggers <ceggers@arri.de>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
