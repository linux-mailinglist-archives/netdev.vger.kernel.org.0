Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64427314156
	for <lists+netdev@lfdr.de>; Mon,  8 Feb 2021 22:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234837AbhBHVKs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 16:10:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233955AbhBHVK1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 16:10:27 -0500
Received: from mail-ot1-x336.google.com (mail-ot1-x336.google.com [IPv6:2607:f8b0:4864:20::336])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F3C82C061786
        for <netdev@vger.kernel.org>; Mon,  8 Feb 2021 13:09:46 -0800 (PST)
Received: by mail-ot1-x336.google.com with SMTP id 63so15574335oty.0
        for <netdev@vger.kernel.org>; Mon, 08 Feb 2021 13:09:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dZvH4fRnKKIDhOMvx3x7i/lw1s14lqNr+lPW1B4Qxvc=;
        b=M+26JNAXoHYDx4KH+q/dL3KonSWGhI6jTyA/3azoh6oAN0xWz16Z7UMDCSn0wNSiPR
         4698nsicg3EZ3InPFvambUOVl60rUUOzkPBSKfIk0xUS2YyyhXx9XHVcLBWBWIx29hjR
         tToMeW54Q/oItkkcFJGao5t9MNmvKR1ETkAcR2V/9rswS40D4+wrlM/tdmObd4nQ5wYu
         erQtFo4iIjoDdrajs7GtEJHadpnYZVjtyzM6JIBu0aRyEniKohHjNO30GE7PWjxtdgiy
         6BWh/p9mpsiaktda/3inaNhZjZcQ60J0xWa/8yU6AtnGXCFhww5uas4pyoc30cZxhcGU
         dBCQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dZvH4fRnKKIDhOMvx3x7i/lw1s14lqNr+lPW1B4Qxvc=;
        b=Crf3cideiXbvzKP4ZlZVL0rmykLUhCUqR3sajmV83SRl2WHzSMhlS1ezuZBAwe3uig
         gVMPqVmWVoPBcutImPTG2h4QjlQS08RZLjMPdVMUIiLSHsT3tNbhj43V6PKenn2HPLzb
         EWoTHkFUZtIO/TiIRC9zfuM5BT3+zQg0XI9dj4htqgSWb1kuvXCw/bulx/1ljam81cWK
         MItgFT57+7asfwfmsjQL0d1b+qmw7hxJL2qEtBQS4uLSwHQkhft6G1ejVagg8woTH6Xl
         pjuF/8eosRgSLSymNYdAtZ9pEtOKCZrsmJfVROrM8QO84OFuzDocrzXHS+zUW7cHpDy2
         VoeA==
X-Gm-Message-State: AOAM531Nblelr3IVLQd7Ke6rmdc/2yTWRBUbzfycjx7y0A11DdnzWLKd
        3M9FszdhRjXAcKKoy1GJ1ZOeGG72CAUX8McPxNItgoBBcvpS
X-Google-Smtp-Source: ABdhPJx10bJCklUqQnfOTaunXQU9xR/hiLF8U1+sqtvXK/UlUgHgpr5UKBRBlvCG7bWX5+FHcdVEMTFT6ICnmCgOcPU=
X-Received: by 2002:a05:6830:1e51:: with SMTP id e17mr13721805otj.340.1612818586276;
 Mon, 08 Feb 2021 13:09:46 -0800 (PST)
