Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CF1643826B0
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 10:18:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235510AbhEQIUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 04:20:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:52542 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235640AbhEQIT7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 04:19:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 787E960C3D;
        Mon, 17 May 2021 08:17:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1621239459;
        bh=BZxAEIkbSW7MbE/cKpN6ELnrkkO5GDgcmYWBCq1E9oE=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=xe+a+SfspvvC4YFLbvfFGou5Jh4ZaOJhNkVXbtGzQzDaw9YtnD2k5/AYJRH37GLz1
         HarCPEyiCvtPLqqvURKmUeKluy77qdfGcIrJi/isWCrMZQ6A5QP/7rtzd2dmdK2J0A
         3SHQ8E4iKKDOiX1B7oZK1lgB1PjMHYvnVe3bZMP0=
Date:   Mon, 17 May 2021 10:17:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Juerg Haefliger <juerg.haefliger@canonical.com>
Cc:     aaro.koskinen@iki.fi, tony@atomide.com, linux@prisktech.co.nz,
        David Miller <davem@davemloft.net>, kuba@kernel.org,
        jejb@linux.ibm.com, martin.petersen@oracle.com,
        Lee Jones <lee.jones@linaro.org>,
        Daniel Thompson <daniel.thompson@linaro.org>,
        jingoohan1@gmail.com, mst@redhat.com, jasowang@redhat.com,
        zbr@ioremap.net, pablo@netfilter.org, kadlec@netfilter.org,
        fw@strlen.de, horms@verge.net.au, ja@ssi.bg,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-crypto@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev <netdev@vger.kernel.org>, linux-scsi@vger.kernel.org,
        dri-devel@lists.freedesktop.org, linux-fbdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        linux-fsdevel@vger.kernel.org, netfilter-devel@vger.kernel.org,
        coreteam@netfilter.org, lvs-devel@vger.kernel.org,
        LKML <linux-kernel@vger.kernel.org>,
        Juerg Haefliger <juergh@canonical.com>
Subject: Re: [PATCH] treewide: Remove leading spaces in Kconfig files
Message-ID: <YKImotylLR7D4mQW@kroah.com>
References: <20210516132209.59229-1-juergh@canonical.com>
 <YKIDJIfuufBrTQ4f@kroah.com>
 <CAB2i3ZgszsUVDuK2fkUXtD72tPSgrycnDawM4VAuGGPJiA9+cA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAB2i3ZgszsUVDuK2fkUXtD72tPSgrycnDawM4VAuGGPJiA9+cA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 17, 2021 at 10:07:43AM +0200, Juerg Haefliger wrote:
> On Mon, May 17, 2021 at 7:46 AM Greg KH <gregkh@linuxfoundation.org> wrote:
> >
> > On Sun, May 16, 2021 at 03:22:09PM +0200, Juerg Haefliger wrote:
> > > There are a few occurences of leading spaces before tabs in a couple of
> > > Kconfig files. Remove them by running the following command:
> > >
> > >   $ find . -name 'Kconfig*' | xargs sed -r -i 's/^[ ]+\t/\t/'
> > >
> > > Signed-off-by: Juerg Haefliger <juergh@canonical.com>
> > > ---
> > >  arch/arm/mach-omap1/Kconfig     | 12 ++++++------
> > >  arch/arm/mach-vt8500/Kconfig    |  6 +++---
> > >  arch/arm/mm/Kconfig             | 10 +++++-----
> > >  drivers/char/hw_random/Kconfig  |  8 ++++----
> > >  drivers/net/usb/Kconfig         | 10 +++++-----
> > >  drivers/net/wan/Kconfig         |  4 ++--
> > >  drivers/scsi/Kconfig            |  2 +-
> > >  drivers/uio/Kconfig             |  2 +-
> > >  drivers/video/backlight/Kconfig | 10 +++++-----
> > >  drivers/virtio/Kconfig          |  2 +-
> > >  drivers/w1/masters/Kconfig      |  6 +++---
> > >  fs/proc/Kconfig                 |  4 ++--
> > >  init/Kconfig                    |  2 +-
> > >  net/netfilter/Kconfig           |  2 +-
> > >  net/netfilter/ipvs/Kconfig      |  2 +-
> > >  15 files changed, 41 insertions(+), 41 deletions(-)
> >
> > Please break this up into one patch per subsystem and resend to the
> > proper maintainers that way.
> 
> Hmm... How is my patch different from other treewide Kconfig cleanup
> patches like:
> a7f7f6248d97 ("treewide: replace '---help---' in Kconfig files with 'help'")
> 8636a1f9677d ("treewide: surround Kconfig file paths with double quotes")
> 83fc61a563cb ("treewide: Fix typos in Kconfig")
> 769a12a9c760 ("treewide: Kconfig: fix wording / spelling")
> f54619f28fb6 ("treewide: Fix typos in Kconfig")

Ok, I'll just ignore this and not try to suggest a way for you to get
your change accepted...

greg k-h
