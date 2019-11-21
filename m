Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99852105A36
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 20:13:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726541AbfKUTNa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 14:13:30 -0500
Received: from mail-wr1-f68.google.com ([209.85.221.68]:41685 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726279AbfKUTN3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 14:13:29 -0500
Received: by mail-wr1-f68.google.com with SMTP id b18so5795035wrj.8
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 11:13:26 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CXQuxrRQoCyWu6YDz1zdqUWiSE3V0JRNZZrfQweWpOI=;
        b=ZaWedUXmb/Exr8HwSEADOVrLACPMcLO4thSoxgECBvH28QmGMhahpPcAqCrWk9jkoe
         YYHfCUtyhO9muZXz8ckalyzQIVc+G7oLlJKcs5ZTaTpwCq+WIKCdcifqOlOy+Qjv4oTr
         O5j/tX0L04YCXPyrExHkB0xB5ybgJdRQc/+xB8DyjgifDvl0h6bCs+aNby6ti0b9R2nb
         BueaAtG1dkHWH4K8zDAHW5uaK3aomDeuYlNPeJMkqwkNKZEoBM9TeIh5HdxA8LjAe90G
         YzDh7Yjye3J0TG4M78bFlHidHSjEF3X9ySld4Ik5GMzrr8FcsZuxJjprl2iFZYDoNDNh
         X1Ig==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CXQuxrRQoCyWu6YDz1zdqUWiSE3V0JRNZZrfQweWpOI=;
        b=Jc52s6ZBecdHD5ir+zUuaA52P/shlxN3NwgtAsJyxlmBT4zIXmGI9KZNc/iklKUFRt
         w+RFJIQQ/WYnisQlPx1lzJz/ryURzV/8883KKdxdvHJ6kg/MQlExVKgIrcB+au1e/ut+
         tfYViUQY8TlgHt2g3mTZeMF8gfRgTrVQjfhPor+rN2FT6dHlsFQlTqhRWA+3V4LRS7LX
         EflW5o5anumqRumQ9PoLmr+PL7Z1r1aFTSbSTpGp4YI+dCFG/sS33mEssJSrXD64QWmm
         qeDYA/KMGWTFMeVzmv+Qepf8eWHDW7DlOqCK45UWppFyXD3LsZBZqr/pxH613wcAtp/w
         Tlyg==
X-Gm-Message-State: APjAAAX9rhW76Z2+6p4M53TfhyVJ2TDfYkRM48C4mBWYRkF9e+qGn/Vl
        Hm2yz8q+zgE7q/TbYhjP7PIpWuAH7yEerUMz7a7YhaTimGk=
X-Google-Smtp-Source: APXvYqySa4u9+OihpeplglpmocYbO1xuPKSjCOSy5MdyCsBgZWWO3AObetu13mwETIqDTnTwz32/F2tWS9nVpy5rMis=
X-Received: by 2002:a5d:4e0a:: with SMTP id p10mr12506503wrt.229.1574363606056;
 Thu, 21 Nov 2019 11:13:26 -0800 (PST)
MIME-Version: 1.0
References: <1574272086-21055-1-git-send-email-sunil.kovvuri@gmail.com>
 <1574272086-21055-17-git-send-email-sunil.kovvuri@gmail.com>
 <20191120164137.6f66a560@cakuba.netronome.com> <CA+sq2CdbXgdsGjG-+34mNztxJ-eQkySB6k2SumkXMUkp7bKtwQ@mail.gmail.com>
 <20191121104316.1bd09fcb@cakuba.netronome.com>
In-Reply-To: <20191121104316.1bd09fcb@cakuba.netronome.com>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Fri, 22 Nov 2019 00:43:14 +0530
Message-ID: <CA+sq2Cfv25A0RW4h_KXi=74g=F61o=KPXyEH7HMisxx1tp8PeA@mail.gmail.com>
Subject: Re: [PATCH v3 16/16] Documentation: net: octeontx2: Add RVU HW and
 drivers overview.
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 22, 2019 at 12:13 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:
>
> On Thu, 21 Nov 2019 08:19:29 +0530, Sunil Kovvuri wrote:
> > > Thanks for the description, I was hoping you'd also provide more info
> > > on how the software componets of the system fit together. Today we only
> > > have an AF driver upstream. Without the PF or VF drivers the card is
> > > pretty much unusable with only the upstream drivers, right?
> >
> > I will start submitting netdev drivers (PF and VF) right after this patchset.
> > And just FYI this is not a NIC card, this HW is found only on the ARM64
> > based OcteonTX2 SOC.
>
> Right, that's kind of my point, it's not a simple NIC, so we want
> to know what are all the software components. How does a real life
> application make use of this HW.
>
> Seems like your DPDK documentation lays that out pretty nicely:
>
> https://doc.dpdk.org/guides/platform/octeontx2.html
>
> It appears the data path components are supposed to be controlled by
> DPDK.
>
> After reading that DPDK documentation I feel like you'd need to do some
> convincing to prove it makes sense to go forward with this AF driver at
> all. For all practical purposes nobody will make use of this HW other
> than through the DPDK-based SDK, so perhaps just keep your drivers in
> the SDK and everyone will be happy?

Based on what you concluded that nobody would use the HW otherthan with DPDK ?

Just because it's not a NIC, it doesn't mean it cannot be used with
applications otherthan DPDK.
Imagine a server (on the lines of Intel xeon) with on-chip NIC instead
of a external PCIe NIC.
A server machine is used for lots of workload applications which are
not DPDK based.
Marvell's ThunderX machine is one such example,
- It is an SoC with an on-chip NIC.
- Both kernel and DPDK network drivers are upstreamed.
  kernel: drivers/net/ethernet/cavium/thunder
  DPDK: https://doc.dpdk.org/guides/nics/thunderx.html

Even for a DPDK only application, there is still a management ethernet
needed to which user can do ssh etc
when there is no console available. And there is no need to supply
whole SDK to customer, just supply
firmware, get latest kernel and DPDK from mainline and use it.

Sorry, i don't understand why a driver for on-chip ethernet cannot be
upstreamed.

Thanks,
Sunil.
