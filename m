Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CD84C819D4
	for <lists+netdev@lfdr.de>; Mon,  5 Aug 2019 14:44:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728983AbfHEMn5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Aug 2019 08:43:57 -0400
Received: from mail-io1-f67.google.com ([209.85.166.67]:45964 "EHLO
        mail-io1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728965AbfHEMn4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Aug 2019 08:43:56 -0400
Received: by mail-io1-f67.google.com with SMTP id g20so166969498ioc.12;
        Mon, 05 Aug 2019 05:43:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BtM+NWj25oYvpSibgXFWcN7a4g9p0DLdhW/V4xt2eBU=;
        b=ZhKaC5MruwlHhhxMdPFwBhdPOYfP4wRyyL5N9ujJ84SwNjtO73htrkFtOMztfiavLw
         3mjniDoCJ3Bdo87uYPsyaTU8Vac2oGmkLqJQ/CYeXZqR3vFSExkCyiri3ODkTnfBhcV4
         C7zWaU+uEvyzRO88l6CgCi/Yl8EFpBECsqiW+0n1EXu43WHzCFRCCdfAtPypn8PcHw77
         VAR8QE8n+f8Bp/TmoDduiOZUWOXS8FME9HJgFscbc1zhEG9ESLdbyJtpPWJzSYOK839a
         blC7htlqER39fmEduUJ5KTjvmZEO/NXXYrGht3l6l8ygJo+W7iWPDcJrCkDfe962tjVN
         w5SQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BtM+NWj25oYvpSibgXFWcN7a4g9p0DLdhW/V4xt2eBU=;
        b=cQ+Sez/VbeUyz54rRqgy5wcfx2BwbofBYYfvEi4WO0GIh/gzd7svFiyJtaapz0Rkzk
         2tvgf9yxfLnkgroyD61+MHwlgoU4jR+kf/I6ZAcupCJ/YFxAgXakJE73zUlSb8xZRh/u
         ZBhWgvpi7a01wZgHiZ91ccIqUzgyOWlNCVdEFYipRT8KsiPJzfI2viYB/g5vQ/l2Tihd
         C0XNwhvHI289REB/HFXCrsLuoHhQH9wvt3UoauGgPFR0k42OaO5qxaGFigLQSLv9/hWY
         48PcAs5jw5kVhOf5AftU66qcLykKtS51oq/kdrUdTlc6vadeF6tJcbQdoej64CvLAnal
         t4PQ==
X-Gm-Message-State: APjAAAVh9yH0+PGL8i4K3Vu0hsy26Z0o9uzSIcGCpLzWScemc5rkCxZh
        MBHhwIxX1Hypy4Qk3fgwhqKKdyPxCV4fLo5P3g4=
X-Google-Smtp-Source: APXvYqwqQSPW397kqrW3kGv0GRCbHES+vT5UGpfo7ZHfq/1Bj6VjaFS3ZRkwHG0PLi1+eyqFIVooHFs/Ke2fu12pfIU=
X-Received: by 2002:a5e:8c11:: with SMTP id n17mr69032096ioj.64.1565009035665;
 Mon, 05 Aug 2019 05:43:55 -0700 (PDT)
MIME-Version: 1.0
References: <20190731195713.3150463-1-arnd@arndb.de> <20190731195713.3150463-5-arnd@arndb.de>
 <20190801055840.GC24607@kroah.com>
In-Reply-To: <20190801055840.GC24607@kroah.com>
From:   Sylvain Lemieux <slemieux.tyco@gmail.com>
Date:   Mon, 5 Aug 2019 08:43:44 -0400
Message-ID: <CA+rxa6oU65QeEDaROdz1v=5R6m4YKTd7rRNEBx41d5uixyoz=g@mail.gmail.com>
Subject: Re: [PATCH 04/14] serial: lpc32xx_hs: allow compile-testing
To:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc:     Arnd Bergmann <arnd@arndb.de>, soc@kernel.org,
        "moderated list:ARM PORT" <linux-arm-kernel@lists.infradead.org>,
        Vladimir Zapolskiy <vz@mleia.com>,
        Russell King <linux@armlinux.org.uk>,
        Gregory Clement <gregory.clement@bootlin.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Jiri Slaby <jslaby@suse.com>,
        Jason Cooper <jason@lakedaemon.net>,
        Andrew Lunn <andrew@lunn.ch>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alan Stern <stern@rowland.harvard.edu>,
        Guenter Roeck <linux@roeck-us.net>,
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

On Thu, Aug 1, 2019 at 1:58 AM Greg Kroah-Hartman
<gregkh@linuxfoundation.org> wrote:
>
> On Wed, Jul 31, 2019 at 09:56:46PM +0200, Arnd Bergmann wrote:
> > The only thing that prevents building this driver on other
> > platforms is the mach/hardware.h include, which is not actually
> > used here at all, so remove the line and allow CONFIG_COMPILE_TEST.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> > ---
> >  drivers/tty/serial/Kconfig      | 3 ++-
> >  drivers/tty/serial/lpc32xx_hs.c | 2 --
> >  2 files changed, 2 insertions(+), 3 deletions(-)
>
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
