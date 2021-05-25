Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C868C3900BC
	for <lists+netdev@lfdr.de>; Tue, 25 May 2021 14:19:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232310AbhEYMUi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 May 2021 08:20:38 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45732 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229896AbhEYMUh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 May 2021 08:20:37 -0400
Received: from mail-oi1-x234.google.com (mail-oi1-x234.google.com [IPv6:2607:f8b0:4864:20::234])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D0AFC061574;
        Tue, 25 May 2021 05:19:07 -0700 (PDT)
Received: by mail-oi1-x234.google.com with SMTP id t24so14556898oiw.3;
        Tue, 25 May 2021 05:19:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Nm+AdfT9IYuKsrC6g6vqUig9hFvRALl9l3gzJP0yMlY=;
        b=bOTlH8hqbacNJ7IMlUeGf0H9+wwno/9OLdByeSjGCh9DG7hGHeKFqlnFM0iKMWrqAS
         dSrCnjdrp07Esm9PB11mVsn0ZK2ae8t4jFYxQco3t83/H2diYyWH9iCL4fZzEZ3T8Hta
         1yAXjyB+cXqB8jlkD7720vFkB/Blh6sbRgaQzOXZTjJZsr7E3GP8B1BWnAczgeS1A9pt
         +8tk3rfzKrYAt/4BAle3FIOElJiPnpdqESvE0lF9EOUvqyKRANSMTaOHVyz/SdqStRy8
         rzaV+pDBbK8DFUMXt1I+osIjZNmsKZMAQsb9WTIj1udNkTKpD023VnMh0y7jkyZwU03W
         iQHQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Nm+AdfT9IYuKsrC6g6vqUig9hFvRALl9l3gzJP0yMlY=;
        b=k3msxSRT6vtYg4GWGyfPp1jdec0P1kZPw5/jsxovDOn6cNsmkYIFFFI2neoevOzchL
         tjQWfKeKp4V5iPw9ZoekBwpW+bwcv0Nwg2PYiW+/sF2IPkyb1C7NrFtg6daqnXa7NcaR
         GO0arGMEp0IM/8bA/QnmELW6R6g0NElI53+i1wb9/Oc3SAtOL7MH9vj8+IyzA3b9J3UM
         aNplteQal2PHba2RgDmHkXufN99PwSeVzMCdLZR6ujhCMCJ5KC8BTvFKzqfejQ3aWGSi
         PaCzvy7xsNjGZ3ASrCarq9rS83E/NYyeN41+ih8wO64rIur2p9X0w8WqV/oGDmd+x3g9
         cxCQ==
X-Gm-Message-State: AOAM530fwkS+vZrZ5YlV853to05IH5gspdFdMpFSyrojnv3YqU5z1Uoh
        qEnUBlF2NtNrH+YeJEmTmFmr/BkLSCu/l/+OSfc=
X-Google-Smtp-Source: ABdhPJyY1OlBEAOIhc/5AL6f78KpvpFfq+jvXpWVsGXBhIFX7XNpYWSe62Zq/K9ZhkftjYrVVgumnJOuVqHciSFod9s=
X-Received: by 2002:aca:2102:: with SMTP id 2mr2597739oiz.70.1621945146618;
 Tue, 25 May 2021 05:19:06 -0700 (PDT)
MIME-Version: 1.0
References: <20210525102941.3958649-1-apusaka@google.com>
In-Reply-To: <20210525102941.3958649-1-apusaka@google.com>
From:   Emil Lenngren <emil.lenngren@gmail.com>
Date:   Tue, 25 May 2021 14:18:56 +0200
Message-ID: <CAO1O6sehBfi+Tn6EEC8XgoORrD=JF9zO9tDCbJBgL=JpaBdL2w@mail.gmail.com>
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

Den tis 25 maj 2021 kl 12:46 skrev Archie Pusaka <apusaka@google.com>:
>
> From: Archie Pusaka <apusaka@chromium.org>
>
> Hi linux-bluetooth maintainers,
>
> This series contains inclusive language patches, to promote usage of
> central, peripheral, reject list, and accept list. I tried to divide
> the change to several smaller patches to ease downstreamers to make
> gradual change.
>
> There are still three occurences in debugfs (patch 09/12) in which the
> original less inclusive terms is still left as-is since it is a
> file name, and I afraid replacing them will cause instability to
> other systems depending on that file name.
>
>
> Archie Pusaka (12):
>   Bluetooth: use inclusive language in HCI role
>   Bluetooth: use inclusive language in hci_core.h
>   Bluetooth: use inclusive language to describe CPB
>   Bluetooth: use inclusive language in HCI LE features
>   Bluetooth: use inclusive language in L2CAP
>   Bluetooth: use inclusive language in RFCOMM
>   Bluetooth: use inclusive language when tracking connections
>   Bluetooth: use inclusive language in SMP
>   Bluetooth: use inclusive language in debugfs
>   Bluetooth: use inclusive language when filtering devices out
>   Bluetooth: use inclusive language when filtering devices in
>   Bluetooth: use inclusive language in comments
>
>  include/net/bluetooth/hci.h      |  98 +++++++++++++-------------
>  include/net/bluetooth/hci_core.h |  22 +++---
>  include/net/bluetooth/l2cap.h    |   2 +-
>  include/net/bluetooth/mgmt.h     |   2 +-
>  include/net/bluetooth/rfcomm.h   |   2 +-
>  net/bluetooth/amp.c              |   2 +-
>  net/bluetooth/hci_conn.c         |  32 ++++-----
>  net/bluetooth/hci_core.c         |  46 ++++++-------
>  net/bluetooth/hci_debugfs.c      |  20 +++---
>  net/bluetooth/hci_event.c        | 114 +++++++++++++++----------------
>  net/bluetooth/hci_request.c      | 106 ++++++++++++++--------------
>  net/bluetooth/hci_sock.c         |  12 ++--
>  net/bluetooth/hidp/core.c        |   2 +-
>  net/bluetooth/l2cap_core.c       |  16 ++---
>  net/bluetooth/l2cap_sock.c       |   4 +-
>  net/bluetooth/mgmt.c             |  36 +++++-----
>  net/bluetooth/rfcomm/sock.c      |   4 +-
>  net/bluetooth/smp.c              |  86 +++++++++++------------
>  net/bluetooth/smp.h              |   6 +-
>  19 files changed, 309 insertions(+), 303 deletions(-)
>
> --
> 2.31.1.818.g46aad6cb9e-goog
>

Interesting move and good initiative!

In my opinion however, shouldn't we wait until Bluetooth SIG changes
the naming in the specification itself first (or rather push them to
make the changes in the first place)? If they are about to change
names, it would be good to make sure we end up with the same word
choices so that we don't call one thing "le peripheral initiated
feature exchange" while the standard calls it "le follower initiated
feature exchange" or similar. Using different terminology than what's
specified by the standard could easily end up in confusion I guess,
and even more if different stacks invented their own alternative
terminology.

In any case, I'm for example not sure if central/peripheral are the
best words to use, since those are tied to a specific higher level
profile (Generic Access Profile) and those words are not mentioned at
all in the spec outside that context. The SMP chapter for example uses
the terminology "initiator" and "responder", so maybe those are better
word choices, at least in SMP.

/Emil
