Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EE633125DC1
	for <lists+netdev@lfdr.de>; Thu, 19 Dec 2019 10:35:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726751AbfLSJfO convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 19 Dec 2019 04:35:14 -0500
Received: from mx2.suse.de ([195.135.220.15]:37362 "EHLO mx2.suse.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726618AbfLSJfO (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Dec 2019 04:35:14 -0500
X-Virus-Scanned: by amavisd-new at test-mx.suse.de
Received: from relay2.suse.de (unknown [195.135.220.254])
        by mx2.suse.de (Postfix) with ESMTP id 92CC7AF8C;
        Thu, 19 Dec 2019 09:35:11 +0000 (UTC)
Date:   Thu, 19 Dec 2019 10:35:10 +0100
From:   Thomas Bogendoerfer <tbogendoerfer@suse.de>
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Ralf Baechle <ralf@linux-mips.org>,
        Paul Burton <paulburton@kernel.org>,
        James Hogan <jhogan@kernel.org>,
        Lee Jones <lee.jones@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.com>, linux-mips@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>, linux-rtc@vger.kernel.org,
        "open list:SERIAL DRIVERS" <linux-serial@vger.kernel.org>
Subject: Re: [PATCH v11 net-next 2/2] mfd: ioc3: Add driver for SGI IOC3
 chip
Message-Id: <20191219103510.9f6e41b3a9339533e245ea53@suse.de>
In-Reply-To: <CACRpkdY+2Z90n6zNZbQpmGCWYAH4PzEOv8puOkwbrcxCk_Eq2A@mail.gmail.com>
References: <20191213124221.25775-1-tbogendoerfer@suse.de>
        <20191213124221.25775-3-tbogendoerfer@suse.de>
        <CACRpkdY+2Z90n6zNZbQpmGCWYAH4PzEOv8puOkwbrcxCk_Eq2A@mail.gmail.com>
X-Mailer: Sylpheed 3.5.1 (GTK+ 2.24.32; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Dec 2019 09:28:42 +0100
Linus Walleij <linus.walleij@linaro.org> wrote:

> On Fri, Dec 13, 2019 at 1:43 PM Thomas Bogendoerfer
> <tbogendoerfer@suse.de> wrote:
> 
> > SGI IOC3 chip has integrated ethernet, keyboard and mouse interface.
> > It also supports connecting a SuperIO chip for serial and parallel
> > interfaces. IOC3 is used inside various SGI systemboards and add-on
> > cards with different equipped external interfaces.
> >
> > Support for ethernet and serial interfaces were implemented inside
> > the network driver. This patchset moves out the not network related
> > parts to a new MFD driver, which takes care of card detection,
> > setup of platform devices and interrupt distribution for the subdevices.
> >
> > Serial portion: Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Acked-for-MFD-by: Lee Jones <lee.jones@linaro.org>
> >
> > Signed-off-by: Thomas Bogendoerfer <tbogendoerfer@suse.de>
> 
> This makes the kernel a better place:
> Acked-by: Linus Walleij <linus.walleij@linaro.org>

Thank you.

> Will there be a GPIO driver arriving later?

as far as I found out, GPIOs are used as reset line for the ethernet phy
and for two leds in the SGI Octanes. So far I've never needed the phy reset
and since there are exclusive registers per GPIO I'm using these registers
directly in the coming LED driver.

Thomas.

-- 
SUSE Software Solutions Germany GmbH
HRB 36809 (AG Nürnberg)
Geschäftsführer: Felix Imendörffer
