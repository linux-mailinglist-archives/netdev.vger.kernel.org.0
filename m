Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 01B66DE028
	for <lists+netdev@lfdr.de>; Sun, 20 Oct 2019 21:12:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726733AbfJTTMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 15:12:13 -0400
Received: from mail-ot1-f67.google.com ([209.85.210.67]:35459 "EHLO
        mail-ot1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726251AbfJTTMN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 15:12:13 -0400
Received: by mail-ot1-f67.google.com with SMTP id z6so9200196otb.2;
        Sun, 20 Oct 2019 12:12:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qf/sVe4OaaSu5coc+u2XBYohKmJFVapNYY/Vba9pEeg=;
        b=e/KmxsLe64muElk1bHBqvk5BB6G4+df8Hx6+RkiEOT+mYKGx/nzW7DGQz3DVwZ+Xo2
         cR0+tneiIJV8M4fWTOpjqfUMpJh3/QdT42kHox7auZERy1bTOmHv/nqBrH2EKNzSE1iq
         VUM7R2liP4dwuTnCrPtvWlSGomr1A57WGANS8ls+hCB245620RAvWw16fMi2ssgUH13o
         t7wewyGCZ+1RYOikA6nGZcQ1zR4UuAmts7SeJ4Npf3SXoxK9C8ZAwP9VSlcRf3iQLOn4
         qAm3R21a3qz0bmWdgp/wb6nZwPBYLK79HFF0mMbE4jOqOYIc9QI/uFAstsNZche95+D+
         duHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qf/sVe4OaaSu5coc+u2XBYohKmJFVapNYY/Vba9pEeg=;
        b=Bodw7nF6K3emXiCyu6ynkeNmIwW3SwzxL3l2WHyNypHiKiYHUAFGk9oQRM2UWlnkOz
         vifEN6BoQKKNR+GPV6pbyKe6Iaa0LtmedH1ztsNr6A2wFNzSwTa7qU770+SATh//Bapp
         IDC0IoI/RIwGGv8gk0s/+kc9r29LlPhdCxlQtpyqFhax6j4kh0bK8hM9lXsfWl3RH9lL
         8qa/LOomz9kc3NcenX0RyBnCIRqNjrownj3nMSFyp7uQJ+ihFvT4Rw9AD2MXJfx8U3Tv
         hMLTSNXntkoT12C6gC8CvrAtBlItCzebNQy73yJy7XHJh69Co2bwesGPJubxKslKBNWf
         aGoA==
X-Gm-Message-State: APjAAAW8HSYGaDgP0k2JPmpAgzJJ7xene4wYttzJSwjuOhiSQbXeN+lH
        lgFHSvCLsX6m8OsNT2u94GYknApKE89pbYdw86c=
X-Google-Smtp-Source: APXvYqzhVFAdFslCNWIJXXjZu/NkaMPU3XVTcluJ7My62pWakGb26uJDD5Y5tarArW0KRgR/rg7bEzq2Kg3pPWBM6Fs=
X-Received: by 2002:a9d:6247:: with SMTP id i7mr15903045otk.139.1571598732021;
 Sun, 20 Oct 2019 12:12:12 -0700 (PDT)
MIME-Version: 1.0
References: <1571391220-22835-1-git-send-email-magnus.karlsson@intel.com>
 <20191018232756.akn4yvyxmi63dl5b@ast-mbp> <CAJ8uoz292vhqb=L0khWeUs89HF42d+UAgzb1z1tf8my1PaU5Fg@mail.gmail.com>
 <20191020172503.qeee2olqxxnynm6v@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20191020172503.qeee2olqxxnynm6v@ast-mbp.dhcp.thefacebook.com>
From:   Magnus Karlsson <magnus.karlsson@gmail.com>
Date:   Sun, 20 Oct 2019 21:12:01 +0200
Message-ID: <CAJ8uoz18+4fFP_JMu0kzFehZceATs5aAD8VUMQY2ax-S2=7Pvg@mail.gmail.com>
Subject: Re: [PATCH bpf v2] xsk: improve documentation for AF_XDP
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@intel.com>,
        =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 20, 2019 at 7:25 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Sun, Oct 20, 2019 at 10:13:49AM +0200, Magnus Karlsson wrote:
> > On Sat, Oct 19, 2019 at 11:48 AM Alexei Starovoitov
> > <alexei.starovoitov@gmail.com> wrote:
> > >
> > > On Fri, Oct 18, 2019 at 11:33:40AM +0200, Magnus Karlsson wrote:
> > > > +
> > > > +   #include <linux/bpf.h>
> > > > +   #include "bpf_helpers.h"
> > > > +
> > > > +   #define MAX_SOCKS 16
> > > > +
> > > > +   struct {
> > > > +        __uint(type, BPF_MAP_TYPE_XSKMAP);
> > > > +        __uint(max_entries, MAX_SOCKS);
> > > > +        __uint(key_size, sizeof(int));
> > > > +        __uint(value_size, sizeof(int));
> > > > +   } xsks_map SEC(".maps");
> > > > +
> > > > +   struct {
> > > > +        __uint(type, BPF_MAP_TYPE_PERCPU_ARRAY);
> > > > +        __uint(max_entries, 1);
> > > > +        __type(key, int);
> > > > +        __type(value, unsigned int);
> > > > +   } rr_map SEC(".maps");
> > >
> > > hmm. does xsks_map compile?
> >
> > Yes. Actually, I wrote a new sample to demonstrate this feature and to
> > test the code above. I will send that patch set (contains some small
> > additions to libbpf also to be able to support this) to bpf-next.
> > Though, if I used the __type declarations of the rr_map PERCPU_ARRAY I
> > got this warning: "pr_warning("Error in
> > bpf_create_map_xattr(%s):%s(%d). Retrying without BTF.\n")", so I had
> > to change it to the type above that is also used for SOCKMAP. Some
> > enablement that is missing for XSKMAP? Have not dug into it.
>
> Ahh. Right. xskmap explicitly prohibits BTF for key/value.
> const struct bpf_map_ops xsk_map_ops = {
>         ...
>         .map_check_btf = map_check_no_btf,
> };
> I guess it's time to add support for it.

Agreed. I will implement that in a separate patch set for bpf-next and
include a patch to update the documentation too in that patch set.

>
