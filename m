Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E764B155CA1
	for <lists+netdev@lfdr.de>; Fri,  7 Feb 2020 18:11:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727047AbgBGRK7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Feb 2020 12:10:59 -0500
Received: from mail-lj1-f196.google.com ([209.85.208.196]:32810 "EHLO
        mail-lj1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726897AbgBGRK7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Feb 2020 12:10:59 -0500
Received: by mail-lj1-f196.google.com with SMTP id y6so107674lji.0
        for <netdev@vger.kernel.org>; Fri, 07 Feb 2020 09:10:58 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=kHZ6O3yZLVjr/z8fh4b0NIHRATY9dkwE1ZXn4+1qxmE=;
        b=DSrPBFU89WipvBFWDiBmx1WEfiNz+QcRasIkw0wuHAcsdY2yl/E8Va/dvrOsEis6nU
         ll7iO7+BXahC5Wo35n+CMC/ZJB0BzkIBDQ6bz2oNfA/FfNyePShEo2IjGJMgHw34we6c
         5ENqo4hbOu356FJCONM9PE3UF4X0c5eevOtFWuYJXogW+JEC2BZHyd0R3ME22fbUS4wT
         +sb9wAS2ouuVh7BYly3TCt/391WbB/K3G6bQ90SeHhqyV0gFMGdZpz9qdnibj2WOgQu0
         SPXFPFM3/TPol8Ju+QZsxciJrkYc66/7jrqn/cig1FoJoN7DwxG4mD5ex1K+QSUtP3a9
         DjCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=kHZ6O3yZLVjr/z8fh4b0NIHRATY9dkwE1ZXn4+1qxmE=;
        b=hh3LSrGd20pOIQxu0ng6mxwfiX9DZq4j1hIXUFhWpoa9Li/niVZcNYX4JOzvihBWNP
         UyotxTrF15laZSGTThExcl0CUFZGB0lZXDGQ536XEi6N6kwQP0wxC7Pd4zVZ5CzQD91Y
         pRHpeN4SRcwrVT0gn16nL2wdnUtct/bwmh9X53shK2+8wB0B8Uh75BOMpDOv4sC2+Miu
         h8IqYnJ0+EI7lt0koXwiS8tLEn79NrK71CLsVCLbKICyq6N5Q7CFgolRafr34ibV7Gig
         lH7gD86cXk3VcouSe8ZrKpiwDvDgDt1hbM6PqsRbhKeG6Xrv7mKd1VjCpD9RdXU00IZY
         n5DA==
X-Gm-Message-State: APjAAAVzDqmqshFo5QjBR/+c+noMCF4x+IdwloiRdZPfv/qN/CQjmn0w
        lFFwNJIav/dSTXyJoSUZ6GJDyleIxAApwtrIiSKi1w==
X-Google-Smtp-Source: APXvYqwIYH+HqZ0Lmzv1e+jykQ7bGnALdVo7BFeDQLK5lJfgzAzGTSciQR870PQ0CA55rMLcBTKI8lLCBo6ykwscAmg=
X-Received: by 2002:a2e:81c3:: with SMTP id s3mr147514ljg.168.1581095457580;
 Fri, 07 Feb 2020 09:10:57 -0800 (PST)
MIME-Version: 1.0
References: <20191211214852.26317-1-christopher.s.hall@intel.com> <20191211214852.26317-6-christopher.s.hall@intel.com>
In-Reply-To: <20191211214852.26317-6-christopher.s.hall@intel.com>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Fri, 7 Feb 2020 18:10:46 +0100
Message-ID: <CACRpkdbi7q5Vr2Lt12eirs3Z8GLL2AuLLrAARCHkYEYgKbYkHg@mail.gmail.com>
Subject: Re: [Intel PMC TGPIO Driver 5/5] drivers/ptp: Add PMC Time-Aware GPIO Driver
To:     christopher.s.hall@intel.com,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>
Cc:     netdev <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        "maintainer:X86 ARCHITECTURE (32-BIT AND 64-BIT)" <x86@kernel.org>,
        jacob.e.keller@intel.com,
        Richard Cochran <richardcochran@gmail.com>,
        "David S. Miller" <davem@davemloft.net>, sean.v.kelley@intel.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Christopher,

thanks for your patch!

On Fri, Jan 31, 2020 at 7:41 AM <christopher.s.hall@intel.com> wrote:

> From: Christopher Hall <christopher.s.hall@intel.com>
>
> Add support for PMC Time-Aware GPIO (TGPIO) hardware that is present on
> upcoming Intel platforms. The hardware logic is driven by the ART clock.
> The current hardware has two GPIO pins. Input interrupts are not
> implemented in hardware.
>
> The driver implements to the expanded PHC interface. Input requires use of
> the user-polling interface. Also, since the ART clock can't be adjusted,
> modulating the output frequency uses the edge timestamp interface
> (EVENT_COUNT_TSTAMP2) and the PEROUT2 ioctl output frequency adjustment
> interface.
>
> Acknowledgment: Portions of the driver code were authored by Felipe
> Balbi <balbi@kernel.org>
>
> Signed-off-by: Christopher Hall <christopher.s.hall@intel.com>

This driver becomes a big confusion for the GPIO maintainer...

> +config PTP_INTEL_PMC_TGPIO
> +       tristate "Intel PMC Timed GPIO"
> +       depends on X86
> +       depends on ACPI
> +       depends on PTP_1588_CLOCK
(...)
> +#include <linux/gpio.h>

Don't use this header in new code, use <linux/gpio/driver.h>

But it looks like you should just drop it because there is no GPIO
of that generic type going on at all?

> +/* Control Register */
> +#define TGPIOCTL_EN                    BIT(0)
> +#define TGPIOCTL_DIR                   BIT(1)
> +#define TGPIOCTL_EP                    GENMASK(3, 2)
> +#define TGPIOCTL_EP_RISING_EDGE                (0 << 2)
> +#define TGPIOCTL_EP_FALLING_EDGE       (1 << 2)
> +#define TGPIOCTL_EP_TOGGLE_EDGE                (2 << 2)
> +#define TGPIOCTL_PM                    BIT(4)

OK this looks like some GPIO registers...

Then there is a bunch of PTP stuff I don't understand I suppose
related to the precision time protocol.

Could you explain to a simple soul like me what is going on?
Should I bother myself with this or is this "some other GPIO,
not what you work on" or could it be that it's something I should
review?

I get the impression that this so-called "general purpose I/O"
isn't very general purpose at all, it seems to be very PTP-purpose
rather, so this confusion needs to be explained in the commit
message and possibly in the code as well.

What is it for really?

Yours,
Linus Walleij
