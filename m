Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DDEA226D73
	for <lists+netdev@lfdr.de>; Mon, 20 Jul 2020 19:47:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732503AbgGTRo4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 13:44:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729820AbgGTRo4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 13:44:56 -0400
Received: from mail-io1-xd43.google.com (mail-io1-xd43.google.com [IPv6:2607:f8b0:4864:20::d43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C18A2C061794;
        Mon, 20 Jul 2020 10:44:55 -0700 (PDT)
Received: by mail-io1-xd43.google.com with SMTP id i4so18449090iov.11;
        Mon, 20 Jul 2020 10:44:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=paf3tY7/j8+71DpSc8B+D4XdLMS+vGMHNSceR0s5vuk=;
        b=CIoS9nmwIWzwodnFDZ+bG+382eJ7Ik0PWc9YsGcHOwK19dwQj0B8Sx/jv3ZZXF2HK+
         FXZR3/2YNJHji4N8MBf6wNrCBjyLorHBucjUWXOBplmm5XuD+vWSNo1AbZe/x3pLUyIs
         VHpBlJucocDJ6XYeXqOlxyIr7weD6Z9EfWxyYm7yR/w/BP4ENPvpiGlBOF2MU7SjG3FP
         wDva1e64MI3Ue2BCM+zs4q9kCJ3p4h5OdZmyc+EfQYYk7pJofSMXJtbkzAOc3s2XrLkY
         1mmhsbmJGBKlcxrsSaG2gx6dIzrVvz25i/LvT3PqiA5ow9jOOy6JVfqjklogwrhphjot
         uRwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=paf3tY7/j8+71DpSc8B+D4XdLMS+vGMHNSceR0s5vuk=;
        b=YeTu9zKjnFiAZCP59yYNcfZew2bEDtGUh3TfCOD8QVo8wFx0qLWQ7uKwZi12j8vG79
         gxZ0rUaS/UZpjKyeOvGiKNJyawGhNn6W+5vzMfJMJX6LGWtf6/kxN84JN129O1rIRcIN
         O6lmzRb8ug+P5/pJnPZGqqubJYr0+ad34xTm3V6J11UfIYl4ej1igv6Ua73gm+fXM6k7
         0KLSqF3Ysl+RJbfF0j5xENRm9lgok7xz8BCF6znMnESLIdiHhSpOwLL2Y8l/u5fwmOZf
         v9CZlM5st13O9+xeO2kt2iy0tl0/5mYYUh6bBmzuaUk1nxU/Er3pdZEtHTgWe6Q2k7Sj
         Xu6g==
X-Gm-Message-State: AOAM532MCg+u8IMasr7cx7RceO93d2u/QPzOtsY+wLYlYfv6yOdNfqsL
        b39Q96J1KMCufT8UYlIAaDDR0QVogBdbeqleBZk=
X-Google-Smtp-Source: ABdhPJyPMI4EAg1FEqf1Bwnb296Q2klr8N86aXoz2bz0cIYNwSvdcZyxGwCN3nsXfTzzDCae/5zUnoglUW6fsyURdf4=
X-Received: by 2002:a02:ce9a:: with SMTP id y26mr27860178jaq.121.1595267095076;
 Mon, 20 Jul 2020 10:44:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200719154836.59873-1-grandmaster@al2klimov.de>
In-Reply-To: <20200719154836.59873-1-grandmaster@al2klimov.de>
From:   Alexander Duyck <alexander.duyck@gmail.com>
Date:   Mon, 20 Jul 2020 10:44:44 -0700
Message-ID: <CAKgT0Ud4jwxD_NHqLdcWXJSdVJ3CZtzosCwODtdfKnV48GfPfQ@mail.gmail.com>
Subject: Re: [PATCH for v5.9] Documentation: intel: Replace HTTP links with
 HTTPS ones
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        intel-wired-lan <intel-wired-lan@lists.osuosl.org>,
        Netdev <netdev@vger.kernel.org>, linux-doc@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jul 19, 2020 at 8:49 AM Alexander A. Klimov
<grandmaster@al2klimov.de> wrote:
>
> Rationale:
> Reduces attack surface on kernel devs opening the links for MITM
> as HTTPS traffic is much harder to manipulate.
>
> Deterministic algorithm:
> For each file:
>   If not .svg:
>     For each line:
>       If doesn't contain `\bxmlns\b`:
>         For each link, `\bhttp://[^# \t\r\n]*(?:\w|/)`:
>           If neither `\bgnu\.org/license`, nor `\bmozilla\.org/MPL\b`:
>             If both the HTTP and HTTPS versions
>             return 200 OK and serve the same content:
>               Replace HTTP with HTTPS.
>
> Signed-off-by: Alexander A. Klimov <grandmaster@al2klimov.de>
> ---
>  Continuing my work started at 93431e0607e5.
>  See also: git log --oneline '--author=Alexander A. Klimov <grandmaster@al2klimov.de>' v5.7..master
>  (Actually letting a shell for loop submit all this stuff for me.)
>
>  If there are any URLs to be removed completely
>  or at least not (just) HTTPSified:
>  Just clearly say so and I'll *undo my change*.
>  See also: https://lkml.org/lkml/2020/6/27/64
>
>  If there are any valid, but yet not changed URLs:
>  See: https://lkml.org/lkml/2020/6/26/837
>
>  If you apply the patch, please let me know.
>
>  Sorry again to all maintainers who complained about subject lines.
>  Now I realized that you want an actually perfect prefixes,
>  not just subsystem ones.
>  I tried my best...
>  And yes, *I could* (at least half-)automate it.
>  Impossible is nothing! :)
>
>
>  Documentation/networking/device_drivers/intel/e100.rst  | 4 ++--
>  Documentation/networking/device_drivers/intel/e1000.rst | 2 +-
>  Documentation/networking/device_drivers/intel/fm10k.rst | 2 +-
>  Documentation/networking/device_drivers/intel/iavf.rst  | 2 +-
>  Documentation/networking/device_drivers/intel/igb.rst   | 2 +-
>  Documentation/networking/device_drivers/intel/igbvf.rst | 2 +-
>  Documentation/networking/device_drivers/intel/ixgb.rst  | 2 +-
>  7 files changed, 8 insertions(+), 8 deletions(-)
>
> diff --git a/Documentation/networking/device_drivers/intel/e100.rst b/Documentation/networking/device_drivers/intel/e100.rst
> index 3ac21e7119a7..3d4a9ba21946 100644
> --- a/Documentation/networking/device_drivers/intel/e100.rst
> +++ b/Documentation/networking/device_drivers/intel/e100.rst
> @@ -41,7 +41,7 @@ Identifying Your Adapter
>
>  For information on how to identify your adapter, and for the latest Intel
>  network drivers, refer to the Intel Support website:
> -http://www.intel.com/support
> +https://www.intel.com/support
>
>  Driver Configuration Parameters
>  ===============================
> @@ -179,7 +179,7 @@ filtering by
>  Support
>  =======
>  For general information, go to the Intel support website at:
> -http://www.intel.com/support/
> +https://www.intel.com/support/
>
>  or the Intel Wired Networking project hosted by Sourceforge at:
>  http://sourceforge.net/projects/e1000
> diff --git a/Documentation/networking/device_drivers/intel/e1000.rst b/Documentation/networking/device_drivers/intel/e1000.rst
> index 4aaae0f7d6ba..9d99ff15d737 100644
> --- a/Documentation/networking/device_drivers/intel/e1000.rst
> +++ b/Documentation/networking/device_drivers/intel/e1000.rst
> @@ -44,7 +44,7 @@ NOTES:
>          For more information about the InterruptThrottleRate,
>          RxIntDelay, TxIntDelay, RxAbsIntDelay, and TxAbsIntDelay
>          parameters, see the application note at:
> -        http://www.intel.com/design/network/applnots/ap450.htm
> +        https://www.intel.com/design/network/applnots/ap450.htm

So I think this link is broken. What it leads you to is not the
application note. We should either find the replacement link or just
drop this reference.
