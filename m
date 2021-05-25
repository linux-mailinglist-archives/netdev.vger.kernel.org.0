Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A95B4390518
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 17:18:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234264AbhEYPUL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 11:20:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58044 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232885AbhEYPTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 11:19:23 -0400
Received: from mail-oi1-x22f.google.com (mail-oi1-x22f.google.com [IPv6:2607:f8b0:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B0CEC061354;
        Tue, 25 May 2021 08:17:28 -0700 (PDT)
Received: by mail-oi1-x22f.google.com with SMTP id v22so30627102oic.2;
        Tue, 25 May 2021 08:17:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CbYbEQtGlD84EODNZdKsXfFlWgmm2XeE09xpe/o0hk8=;
        b=YKceKAf5IOkI8WPqiq+8cvKV8CrlaKXN5hkYJFg8IyjoG+xoid/qHuBziKHezN7QDH
         WaQyk/CUTTUzZ5JKJTrE4nBEZv19mmjbkJmWJvQSadv+g+qg1gehZYl4nYmh82/M0dlS
         d8AjKqbgXKdGCtnsRJzbZ44fAEimGeooIzm+Pc5i/Eh133d2QG2BcwasdQ7aKi8piYxE
         CdY9C57Hln6QP3nnX/FLumvjdYN3ugVv6V+Rbr9EwP+geVGW1YKaYj1a6VwT3DxRx+2X
         8zIx9iB34cDO7ZYLASGihMLyAeUAMksdB5wmJwohLBXINLsisp0h4PD/uRAaT2Nj6Kjw
         9eTA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CbYbEQtGlD84EODNZdKsXfFlWgmm2XeE09xpe/o0hk8=;
        b=I6HbBmmkixjWhDtb11tHvHtG1mkFoxLj1lcDGTa/sIB/rz0vv665+R6F67VRN8WC34
         xZlS+lefVNt3t1tnrKB/JJVvrGDf0O9DE8YjfWnArbAH1wvzqfFkCgUG+Zrs2eNAyhG/
         CIw2g7/F0vUvKeblY8624xdF+KxAyhw6TFz4lnydm+exBb+zq9Mzmsv+YQqq4n+fWMA9
         dAuamqRwxEU8roFLTXYtyMeDYHc8PZXTLliO/iMvG7KJb9QrONhuWBbQi0uELOt5Gqgf
         567qRs0lvlwcyRSIChGnl6aRUeKQVwgvZCOOcMppUyws4RFfDAcsnZGnXNvDjmByZfcY
         9WlQ==
X-Gm-Message-State: AOAM532/3hTEiUrIJ7uyCgZdJYr7pBq66i5fPTatWn4qbdbvQcknZWXG
        9aUsz2twQHVQMR8fGEeLbNu184wrOlw+CbEeUDc=
X-Google-Smtp-Source: ABdhPJxoPpWBhbgamtW7bCNvhDENQMPFELUvEdXA4vCD7K0lhP24RUKLVN7oaGrDYHC2TxdczIKOh7QYusMliK3IfTA=
X-Received: by 2002:aca:2102:: with SMTP id 2mr3196288oiz.70.1621955847593;
 Tue, 25 May 2021 08:17:27 -0700 (PDT)
MIME-Version: 1.0
References: <20210525102941.3958649-1-apusaka@google.com> <CAO1O6sehBfi+Tn6EEC8XgoORrD=JF9zO9tDCbJBgL=JpaBdL2w@mail.gmail.com>
 <CAJQfnxG1Q=6n4H_kTbFA-=b0Rbs6v7WE8mKKonqvw-nXhLnLMA@mail.gmail.com>
In-Reply-To: <CAJQfnxG1Q=6n4H_kTbFA-=b0Rbs6v7WE8mKKonqvw-nXhLnLMA@mail.gmail.com>
From:   Emil Lenngren <emil.lenngren@gmail.com>
Date:   Tue, 25 May 2021 17:17:17 +0200
Message-ID: <CAO1O6sdcWY8xt4LHWjSfuunJ3G68rgZ0_hN13iJoA3AA6tksJg@mail.gmail.com>
Subject: Re: [PATCH 00/12] Bluetooth: use inclusive language
To:     Archie Pusaka <apusaka@google.com>
Cc:     linux-bluetooth <linux-bluetooth@vger.kernel.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        CrosBT Upstreaming <chromeos-bluetooth-upstreaming@chromium.org>,
        Archie Pusaka <apusaka@chromium.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Matthieu Baerts <matthieu.baerts@tessares.net>,
        Miao-chen Chou <mcchou@chromium.org>,
        =?UTF-8?B?T2xlIEJqw7hybiBNaWR0YsO4?= <omidtbo@cisco.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Stefan Schmidt <stefan@datenfreihafen.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Archie,

Den tis 25 maj 2021 kl 16:34 skrev Archie Pusaka <apusaka@google.com>:
>
> Hi Emil,
>
> On Tue, 25 May 2021 at 20:19, Emil Lenngren <emil.lenngren@gmail.com> wrote:
> >
> > Hi Archie,
> >
> > Den tis 25 maj 2021 kl 12:46 skrev Archie Pusaka <apusaka@google.com>:
> > >
> > > From: Archie Pusaka <apusaka@chromium.org>
> > >
> > > Hi linux-bluetooth maintainers,
> > >
> > > This series contains inclusive language patches, to promote usage of
> > > central, peripheral, reject list, and accept list. I tried to divide
> > > the change to several smaller patches to ease downstreamers to make
> > > gradual change.
> > >
> > > There are still three occurences in debugfs (patch 09/12) in which the
> > > original less inclusive terms is still left as-is since it is a
> > > file name, and I afraid replacing them will cause instability to
> > > other systems depending on that file name.
> > >
> > >
> > > Archie Pusaka (12):
> > >   Bluetooth: use inclusive language in HCI role
> > >   Bluetooth: use inclusive language in hci_core.h
> > >   Bluetooth: use inclusive language to describe CPB
> > >   Bluetooth: use inclusive language in HCI LE features
> > >   Bluetooth: use inclusive language in L2CAP
> > >   Bluetooth: use inclusive language in RFCOMM
> > >   Bluetooth: use inclusive language when tracking connections
> > >   Bluetooth: use inclusive language in SMP
> > >   Bluetooth: use inclusive language in debugfs
> > >   Bluetooth: use inclusive language when filtering devices out
> > >   Bluetooth: use inclusive language when filtering devices in
> > >   Bluetooth: use inclusive language in comments
> > >
> > >  include/net/bluetooth/hci.h      |  98 +++++++++++++-------------
> > >  include/net/bluetooth/hci_core.h |  22 +++---
> > >  include/net/bluetooth/l2cap.h    |   2 +-
> > >  include/net/bluetooth/mgmt.h     |   2 +-
> > >  include/net/bluetooth/rfcomm.h   |   2 +-
> > >  net/bluetooth/amp.c              |   2 +-
> > >  net/bluetooth/hci_conn.c         |  32 ++++-----
> > >  net/bluetooth/hci_core.c         |  46 ++++++-------
> > >  net/bluetooth/hci_debugfs.c      |  20 +++---
> > >  net/bluetooth/hci_event.c        | 114 +++++++++++++++----------------
> > >  net/bluetooth/hci_request.c      | 106 ++++++++++++++--------------
> > >  net/bluetooth/hci_sock.c         |  12 ++--
> > >  net/bluetooth/hidp/core.c        |   2 +-
> > >  net/bluetooth/l2cap_core.c       |  16 ++---
> > >  net/bluetooth/l2cap_sock.c       |   4 +-
> > >  net/bluetooth/mgmt.c             |  36 +++++-----
> > >  net/bluetooth/rfcomm/sock.c      |   4 +-
> > >  net/bluetooth/smp.c              |  86 +++++++++++------------
> > >  net/bluetooth/smp.h              |   6 +-
> > >  19 files changed, 309 insertions(+), 303 deletions(-)
> > >
> > > --
> > > 2.31.1.818.g46aad6cb9e-goog
> > >
> >
> > Interesting move and good initiative!
> >
> > In my opinion however, shouldn't we wait until Bluetooth SIG changes
> > the naming in the specification itself first (or rather push them to
> > make the changes in the first place)? If they are about to change
> > names, it would be good to make sure we end up with the same word
> > choices so that we don't call one thing "le peripheral initiated
> > feature exchange" while the standard calls it "le follower initiated
> > feature exchange" or similar. Using different terminology than what's
> > specified by the standard could easily end up in confusion I guess,
> > and even more if different stacks invented their own alternative
> > terminology.
>
> So far the Bluetooth SIG has only published an "Appropriate Language
> Mapping Table" (https://specificationrefs.bluetooth.com/language-mapping/Appropriate_Language_Mapping_Table.pdf).
> It doesn't look like it's finalized, but it's enough to get started.
> Hopefully someone in the community can help to push the changes to the
> spec?
>
> > In any case, I'm for example not sure if central/peripheral are the
> > best words to use, since those are tied to a specific higher level
> > profile (Generic Access Profile) and those words are not mentioned at
> > all in the spec outside that context. The SMP chapter for example uses
> > the terminology "initiator" and "responder", so maybe those are better
> > word choices, at least in SMP.
>
> Thanks, you are correct about that. I didn't read the spec thoroughly
> and just did a simple replacement. I shall incorporate your suggestion
> if this set of patches is greenlighted.
>

Yeah that document really seems to be "in progress". As you can see,
they have replaced Srand (slave random, used in SMP) by LP_RAND_R
(legacy pairing, responder random number) so it seems they thought in
the same way as I did, at least for SMP. And indeed, as in your patch
they seem to prefer "central" and "peripheral", even outside GAP.

So my guess is that we could rename at least the terms that are in
that list right now, but probably wait with terms not yet present in
the list. Or patch everything at once when Bluetooth SIG has finished
the naming. (Note that I'm not a maintainer so someone else will need
to decide)

/Emil
