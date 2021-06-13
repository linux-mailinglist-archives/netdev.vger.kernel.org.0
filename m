Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278363A5AB4
	for <lists+netdev@lfdr.de>; Sun, 13 Jun 2021 23:54:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232133AbhFMV4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 13 Jun 2021 17:56:43 -0400
Received: from mail.kernel.org ([198.145.29.99]:58504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232020AbhFMV4n (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 13 Jun 2021 17:56:43 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id ADEF161357
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 21:54:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623621281;
        bh=nDlFMGcd/pGf1I1cVkAJkqSkBAxPz0TB5uIhs2XdHgQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=OmCYv/nQ3cAWVoUXhsro00oF0zdcKXUEKey2fqp9Mr6qv3tVB8YwRyYiRAmKfJjw8
         Yo5YaaOqGIQ4kkWS7dIM0cRDRZdoDqDy9wVr3dLeRrh8KK2QpeYy0JdoMy7EOAse0P
         s7dLbFuOmEZHNqnQADBMm2nIY4grXizEwr9XCcdbbmX+SDiALkF4n79DnCrsGXlRKw
         hgmdmWEArdz/gYHjmkRPnvKvTy3KZuKaf684MpYcXNuFAqYgQyZcKxouXnGfq2VaQw
         S+K/UcwgcYPM/1A7ij5ZGsA4bbKg11emZNB3r2/S7n36CX0xdQ24zLSelXANiUVz0e
         LAjVdMJLU5TXQ==
Received: by mail-wr1-f52.google.com with SMTP id a20so12300286wrc.0
        for <netdev@vger.kernel.org>; Sun, 13 Jun 2021 14:54:41 -0700 (PDT)
X-Gm-Message-State: AOAM5302WF3tfYE4+K9QeuHKeJE6ThDRfwzbV9JfitujI1Z83KRBaDre
        wkajdMz5vVmVvY0+CQN6+2D0RViWUdsmjdg61NI=
X-Google-Smtp-Source: ABdhPJx5gg8LGu4fSNUC6mblCRSixQ5/mz5brOsJs6nmckIOIRLYDQo1fKEK+ki7rcmvzP67+ZCXV6FII9LYhoCWcQo=
X-Received: by 2002:adf:fe4f:: with SMTP id m15mr15932316wrs.361.1623621280320;
 Sun, 13 Jun 2021 14:54:40 -0700 (PDT)
MIME-Version: 1.0
References: <60B24AC2.9050505@gmail.com> <60B41D00.8050801@gmail.com>
 <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com>
 <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com>
 <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com>
 <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com>
 <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com>
 <60B6C4B2.1080704@gmail.com> <CAK8P3a0iwVpU_inEVH9mwkMkBxrxbGsXAfeR9_bOYBaNP4Wx5g@mail.gmail.com>
 <60BEA6CF.9080500@gmail.com> <CAK8P3a12-c136eHmjiN+BJfZYfRjXz6hk25uo_DMf+tvbTDzGw@mail.gmail.com>
 <60BFD3D9.4000107@gmail.com> <CAK8P3a0Wry54wUGpdRnet3WAx1yfd-RiAgXvmTdPd1aCTTSsFw@mail.gmail.com>
 <60BFEA2D.2060003@gmail.com> <CAK8P3a0j+kSsEYwzdERJ7EZ8KheAPhyj+zYi645pbykrxgZYdQ@mail.gmail.com>
 <60C4F187.3050808@gmail.com> <CAK8P3a3vnnaYf6+v9N1WmH0N7uG55DrC=Hy71mYi4Kt+FXBRuw@mail.gmail.com>
 <60C611E0.5020908@gmail.com>
In-Reply-To: <60C611E0.5020908@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Sun, 13 Jun 2021 23:52:38 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3W=njxgG-GzpW=XkcLjuo0-xsbzhZRcAYvRYT_S0uwsw@mail.gmail.com>
Message-ID: <CAK8P3a3W=njxgG-GzpW=XkcLjuo0-xsbzhZRcAYvRYT_S0uwsw@mail.gmail.com>
Subject: Re: Realtek 8139 problem on 486.
To:     Nikolai Zhubr <zhubr.2@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Jun 13, 2021 at 4:00 PM Nikolai Zhubr <zhubr.2@gmail.com> wrote:
>
> 13.06.2021 1:41, Arnd Bergmann:
> > Or, to keep the change simpler, keep the inner loop in the tx
> > and rx processing, doing all rx events before moving on
> > to processing all tx events, but then looping back to try both
> > again, until either the budget runs out or no further events
> > are pending.
>
> Ok, made a new version: https://pastebin.com/3FUUrg7C
> It is much simpler and is very close to your patch now.
>
> All previous conditional defines are eliminated along with unnecessary
> code fragments, and here is TUNE8139_BIG_LOOP to introduce a top-level
> loop in poll function as you suggested above. But apparently it works
> well both with and without this loop. At least my testing did not show
> any substantial difference in performance. Therefore I think it could be
> completely removed for the sake of simplicity.

Ok, simpler is better in that case.

> One problem though is the kernel now always throws a traceback shortly
> after communication start:
> https://pastebin.com/VhwQ8wsU
> According to system.map it likely points to __local_bh_endble_ip() and
> there is one WARN_ON_ONCE() in it indeed, but I have no idea what it is
> and how to fix it.

There must be some call to spin_unlock_bh() or local_bh_enabled() or similar,
which is not allowed when interrupts are disabled with spin_lock_irqsave().

I don't see where exactly happens, but since nothing interesting is now
executed in hardirq context, I assume you can change tp->lock from
being called with _irq or _irqsave to using the _bh version that just
blocks the poll and start_xmit functions from happening, not the
hardirq.

> Yet another thing is that tp->rx_lock and tp->lock are now used within
> poll function in a way that possibly suggests one of them could be
> eliminated.

Agreed. I didn't want to change too much in my proposal, but I'm
sure these can be merged into a single lock, or possibly even
eliminated entirely.

        Arnd
