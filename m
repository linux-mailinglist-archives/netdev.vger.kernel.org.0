Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B4593455C66
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 14:13:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbhKRNQM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Nov 2021 08:16:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53880 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229712AbhKRNQL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Nov 2021 08:16:11 -0500
Received: from mail-wm1-x332.google.com (mail-wm1-x332.google.com [IPv6:2a00:1450:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4315C061570
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 05:13:10 -0800 (PST)
Received: by mail-wm1-x332.google.com with SMTP id p18so5245268wmq.5
        for <netdev@vger.kernel.org>; Thu, 18 Nov 2021 05:13:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=qWcegv6ZkRbkaatJLE7hO06lvDd/+/ZmYi2cP/Z+HX0=;
        b=GFWjknjiYSVIeHrkWSxu+uOuT/qkWWDEdW+paS6d/6lTWPkh0E8R+zhS0mZf2+9gxS
         jOwjoqVRQBuLGupr+TTG51lPevG2JtwiQ27nSeeIfkGrH6Uum5mBF7eSLIBjXEv9aPzm
         OPcnZgVUAIMZgBM21ViRYvsHqbTXjwSunvzUFJkLroHAikDqFQhXjM2okw8RwSg8Tzyt
         m+PVNLnXW5x6wFPL4SM24Ea6lnqPRiahvUruDK/pJELGPj38G0jFWzXeNk9awDJVGIY6
         RNWBQPz61BL2zHM1NrZkkoZK6755BLDNfXw2Heql/z4eoAaBz0M0aviJutkN4ZyHFB7z
         hPDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=qWcegv6ZkRbkaatJLE7hO06lvDd/+/ZmYi2cP/Z+HX0=;
        b=CMaFGgeUzQtipKQWDBdGFZM3mKDZ/AKQjtozsN4r11K4wwpJ8S18UB5BPMwENpp0l+
         osMqm4bQaODjULvsplHjqJxgrK0aV0grQ8ZZBIDvgDMn/odhsPZ8e7E/9eYicQ+u7vXF
         Uw5ZW5cq5exmEmP6YSjbcpbm7AOU/Xt+S33lXQ0s7kVpBtMjFCcqs7D9X0opWZ4C197R
         RxgMXAn8Xr8aqd9RK3lsT7L2SH7iW28tDDRGRWx+RkCUhti1qXt8SLOxtsEwsIrYq3P2
         nUT8Hmr65mpiKwKDjXCFfiFML3BceiNkh/LALsAbRf/+rQpGrRZAhiu0IElBT3YI4I2w
         3dew==
X-Gm-Message-State: AOAM530+FbXSGuNP8++NpokId63xXnjsK6d8hY4IsI2n2XjKvijqT92A
        d08CR9JNZEkV9EGdvYnCVtsa/xroVneASne2GNWhzGziHyU=
X-Google-Smtp-Source: ABdhPJx1SSULhQKSDBhyLDKeuYzluttdKdvacxhta7Edku3BxKT9YwVxDDd5E9GfjlnpamXAic/Oq/dOfSa7weQPHmE=
X-Received: by 2002:a05:600c:3c85:: with SMTP id bg5mr8318268wmb.58.1637241189280;
 Thu, 18 Nov 2021 05:13:09 -0800 (PST)
MIME-Version: 1.0
References: <CACS3ZpA=QDLqXE6RyCox8sCX753B=8+JC3jSxpv+vkbKAOwkYQ@mail.gmail.com>
 <3DEFF398-F151-487E-A2F8-5AB593E4A21B@massar.ch>
In-Reply-To: <3DEFF398-F151-487E-A2F8-5AB593E4A21B@massar.ch>
From:   Juhamatti Kuusisaari <juhamatk@gmail.com>
Date:   Thu, 18 Nov 2021 15:12:57 +0200
Message-ID: <CACS3ZpDLpxNStsS61MV_yadERP=PDLJovp44M7e7YSBkadyC8g@mail.gmail.com>
Subject: Re: IPv6 Router Advertisement Router Preference (RFC 4191) behavior issue
To:     Jeroen Massar <jeroen@massar.ch>
Cc:     netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Nov 2021 at 12:49, Jeroen Massar <jeroen@massar.ch> wrote:
>
>
>
> > On 20211118, at 11:35, Juhamatti Kuusisaari <juhamatk@gmail.com> wrote:
> >
> > Hello,
> >
> > I have been testing IPv6 Router Advertisement Default Router
> > Preference on 5.1X and it seems it is not honoured by the Linux
> > networking stack. Whenever a new default router preference with a
> > higher or lower preference value is received, a new default gateway is
> > added as an ECMP route in the routing table with equal weight. This is
> > a bit surprising as RFC 4191 Sec. 3.2 mentions that the higher
> > preference value should be preferred. This part seems to be missing
> > from the Linux implementation.
>
> Do watch out that there are a couple of user space tools (yes, that thing) that think that they have to handle RAs.... and thus one might get conflicts about reasoning between the kernel doing it or that user space daemon thing.

Thanks for the heads-up. AFAIK, I am not running anything extra in the
user space of the receiving node.

Here are some more details:

1) RA with pref medium is received over enp0s8 from router X at
fe80::a00:27ff:fe90:5a8a:
::1 dev lo proto kernel metric 256 pref medium
fe80::/64 dev enp0s8 proto kernel metric 256 pref medium
fe80::/64 dev enp0s3 proto kernel metric 256 pref medium
default via fe80::a00:27ff:fe90:5a8a dev enp0s8 proto ra metric 1024
expires 273sec pref medium

2) RA with pref high is received over enp0s8 from router Y at
fe80::ffff:a00:275e:85ca:
::1 dev lo proto kernel metric 256 pref medium
fe80::/64 dev enp0s8 proto kernel metric 256 pref medium
fe80::/64 dev enp0s3 proto kernel metric 256 pref medium
default proto ra metric 1024 expires 276sec pref medium
        nexthop via fe80::a00:27ff:fe90:5a8a dev enp0s8 weight 1
        nexthop via fe80::ffff:a00:275e:85ca dev enp0s8 weight 1

i.e. the default ends up as an ECMP configuration. I would have
expected it to change to a high preference route via
fe80::ffff:a00:275e:85ca only.

BR,
--
 Juhamatti
