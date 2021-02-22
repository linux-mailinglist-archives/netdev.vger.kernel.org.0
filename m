Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC45432229D
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 00:24:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231124AbhBVXYJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 18:24:09 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32902 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230088AbhBVXYH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 18:24:07 -0500
Received: from mail-pf1-x434.google.com (mail-pf1-x434.google.com [IPv6:2607:f8b0:4864:20::434])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8973AC061574;
        Mon, 22 Feb 2021 15:23:27 -0800 (PST)
Received: by mail-pf1-x434.google.com with SMTP id 201so4486658pfw.5;
        Mon, 22 Feb 2021 15:23:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=GLEz0viUzMtR/T98HSPxFfZs67/2EQnLdMbHGYx9YLw=;
        b=o4lyH4ZjksIk+o36u4d9eywceLswRLy5VPGHsUKeDe6puCETiFSI5DN4r35OrqV9lc
         VBF1bpIzmtvukisWOFagO/oCQxqbPSM0kscZXztWp1JD97yqTGI3ngDM9gt1jCVblRT5
         yJvY3As4APYpvL4jj7ODp04tGm1RxSagCcRhY632ysOC6q5k8wjyje2/PreiS49dWnMV
         UvkX5dFguNx+qLb+0WcZS6EOBqq0KpTwr5RJnKhHpaKVPSTR2NLv/d5hCnJlPwA7vHFV
         6X/XSRy46ZaGlJ1ksSD8gi/SKwZjJC96tmgs9P/5Xh3ZZd0tXwKLFaYSS3Dvx6YA8QKZ
         OWKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=GLEz0viUzMtR/T98HSPxFfZs67/2EQnLdMbHGYx9YLw=;
        b=KlvQERB8cEBiwnqPQP1aCqFjIu9F+WYTWvwqEHn5JJEWlQNlfcQ4ObA5pOYGr5A3qw
         z/Ly15Xd4DL7qMhu8in/i1d/6NTR1M/NDyYKgUECojbyhDQsXTlU76TuDvuhqTJfdaDB
         nBFazoPrjbUxOG0xwWq66yN6HX6A9PyOMizbGtaPKzjB/55pQaLEOnj8Ll27jDdhDzt7
         EmlbExFBaKD36Qg/W1Nd7/SzudK27jeyfSF9iDyhTNp+Hs0BFuyNGqIlQst5TfrY9i3A
         nK6h3fI7wu0IDEsLJWG4ri8C6lZW6ZRedP7fvASG2I0Ora5JGjl0Z4DV0UktvwIa3Jx0
         iCtg==
X-Gm-Message-State: AOAM530xzoPPfrU04WvPorBJJMm1cA55Qcoq3fn6hrFXvJ+X9AGCnzBQ
        eVnO1/Orqinu+SnKDlags8H1mNmrDwyEkGEbGzc=
X-Google-Smtp-Source: ABdhPJyQXcWvaXZMu6X00fEj5A5EwH/doEFVsm/SX2NEj2GgivCtPNeGmZzwaR6A4lU1xnCJUIfXy/xllNU8DsFXc1I=
X-Received: by 2002:aa7:92c4:0:b029:1e6:c4:c821 with SMTP id
 k4-20020aa792c40000b02901e600c4c821mr24453113pfa.10.1614036207123; Mon, 22
 Feb 2021 15:23:27 -0800 (PST)
MIME-Version: 1.0
References: <20210220052924.106599-1-xiyou.wangcong@gmail.com>
 <20210220052924.106599-2-xiyou.wangcong@gmail.com> <87ft1o4h8w.fsf@cloudflare.com>
In-Reply-To: <87ft1o4h8w.fsf@cloudflare.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Mon, 22 Feb 2021 15:23:16 -0800
Message-ID: <CAM_iQpWuRT6miFgsDvMLoOhtROmP=f6-qo6QfEAm7xFDfqB4rA@mail.gmail.com>
Subject: Re: [Patch bpf-next v6 1/8] bpf: clean up sockmap related Kconfigs
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, duanxiongchun@bytedance.com,
        Dongdong Wang <wangdongdong.6@bytedance.com>,
        Jiang Wang <jiang.wang@bytedance.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Lorenz Bauer <lmb@cloudflare.com>,
        John Fastabend <john.fastabend@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Feb 22, 2021 at 12:52 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
>
> On Sat, Feb 20, 2021 at 06:29 AM CET, Cong Wang wrote:
> > From: Cong Wang <cong.wang@bytedance.com>
> >
> > As suggested by John, clean up sockmap related Kconfigs:
> >
> > Reduce the scope of CONFIG_BPF_STREAM_PARSER down to TCP stream
> > parser, to reflect its name.
> >
> > Make the rest sockmap code simply depend on CONFIG_BPF_SYSCALL
> > and CONFIG_INET, the latter is still needed at this point because
> > of TCP/UDP proto update. And leave CONFIG_NET_SOCK_MSG untouched,
> > as it is used by non-sockmap cases.
> >
> > Cc: Daniel Borkmann <daniel@iogearbox.net>
> > Cc: Jakub Sitnicki <jakub@cloudflare.com>
> > Reviewed-by: Lorenz Bauer <lmb@cloudflare.com>
> > Acked-by: John Fastabend <john.fastabend@gmail.com>
> > Signed-off-by: Cong Wang <cong.wang@bytedance.com>
> > ---
>
> Couple comments:
>
> 1. sk_psock_done_strp() could be static to skmsg.c, as mentioned
>    earlier.

Oops, I thought you meant to move it to sock_map.c...

>
> 2. udp_bpf.c is built when CONFIG_BPF_SYSCALL is enabled, while its API
>    declarations in udp.h are guarded on CONFIG_NET_SOCK_MSG.
>
>    This works because BPF_SYSCALL now selects NET_SOCK_MSG if INET, and
>    INET has to be enabled when using udp, but seems confusing to me.
>

Sure.

Thanks.
