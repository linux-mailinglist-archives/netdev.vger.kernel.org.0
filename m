Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F416731B2DD
	for <lists+netdev@lfdr.de>; Sun, 14 Feb 2021 22:41:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229901AbhBNVlb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 16:41:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229827AbhBNVla (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 16:41:30 -0500
Received: from mail-pj1-x1033.google.com (mail-pj1-x1033.google.com [IPv6:2607:f8b0:4864:20::1033])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C0A6C061756
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 13:40:50 -0800 (PST)
Received: by mail-pj1-x1033.google.com with SMTP id q72so2588697pjq.2
        for <netdev@vger.kernel.org>; Sun, 14 Feb 2021 13:40:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=PiG6cYoVsBFCEBxVL/MHzdKRIBPAg+eCl4dTqw4n41o=;
        b=hR0QP9L9vXHRLCGVv4CmmoNvHih4aDAmCL/YFKNhdrXKHRBmLrOrp8+0nfeauwgRBA
         99RKyjgRdcWAXGfM7rubvvxsyuoUHn9TFohn4RQjtapAsYm8sT+ZRX6GfHWpa/3aJNV4
         EYzRT3vvx4h84CbaTpZOHSzYqG/1o9G+1WCET0lWEuFXGT/0PqobgCic8ynnvnPQTtij
         noWtNnjWu7ev2qZCZkh2i+r0h+FYDo/8M1U1iRIX1u0BoY+MM2Zbv0/f34lUDSzkH1OH
         G59nKEhBFANPj88fkej01MbTGm1Is93aM+gN3bkPfrLXP0Zp0J+OeMjs6B+v4pOHTga0
         tLDA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=PiG6cYoVsBFCEBxVL/MHzdKRIBPAg+eCl4dTqw4n41o=;
        b=dFsM3mkmaN7kJnjHPm8dTUdbZbCnDKVMMMNsgAdDF67HoTGs989+Qs/Mgy5JjtvZKo
         n9rT8tvHbHN3w2YimUxUzAQ0B4iW47RZYA1gIikpQ2g1aCosQpE0kkSUQhEq+xVbJoIR
         qqU3nxQbobnRGK9mqAZrdpdLf1LXIq92Y0u4QG+gg850f0rYI6/KKrDJ02zL0AdhyWul
         cO0vt5hh5qzLoTp1AhiL7Xlg2KQz4CjKCGjQoy73LljI+32aCDkN2WRNNiIFKWCHdCZS
         6G3trPZVkgdKx3iTuQGVR46PUkmjvxDJr3UyCCrMxrou2ZOqqUCh2gm1Qar5jp1A4Q2y
         WiYA==
X-Gm-Message-State: AOAM530YTlfubDlvEmA7vVzhnhqrZymYxy8vSmxL6DETGw7pWzfVVfUI
        /TFNASOdH0q/idURjph/l9XaRuIzrfyYaGW/dmpXkA==
X-Google-Smtp-Source: ABdhPJwbaMnJq9+uWRBDq60rh+blroXEPgnFdWwqqdaQzQ2UGXLZ6zmWeP26EPkd2ceb5KbOQglxK0zu1EXa5QSSmfQ=
X-Received: by 2002:a17:90b:4b02:: with SMTP id lx2mr13268074pjb.178.1613338849352;
 Sun, 14 Feb 2021 13:40:49 -0800 (PST)
MIME-Version: 1.0
References: <20210125111223.2540294c@canb.auug.org.au> <20210215081250.19bc8921@canb.auug.org.au>
In-Reply-To: <20210215081250.19bc8921@canb.auug.org.au>
From:   Arjun Roy <arjunroy@google.com>
Date:   Sun, 14 Feb 2021 13:40:38 -0800
Message-ID: <CAOFY-A2sLGQHpBp79f2bQ-2hgQDbu04e+7uC9+E3vSo7Cqq5=A@mail.gmail.com>
Subject: Re: linux-next: manual merge of the bpf-next tree with the net-next tree
To:     Stephen Rothwell <sfr@canb.auug.org.au>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        David Miller <davem@davemloft.net>,
        Networking <netdev@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Linux Next Mailing List <linux-next@vger.kernel.org>,
        Stanislav Fomichev <sdf@google.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 14, 2021 at 1:13 PM Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>
> Hi all,
>
> On Mon, 25 Jan 2021 11:12:23 +1100 Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> >
> > Today's linux-next merge of the bpf-next tree got a conflict in:
> >
> >   net/ipv4/tcp.c
> >
> > between commit:
> >
> >   7eeba1706eba ("tcp: Add receive timestamp support for receive zerocopy.")
> >
> > from the net-next tree and commit:
> >
> >   9cacf81f8161 ("bpf: Remove extra lock_sock for TCP_ZEROCOPY_RECEIVE")
> >
> > from the bpf-next tree.
> >
> > I fixed it up (see below) and can carry the fix as necessary. This
> > is now fixed as far as linux-next is concerned, but any non trivial
> > conflicts should be mentioned to your upstream maintainer when your tree
> > is submitted for merging.  You may also want to consider cooperating
> > with the maintainer of the conflicting tree to minimise any particularly
> > complex conflicts.
> >
> > diff --cc net/ipv4/tcp.c
> > index e1a17c6b473c,26aa923cf522..000000000000
> > --- a/net/ipv4/tcp.c
> > +++ b/net/ipv4/tcp.c
> > @@@ -4160,18 -4098,13 +4160,20 @@@ static int do_tcp_getsockopt(struct soc
> >               if (copy_from_user(&zc, optval, len))
> >                       return -EFAULT;
> >               lock_sock(sk);
> >  -            err = tcp_zerocopy_receive(sk, &zc);
> >  +            err = tcp_zerocopy_receive(sk, &zc, &tss);
> > +             err = BPF_CGROUP_RUN_PROG_GETSOCKOPT_KERN(sk, level, optname,
> > +                                                       &zc, &len, err);
> >               release_sock(sk);
> >  -            if (len >= offsetofend(struct tcp_zerocopy_receive, err))
> >  -                    goto zerocopy_rcv_sk_err;
> >  +            if (len >= offsetofend(struct tcp_zerocopy_receive, msg_flags))
> >  +                    goto zerocopy_rcv_cmsg;
> >               switch (len) {
> >  +            case offsetofend(struct tcp_zerocopy_receive, msg_flags):
> >  +                    goto zerocopy_rcv_cmsg;
> >  +            case offsetofend(struct tcp_zerocopy_receive, msg_controllen):
> >  +            case offsetofend(struct tcp_zerocopy_receive, msg_control):
> >  +            case offsetofend(struct tcp_zerocopy_receive, flags):
> >  +            case offsetofend(struct tcp_zerocopy_receive, copybuf_len):
> >  +            case offsetofend(struct tcp_zerocopy_receive, copybuf_address):
> >               case offsetofend(struct tcp_zerocopy_receive, err):
> >                       goto zerocopy_rcv_sk_err;
> >               case offsetofend(struct tcp_zerocopy_receive, inq):
>
> With the merge window about to open, this is a reminder that this
> conflict still exists.
>
Sorry, I was confused from the prior email. Is any action required at
the moment, or not?

Thanks,
-Arjun

> --
> Cheers,
> Stephen Rothwell
