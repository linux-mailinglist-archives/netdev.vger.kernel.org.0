Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E702F7D524
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 07:58:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729583AbfHAF6o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 01:58:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51182 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726783AbfHAF6n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Aug 2019 01:58:43 -0400
Received: from localhost (83-86-89-107.cable.dynamic.v4.ziggo.nl [83.86.89.107])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 1EA8B206A2;
        Thu,  1 Aug 2019 05:58:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1564639122;
        bh=bCQN5YRJ9WbxismztYDQbIiyurSCBavugzJYk9d8DX0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=enf8FkC8RBuclKflB0dMufb2Gfm5EXll3mPHHzF837c+6LpHKjurVx2UeVGVHZszY
         aNNXlIC67rCD1PBKZCD+uBmh3ccQSJ2eOk+yaQOWDyg647IMGeGUibPIfFoEBZBw+i
         L/MHEj90iRd151oJfqbo18Lbk9ANBxAVqdRD5FuI=
Date:   Thu, 1 Aug 2019 07:58:40 +0200
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Arnd Bergmann <arnd@arndb.de>
Cc:     soc@kernel.org, linux-arm-kernel@lists.infradead.org,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jiri Slaby <jslaby@suse.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Guenter Roeck <linux@roeck-us.net>, linux-gpio@vger.kernel.org,
        netdev@vger.kernel.org, linux-serial@vger.kernel.org,
        linux-usb@vger.kernel.org, linux-watchdog@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 04/14] serial: lpc32xx_hs: allow compile-testing
Message-ID: <20190801055840.GC24607@kroah.com>
References: <20190731195713.3150463-1-arnd@arndb.de>
 <20190731195713.3150463-5-arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190731195713.3150463-5-arnd@arndb.de>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 09:56:46PM +0200, Arnd Bergmann wrote:
> The only thing that prevents building this driver on other
> platforms is the mach/hardware.h include, which is not actually
> used here at all, so remove the line and allow CONFIG_COMPILE_TEST.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> ---
>  drivers/tty/serial/Kconfig      | 3 ++-
>  drivers/tty/serial/lpc32xx_hs.c | 2 --
>  2 files changed, 2 insertions(+), 3 deletions(-)

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
