Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 585C33A0D4E
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 09:11:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235264AbhFIHNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 03:13:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:59316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233299AbhFIHNh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 03:13:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 567EF60E0C
        for <netdev@vger.kernel.org>; Wed,  9 Jun 2021 07:11:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623222703;
        bh=oV7pzhecuN2rfrdMqv0JeAaUkpdbLp8uILlhm9GtaKA=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=dTlnqUevCzKWWy5Nmo2d8DROyTc/O6vUVIiMnuNXuf+vHgeIk93y+Ay1HB2P+CX6a
         91EAjD+nZOX8sRzKSo2FwB1+ebraLlKeSEkD2tHStW34T4pCdeD6tjgrd3rZ878K9x
         dKdB3pH/vx0mYl1For0lo3ImJB/A+bVum873nexbm0wHFKTktRsRixm65x3qnmlcGW
         savc6FWsoTDVKy/OiavDHsKuFnayaupEHL4pCw8BPV6CVWdJfc7TfzyPKMUaZQ/1Ls
         iRU0P0rLOxTynoxr9fsyH+bW0qqygW5AnKnfO6UUG3RRvfpSRl45V/tZ2j5Kpa3eGk
         u+LZAbVBcuJWw==
Received: by mail-wr1-f50.google.com with SMTP id i94so19185600wri.4
        for <netdev@vger.kernel.org>; Wed, 09 Jun 2021 00:11:43 -0700 (PDT)
X-Gm-Message-State: AOAM53339R82qujiktpv8NtTOWWPKOn9+xb3oF/8pC7D6kGkpfsExUAZ
        qOrrfFmiCmnourqu155J4xz/a8sDgkEPb4bbouQ=
X-Google-Smtp-Source: ABdhPJx8W42lqmway211Wxw7a6JbgUo+kR/fr3sFTv9X+m0bQlIUSa6jqksJJCJTVpzVnLUF9acJpJq15Rq0/YHqr/8=
X-Received: by 2002:adf:a28c:: with SMTP id s12mr27650696wra.105.1623222701841;
 Wed, 09 Jun 2021 00:11:41 -0700 (PDT)
MIME-Version: 1.0
References: <60B24AC2.9050505@gmail.com> <CAP8WD_bKiGLczUfRVOWY3y4TT80yhRCPmLkN7pDMhkJ5m=2Pew@mail.gmail.com>
 <60B2E0FF.4030705@gmail.com> <60B36A9A.4010806@gmail.com> <60B3CAF8.90902@gmail.com>
 <CAK8P3a3y3vvgdWXU3x9f1cwYKt3AvLUfN6sMEo0SXFPTCuxjCw@mail.gmail.com>
 <60B41D00.8050801@gmail.com> <60B514A0.1020701@gmail.com> <CAK8P3a08Bbzj9GtZi0Vo1-yRkqEMfnvTZMNEVWAn-gmLKx2Oag@mail.gmail.com>
 <60B560A8.8000800@gmail.com> <49f40dd8-da68-f579-b359-7a7e229565e1@gmail.com>
 <CAK8P3a2PEQgC1GQTVHafKyxSbKNigiTDD6rzAC=6=FY1rqBJhw@mail.gmail.com>
 <60B611C6.2000801@gmail.com> <a1589139-82c7-0219-97ce-668837a9c7b1@gmail.com>
 <60B65BBB.2040507@gmail.com> <c2af3adf-ba28-4505-f2a3-58ce13ccea3e@gmail.com>
 <60B6C4B2.1080704@gmail.com> <CAK8P3a0iwVpU_inEVH9mwkMkBxrxbGsXAfeR9_bOYBaNP4Wx5g@mail.gmail.com>
 <60BEA6CF.9080500@gmail.com> <CAK8P3a12-c136eHmjiN+BJfZYfRjXz6hk25uo_DMf+tvbTDzGw@mail.gmail.com>
 <60BFD3D9.4000107@gmail.com> <CAK8P3a0Wry54wUGpdRnet3WAx1yfd-RiAgXvmTdPd1aCTTSsFw@mail.gmail.com>
 <60BFEA2D.2060003@gmail.com>
In-Reply-To: <60BFEA2D.2060003@gmail.com>
From:   Arnd Bergmann <arnd@kernel.org>
Date:   Wed, 9 Jun 2021 09:09:49 +0200
X-Gmail-Original-Message-ID: <CAK8P3a0j+kSsEYwzdERJ7EZ8KheAPhyj+zYi645pbykrxgZYdQ@mail.gmail.com>
Message-ID: <CAK8P3a0j+kSsEYwzdERJ7EZ8KheAPhyj+zYi645pbykrxgZYdQ@mail.gmail.com>
Subject: Re: Realtek 8139 problem on 486.
To:     Nikolai Zhubr <zhubr.2@gmail.com>
Cc:     netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 9, 2021 at 12:07 AM Nikolai Zhubr <zhubr.2@gmail.com> wrote:
>
> 08.06.2021 23:45, Arnd Bergmann:
> > The idea was that all non-rx events that were pending at the start of the
> > function have been Acked at this point, by writing to the IntrMask
> > register before processing the particular event. If the same kind of event
> > arrives after the Ack, then opening in the mask should immediately trigger
> > the interrupt handler, which reactivates the poll function.
>
> Ok, it works, indeed. The overall bitrate seems lower somewhat.
> I'll re-test and benchmark some few variants (e.g. with and without busy
> loop) and report my findings.

If it's only a bit slower, that is not surprising, I'd expect it to
use fewer CPU
cycles though, as it avoids the expensive polling.

There are a couple of things you could do to make it faster without reducing
reliability, but I wouldn't recommend major surgery on this driver, I was just
going for the simplest change that would make it work right with broken
IRQ settings.

You could play around a little with the order in which you process events:
doing RX first would help free up buffer space in the card earlier, possibly
alternating between TX and RX one buffer at a time, or processing both
in a loop until the budget runs out would also help.

         Arnd
