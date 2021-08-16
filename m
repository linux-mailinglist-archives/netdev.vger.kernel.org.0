Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 570F73EDDF2
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 21:34:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230287AbhHPTeq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 15:34:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51130 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbhHPTep (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Aug 2021 15:34:45 -0400
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 02FEEC061764;
        Mon, 16 Aug 2021 12:34:13 -0700 (PDT)
Received: by mail-pj1-x1033.google.com with SMTP id m24-20020a17090a7f98b0290178b1a81700so1895808pjl.4;
        Mon, 16 Aug 2021 12:34:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ejh96zdQFAkMHSu0phVaYzWKBUJVVpTVNRQtzX1VTHM=;
        b=GJuj1BP5zsSHoKXqpU1iu16LajzlZcspHrUcQQYVmuvhrwS24Zy0+JKsEz1up6Kesg
         aqALBJsAoNhyRy1ZYGGJKCgiOraNg0/gE9zBQUdbq/fc2ZCXyUqgOy5rBGtSRL5QSLLl
         kfjHwx6/87YgNPRGzBgNUfj0XXdrcid/WyLmPC/COfJCCluYwtfv19/yWJN911Up+1SE
         hdvo+XDIOqiB+SMpFOPweodXPxiJIo9cNOyQY16gyvRGt9LbYe57HBZRkNxY5nvSa5nR
         OsvD5ORmfyU0xg5Gz8lSdbGfbOxXgf79MZfapQuK150hMd+j7kOLqKOHIy77XFP0c2pJ
         +WVA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ejh96zdQFAkMHSu0phVaYzWKBUJVVpTVNRQtzX1VTHM=;
        b=Zju3rBSGVpxN/e9TfsfcbH/QMsnybwOx5ij/NcUNgwOSsf71JPS7Hoz1Bi2E3tPK3E
         VhgaQ5gLMGzoGOqCxR/dsZp12vrvOFc4zUPZ0O7VuX6/OqgWhc/0b7bqK79OXcrRn17u
         V8vL+KKhH8srUA9oEWMPirlrFBZQ1sOVdb9KflLygCR5JVKsEgLKPVKV6+XaCbe8KP9J
         Kp3dpmaBVT2f2nC3drq7vL4UsR4CpfKpknbp/pzwFsiyMvYj5fldVQ2SB6FWr+n1baEl
         nXRO3aTXhQhOPkJtcNcJa2jEWePtd5R1uegm3AAH0SIbQXjfdkpOC8I8TUSFhyPhptJg
         HvWg==
X-Gm-Message-State: AOAM533lWWwEPcq6ItpxD6XHw0rhgerznZiXCI6fsPhJm6+cSznwqj86
        seQ7q5rCFol+xVJh+0by/ay9KxwojT+ncTxPubpLIuXDu2lCeg==
X-Google-Smtp-Source: ABdhPJz1r52KUqwqRKHoUXIzD/qS8GQ8VTkQ7X7wG1bdRbrUJlGa7mj7UCTq98Sk8EVFNvF9+DFY/g9it8YPfaWZk9E=
X-Received: by 2002:a17:902:e786:b029:12d:2a7:365f with SMTP id
 cp6-20020a170902e786b029012d02a7365fmr347027plb.21.1629142452568; Mon, 16 Aug
 2021 12:34:12 -0700 (PDT)
MIME-Version: 1.0
References: <20210816115953.72533-1-andriy.shevchenko@linux.intel.com>
 <20210816115953.72533-3-andriy.shevchenko@linux.intel.com> <CAMpxmJWrCJb6JJtQVurM3UexPwqz1OuydE9NvxyRwBb5hD=7aQ@mail.gmail.com>
In-Reply-To: <CAMpxmJWrCJb6JJtQVurM3UexPwqz1OuydE9NvxyRwBb5hD=7aQ@mail.gmail.com>
From:   Andy Shevchenko <andy.shevchenko@gmail.com>
Date:   Mon, 16 Aug 2021 22:33:36 +0300
Message-ID: <CAHp75VexePKtMRXRuT-7pY=qEZgBkostYFEaOxaHZoi3=UpniA@mail.gmail.com>
Subject: Re: [PATCH v1 2/6] gpio: mlxbf2: Drop wrong use of ACPI_PTR()
To:     Bartosz Golaszewski <bgolaszewski@baylibre.com>
Cc:     Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        David Thompson <davthompson@nvidia.com>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-gpio <linux-gpio@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Asmaa Mnebhi <asmaa@nvidia.com>,
        Liming Sun <limings@nvidia.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 16, 2021 at 10:21 PM Bartosz Golaszewski
<bgolaszewski@baylibre.com> wrote:
> On Mon, Aug 16, 2021 at 2:00 PM Andy Shevchenko
> <andriy.shevchenko@linux.intel.com> wrote:

...

> >  static const struct acpi_device_id __maybe_unused mlxbf2_gpio_acpi_match[] = {
> >         { "MLNXBF22", 0 },
> > -       {},
> > +       {}
>
> Ninja change :) I removed it -

Thanks!

> send a separate patch for this if you want to.

I don't think it's needed per se right now.

-- 
With Best Regards,
Andy Shevchenko
