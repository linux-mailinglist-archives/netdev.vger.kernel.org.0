Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD1DA7143E
	for <lists+netdev@lfdr.de>; Tue, 23 Jul 2019 10:43:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731816AbfGWInX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jul 2019 04:43:23 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:33819 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728680AbfGWInW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jul 2019 04:43:22 -0400
Received: by mail-qk1-f196.google.com with SMTP id t8so30537518qkt.1;
        Tue, 23 Jul 2019 01:43:22 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZKnC18HhPKwDPrI9FlnS+GlfmqXdEBTBkjh93zPpTQQ=;
        b=bxCjL/oGUaWbQilfFX4Ekz99WOwtrca0pCnJpaOUPLIiYzHUXHjgLnfzzzVtMAdlN8
         WBVr3tiYKUYAC4KZZ8R4xcrRN2MX57JrKbUU5V+yHixZw56IN249qWlyon7ZnuiJKx37
         XjzhWWkVMCBgQa5YKNuSl9BQLD3pTsziMALmrRfEd3UBhedNk7neFlpCkdtc1J97mHWI
         meXapJNA9ndjGpNu18YCgu3BwMMYchy/aQ99QY6CAHqY9trT1TD34aiN+uqysziONlTd
         mhS6onm6vfMYZFgm+vCUHU6fZfJ43f4PLN4so4DUtmUw2QDZNDCkwDBJCuU8Vpy2lVJX
         UpxQ==
X-Gm-Message-State: APjAAAXrVMSy1ID7Bcx9sU3rKw+ZeqWMb10aY/jHGbbeUaSx+DtkyMVf
        dH/0uUf2QuH1+wnYGpL+1YPjYCi8w4Siti/R1TwCHBqAuY8=
X-Google-Smtp-Source: APXvYqzFoC+pPfbF0W3T1tn86l3nXu8u9mSRtjF5jSwBn0hO82qRogXGOHgeYRfVb3wPdUyOSONuGRUQqYAogzUAWBs=
X-Received: by 2002:a37:76c5:: with SMTP id r188mr48846330qkc.394.1563871401482;
 Tue, 23 Jul 2019 01:43:21 -0700 (PDT)
MIME-Version: 1.0
References: <20190722191552.252805-1-arnd@arndb.de> <20190722191552.252805-2-arnd@arndb.de>
 <CACRpkdbm5MpcNdm8EGTR=U8MpK2VPzEg=Us0-AxZzOZ=vVJSmQ@mail.gmail.com>
In-Reply-To: <CACRpkdbm5MpcNdm8EGTR=U8MpK2VPzEg=Us0-AxZzOZ=vVJSmQ@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 23 Jul 2019 10:43:05 +0200
Message-ID: <CAK8P3a1=Bnsxg-3RztGEL-c6muQjam-egyrsZfqc7_yjBzcGXA@mail.gmail.com>
Subject: Re: [PATCH 2/3] serial: remove netx serial driver
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev <netdev@vger.kernel.org>, linux-serial@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>,
        "David S. Miller" <davem@davemloft.net>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Michael Trensch <MTrensch@hilscher.com>,
        Robert Schwebel <r.schwebel@pengutronix.de>,
        Jiri Slaby <jslaby@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 23, 2019 at 10:26 AM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> On Mon, Jul 22, 2019 at 9:16 PM Arnd Bergmann <arnd@arndb.de> wrote:
>
> > The netx platform got removed, so this driver is now
> > useless.
> >
> > Signed-off-by: Arnd Bergmann <arnd@arndb.de>
>
> We seem so overlap :)
> https://marc.info/?l=linux-serial&m=156377843325488&w=2
>
> Anyways, the patches are identical except here:
>
> > -/* Hilscher netx */
> > +/* Hilscher netx (removed) */
> >  #define PORT_NETX      71
>
> Is there some reason for keeping the magical number around?
> When I looked over the file there seemed to be more "holes"
> in the list.

I looked at the same list and though I saw more obsolete entries
than holes. The last ones that I saw getting removed were
PORT_MFD in 2017 and PORT_V850E_UART in 2008.

It probably doesn't matter as we have precedence for both.

       Arnd
