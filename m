Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 03E534EE78
	for <lists+netdev@lfdr.de>; Fri, 21 Jun 2019 20:13:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726321AbfFUSNN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 14:13:13 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:54731 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726080AbfFUSNM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 14:13:12 -0400
Received: by mail-wm1-f65.google.com with SMTP id g135so7115485wme.4
        for <netdev@vger.kernel.org>; Fri, 21 Jun 2019 11:13:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dEyGlTsnsKuBLwX5xX2JKI/ESGQXtRFnkrYp5ebnbEM=;
        b=jpDMD7h4CQgiptV4ihUW/bUNgJKDqTi71iQj64iG0gyAevW/vejPrbeHwJKqytGUxs
         JH//IpRhhpQq5/ACeHQIHb/A0y8Y+60JkKT9VVqp6Y5N1SSLTFYLqjmfxB5qNM8NYNEi
         wKFg81RKKrcff5f4kOgSsGDmV7e/fagFLOX3fnLvxw1/PIFWBbs5tzHdOrVuGHa16z41
         WM/EOmwP0nCV72YLzbXnExNO5PreQzUviu7SnqBKpMjro3IHKcxkQUyFnWRPHz1mLlWQ
         3fqK2GFsob1NgeqZeby50at4AgQenZ/yDnz1A0hUrXWaBs/j2FK9iNBCxwbKNfZprUtZ
         aBMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dEyGlTsnsKuBLwX5xX2JKI/ESGQXtRFnkrYp5ebnbEM=;
        b=Dj6DoI9W+wIis1H2WlC2AWAVthw9YH869wNJ8Usl9peCf/+AAHGm7YiKzqovYJ3g8/
         V4VGf3rXsj+sABBXaI2kZb/+dIP+jOLS9SGG9gTvURCVjm7SHZCEQEK3QjjOUeqeiwq+
         D5WMWfOolBvYE2fchZgA1AmuO2Goo296Dl5qBZAobnCHXj1Ej7jyxoQDqboWk6TaJqvn
         QbW7ve/uIcIxZUxp1AgNK5ZIRcC7WY4JJCkI8xin3nWfz8yScOQ9ajSuhXhON/e49C2W
         XoToD4CQPPCrWsjuTC2iKMnEo302cI/tKx180HJX0My+jzedKaCE2ZcMZGTeTowAjEMR
         f1kQ==
X-Gm-Message-State: APjAAAUwwMF4i53aQ9R1U1MG9Flg7hRQ2o3PciSARb3JQKnC8u5fB4Cr
        xWVi4wqwDnjlIm/iG1UlyOTwugbAON6OaCru53YK
X-Google-Smtp-Source: APXvYqyDZAMAe0SGrsikwsOgiVKLU6ZWCS7eXygDIMzxOPc8qc57aRbkICtb2bfT9w1wvSlQ1kgHFd43Ln85KNGdZs8=
X-Received: by 2002:a1c:3dc1:: with SMTP id k184mr5129288wma.88.1561140791059;
 Fri, 21 Jun 2019 11:13:11 -0700 (PDT)
MIME-Version: 1.0
References: <20190621163921.26188-1-puranjay12@gmail.com> <CAErSpo5TMPokae7BMY8ZcOXtW=GeGsWXX_bqS8SrZnh0pEQYxw@mail.gmail.com>
 <698d3e3614ae903ae9582547d64c6a9846629e57.camel@perches.com>
In-Reply-To: <698d3e3614ae903ae9582547d64c6a9846629e57.camel@perches.com>
From:   Bjorn Helgaas <bhelgaas@google.com>
Date:   Fri, 21 Jun 2019 13:12:58 -0500
Message-ID: <CAErSpo6iRVWU-yL5CRF_GEY7CWg5iV=Jw0BrdNV4h3Jvh5AuAw@mail.gmail.com>
Subject: Re: [PATCH 0/3] net: ethernet: atheros: atlx: Use PCI generic
 definitions instead of private duplicates
To:     Joe Perches <joe@perches.com>
Cc:     Puranjay Mohan <puranjay12@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Chris Snook <chris.snook@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 21, 2019 at 12:27 PM Joe Perches <joe@perches.com> wrote:
>
> (adding the atlx maintainers to cc)
>
> On Fri, 2019-06-21 at 12:11 -0500, Bjorn Helgaas wrote:
> > On Fri, Jun 21, 2019 at 11:39 AM Puranjay Mohan <puranjay12@gmail.com> wrote:
> > > This patch series removes the private duplicates of PCI definitions in
> > > favour of generic definitions defined in pci_regs.h.
> > >
> > > Puranjay Mohan (3):
> > >   net: ethernet: atheros: atlx: Rename local PCI defines to generic
> > >     names
> > >   net: ethernet: atheros: atlx: Include generic PCI definitions
> > >   net: ethernet: atheros: atlx: Remove unused and private PCI
> > >     definitions
> > >
> > >  drivers/net/ethernet/atheros/atlx/atl2.c | 5 +++--
> > >  drivers/net/ethernet/atheros/atlx/atl2.h | 2 --
> > >  drivers/net/ethernet/atheros/atlx/atlx.h | 1 -
> > >  3 files changed, 3 insertions(+), 5 deletions(-)
> >
> > Let's slow this down a little bit; I'm afraid we're going to overwhelm folks.
>
> I generally disagree.
>
> Consolidation of these sorts of changes are generally
> better done treewide all at once, posted as a series to
> a list and maintainers allowing time (weeks to months)
> for the specific maintainers to accept them and then
> whatever remainder exists reposted and possibly applied
> by an overall maintainer (e.g.: Dave M)
>
> > Before posting more to LKML/netdev, how about we first complete a
> > sweep of all the drivers to see what we're getting into.  It could be
> > that this will end up being more churn than it's worth.
>
> Also doubtful.
>
> Subsystem specific local PCI #defines without generic
> naming is poor style and makes treewide grep and
> refactoring much more difficult.

Don't worry, we have the same objectives.  I totally agree that local
#defines are a bad thing, which is why I proposed this project in the
first place.

I'm just saying that this is a "first-patch" sort of learning project
and I think it'll avoid some list spamming and discouragement if we
can figure out the scope and shake out some of the teething problems
ahead of time.  I don't want to end up with multiple versions of
dozens of little 2-3 patch series posted every week or two.  I'd
rather be able to deal with a whole block of them at one time.

> The atlx maintainers should definitely have been cc'd
> on these patches.
>
> Jay Cliburn <jcliburn@gmail.com> (maintainer:ATLX ETHERNET DRIVERS)
> Chris Snook <chris.snook@gmail.com> (maintainer:ATLX ETHERNET DRIVERS)
>
> Puranjay, can you please do a few things more here:
>
> 1: Make sure you use scripts/get_maintainer.pl to cc the
>    appropriate people.
>
> 2: Show that you compiled the object files and verified
>    where possible that there are no object file changes.

Do you have any pointers for the best way to do this?  Is it as simple
as comparing output of "objdump -d"?

> 3: State that there are no object changes in the proposed
>    commit log.

Thanks for the additional tips.

Bjorn
