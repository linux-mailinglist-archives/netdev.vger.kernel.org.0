Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 757B7E82C
	for <lists+netdev@lfdr.de>; Mon, 29 Apr 2019 18:54:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728834AbfD2QyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Apr 2019 12:54:19 -0400
Received: from mail-it1-f193.google.com ([209.85.166.193]:56318 "EHLO
        mail-it1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728520AbfD2QyS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Apr 2019 12:54:18 -0400
Received: by mail-it1-f193.google.com with SMTP id w130so79471itc.5;
        Mon, 29 Apr 2019 09:54:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=c3wXl+d8QpRCeQBpTfTs111VOjqG2CYn/DIy4oZq6QY=;
        b=KQ7yRSXztHjL+Q5e2DdBr+uDBq/f/WjST1LqsFfMUE022DOyKtd0jotbyoCnVOktfz
         BKCLbBDX6ERxomEu5K201InwMg7W3jt/wdYlEWTlVc4lCIbswMh3bA97rompXtZGpqta
         06OEvmXjtz/RKnYYbhc7+yVKSc1q3bAM9ShXX/IWatt+HaN2nL8AfURlwZ1RoWkeshMI
         fxSBwRHYosqDFlBrlwmkiP3RIJHYZ7HDQAEda6YJ4hbHJl8EoCjc8TTP5IhPnrS+Q1mA
         dYG7/oo3zYy6ckuzD13jwyvY+C08qMXqci5rTej0rLcTN2je2YxBlftaKScXMMjBXudr
         OHwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=c3wXl+d8QpRCeQBpTfTs111VOjqG2CYn/DIy4oZq6QY=;
        b=GnffQwtOIVKYGCxjBDbFR9Ph7JZ1CBZw5vcbaAaqdRAXhz78TMA6eAv3oWfMYfDs5k
         B84KpC9wPf/wUio56qSrrS3CyH9uBzAqUEBRdNY6aghlcZ7N+JoTl3vBNofH/jnbZeSm
         5759LnpsQONPML4X35e+H7Qq0vq3cBhIsx5mVDbBl5k7V7DQVVI0eO3YafYFq4uF8fFH
         pryC3MhPML4/ELjyWkNeSu07yYBP/V8pynPlDrRFJsylrjRbp5SxJfvP3TWZR18+b8xa
         VQZ+WSIGXPsy7PxguzyeOGu5nvQPQzxVx46NGsGj1VNtNqvY4orpHyzRXFEUHiFnC6RL
         nCNQ==
X-Gm-Message-State: APjAAAX/srpyaUmSNSXr8lBFelcEM2Q2hfA1FsgxcP+LgrTSai9q548W
        21tANotW2LDhANmeOcAXqYqHDCbQCPO73PPsOsw=
X-Google-Smtp-Source: APXvYqyOBs9giJ5gQTxUUHXBcm8E1SVNNupBzYljk/EUDFjBy10i314DgxqQVrKR74VxDGtN90GShI5S1GOoljF9eok=
X-Received: by 2002:a02:ad15:: with SMTP id s21mr31604749jan.79.1556556857848;
 Mon, 29 Apr 2019 09:54:17 -0700 (PDT)
MIME-Version: 1.0
References: <20190426154108.52277-1-posk@google.com> <CAFTs51VUqReSAvr_pu3eUioJ2N4uOP4r4AAbGTadVoq657NY0A@mail.gmail.com>
In-Reply-To: <CAFTs51VUqReSAvr_pu3eUioJ2N4uOP4r4AAbGTadVoq657NY0A@mail.gmail.com>
From:   Captain Wiggum <captwiggum@gmail.com>
Date:   Mon, 29 Apr 2019 10:54:07 -0600
Message-ID: <CAB=W+o=yJ3Dj836FfezhoF4L4xx6fYk+aY=mxos7PNfnG3ymDQ@mail.gmail.com>
Subject: Re: [PATCH 4.9 stable 0/5] net: ip6 defrag: backport fixes
To:     Peter Oskolkov <posk@posk.io>
Cc:     stable@vger.kernel.org, linux-netdev <netdev@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        David Miller <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Florian Westphal <fw@strlen.de>,
        Sasha Levin <sashal@kernel.org>, Lars Persson <lists@bofh.nu>,
        Peter Oskolkov <posk@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

My $.02 I do not see 4.4 used much in my circles. We do not use it
anywhere at McAfee.

On Fri, Apr 26, 2019 at 3:27 PM Peter Oskolkov <posk@posk.io> wrote:
>
> On Fri, Apr 26, 2019 at 8:41 AM Peter Oskolkov <posk@google.com> wrote:
> >
> > This is a backport of a 5.1rc patchset:
> >   https://patchwork.ozlabs.org/cover/1029418/
> >
> > Which was backported into 4.19:
> >   https://patchwork.ozlabs.org/cover/1081619/
> >
> > and into 4.14:
> >   https://patchwork.ozlabs.org/cover/1089651/
> >
> >
> > This 4.9 patchset is very close to the 4.14 patchset above
> > (cherry-picks from 4.14 were almost clean).
>
> FYI: I have a patchset that backports these into 4.4, but things got
> much hairier
> there, as I needed to backport three additional netfilter patches. So I'm not
> going to send the patchset to the lists unless there is a real need and somebody
> with enough knowledge of netfitler volunteers to review/test it (I tested
> that IP defrag works, but there are netfilter-related pieces that
> I understand little about).
>
> >
> >
> > Eric Dumazet (1):
> >   ipv6: frags: fix a lockdep false positive
> >
> > Florian Westphal (1):
> >   ipv6: remove dependency of nf_defrag_ipv6 on ipv6 module
> >
> > Peter Oskolkov (3):
> >   net: IP defrag: encapsulate rbtree defrag code into callable functions
> >   net: IP6 defrag: use rbtrees for IPv6 defrag
> >   net: IP6 defrag: use rbtrees in nf_conntrack_reasm.c
> >
> >  include/net/inet_frag.h                   |  16 +-
> >  include/net/ipv6.h                        |  29 --
> >  include/net/ipv6_frag.h                   | 111 +++++++
> >  net/ieee802154/6lowpan/reassembly.c       |   2 +-
> >  net/ipv4/inet_fragment.c                  | 293 ++++++++++++++++++
> >  net/ipv4/ip_fragment.c                    | 295 +++---------------
> >  net/ipv6/netfilter/nf_conntrack_reasm.c   | 273 +++++-----------
> >  net/ipv6/netfilter/nf_defrag_ipv6_hooks.c |   3 +-
> >  net/ipv6/reassembly.c                     | 361 ++++++----------------
> >  net/openvswitch/conntrack.c               |   1 +
> >  10 files changed, 631 insertions(+), 753 deletions(-)
> >  create mode 100644 include/net/ipv6_frag.h
> >
> > --
> > 2.21.0.593.g511ec345e18-goog
> >
