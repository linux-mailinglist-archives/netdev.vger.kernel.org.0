Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB481982D2
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:54:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730369AbgC3Ryj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:54:39 -0400
Received: from mail-wr1-f67.google.com ([209.85.221.67]:37068 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727779AbgC3Ryi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 13:54:38 -0400
Received: by mail-wr1-f67.google.com with SMTP id w10so22855962wrm.4
        for <netdev@vger.kernel.org>; Mon, 30 Mar 2020 10:54:37 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=utW+7YJkRuGqH8XK7nqVWH149nVP6e/z3NiTESoZJ6I=;
        b=FUM/Log5Gw5uixyZLFfSJCSdgQdC9uA76xrChs16wy5iNS75Rmzu4dn06dHbbaqEit
         ghRrrro2jkjKhoIsDZgxiwceZIGwOOz9ZhOJQ8t7wUcny1DlafqxQZ7bfiYypLtBEBZj
         9WolA73ts7cOv3ZaPB3DCzcc25CpUytxEw5pA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=utW+7YJkRuGqH8XK7nqVWH149nVP6e/z3NiTESoZJ6I=;
        b=OL+XcyPYHsDPZ2Ki/9dlO5JX3MMoYOY3etlstd2zAPYpScEUzmO8BLXWMylAQuMQha
         3JWwNjHAxIW7dwaZxYSKZHBM/Q5Q++dQ+1ST01wTxl8CLWFw5tCa26/NRncw824LGOoU
         T8V18DlI1fACqv8uWS/xN3459ro1jpYkEVBHVrW2rqBgokmNNUsHEeabn+hC6Se1FnY2
         r6N+MReBQm8bJ5V5kegneaCmXq9n4D8wiFkQ3jd5h98W7Qloo7T/03+BFNHWHjiV1Dug
         0hH89g87GWoTpi7IF3Fm5skrJmPg4Argz2V3hNtu4rG+9yFDElst9nF0LLAw8YLK8hjR
         Z60g==
X-Gm-Message-State: ANhLgQ2329/Wj4Hyernp08v/mbstQTEUeHXJRXHlHXIdWfNzVOS0B3l4
        rvxSptttwMKQBVCJ6l7SsA+a/57m4HpjTaiDAx3fEA==
X-Google-Smtp-Source: ADFU+vsUn9IsKe0gSvckJlw0u4Px0D/tzS/kNZ/jnXIKvDX6ef/ApzKlvKspnJvAglkMak8cC2//FXu1A1VOWCpgq60=
X-Received: by 2002:a5d:4847:: with SMTP id n7mr16829913wrs.182.1585590876589;
 Mon, 30 Mar 2020 10:54:36 -0700 (PDT)
MIME-Version: 1.0
References: <20200330204307.669bbb4d@canb.auug.org.au> <86f7031a-57c6-5d50-2788-ae0e06a7c138@infradead.org>
 <d5b4bd95-7ef9-58cb-1955-900e6edb2467@iogearbox.net>
In-Reply-To: <d5b4bd95-7ef9-58cb-1955-900e6edb2467@iogearbox.net>
From:   KP Singh <kpsingh@chromium.org>
Date:   Mon, 30 Mar 2020 19:54:25 +0200
Message-ID: <CACYkzJ72Uy9mnenO04OJaKH=Bk4ZENKJb9yw6i+EhJUa+ygngQ@mail.gmail.com>
Subject: Re: linux-next: Tree for Mar 30 (bpf)
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     Randy Dunlap <rdunlap@infradead.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for adding me Daniel, taking a look.

- KP

On Mon, Mar 30, 2020 at 7:25 PM Daniel Borkmann <daniel@iogearbox.net> wrote:
>
> [Cc KP, ptal]
>
> On 3/30/20 7:15 PM, Randy Dunlap wrote:
> > On 3/30/20 2:43 AM, Stephen Rothwell wrote:
> >> Hi all,
> >>
> >> The merge window has opened, so please do not add any material for the
> >> next release into your linux-next included trees/branches until after
> >> the merge window closes.
> >>
> >> Changes since 20200327:
> >
> > (note: linux-next is based on linux 5.6-rc7)
> >
> >
> > on i386:
> >
> > ld: kernel/bpf/bpf_lsm.o:(.rodata+0x0): undefined reference to `bpf_tracing_func_proto'
> >
> >
> > Full randconfig file is attached.
> >
>
