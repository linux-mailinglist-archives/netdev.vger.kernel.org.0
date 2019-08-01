Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C96E37D52B
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 07:59:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729292AbfHAF7J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 01:59:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:51412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725804AbfHAF7J (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 01:59:09 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 65BE2206A2;
        Thu,  1 Aug 2019 05:59:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564639148;
        bh=7BxA1dkTb2aGHMGDFxjJqWn0Px1o18m+epr8o6ediEs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Ia9p6X0H5Gl724ivQ6InCtcROAEFe8rQVFaNOvVlq5Rh882/tha4kHGaeDXQjwprA
         eZDwMIAXb/VUsYV132SJ2N7N/VRdKwBfE+UTEWWt8varYy8gV1JcvGWclfkmx6iU/4
         N6oPuU82l/c8qVTzrHI0kmAiVPJ5Ek6s3dj+ApoA=
Date:   Thu, 1 Aug 2019 07:59:06 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     soc@kernel.org, linux-arm-kernel@lists.infradead.org,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Guenter Roeck <linux@roeck-us.net>, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        Jiri Slaby <jslaby@suse.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 09/14] serial: lpc32xx: allow compile testing
Message-ID: <20190801055906.GD24607@kroah.com>
References: <20190731195713.3150463-1-arnd@arndb.de>
 <20190731195713.3150463-10-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731195713.3150463-10-arnd@arndb.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 09:56:51PM +0200, Arnd Bergmann wrote:
> The lpc32xx_loopback_set() function in hte lpc32xx_hs driver is the
> one thing that relies on platform header files. Move that into the
> core platform code so we only need a variable declaration for it,
> and enable COMPILE_TEST building.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  arch/arm/mach-lpc32xx/serial.c       | 30 ++++++++++++++++++++++++
>  drivers/tty/serial/lpc32xx_hs.c      | 35 ++++------------------------
>  include/linux/soc/nxp/lpc32xx-misc.h |  4 ++++
>  3 files changed, 38 insertions(+), 31 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
