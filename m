Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59ECD342CD6
	for <lists+netdev@lfdr.de>; Sat, 20 Mar 2021 13:45:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229766AbhCTMou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Mar 2021 08:44:50 -0400
Received: from mout.kundenserver.de ([212.227.126.135]:39307 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229564AbhCTMol (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Mar 2021 08:44:41 -0400
Received: from mail-ot1-f49.google.com ([209.85.210.49]) by
 mrelayeu.kundenserver.de (mreue011 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1M1YtP-1lQ3oL2SF9-003975; Sat, 20 Mar 2021 13:44:38 +0100
Received: by mail-ot1-f49.google.com with SMTP id o19-20020a9d22130000b02901bfa5b79e18so11204704ota.0;
        Sat, 20 Mar 2021 05:44:37 -0700 (PDT)
X-Gm-Message-State: AOAM533tJ4hARlAND5uzi2rUOkNdBfKTQ8xuyym4T6P13QnyW/XxPStg
        U5a00vk//QRDE0HAwXZKtHGitOuaxeQC0Pd5J8I=
X-Google-Smtp-Source: ABdhPJxPabsbC9l0uov8VA+QPfsVO0jOLb9EmBvBROLIp8qu9VlJZY7K8edBl0OEw9G+JsJmxObK2UpoOm2egNiBGoI=
X-Received: by 2002:a9d:316:: with SMTP id 22mr636124otv.210.1616244276911;
 Sat, 20 Mar 2021 05:44:36 -0700 (PDT)
MIME-Version: 1.0
References: <4c46726d-fa35-1a95-4295-bca37c8b6fe3@nvidia.com> <CACRpkdbmqww6UQ8CFYo=+bCtVYBJwjMxVixc4vS6D3B+dUHScw@mail.gmail.com>
In-Reply-To: <CACRpkdbmqww6UQ8CFYo=+bCtVYBJwjMxVixc4vS6D3B+dUHScw@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Sat, 20 Mar 2021 13:44:20 +0100
X-Gmail-Original-Message-ID: <CAK8P3a30CdRKGe++MyBVDLW=p9E1oS+C7d7W4jLE01TAA4k+GA@mail.gmail.com>
Message-ID: <CAK8P3a30CdRKGe++MyBVDLW=p9E1oS+C7d7W4jLE01TAA4k+GA@mail.gmail.com>
Subject: Re: GTE - The hardware timestamping engine
To:     Linus Walleij <linus.walleij@linaro.org>
Cc:     Dipen Patel <dipenp@nvidia.com>,
        Kent Gibson <warthog618@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "thierry.reding@gmail.com" <thierry.reding@gmail.com>,
        Jon Hunter <jonathanh@nvidia.com>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        "open list:GPIO SUBSYSTEM" <linux-gpio@vger.kernel.org>,
        linux-tegra <linux-tegra@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:8WL2U0ZQ9+i5oBZA4YcSoYeOEcSz0EIU4+EG7j07uzzGBzz5PzQ
 G0Rmke1vlmE7RhNOm7gNWYPtGNsEL7eD1y9HIH0KYGwi6MzLriTHKdKZQ/QayOMWXqBqs7U
 Kz3vAjBggCNGSvRL4XlOLSPhYRTXtGQVdsAsNCY5dxPztyYIvC1p+8yVLM+x8ZkVJwnfea6
 gZlk3nz4pIkYRQLeSijgA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:kwWt9/LbsDw=:8L6KL4WVrty0aeYmZ+GY+5
 icnxt9Uuij0VPYPBo/YV96dCSUmye27xAyh5E+AxIlvozNjysihheVwbYTaRnxDtNE5HCgvkm
 xa74UP4m9umr7Ypsgpscl65cU2JKR3nmyMSz7V5yB/kWCG3eDGkD9i5U7E6hTVboqBRAHOxOE
 xap2ll3KpnH0f1jy7O+R9k4qhjNCQv+MWDXQYFUmoN3wa+MjWFjvUiUya1NoHPycSjn3QqJ+B
 HFpyMP858Vq5briB/7hyN0XFhJ5oKZ1MprvY6zjTQQ5JqMddY+6ZLn/tlZxjuOd+uXbGXhuLy
 RRGQHyqicfmm3HfwikHe+60rg5IxrzFsbvERA7hKs6f5Jkz9h9s/rUls93HZLcJcuU+8YOKOt
 rkxw6xHyRzzBXiNvn/s2NtSbdJIJCeFBgT+dmJw/jo1UlkNgk+gAsdQaSMnCk
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 20, 2021 at 12:56 PM Linus Walleij <linus.walleij@linaro.org> wrote:
>
> Hi Dipen,
>
> thanks for your mail!
>
> I involved some other kernel people to get some discussion.
> I think Kent Gibson can be of great help because he is using
> GPIOs with high precision.
>
> We actually discussed this a bit when adding support for
> realtime timestamps.

Adding Richard Cochran as well, for drivers/ptp/, he may be able to
identify whether this should be integrated into that framework in some
form.

fullquote below

> On Wed, Mar 17, 2021 at 11:29 PM Dipen Patel <dipenp@nvidia.com> wrote:
>
> > Nvidia Tegra SoCs have generic timestamping engine (GTE) hardware module which
> > can monitor SoC signals like IRQ lines and GPIO lines for state change, upon
> > detecting the change, it can timestamp and store in its internal hardware FIFO.
> > The advantage of the GTE module can be realized in applications like robotics
> > or autonomous vehicle where it can help record events with precise timestamp.
>
> That sounds very useful.
>
> Certainly the kernel shall be able to handle this.
>
> > ============
> > For GPIO:
> > ============
> > 1.  GPIO has to be configured as input and IRQ must be enabled.
> > 2.  Ask GPIO controller driver to set corresponding timestamp bit in the
> >     specified GPIO config register.
> > 3.  Translate GPIO specified by the client to its internal bitmap.
> > 3.a For example, If client specifies GPIO line 31, it could be bit 13 of GTE
> >     register.
> > 4.  Set internal bits to enable monitoring in GTE module
> > 5.  Additionally GTE driver can open up lanes for the user space application
> >     as a client and can send timestamping events directly to the application.
>
> I have some concerns:
>
> 1. GPIO should for all professional applications be used with the character
> device /dev/gpiochipN, under no circumstances shall the old sysfs
> ABI be used for this. In this case it is necessary because the
> character device provides events in a FIFO to userspace, which is
> what we need.
>
> The timestamp provided to userspace is an opaque 64bit
> unsigned value. I suppose we assume it is monotonic but
> you can actually augment the semantics for your specific
> stamp, as long as 64 bits is gonna work.
>
> 2. The timestamp for the chardev is currently obtained in
> drivers/gpio/gpiolib-cdev.c like this:
>
> static u64 line_event_timestamp(struct line *line)
> {
>         if (test_bit(FLAG_EVENT_CLOCK_REALTIME, &line->desc->flags))
>                 return ktime_get_real_ns();
>
>         return ktime_get_ns();
> }
>
> What you want to do is to add a new flag for hardware timestamps
> and use that if available. FLAG_EVENT_CLOCK_HARDWARE?
> FLAG_EVENT_CLOCK_NATIVE?
>
> Then you need to figure out a mechanism so we can obtain
> the right timestamp from the hardware event right here,
> you can hook into the GPIO driver if need be, we can
> figure out the gpio_chip for a certain line for sure.
>
> So you first need to augment the userspace
> ABI and the character device code to add this. See
> commit 26d060e47e25f2c715a1b2c48fea391f67907a30
> "gpiolib: cdev: allow edge event timestamps to be configured as REALTIME"
> by Kent Gibson to see what needs to be done.
>
> 3. Also patch tools/gpio/gpio-event-mon.c to support this flag and use that
> for prototyping and proof of concept.
>
> > ============
> > For IRQ:
> > ============
>
> Marc Zyngier and/or Thomas Gleixner know this stuff.
>
> It does make sense to add some infrastructure so that GPIO events
> and IRQs can use the same timestamping hardware.
>
> And certainly you will also want to use this timestamp for
> IIO devices? If it is just GPIOs and IRQs today, it will be
> gyroscopes and accelerometers tomorrow, am I right?
>
> Yours,
> Linus Walleij
