Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7C457CE45
	for <lists+netdev@lfdr.de>; Wed, 31 Jul 2019 22:27:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730510AbfGaU0x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Jul 2019 16:26:53 -0400
Received: from mail-qt1-f194.google.com ([209.85.160.194]:37360 "EHLO
        mail-qt1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728136AbfGaU0x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Jul 2019 16:26:53 -0400
Received: by mail-qt1-f194.google.com with SMTP id y26so67873946qto.4;
        Wed, 31 Jul 2019 13:26:52 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nexwj/gyEdfGcFhtgJkuEvqAxLsbVQicvOBgvCJpGfM=;
        b=D9jgJbYsefhU1bp4dHus8py68/b5IqFtti2ZA0IWtdNeTXXzgHoSvZgwyATaRbMo1I
         Y2ZCvsQkNKiv3MfwEoO16AvmHiVqDynglfC0pMvczN8idqyL5Mue63+1gp7WH8Ey6Zl5
         q4otDS5gwreCRXddS9examugoB0OmqicTmHXCzevjo/B0Z4WIaAQvRK0HHiWWSKDv73h
         SJNPXEYWiUALSViuZZDV6klbePjHei9zkLbp/WMrrRTy1DJyXpb4s8CuT0xBMAgxVSWJ
         I2H6gKlCtVeQZYR2tKUDWHpUvstIUcQNUuXHWepTCde40wxp4JGtVGFZ0yiepChrzfAm
         y4ww==
X-Gm-Message-State: APjAAAXxEtv4W0WR0m/laJUHCGRRHEsNz2JcwmRfQqSc+67bMUvLcr9w
        YNYoizlbjZMkCq1Q4gfVD8Z0/nUP5Rd4r7OdTvQ=
X-Google-Smtp-Source: APXvYqxrQwILyzcU6or5m1F0P2T2g+2d1hVZgeveWHo/LNI028WFf469HVX7i9p/CxTB96w3vHftaMn2P+OT3OV3MzY=
X-Received: by 2002:aed:33a4:: with SMTP id v33mr84957899qtd.18.1564604812113;
 Wed, 31 Jul 2019 13:26:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190731195713.3150463-1-arnd@arndb.de> <20190731195713.3150463-4-arnd@arndb.de>
 <20190731202343.GA14817@roeck-us.net>
In-Reply-To: <20190731202343.GA14817@roeck-us.net>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Wed, 31 Jul 2019 22:26:35 +0200
Message-ID: <CAK8P3a2=gqeCMtdzdqg4d1n6v1-cdaHObeUoVXeB+=Okwd1rqA@mail.gmail.com>
Subject: Re: [PATCH 03/14] watchdog: pnx4008_wdt: allow compile-testing
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     soc@kernel.org, Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-serial@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
        LINUXWATCHDOG <linux-watchdog@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 31, 2019 at 10:23 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On Wed, Jul 31, 2019 at 09:56:45PM +0200, Arnd Bergmann wrote:
> > The only thing that prevents building this driver on other
> > platforms is the mach/hardware.h include, which is not actually
> > used here at all, so remove the line and allow CONFIG_COMPILE_TEST.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
>
> What is the plan for this patch ? Push through watchdog
> or through your branch ?

I would prefer my branch so I can apply the final patch without waiting
for another release. Not in a hurry though, so if some other maintainer
wants to take the respective driver patch through their tree instead of the
arm-soc one, I'll just wait anyway.

        Arnd
