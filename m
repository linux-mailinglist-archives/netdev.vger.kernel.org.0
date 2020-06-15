Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6EE071F9508
	for <lists+netdev@lfdr.de>; Mon, 15 Jun 2020 13:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729630AbgFOLLh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jun 2020 07:11:37 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:44602 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728285AbgFOLLf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jun 2020 07:11:35 -0400
Received: by mail-ot1-f66.google.com with SMTP id e5so12749939ote.11;
        Mon, 15 Jun 2020 04:11:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=5CY9W/R8PVfuC9sqxRBqVw1uewgeiGQUga39MZZDtgE=;
        b=cADIiUIGUGJE+40d8zPhf8ygYfhxpUrZArnY35sI3QiKhj309Xm6Fy41ThKAr2FUie
         E7Xr6v1bQ4T8Sk3ZF10BDVwXIYoMl/J/idI48oldQSZ78F5Q1bqdOk+cV35mCYmXMLOB
         zsNZScnu+TLV02N+zH21xC6zrNZb2/xgpGGpkxvCtbrZ8VpwD3r0UZ4j2Du/Sngn3vVJ
         khDTNkCMnGFJg8Ih7LpAkYFgT1qhInaniRgwyw2Ks80J3Xuwefa3o92VdjpJMR9Iutfp
         3Y7qBBr2kAY/hq4wiHsQAdSzJxwUBL8ZGQ/f2J/o963oTdKsbOm97DGh/YJrqY4CQGLa
         qgeg==
X-Gm-Message-State: AOAM5305BchxN+ni0uFyntydTGkyT8O5G/Et72cLKna2xxrKdAg3Rm3B
        7NtRLlGdhHVg+wmAk7uo+moMLLsUYEJv+DYhDDA=
X-Google-Smtp-Source: ABdhPJxqwi8MnZ0bTP5LApZwYenNqY/5jKzHiLXqehYN7pgYecrM9cD9SN/qL/FqLS7oLc+l+cgfu73Tu03M1ONzZbQ=
X-Received: by 2002:a9d:c29:: with SMTP id 38mr19723723otr.107.1592219494134;
 Mon, 15 Jun 2020 04:11:34 -0700 (PDT)
MIME-Version: 1.0
References: <9feded75-4b45-2821-287b-af00ec5f910f@al2klimov.de>
 <20200614223456.13807a00@redhat.com> <5033402c-d95c-eecd-db84-75195b159fab@al2klimov.de>
In-Reply-To: <5033402c-d95c-eecd-db84-75195b159fab@al2klimov.de>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Mon, 15 Jun 2020 13:11:22 +0200
Message-ID: <CAMuHMdVvYRzOA-cOj41_0g1OXw+xhJ29=FZNAL5v_fWsBjwm4g@mail.gmail.com>
Subject: Re: Good idea to rename files in include/uapi/ ?
To:     "Alexander A. Klimov" <grandmaster@al2klimov.de>
Cc:     Stefano Brivio <sbrivio@redhat.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@netfilter.org>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        Andrea Parri <parri.andrea@gmail.com>,
        Will Deacon <will@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Boqun Feng <boqun.feng@gmail.com>,
        Nicholas Piggin <npiggin@gmail.com>,
        David Howells <dhowells@redhat.com>,
        Jade Alglave <j.alglave@ucl.ac.uk>,
        Luc Maranget <luc.maranget@inria.fr>,
        "Paul E. McKenney" <paulmck@kernel.org>,
        Akira Yokosawa <akiyks@gmail.com>,
        Daniel Lustig <dlustig@nvidia.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        NetFilter <netfilter-devel@vger.kernel.org>,
        coreteam@netfilter.org, netdev <netdev@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Alexander,

On Mon, Jun 15, 2020 at 1:11 AM Alexander A. Klimov
<grandmaster@al2klimov.de> wrote:
> Am 14.06.20 um 22:34 schrieb Stefano Brivio:
> > On Sun, 14 Jun 2020 21:41:17 +0200
> >> Also even on a case-sensitive one VIm seems to have trouble with editing
> >> both case-insensitively equal files at the same time.
> >
> > ...what trouble exactly?
> vi -O2 include/uapi/linux/netfilter/xt_CONNMARK.h
> include/uapi/linux/netfilter/xt_connmark.h
>
> ... opens the first file two times.

Works fine for me, using vim 2:8.0.1453-1ubuntu1.3.
You must be using a buggy version.

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
