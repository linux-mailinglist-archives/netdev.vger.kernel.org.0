Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA88476166
	for <lists+netdev@lfdr.de>; Wed, 15 Dec 2021 20:16:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344126AbhLOTPT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Dec 2021 14:15:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344124AbhLOTPS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Dec 2021 14:15:18 -0500
Received: from mail-qt1-x82a.google.com (mail-qt1-x82a.google.com [IPv6:2607:f8b0:4864:20::82a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6D1FBC061574
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 11:15:17 -0800 (PST)
Received: by mail-qt1-x82a.google.com with SMTP id o17so22936460qtk.1
        for <netdev@vger.kernel.org>; Wed, 15 Dec 2021 11:15:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=UpI3HneaoGVJ5KkM2LMcsXRbLjNuK02QifkoMFbXRvo=;
        b=bnQTMrKXW384szCu/GV6keyGIzOCqPl91frCICxMNaGpzZ4ExMnasu/Mtsdi20VBZu
         sZYgteWV9QLoRk8fXbwWTAjTa2i/ZmUoII332QM+Y9QFxmsc5/746d9Gh+STvh4R1sUq
         3ZR+kP3lA4cr2IhqqthdAUBX02fj9O58D2kZ9OSksp0UnPXmgL3UQNr7syF1FQEkx7nU
         xzEtYkxTtRJ3LxEWwZo9TeP9YVhY3KYk+ZyC7Y9KmRYflL5tl9jzU3sv5PWayToSuQpT
         wNownxU1t4RSuVZWwtwhHx0ogIEn5HhWM3G4ZrC8xFqtyYOOVXavBVZa20YOnAm7TuFv
         n+/g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=UpI3HneaoGVJ5KkM2LMcsXRbLjNuK02QifkoMFbXRvo=;
        b=XdVvqU6ohkEpMPkB3jW9j3BOLgKWKdQvMIOl3mGTl/WZKDSzqcRf3RhRSBmZSlPwN0
         YqX7xHcCJlk/Rfd1GjS69ABwHqkKRMTzh0uLucbphKc2CuhT5zbtUCQ4xEAH3VfRji1z
         Obj/mke38hvZZcBAX6VYQTcXGiuoe7esB3VVH9hQLsIYv7jxqo3jyCE9bXtCmC0yw1Fz
         aFKFkTb3plEIJhvVp19SGIvW9BwN326xbAiTOaZ7BxfIrldtmUf30q5nJBxyazMfDpCO
         MtJ0sByI+wqwlOtimrLLrcQZIEcM1U6ShoBvxvR6LWsnIoAB9waANIlDyD424LGQeG70
         O8Nw==
X-Gm-Message-State: AOAM5303Joksg+EoZ+WHuHDaTva1uCE4Dc5iV8Ks7OpYfWPnZRl+3g+H
        Kp/jBF52NiVnUSu1lZsMiEZqZBB7O8y6YsV8cQ/7EA==
X-Google-Smtp-Source: ABdhPJxSj0kHaySeDZCkpMe2D6Xf7GnXEwDu6v7OTt3DCVmc7SS7f3nBBhy0SgE5CCrfoN0Tr+vwcKDBqrEienrmBFw=
X-Received: by 2002:a05:622a:609:: with SMTP id z9mr13474939qta.243.1639595716346;
 Wed, 15 Dec 2021 11:15:16 -0800 (PST)
MIME-Version: 1.0
References: <462ce9402621f5e32f08cc8acbf3d9da4d7d69ca.1639579508.git.asml.silence@gmail.com>
 <Yboc/G18R1Vi1eQV@google.com> <b2af633d-aaae-d0c5-72f9-0688b76b4505@gmail.com>
 <Ybom69OyOjsR7kmZ@google.com> <634c2c87-84c9-0254-3f12-7d993037495c@gmail.com>
 <Yboy2WwaREgo95dy@google.com> <e729a63a-cded-da9c-3860-a90013b87e2d@gmail.com>
In-Reply-To: <e729a63a-cded-da9c-3860-a90013b87e2d@gmail.com>
From:   Stanislav Fomichev <sdf@google.com>
Date:   Wed, 15 Dec 2021 11:15:05 -0800
Message-ID: <CAKH8qBv+GsPz3JTTmLZ+Q2iMSC3PS+bE1xOLbxZyjfno7hqpSA@mail.gmail.com>
Subject: Re: [PATCH v3] cgroup/bpf: fast path skb BPF filtering
To:     Pavel Begunkov <asml.silence@gmail.com>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 15, 2021 at 10:54 AM Pavel Begunkov <asml.silence@gmail.com> wr=
ote:
>
> On 12/15/21 18:24, sdf@google.com wrote:
> > On 12/15, Pavel Begunkov wrote:
> >> On 12/15/21 17:33, sdf@google.com wrote:
> >> > On 12/15, Pavel Begunkov wrote:
> >> > > On 12/15/21 16:51, sdf@google.com wrote:
> >> > > > On 12/15, Pavel Begunkov wrote:
> >> > > > > =EF=BF=BD /* Wrappers for __cgroup_bpf_run_filter_skb() guarde=
d by cgroup_bpf_enabled. */
> >> > > > > =EF=BF=BD #define BPF_CGROUP_RUN_PROG_INET_INGRESS(sk, skb)=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
 \
> >> > > > > =EF=BF=BD ({=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD \
> >> > > > > =EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD int __ret =3D 0;=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=
=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD \
> >> > > > > -=EF=BF=BD=EF=BF=BD=EF=BF=BD if (cgroup_bpf_enabled(CGROUP_INE=
T_INGRESS))=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD \
> >> > > > > +=EF=BF=BD=EF=BF=BD=EF=BF=BD if (cgroup_bpf_enabled(CGROUP_INE=
T_INGRESS) && sk &&=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD \
> >> > > > > +=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=
=BD CGROUP_BPF_TYPE_ENABLED((sk), CGROUP_INET_INGRESS))=EF=BF=BD=EF=BF=BD=
=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD=EF=BF=BD \
> >> > > >
> >> > > > Why not add this __cgroup_bpf_run_filter_skb check to
> >> > > > __cgroup_bpf_run_filter_skb? Result of sock_cgroup_ptr() is alre=
ady there
> >> > > > and you can use it. Maybe move the things around if you want
> >> > > > it to happen earlier.
> >> >
> >> > > For inlining. Just wanted to get it done right, otherwise I'll lik=
ely be
> >> > > returning to it back in a few months complaining that I see measur=
able
> >> > > overhead from the function call :)
> >> >
> >> > Do you expect that direct call to bring any visible overhead?
> >> > Would be nice to compare that inlined case vs
> >> > __cgroup_bpf_prog_array_is_empty inside of __cgroup_bpf_run_filter_s=
kb
> >> > while you're at it (plus move offset initialization down?).
> >
> >> Sorry but that would be waste of time. I naively hope it will be visib=
le
> >> with net at some moment (if not already), that's how it was with io_ur=
ing,
> >> that's what I see in the block layer. And in anyway, if just one inlin=
ed
> >> won't make a difference, then 10 will.
> >
> > I can probably do more experiments on my side once your patch is
> > accepted. I'm mostly concerned with getsockopt(TCP_ZEROCOPY_RECEIVE).
> > If you claim there is visible overhead for a direct call then there
> > should be visible benefit to using CGROUP_BPF_TYPE_ENABLED there as
> > well.
>
> Interesting, sounds getsockopt might be performance sensitive to
> someone.
>
> FWIW, I forgot to mention that for testing tx I'm using io_uring
> (for both zc and not) with good submission batching.

Yeah, last time I saw 2-3% as well, but it was due to kmalloc, see
more details in 9cacf81f8161, it was pretty visible under perf.
That's why I'm a bit skeptical of your claims of direct calls being
somehow visible in these 2-3% (even skb pulls/pushes are not 2-3%?).
But tbf I don't understand how it all plays out with the io_uring.

(mostly trying to understand where there is some gain left on the
table for TCP_ZEROCOPY_RECEIVE).