MIME-Version: 1.0
References: <20210204215926.64377-1-george.mccollister@gmail.com> <87sg6648nw.fsf@waldekranz.com>
In-Reply-To: <87sg6648nw.fsf@waldekranz.com>
From:   George McCollister <george.mccollister@gmail.com>
Date:   Mon, 8 Feb 2021 15:09:34 -0600
Message-ID: <CAFSKS=OO8oi=757b9DqOMpS4X6jqf5rg+X=GO8G-hOQ+S7LaKQ@mail.gmail.com>
Subject: Re: [PATCH net-next v2 0/4] add HSR offloading support for DSA switches
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     Jakub Kicinski <kuba@kernel.org>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 8, 2021 at 2:16 PM Tobias Waldekranz <tobias@waldekranz.com> wrote:
>
> On Thu, Feb 04, 2021 at 15:59, George McCollister <george.mccollister@gmail.com> wrote:
> > Add support for offloading HSR/PRP (IEC 62439-3) tag insertion, tag
> > removal, forwarding and duplication on DSA switches.
> > This series adds offloading to the xrs700x DSA driver.
> >
> > Changes since RFC:
> >  * Split hsr and dsa patches. (Florian Fainelli)
> >
> > Changes since v1:
> >  * Fixed some typos/wording. (Vladimir Oltean)
> >  * eliminate IFF_HSR and use is_hsr_master instead. (Vladimir Oltean)
> >  * Make hsr_handle_sup_frame handle skb_std as well (required when offloading)
> >  * Don't add hsr tag for HSR v0 supervisory frames.
> >  * Fixed tag insertion offloading for PRP.
> >
> > George McCollister (4):
> >   net: hsr: generate supervision frame without HSR/PRP tag
> >   net: hsr: add offloading support
> >   net: dsa: add support for offloading HSR
> >   net: dsa: xrs700x: add HSR offloading support
> >
> >  Documentation/networking/netdev-features.rst |  21 ++++++
> >  drivers/net/dsa/xrs700x/xrs700x.c            | 106 +++++++++++++++++++++++++++
> >  drivers/net/dsa/xrs700x/xrs700x_reg.h        |   5 ++
> >  include/linux/if_hsr.h                       |  27 +++++++
> >  include/linux/netdev_features.h              |   9 +++
> >  include/net/dsa.h                            |  13 ++++
> >  net/dsa/dsa_priv.h                           |  11 +++
> >  net/dsa/port.c                               |  34 +++++++++
> >  net/dsa/slave.c                              |  14 ++++
> >  net/dsa/switch.c                             |  24 ++++++
> >  net/dsa/tag_xrs700x.c                        |   7 +-
> >  net/ethtool/common.c                         |   4 +
> >  net/hsr/hsr_device.c                         |  46 ++----------
> >  net/hsr/hsr_device.h                         |   1 -
> >  net/hsr/hsr_forward.c                        |  33 ++++++++-
> >  net/hsr/hsr_forward.h                        |   1 +
> >  net/hsr/hsr_framereg.c                       |   2 +
> >  net/hsr/hsr_main.c                           |  11 +++
> >  net/hsr/hsr_main.h                           |   8 +-
> >  net/hsr/hsr_slave.c                          |  10 ++-
> >  20 files changed, 331 insertions(+), 56 deletions(-)
> >  create mode 100644 include/linux/if_hsr.h
> >
> > --
> > 2.11.0
>
> Hi George,
>
> I will hopefully have some more time to look into this during the coming
> weeks. What follows are some random thoughts so far, I hope you can
> accept the windy road :)
>
> Broadly speaking, I gather there are two common topologies that will be
> used with the XRS chip: "End-device" and "RedBox".
>
> End-device:    RedBox:
>  .-----.       .-----.
>  | CPU |       | CPU |
>  '--+--'       '--+--'
>     |             |
> .---0---.     .---0---.
> |  XRS  |     |  XRS  3--- Non-redundant network
> '-1---2-'     '-1---2-'
>   |   |         |   |
>  HSR Ring      HSR Ring

There is also the HSR-HSR use case and HSR-PRP use case.

>
> From the looks of it, this series only deals with the end-device
> use-case. Is that right?

Correct. net/hsr doesn't support this use case right now. It will
stomp the outgoing source MAC with that of the interface for instance.
It also doesn't implement a ProxyNodeTable (though that actually
wouldn't matter if you were offloading to the xrs700x I think). Try
commenting out the ether_addr_copy() line in hsr_xmit and see if it
makes your use case work.

>
> I will be targeting a RedBox setup, and I believe that means that the
> remaining port has to be configured as an "interlink". (HSR/PRP is still
> pretty new to me). Is that equivalent to a Linux config like this:

Depends what you mean by configured as an interlink. I believe bit 9
of HSR_CFG in the switch is only supposed to be used for the HSR-HSR
and HSR-PRP use case, not HSR-SAN.

>
>       br0
>      /   \
>    hsr0   \
>    /  \    \
> swp1 swp2 swp3
>
> Or are there some additional semantics involved in forwarding between
> the redundant ports and the interlink?

That sounds right.

>
> The chip is very rigid in the sense that most roles are statically
> allocated to specific ports. I think we need to add checks for this.

Okay. I'll look into this. Though a lot of the restrictions have to do
with using the third gigabit port for an HSR/PRP interlink (not
HSR-SAN) which I'm not currently supporting anyway.

>
> Looking at the packets being generated on the redundant ports, both
> regular traffic and supervision frames seem to be HSR-tagged. Are
> supervision frames not supposed to be sent with an outer ethertype of
> 0x88fb? The manual talks about the possibility of setting up a policy
> entry to bypass HSR-tagging (section 6.1.5), is this what that is for?

This was changed between 62439-3:2010 and 62439-3:2012.
"Prefixing the supervision frames on HSR by an HSR tag to simplify the hardware
implementation and introduce a unique EtherType for HSR to simplify processing."
The Linux HSR driver calls the former HSR v0 and the later HSR v1. I'm
not sure what their intention was with this feature. The inbound
policies are pretty flexible so maybe they didn't have anything so
specific in mind.
I don't think the xrs7000 series could offload HSR v0 anyway because
the tag ether type is different.

>
> In the DSA layer (dsa_slave_changeupper), could we merge the two HSR
> join/leave calls somehow? My guess is all drivers are going to end up
> having to do the same dance of deferring configuration until both ports
> are known.

Describe what you mean a bit more. Do you mean join and leave should
each only be called once with both hsr ports being passed in?

>
> Thanks for working on this!
