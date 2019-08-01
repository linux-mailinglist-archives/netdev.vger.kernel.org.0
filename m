Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1EBEA7D65C
	for <lists+netdev@lfdr.de>; Thu,  1 Aug 2019 09:33:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730030AbfHAHdl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Aug 2019 03:33:41 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:43253 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725946AbfHAHdk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Aug 2019 03:33:40 -0400
Received: by mail-qk1-f194.google.com with SMTP id m14so25541015qka.10;
        Thu, 01 Aug 2019 00:33:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uzHxuqP9bTvMw7JBQ/Id5Vam5w5HBpX0XWumLmps/F8=;
        b=a2zwqHyjT8P+fvFrSFEOJ3Z1sbAqdsA2LP5g/lQoCinOhcUXP7sYyD11Wo60055Sut
         EunN2tSpc0ixremLnzzmIt3Q/qJEdxpJOHqgoZN6hk2YXuU0hrwP6WXeY1m/k4fzlw/F
         +DIAGrpnBnVrtnL/kZDuiTI4DfCNnBPgeElRwS5SUEhge1RgQokuqsUmM6YgBys7va57
         0X5Qle87sSRyXQ1OHv94ddtqARdJfTvcugTjTHNEVyIXhFxD0vcdTfm2AeZAhoSldzI9
         NhNMtU7wkxW9e+CZ/LJN7wg1gKdPv+knC0RL0DPFUGkegJO5xF733jO3d8GxGCYgsGF9
         kU3A==
X-Gm-Message-State: APjAAAU8B+qBWNdUE6ia99zmQpQswSTH9EbLvTEXCtYa2Y/Mc46yDQ5x
        0If5aJq5SFXeVKQU8sxPUArwBNtG6CMFeWVzE8c=
X-Google-Smtp-Source: APXvYqyMeJ9LlJMXE9rDAXSa0/HHTUU6jsIhO5Y0qQu+ABh/obgCJKyAqVIsLutAY+sl9DXQqRxphmZCeAPnr5ENpd8=
X-Received: by 2002:a37:5f45:: with SMTP id t66mr84886325qkb.286.1564644819429;
 Thu, 01 Aug 2019 00:33:39 -0700 (PDT)
MIME-Version: 1.0
References: <20190731195713.3150463-1-arnd@arndb.de> <20190731225303.GC1330@shell.armlinux.org.uk>
In-Reply-To: <20190731225303.GC1330@shell.armlinux.org.uk>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 1 Aug 2019 09:33:23 +0200
Message-ID: <CAK8P3a1Lgbz9RwVaOgNq=--gwvEG70tUi67XwsswjgnXAX6EhA@mail.gmail.com>
Subject: Re: [PATCH 00/14] ARM: move lpc32xx and dove to multiplatform
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     soc@kernel.org, Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Sylvain Lemieux <slemieux.tyco@gmail.com>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Guenter Roeck <linux@roeck-us.net>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        linux-serial@vger.kernel.org, USB list <linux-usb@vger.kernel.org>,
        LINUXWATCHDOG <linux-watchdog@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 1, 2019 at 12:53 AM Russell King - ARM Linux admin
<linux@armlinux.org.uk> wrote:
>
> On Wed, Jul 31, 2019 at 09:56:42PM +0200, Arnd Bergmann wrote:
> > For dove, the patches are basically what I had proposed back in
> > 2015 when all other ARMv6/ARMv7 machines became part of a single
> > kernel build. I don't know what the state is mach-dove support is,
> > compared to the DT based support in mach-mvebu for the same
> > hardware. If they are functionally the same, we could also just
> > remove mach-dove rather than applying my patches.
>
> Well, the good news is that I'm down to a small board support file
> for the Dove Cubox now - but the bad news is, that there's still a
> board support file necessary to support everything the Dove SoC has
> to offer.
>
> Even for a DT based Dove Cubox, I'm still using mach-dove, but it
> may be possible to drop most of mach-dove now.  Without spending a
> lot of time digging through it, it's impossible to really know.

Ok, so we won't remove it then, but I'd like to merge my patches to
at least get away from the special case of requiring a separate kernel
image for it.

Can you try if applying patches 12 and 14 from my series causes
problems for you? (it may be easier to apply the entire set
or pull from [1] to avoid rebase conflicts).

     Arnd

[1] kernel.org:/pub/scm/linux/kernel/git/arnd/playground.git mach-cleanup-5.4
