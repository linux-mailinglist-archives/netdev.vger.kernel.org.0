Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C897177688
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 14:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728494AbgCCNBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 08:01:01 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:38968 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727961AbgCCNBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Mar 2020 08:01:01 -0500
Received: by mail-lj1-f196.google.com with SMTP id f10so1567675ljn.6
        for <netdev@vger.kernel.org>; Tue, 03 Mar 2020 05:01:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NKj+1Rf5TnGZp4SiLcelNGaJtNpD2JrLWM1tk/In9ck=;
        b=jx1mKKrApcRXamn0UdmROfGB/dWjaSxTUv6iyGimgChB2LNGywfc217cKIVp8ywKB0
         5AFhGnzfgGLxwjwKwQ5z2C+zKUW7FUnqWZ7M9GUvS2VLhIBz95aJVpVDlX4gr5rt6Jl2
         uhCZdMUDn5WD6z+3sbZ39l67QTde69vqXP09FAuXwfCWfPzVtplTJjgCUH5BLVXmE3Qe
         es3YU6cEE1TTCOgADetZuNWd7uC0DwwbRLe1A6RZTX25hMYSpWDKZcDtPqPvDYSKJhNi
         mhomdgxZ541z06qXd4tS9oeGlCUjzy2f9jyanXnJ+Qfuwm5McojSZczPgwijviXEPVgX
         8uoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NKj+1Rf5TnGZp4SiLcelNGaJtNpD2JrLWM1tk/In9ck=;
        b=oMUv10V90dxPC08EeRxm0J9xiUn+9R9LZEMW8gVDdEqHQy/PZD9DUFVzM0LqC/zpP/
         n95SpycFv3Ljm8Vo0rKCBM1T/B2jUjcwCC4qthXUqPPFBuatFZMIi0/I61TaDHBcqk1Y
         +ha1oiX1W1vH1MlZAq4wF+nfKXH3qJ3eTUltCQ478Y6V5RxQIxJ4wY7be5fEvYcqi/by
         MyQj7mfraAlZPI7kGBpyMZ2udcLDKJkz2ra4VnaYB/LLxtaBaoFHyt+HGyZN3lEp0l1V
         53ZVxCSg9KdrPv+Wq6kGm0bGlqRkrdh9gmLdoS5p55ioLFnaT18C4o0pyreTso/cOU9A
         kXKA==
X-Gm-Message-State: ANhLgQ34qnPSg6ktLyCU9zywSCHik4kMVdGMjeZX4xEGXtbotNNwUTDO
        1x+LaJcSi/wcVdUYG6+lzmTK/WB+iXYaCVJ7OLnL9g==
X-Google-Smtp-Source: ADFU+vt6Xgq2BT1BgAbHQx9inuBc+XGlWT4URTEZQQUd8DrO3mUIikmr/9q5Su6eUhpueU4LIGXp9eMIsusx2RPh1T0=
X-Received: by 2002:a05:651c:2c7:: with SMTP id f7mr2343804ljo.125.1583240459705;
 Tue, 03 Mar 2020 05:00:59 -0800 (PST)
MIME-Version: 1.0
References: <20191211214852.26317-1-christopher.s.hall@intel.com>
 <87eevf4hnq.fsf@nanos.tec.linutronix.de> <20200224224059.GC1508@skl-build> <87mu95ne3q.fsf@nanos.tec.linutronix.de>
In-Reply-To: <87mu95ne3q.fsf@nanos.tec.linutronix.de>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Tue, 3 Mar 2020 14:00:48 +0100
Message-ID: <CACRpkdadbWvsnyrH_+sRha2C0fJU0EFEO9UyO7wHybZT-R1jzA@mail.gmail.com>
Subject: Re: [Intel PMC TGPIO Driver 0/5] Add support for Intel PMC Time GPIO
 Driver with PHC interface changes to support additional H/W Features
To:     Thomas Gleixner <tglx@linutronix.de>,
        Bartosz Golaszewski <bgolaszewski@baylibre.com>,
        Jonathan Cameron <jic23@kernel.org>
Cc:     "Christopher S. Hall" <christopher.s.hall@intel.com>,
        netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        jacob.e.keller@intel.com,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Sean V Kelley <sean.v.kelley@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 27, 2020 at 12:06 AM Thomas Gleixner <tglx@linutronix.de> wrote:
> "Christopher S. Hall" <christopher.s.hall@intel.com> writes:

> > Apart from clock import/export applications, timestamping single I/O
> > events are potentially valuable for industrial control applications
> > (e.g. motor position sensing vs. time). As time sync precision
> > requirements for these applications are tightened, standard GPIO
> > timing precision will not be good enough.

If you are using (from userspace) the GPIO character device
and open the events using e.g. tools/gpio/gpio-event-mon.c
you get GPIO events to userspace.

This uses a threaded interrupt with an top half (fastpath)
that timestamps it as the IRQ comes in using
ktime_get_ns(). It's as good as we can get it with just
software and IRQs (I think).

This uses a KFIFO to userspace, same approach as the IIO
subsystem.

> Anyway, the device we are talking about is a GPIO device with inputs and
> outputs plus bells and whistles attached to it.
>
> On the input side this provides a timestamp taken by the hardware when
> the input level changes, i.e. hardware based time stamping instead of
> software based interrupt arrival timestamping. Looks like an obvious
> extension to the GPIO subsystem.

That looks like something I/we would want to support all the way
to userspace so people can do their funny industrial stuff in some
standard manner.

IIO has a config file in sysfs that lets them select the source of the
timestamp like so (drivers/iio/industrialio-core.c):

s64 iio_get_time_ns(const struct iio_dev *indio_dev)
{
        struct timespec64 tp;

        switch (iio_device_get_clock(indio_dev)) {
        case CLOCK_REALTIME:
                return ktime_get_real_ns();
        case CLOCK_MONOTONIC:
                return ktime_get_ns();
        case CLOCK_MONOTONIC_RAW:
                return ktime_get_raw_ns();
        case CLOCK_REALTIME_COARSE:
                return ktime_to_ns(ktime_get_coarse_real());
        case CLOCK_MONOTONIC_COARSE:
                ktime_get_coarse_ts64(&tp);
                return timespec64_to_ns(&tp);
        case CLOCK_BOOTTIME:
                return ktime_get_boottime_ns();
        case CLOCK_TAI:
                return ktime_get_clocktai_ns();
        default:
                BUG();
        }
}

After discussion with Arnd we concluded the only timestamp that
makes sense is ktime_get_ns(). So in GPIO we just use that, all the
userspace I can think of certainly prefers monotonic time.
(If tglx does not agree with that I stand corrected to whatever
he says, I suppose.)

Anyway in GPIO we could also make it configurable for users who
know what they are doing.

HW timestamps would be something more elaborate and
nice CLOCK_HW_SPECIFIC or so. Some of the IIO sensors also
have that, we just don't expose it as of now.

Yours,
Linus Walleij
