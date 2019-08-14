Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 472C08CF61
	for <lists+netdev@lfdr.de>; Wed, 14 Aug 2019 11:25:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726571AbfHNJZj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Aug 2019 05:25:39 -0400
Received: from mail-lf1-f43.google.com ([209.85.167.43]:44177 "EHLO
        mail-lf1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726383AbfHNJZi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Aug 2019 05:25:38 -0400
Received: by mail-lf1-f43.google.com with SMTP id v16so7120274lfg.11
        for <netdev@vger.kernel.org>; Wed, 14 Aug 2019 02:25:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=sentorsecurity.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pZ4G9V/bxMjiKlcxVSDzmNEaY7yeTRFh5KrhMcKms5o=;
        b=nJmcaRfbrJUNFA40pjHugOmstYy/yRi4GPcU8GookaXNTuA68eEiFuIsqE203DEKmi
         IXQrU8YnboF4RUu77c58qiyIaYF1FdCXzv6l5tPXh9X35vBzQ3JGcy6wp4Z0cuCJbYAE
         7Yiq2fekZoP/pKgjIxRu8/jSZ2/zyZGhRxiU2JxD0psHOcM3u+o4/UHzpq9g/p4U3wkz
         +md4AQg07G8zvzJEXEA9Xb30cK0hKl2/r6JqqDpZodIc6XR+jYsUq5vD2BzoXBE0kcKX
         C8aMynbRisyKrc776l8zOifps6fJJoWBcll9iE+0rf76ZkVq+ohBdpf/paTpnDDTixtj
         r7sA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pZ4G9V/bxMjiKlcxVSDzmNEaY7yeTRFh5KrhMcKms5o=;
        b=lCUhZ9rcI/mEwxTHqDk8RdA9BHafMOIZKZV7jMwGtWaY0ohLCbrO81EMG7cdAqc+/I
         Vb7PjrUpUb08so3m76rB3IAJWXibvfClUwOwDmjsLz73+5DW2Jjsp2Pp0kE9wWzxCkgT
         UPRzYdc35Qyzccex96zPkAHyEnFGN+DTqlV2NcM1ZrEhxDkw+f0XgLULm8OyF8y+zE/D
         QlbQ5SDflDwr5RSi+E7EoTO51rYLW3ZFbl57+Dk84nCXmdyVKE+qxJGdinawYGRv2KbK
         3Au0Q/fWJ1W+lGT1sQrFLoTcnzs6FUDZmlUyc48QPxoMqNtn1wvjphlqH1FC7iabZSjk
         Y6lA==
X-Gm-Message-State: APjAAAUMj2JEN73XcKq+qF6MxXm6XJKA5T+FmEj0s8GiMocvNsmnxC3t
        Si7L8ocVP1k283sv+MPwMHp/l0R69e+BO0SZIRgxMw==
X-Google-Smtp-Source: APXvYqwJ2se7EGENjR+qFe1aubUjU+qKU6vyG8cQxzFUMilhKUWBRerwARSih7TMvzDN0kqrr63pwNXbY7ZqRU/UQ4Y=
X-Received: by 2002:ac2:4d02:: with SMTP id r2mr24465959lfi.138.1565774737031;
 Wed, 14 Aug 2019 02:25:37 -0700 (PDT)
MIME-Version: 1.0
References: <CAAT+qEa6Yw-tf3L_R-phzSvLiGOdW9uLhFGNTz+i9eWhBT_+DA@mail.gmail.com>
 <CAAT+qEbOx8Jh3aFS-e7U6FyHo03sdcY6UoeGzwYQbO6WRjc3PQ@mail.gmail.com>
 <CAM_iQpW-kTV1ZL-OnS2TNVcso1NbiiPn0eUz=7f5uTpFucz7sw@mail.gmail.com> <CAAT+qEYG5=5ny+t0VcqiYjDUQLrcj9sBR=2w-fdsE7Jjf4xOkQ@mail.gmail.com>
In-Reply-To: <CAAT+qEYG5=5ny+t0VcqiYjDUQLrcj9sBR=2w-fdsE7Jjf4xOkQ@mail.gmail.com>
From:   Martin Olsson <martin.olsson+netdev@sentorsecurity.com>
Date:   Wed, 14 Aug 2019 11:25:25 +0200
Message-ID: <CAAT+qEbDAuQWGZa5BQYMZfBRQM+mDS=CMb9GTPz6Nxz_WD0M8Q@mail.gmail.com>
Subject: tc - mirred ingress not supported at the moment
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Cong!

Ah sorry.
Already implemented. Great!

Hmmm. Then why don't the manual at
https://www.linux.org/docs/man8/tc-mirred.html to reflect the changes?
That was the place I checked to see if ingress was still not implemented.
In the commit you point at, the sentence "Currently only egress is
implemented" has been removed.


Question:
Is there any form of performance penalty if I send the mirrored
traffic to the ingress queue of the destination interface rather than
to the egress queue?
I mean, in the kernel there is the possibility to perform far more
actions on the ingress queue than on the egress, but if I leave both
queues at their defaults, will mirrored packets to ingress use more
CPU cycles than to the egress destination, or are they more or less
identical?


Question 2:
Given the commit
https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=5eca0a3701223619a513c7209f7d9335ca1b4cfa,
how can I see in what kernel version it was added?

/Martin


Den tis 13 aug. 2019 kl 18:47 skrev Cong Wang <xiyou.wangcong@gmail.com>:
>
> On Tue, Aug 13, 2019 at 4:05 AM Martin Olsson
> <martin.olsson+netdev@sentorsecurity.com> wrote:
> > Q1: Why was 'ingress' not implemented at the same time as 'egress'?
>
> Because you are using an old iproute2.
>
> ingress support is added by:
> https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=5eca0a3701223619a513c7209f7d9335ca1b4cfa
>
>
> > 2)
> > Ok, so I have to use 'egress':
> > # tc filter add dev eno2 parent ffff: prio 999  protocol all matchall
> > action mirred egress redirect dev mon0
>
>
> So you redirect packets from eno2's ingress to mon0's egress.
>
>
> >
> > Since the mirred action forces me to use 'egress' as the direction on
> > the dest interface, all kinds of network statistics tools show
> > incorrect counters. :-(
> > eno2 is a pure sniffer interface (it is connected to the SPAN dest
> > port of a switch).
> > All packets (matchall) on eno2 are mirrored to mon0.
> >
> > # ip -s link show dev eno2
> >     ...
> >     ...
> >     RX: bytes  packets  errors  dropped overrun mcast
> >     13660757   16329    0       0       0       0
> >     TX: bytes  packets  errors  dropped carrier collsns
> >     0          0        0       0       0       0
> > # ip -s link show dev mon0
> >     ...
> >     ...
> >     RX: bytes  packets  errors  dropped overrun mcast
> >     0          0        0       0       0       0
> >     TX: bytes  packets  errors  dropped carrier collsns
> >     13660757   16329    0       0       0       0
> >
> > eno2 and mon0 should be identical, but they are inverted.
>
> Yes, this behavior is correct. The keyword "egress" in your cmdline
> already says so.
>
> >
> > Q2: So... Can the 'ingress' option please be implemented? (I'm no
> > programmer, so unfortunetly I can't do it myself).
>
> It is completed, you need to update your iproute2 and kernel.
>
> Thanks.
