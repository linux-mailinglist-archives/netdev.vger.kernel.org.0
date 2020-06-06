Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D0B21F06D6
	for <lists+netdev@lfdr.de>; Sat,  6 Jun 2020 15:48:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726466AbgFFNsF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 6 Jun 2020 09:48:05 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726078AbgFFNsE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 6 Jun 2020 09:48:04 -0400
Received: from mail-io1-xd42.google.com (mail-io1-xd42.google.com [IPv6:2607:f8b0:4864:20::d42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF335C03E96A
        for <netdev@vger.kernel.org>; Sat,  6 Jun 2020 06:48:04 -0700 (PDT)
Received: by mail-io1-xd42.google.com with SMTP id k8so1223133iol.13
        for <netdev@vger.kernel.org>; Sat, 06 Jun 2020 06:48:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WmBBTtlQXF1epClnu85CZOA2p0/GnLnPtjrpIYAu2NY=;
        b=dALzad2BsM16joH8ihFBpjTUBdQG9CJD6WjxVhKfDZeEn2c8ObEx13d6/TSegkmXzv
         yhGhiYGX4Kw22C3i35Ca+804iV5GYDysFUkt9M8czyc0BCvQ3GHgDeCm0gvplCLR3pv7
         8stIuFCyJhObl6e2zWmpXx5CGQovX/MPNoMvjqMvqjucG0+RDEyvRSaxVVJNJNxWny13
         gu3qVnxPFKOdm1i0pZThkIcvb3BOJhhBRCMZc7h0bDsUoRW30S2jxEbsCLRQazoC4YKb
         tA01BPTgKqY8mCtufTH2jo2RBOzykf+4SiUwlbHFPLJAC1cMbVcs2ZncwSVM60/kZOtb
         i+zg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WmBBTtlQXF1epClnu85CZOA2p0/GnLnPtjrpIYAu2NY=;
        b=FRI26wxHFaTSg6TER51a7Bv8NIhj5J0OECJ9AQ3gnlTnU/iGNPHa3JlYsRRByPxAg+
         yDG1lUzv7NsfJO5yohiD5pmVitv+/IRNJMjuYEk9zB0S62pwA3TH/hMD+d6B5aKjEQhY
         4Kk/q9m/e5gjpZ3uSjfZi1/txjCqLKvQRQuwklusCgjIKgi+Yjdt4f8IsCtaIOFBmdQg
         oB07VUCeDopr7sefUXw6O5epXAdeQp6tQa4tYNx6QKkzhqDvb4Szim6Bxl5SkVWJ9wDW
         Z58gZH/MZX1vQr4JpqIPh6j6aYeEgextuWAT2aVN1yHIqXMjtJ3BBXLqRJbfdqY8dvtt
         Qr9A==
X-Gm-Message-State: AOAM533yRnECMHPENvlEKGgy1uzZApGE6DPdQ1z8VwXwDT5H1HwKMkr+
        NkgkSKCfO2VqJfkDSbjLVJ/LzdZfR923vg1WYIc=
X-Google-Smtp-Source: ABdhPJx5DTMf4b16NpoTPo5HfcnfmElF2HdrXPhRD0hJYeGezm7TtVd93sT7u6lm1qorjFoiTuWqpviW3ocTtiFxuwg=
X-Received: by 2002:a02:9f84:: with SMTP id a4mr13654364jam.0.1591451283072;
 Sat, 06 Jun 2020 06:48:03 -0700 (PDT)
MIME-Version: 1.0
References: <CAEyMn7a5SwQtMxrrJ-C0Jy6THZcCCPXp5ouC+jRLH4ySK-8p_A@mail.gmail.com>
 <20200606134314.kphjg6mkdbcjsx6l@lion.mk-sys.cz>
In-Reply-To: <20200606134314.kphjg6mkdbcjsx6l@lion.mk-sys.cz>
From:   Heiko Thiery <heiko.thiery@gmail.com>
Date:   Sat, 6 Jun 2020 15:47:52 +0200
Message-ID: <CAEyMn7Y2BHT24cwBMKG5sTDek5MP2pcn+WKrn3OUkJtCsz4epw@mail.gmail.com>
Subject: Re: ethtool build failure
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michal,

Am Sa., 6. Juni 2020 um 15:43 Uhr schrieb Michal Kubecek <mkubecek@suse.cz>:
>
> On Sat, Jun 06, 2020 at 03:24:22PM +0200, Heiko Thiery wrote:
> > Hi Michael et all,
> >
> > I'm digging in the reason for a failure when building ethtool with
> > buildroot [1].
> >
> > I see the following error:
> > ---
> > data/buildroot/buildroot-test/instance-0/output/host/bin/i686-linux-gcc
> > -DHAVE_CONFIG_H -I.  -I./uapi  -D_LARGEFILE_SOURCE
> > -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64 -Wall -D_LARGEFILE_SOURCE
> > -D_LARGEFILE64_SOURCE -D_FILE_OFFSET_BITS=64  -Os   -static -c -o
> > netlink/desc-rtnl.o netlink/desc-rtnl.c
> > In file included from ./uapi/linux/ethtool_netlink.h:12,
> >                  from netlink/desc-ethtool.c:7:
> > ./uapi/linux/ethtool.h:1294:19: warning: implicit declaration of
> > function '__KERNEL_DIV_ROUND_UP' [-Wimplicit-function-declaration]
> >   __u32 queue_mask[__KERNEL_DIV_ROUND_UP(MAX_NUM_QUEUE, 32)];
> >                    ^~~~~~~~~~~~~~~~~~~~~
> > ./uapi/linux/ethtool.h:1294:8: error: variably modified 'queue_mask'
> > at file scope
> >   __u32 queue_mask[__KERNEL_DIV_ROUND_UP(MAX_NUM_QUEUE, 32)];
> >         ^~~~~~~~~~
> > ---
>
> Thank you for the report. This is fixed by first part of this patch:
>
>   https://patchwork.ozlabs.org/project/netdev/patch/bb60cbfe99071fca4b0ea9e62d67a2341d8dd652.1590707335.git.mkubecek@suse.cz/
>
> I'm going to apply it (with the rest of the series) this weekend.

I will try to apply this patch and check if the failure is gone.

>
> > The problems seems to be injected by the "warning: implicit
> > declaration of function".
> >
> > When I move the __KERNEL_DIV_ROUND_UP macro right beside usage in
> > "uapi/linux/ethtool.h" the failure is gone.
> >
> > ---
> > diff --git a/uapi/linux/ethtool.h b/uapi/linux/ethtool.h
> > index d3dcb45..6710fa0 100644
> > --- a/uapi/linux/ethtool.h
> > +++ b/uapi/linux/ethtool.h
> > @@ -1288,6 +1288,11 @@ enum ethtool_sfeatures_retval_bits {
> >   * @queue_mask: Bitmap of the queues which sub command apply to
> >   * @data: A complete command structure following for each of the
> > queues addressed
> >   */
> > +/* ethtool.h epxects __KERNEL_DIV_ROUND_UP to be defined by <linux/kernel.h> */
> > +#include <linux/kernel.h>
> > +#ifndef __KERNEL_DIV_ROUND_UP
> > +#define __KERNEL_DIV_ROUND_UP(n, d) (((n) + (d) - 1) / (d))
> > +#endif
> >  struct ethtool_per_queue_op {
> >         __u32   cmd;
> >         __u32   sub_command;
> > ---
>
> This would fix the warning and error too but uapi/linux/ethtool.h is
> a sanitized copy of a kernel header which we import and do not apply
> further changes. Moreover, there is no need to have multiple definitions
> of the same macro and there is already one in internal.h.

I saw that the definition is already done in internal.h. I just did a
quick hackaround to check if the failure is gone.

Thanks!

-- 
Heiko
