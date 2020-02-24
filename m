Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5BDE916AC3B
	for <lists+netdev@lfdr.de>; Mon, 24 Feb 2020 17:53:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727785AbgBXQxs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 11:53:48 -0500
Received: from mail-ot1-f65.google.com ([209.85.210.65]:46473 "EHLO
        mail-ot1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727108AbgBXQxs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Feb 2020 11:53:48 -0500
Received: by mail-ot1-f65.google.com with SMTP id g64so9282489otb.13;
        Mon, 24 Feb 2020 08:53:47 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=S2CeuYhms+z1RLjkpC6tLN0iv2u2YH/Af1uxvbwpDpg=;
        b=rVTf8sZ32BA+n/zdM7J5lo58/3mVpRqV9XSU+weDOOWmBarT00ZhCaEb8kN9Xgm5oz
         EB2HM0ank0a8N+46zYuCfcblIjUsek+nq+Y4oIcXekC1/M10lEyCRS1k+6y5DxF9veoN
         OCO44NwishG/sPbsHWT4H7DgIczRACNFA0pzAS/Od/OhDbpHAM3sEtEMWA1U4HgCDxxb
         KzZJNEa8U1s5NcxddsI24abtW1LvOaxy/xLZPNzzMq27nCLhA1cG0bm/pTphIEmU0fOf
         ECvq7hOxr5fJMvAJK6ukMk4QxrhreyJ+gS84SeuJMGmWUEs5b/TOf8Osx9LRwCzHtZtv
         INrA==
X-Gm-Message-State: APjAAAUlUJBmcl/vtI59OVnDNi4gXfOJa9jKutjLvLV3lQmxFzUJG4Lt
        Oz6wLuVWQq+g/32y2jJiLxrE03ZvgOH+Vyn0cRGu/NWi
X-Google-Smtp-Source: APXvYqyGK3OqOj92NWHszGCNXUvRgUjBl2iL47YctM916YkCVbfv6s3X6VxFSCUI14iFLaP88lOPlqU3M04zewZX9QM=
X-Received: by 2002:a05:6830:1d4:: with SMTP id r20mr25938558ota.107.1582563227313;
 Mon, 24 Feb 2020 08:53:47 -0800 (PST)
MIME-Version: 1.0
References: <20150624.063911.1220157256743743341.davem@davemloft.net>
 <CA+55aFybr6Fjti5WSm=FQpfwdwgH1Pcfg6L81M-Hd9MzuSHktg@mail.gmail.com>
 <CAMuHMdViacgi1W8acma7GhWaaVj92z6pg-g7ByvYOQL-DToacA@mail.gmail.com>
 <20200224124732.GA694161@kroah.com> <20200224163312.GC4526@unreal> <10EE986F-E1F6-44F3-A025-6F2CA820C690@redhat.com>
In-Reply-To: <10EE986F-E1F6-44F3-A025-6F2CA820C690@redhat.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 24 Feb 2020 17:53:36 +0100
Message-ID: <CAMuHMdWCBKS_gSfeAHG-asS+tK_s+MjaeRXXa+krEgoBtB6pvg@mail.gmail.com>
Subject: Re: [GIT] Networking
To:     Doug Ledford <dledford@redhat.com>
Cc:     Leon Romanovsky <leon@kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        David Miller <davem@davemloft.net>,
        "Weiny, Ira" <ira.weiny@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Network Development <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Doug et al,

On Mon, Feb 24, 2020 at 5:36 PM Doug Ledford <dledford@redhat.com> wrote:
> > On Feb 24, 2020, at 11:33 AM, Leon Romanovsky <leon@kernel.org> wrote:
> > On Mon, Feb 24, 2020 at 01:47:32PM +0100, Greg KH wrote:
> >> On Mon, Feb 24, 2020 at 11:01:09AM +0100, Geert Uytterhoeven wrote:
> >>> On Thu, Jun 25, 2015 at 1:38 AM Linus Torvalds
> >>> <torvalds@linux-foundation.org> wrote:
> >>>> On Wed, Jun 24, 2015 at 6:39 AM, David Miller <davem@davemloft.net> wrote:
> >>>>>  git://git.kernel.org/pub/scm/linux/kernel/git/davem/net-next.git master
> >>>>
> >>>> On the *other* side of the same conflict, I find an even more
> >>>> offensive commit, namely commit 4cd7c9479aff ("IB/mad: Add support for
> >>>> additional MAD info to/from drivers") which adds a BUG_ON() for a
> >>>> sanity check, rather than just returning -EINVAL or something sane
> >>>> like that.
> >>>>
> >>>> I'm getting *real* tired of that BUG_ON() shit. I realize that
> >>>> infiniband is a niche market, and those "commercial grade" niche
> >>>> markets are more-than-used-to crap code and horrible hacks, but this
> >>>> is still the kernel. We don't add random machine-killing debug checks
> >>>> when it is *so* simple to just do
> >>>>
> >>>>        if (WARN_ON_ONCE(..))
> >>>>                return -EINVAL;
> >>>>
> >>>> instead.
> >>>
> >>> And if we follow that advice, friendly Greg will respond with:
> >>> "We really do not want WARN_ON() anywhere, as that causes systems with
> >>> panic-on-warn to reboot."
> >>> https://lore.kernel.org/lkml/20191121135743.GA552517@kroah.com/
> >>
> >> Yes, we should not have any WARN_ON calls for something that userspace
> >> can trigger, because then syzbot will trigger it and we will get an
> >> annoying report saying to fix it :)
> >
> > Impressive backlog :)
> > Geert, you replied on original discussion from 2015.

Oops.
I was looking up a recent net commit that was part of Dave's last pull
request, couldn't find what I was looking for, and must have suddenly
ended up in the email for an old pull request instead (they're all called
"[GIT] Networking")...

> Yeah, that threw me for a loop too ;-).  Took several double takes on that one just to make sure none of the IB comments from Linus were related to anything current!

Sorry for that. I hope I didn't cause any lost heartbeats.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
