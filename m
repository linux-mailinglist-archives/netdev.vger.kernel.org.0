Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E0F4BF3397
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 16:42:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729617AbfKGPmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 10:42:04 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:54520 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726231AbfKGPmD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 10:42:03 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=xxmqV9GxolyS940GPt0JvlXk4Ow9bakhZ28hd3PPswg=; b=Ko5qbR6CYvZW/GFOu7TAd2TluQ
        z8S6cLwOh5sZqzjXnd4LfDBdSn5nagCYIhdwBQ6xm90RDKddgtK2bPAg7bbcunqRKbB5N1jpkE0Pj
        +tGHoS3y4RRFoJvgrORDsraXU5tAb7pYjffJb7/ZGqbE7OYu105DTPkUOtgIZidM7mRE=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iSjv7-0006oZ-9G; Thu, 07 Nov 2019 16:42:01 +0100
Date:   Thu, 7 Nov 2019 16:42:01 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>
Cc:     netdev@vger.kernel.org, Tristram.Ha@microchip.com,
        UNGLinuxDriver@microchip.com, kernel@pengutronix.de
Subject: Re: [PATCH v1 1/4] mdio-bitbang: add SMI0 mode support
Message-ID: <20191107154201.GF7344@lunn.ch>
References: <20191107110030.25199-1-m.grzeschik@pengutronix.de>
 <20191107110030.25199-2-m.grzeschik@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107110030.25199-2-m.grzeschik@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 07, 2019 at 12:00:27PM +0100, Michael Grzeschik wrote:
> Some microchip phys support the Serial Management Interface Protocol
> (SMI) for the configuration of the extended register set. We add
> MII_ADDR_SMI0 as an available interface to the mdiobb write and read
> functions, as this interface can be easy realized using the bitbang mdio
> driver.
> 
> Signed-off-by: Sam Ravnborg <sam@ravnborg.org>
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Hi Michael

I don't like adding vendor proprietary stuff to generic code like
this. Please could you see if you can make use of mdiobb_ops in some
way? Move all this junk out into a mdio-kzs88x3.c?

Thanks
	Andrew
