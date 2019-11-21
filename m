Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBDC5105A8E
	for <lists+netdev@lfdr.de>; Thu, 21 Nov 2019 20:45:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726784AbfKUTpy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Nov 2019 14:45:54 -0500
Received: from mail-wm1-f66.google.com ([209.85.128.66]:34826 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726541AbfKUTpy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Nov 2019 14:45:54 -0500
Received: by mail-wm1-f66.google.com with SMTP id 8so5138563wmo.0
        for <netdev@vger.kernel.org>; Thu, 21 Nov 2019 11:45:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=LzKHuGPaDpfBiE5L/Bor+qx0lYStmlI4MDGNB32AfCE=;
        b=vNCyQFHop52uYR9Wug+28cXl3mftTbyXLXc/QYwkZZWEb1O2qmiD9O2EfZu7D5LqUP
         VPnvGE9mgU17bqRZAoMkAxGFo5kjWZhJ0Gcp6+UN1E8eNTPJVgS927ZYsH6i/3mS01by
         fQdbrGWHUC2Oy+FG9Kkd4OG1YzT/f4Lik7tr2y2+/6N7A1t5bRm50Zqaiw8bKcElQNlN
         xzCOADDm5F5JxJzMCk1HXcU7SSoH7fGrQdWv/vDiTmVDLCKhjSqw3ZbRRIpeR1b8bT9J
         mzaB6alGR7zNFdvLZwWwpkt7Lr+0h7Ng1KxB9CydXyyZSiEJOfLcrWNe3pzHyQS+uBIZ
         iC5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=LzKHuGPaDpfBiE5L/Bor+qx0lYStmlI4MDGNB32AfCE=;
        b=bpvxFkFHoVBcsaLuYOT/iksVU+wmhLKqTkZ+LR5bSv37zWxI3/cNjoBEHTSBEX9oE6
         XO97SRvkCsrtuTzZ6QP9Oc/e3ajGCokCmd+6vDdjAhvSWquKdYQWBuTEzZg2BJzlMRK4
         2fUMb41vSsuTjXNbEJXL0jlkUpjVWW9+o0KkbvkH8x9mFnWuE3MFfEsu/nuMmZsy7zic
         w7sQPeiOxjQ44xHHgACellz+2wHw/sny1EaWJK5bb3C32PsauB0Us9Vzhlip7IwLEnIe
         eS+HADVLaKcxCqMc+15EeZftrLlraYDSv6kJlA5/li0WoVbDirHaZdSHSGjdC7MerwHN
         H8Xg==
X-Gm-Message-State: APjAAAVsv5cOhb1CJcphoWH68eSXsk/ZV+G/IRJM2uFpyhjIEIoLf0Aa
        5x2h+xp5XHEwQxBzpF1c3iRFNpbQ/W7q5gsoUSFiL3/qVVQ=
X-Google-Smtp-Source: APXvYqw0ZZf2q3SUdEmXxsIohGf4TgPEPJpKRblNnLV+qXkLn9XqFC0iT26Xa8RepoZM9oYAy7pmOn+7olDoi1OTVXQ=
X-Received: by 2002:a05:600c:2919:: with SMTP id i25mr11990978wmd.158.1574365552003;
 Thu, 21 Nov 2019 11:45:52 -0800 (PST)
MIME-Version: 1.0
References: <1574272086-21055-1-git-send-email-sunil.kovvuri@gmail.com>
 <1574272086-21055-17-git-send-email-sunil.kovvuri@gmail.com>
 <20191120164137.6f66a560@cakuba.netronome.com> <CA+sq2CdbXgdsGjG-+34mNztxJ-eQkySB6k2SumkXMUkp7bKtwQ@mail.gmail.com>
 <20191121104316.1bd09fcb@cakuba.netronome.com> <CA+sq2Cfv25A0RW4h_KXi=74g=F61o=KPXyEH7HMisxx1tp8PeA@mail.gmail.com>
 <20191121112335.7c2916d8@cakuba.netronome.com>
In-Reply-To: <20191121112335.7c2916d8@cakuba.netronome.com>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Fri, 22 Nov 2019 01:15:40 +0530
Message-ID: <CA+sq2CcCYUekJjxfM_crrQxiP5j1dHqixVvHWKO9YtcfaVVcFw@mail.gmail.com>
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

On Fri, Nov 22, 2019 at 12:53 AM Jakub Kicinski
<jakub.kicinski@netronome.com> wrote:

> > > It appears the data path components are supposed to be controlled by
> > > DPDK.
> > >
> > > After reading that DPDK documentation I feel like you'd need to do some
> > > convincing to prove it makes sense to go forward with this AF driver at
> > > all. For all practical purposes nobody will make use of this HW other
> > > than through the DPDK-based SDK, so perhaps just keep your drivers in
> > > the SDK and everyone will be happy?
> >
> > Based on what you concluded that nobody would use the HW otherthan with DPDK ?
>
> Based on the fact that you only have a DPDK SDK for it?

Again how do you know there is only DPDK SDK available with us ?
Just by reading DPDK documentation, is it right to conclude that way.

>
> > Just because it's not a NIC, it doesn't mean it cannot be used with
> > applications otherthan DPDK.
> > Imagine a server (on the lines of Intel xeon) with on-chip NIC instead
> > of a external PCIe NIC.
> > A server machine is used for lots of workload applications which are
> > not DPDK based.
> > Marvell's ThunderX machine is one such example,
> > - It is an SoC with an on-chip NIC.
> > - Both kernel and DPDK network drivers are upstreamed.
> >   kernel: drivers/net/ethernet/cavium/thunder
> >   DPDK: https://doc.dpdk.org/guides/nics/thunderx.html
>
> Are you saying someone will use a Octeon as just an ARM
> server? Seriously someone will buy an NPU and use it for
> something else than network processing?

If a Intel machine with external NIC can be used for something otherthan
pure network processing, then why can't this. I am not saying this is 'the'
intended application, just giving an example of the previous silicon
with on-chip NIC.

There are many other things, can use it for NFVs, containers, virtual machines
with PF (netdev) in kernel and VFs in userspace. There are many real
life applications.

>
> > Even for a DPDK only application, there is still a management ethernet
> > needed to which user can do ssh etc
> > when there is no console available. And there is no need to supply
> > whole SDK to customer, just supply
> > firmware, get latest kernel and DPDK from mainline and use it.
> >
> > Sorry, i don't understand why a driver for on-chip ethernet cannot be
> > upstreamed.
>
> Well you didn't bother to upstream it until now. You're just pushing
> admin parts of your DPDK solution. Can you honestly be surprised the
> upstream netdev community doesn't like that?

Yes, I am very well aware of the fact that upstream netdev community
doesn't like DPDK.
I did attend couple of netdev conferences where it was loudly said
"DPDK is not kernel" :-)

And yes I agree there was a long gap in between, but this time i am
going to publish PF/VF netdev drivers.

Thanks,
Sunil.
