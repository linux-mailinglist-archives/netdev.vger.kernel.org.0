Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA4928198F
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 14:43:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728768AbfHEMnL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 08:43:11 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:39948 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726315AbfHEMnL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 08:43:11 -0400
Received: by mail-io1-f67.google.com with SMTP id h6so41749880iom.7;
        Mon, 05 Aug 2019 05:43:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=KQm9NPghtf2wFJQFdwyuoe6G2q10wFofTqLGNt8zEfc=;
        b=Jm9lN989x1LL1wAGmtgQW1PbFf7i6ALddtYVvYUT3D0ZuifbqBe7vXuKRfHJ1DVFyf
         5E6ia0qFc+YxzkWLdGYvRSD2zIYvdSQi7desBh6dPVYOxX5FGHe8MZTcpO7SoBv2T+fx
         rM6HGgCOlS1+Mq1T7ZsjoN47gJmVIc8qASDJbmnblb51sxAIIH83d2PNguaUH54zd0Pd
         g8BJGwj/2VWcZL1lekXwBWPoMwwDfwE/1wbv8+ARLVMYNN37zc7ARSt2a3DyNCxJMg8n
         X9boR31zKzMZP2i4KZCBZU3pIFAZQ4KVkLrRQcNoPYIaJXKm1UqQkctLH6lsqK5JS0DO
         uLqQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=KQm9NPghtf2wFJQFdwyuoe6G2q10wFofTqLGNt8zEfc=;
        b=l/PpOsVrGHqNxry9E6KpiL1m18rE+Y9jD6rlCTMP/NgLQsrD9kQHFa/0wMdqE1Ygmw
         lPbqS6m7+u8nt/2SRFwMg/EQahAbtWPf8IPunWkV1lWfsUa1Cj+Sepn3kCWdFFiN3kRM
         kXG+jYA5LlaLtHWDO9V/pHOICNxng7+Iuc+C253IZ3xYg/4bycVJmw3St31Hy6ATTKH0
         YP4O2e0gksUmz0UaQ4O3XQbFWg+6NWIn0o40jXR4sChHiD6gYSTMEmYJ63JmtFcq2zMh
         8dllAS8Ralb83GWveEoAQrIsezbwfoVf374l+jeFbWqwK8YptzZsaYUdTu/b3fztqjY+
         O4tA==
X-Gm-Message-State: APjAAAUTKR0LSE9ppQhhTeR6rZV8DMhLVJD1VggiP8DVJugrw+TU3TXI
        y5G6lBvTu7rJkBnM81z706+P56gNLPKeNdZgLA8=
X-Google-Smtp-Source: APXvYqz396zlNXAqcaOCvcqObVMswatfB+f2uh+zsXE7YIFo6iaQRklzHrm0RcU5f66HRRMmb5shLa66REY85aMxJmc=
X-Received: by 2002:a6b:f114:: with SMTP id e20mr11104225iog.169.1565008990378;
 Mon, 05 Aug 2019 05:43:10 -0700 (PDT)
MIME-Version: 1.0
References: <20190731195713.3150463-1-arnd@arndb.de> <20190731195713.3150463-4-arnd@arndb.de>
 <20190731202343.GA14817@roeck-us.net> <CAK8P3a2=gqeCMtdzdqg4d1n6v1-cdaHObeUoVXeB+=Okwd1rqA@mail.gmail.com>
 <20190731203646.GB14817@roeck-us.net>
In-Reply-To: <20190731203646.GB14817@roeck-us.net>
From:   Sylvain Lemieux <slemieux.tyco@gmail.com>
Date:   Mon, 5 Aug 2019 08:42:58 -0400
Message-ID: <CA+rxa6oOxHH20Oiw1BKqa+9QF+J+M2cnQgMRKkLuxjcm9Ux2uQ@mail.gmail.com>
Subject: Re: [PATCH 03/14] watchdog: pnx4008_wdt: allow compile-testing
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     Arnd Bergmann <arnd@arndb.de>, soc@kernel.org,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
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

Acked-by: Sylvain Lemieux <slemieux.tyco@gmail.com>

On Wed, Jul 31, 2019 at 4:36 PM Guenter Roeck <linux@roeck-us.net> wrote:
>
> On Wed, Jul 31, 2019 at 10:26:35PM +0200, Arnd Bergmann wrote:
> > On Wed, Jul 31, 2019 at 10:23 PM Guenter Roeck <linux@roeck-us.net> wrote:
> > >
> > > On Wed, Jul 31, 2019 at 09:56:45PM +0200, Arnd Bergmann wrote:
> > > > The only thing that prevents building this driver on other
> > > > platforms is the mach/hardware.h include, which is not actually
> > > > used here at all, so remove the line and allow CONFIG_COMPILE_TEST.
> > > >
> > > > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > >
> > > Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> > >
> > > What is the plan for this patch ? Push through watchdog
> > > or through your branch ?
> >
> > I would prefer my branch so I can apply the final patch without waiting
> > for another release. Not in a hurry though, so if some other maintainer
>
> Ok with me.
>
> Guenter
