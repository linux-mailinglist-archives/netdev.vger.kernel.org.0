Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84802522C1A
	for <lists+netdev@lfdr.de>; Wed, 11 May 2022 08:10:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238207AbiEKGKu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 02:10:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229899AbiEKGKs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 02:10:48 -0400
Received: from mail-pj1-x1036.google.com (mail-pj1-x1036.google.com [IPv6:2607:f8b0:4864:20::1036])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE104205EE;
        Tue, 10 May 2022 23:10:45 -0700 (PDT)
Received: by mail-pj1-x1036.google.com with SMTP id x88so1298964pjj.1;
        Tue, 10 May 2022 23:10:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=Rxwmw7F4yraTtQttPtF/0wZ/ikGq2Rscn+f5iMrT7V8=;
        b=hk5nmcxWqr1+4XZIG4Y2EoHdn4MFyQuBSg3wMbJB03xCN3J0/fGQJI9kJKzQLLlWfP
         ZDVe37fm/UkBmm/PkjCtG1P4jelVut0rqGMNUuM6eaNwDqMDWJXOAVNl43inn/9fzuiX
         08PIOuW+zLnKULD33PrfJiIhTaBGApajk5KJgbDuUBGdDqvD325R1qkKy6xn2plIZWb6
         q0aQvfYNQ6zMw9ug/iMN/mRFoKLZLTd/4HF2ZzjOoZxf4gLk0u7t38GhennBESJ0W/R3
         gpWBhIKHac6jv9zJ8sSWOg69s2c3x674NJk5GSfVmEAeoaiakgRb0u/l55Wh9RH3czUw
         sUqA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=Rxwmw7F4yraTtQttPtF/0wZ/ikGq2Rscn+f5iMrT7V8=;
        b=wYldsW1JXUalSrSHKRfmylqPaxvLv3fbH5+8XCpmWHWujyespPWtDMZFl/OhQQIeuF
         xN6sSG3THp+7hC+NeJHCqfYak2dtQAEgqOMTUF03TJXRFb4LF2iOlngGUZUODzmGZ3Ic
         9xybs+godMM4/tPZH9Q0aDO1dJDHmDLSJ17gGpLVAD83Hs4Sxa9SZsSIEZdBDHiLR5qJ
         DZZlO80ePidx8M9oxFVzHntQfBotPAK3APKc/u4wp+6sA4oKTXCcSmt3yN3ZSUlkzKYh
         wI7nm3HKLd9l3bB48Wt5+szB9sszQZJAs1y2hpMPBzqlEpZq1VH2kmw9VrYEsFHNgyTf
         Jo9A==
X-Gm-Message-State: AOAM5332wQMR0n45xZCerDPjr3xV7gf+k0OxDq9WS6rP1uYIi4Gc9gG1
        IaqFJD5bZGodb8djffbq3tfKdwNyBuwQc8CzyzrOOM/97bk=
X-Google-Smtp-Source: ABdhPJyvXv/OGzpotKsy1AIe0kD136J2PA88iaQfJStWhn17wXqCV6y8+g7+UBAut26mWSxafLKVkQRZipa4VxIIYG4=
X-Received: by 2002:a17:902:8f8d:b0:15b:7b98:22e6 with SMTP id
 z13-20020a1709028f8d00b0015b7b9822e6mr23907991plo.102.1652249445174; Tue, 10
 May 2022 23:10:45 -0700 (PDT)
MIME-Version: 1.0
References: <20220502211235.142250-1-mathew.j.martineau@linux.intel.com>
 <20220502211235.142250-2-mathew.j.martineau@linux.intel.com>
 <20220511004818.qnfpzgepmg7xufwd@kafai-mbp.dhcp.thefacebook.com> <CAEf4BzbnsdSAKoZhQbX8WPuNtnJBx9hNLS2ct8gBkSRg-=Meog@mail.gmail.com>
In-Reply-To: <CAEf4BzbnsdSAKoZhQbX8WPuNtnJBx9hNLS2ct8gBkSRg-=Meog@mail.gmail.com>
From:   Geliang Tang <geliangtang@gmail.com>
Date:   Wed, 11 May 2022 14:10:42 +0800
Message-ID: <CA+WQbwvdOPk7c1s648kgkgVf+DOrEhRvOv2kz+WuP8eWV+qvBA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 1/8] bpf: expose is_mptcp flag to bpf_tcp_sock
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Martin KaFai Lau <kafai@fb.com>,
        Mat Martineau <mathew.j.martineau@linux.intel.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Nicolas Rybowski <nicolas.rybowski@tessares.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        MPTCP Upstream <mptcp@lists.linux.dev>,
        Matthieu Baerts <matthieu.baerts@tessares.net>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrii Nakryiko <andrii.nakryiko@gmail.com> =E4=BA=8E2022=E5=B9=B45=E6=9C=
=8811=E6=97=A5=E5=91=A8=E4=B8=89 13:02=E5=86=99=E9=81=93=EF=BC=9A
>
> On Tue, May 10, 2022 at 5:48 PM Martin KaFai Lau <kafai@fb.com> wrote:
> >
> > On Mon, May 02, 2022 at 02:12:27PM -0700, Mat Martineau wrote:
> > > From: Nicolas Rybowski <nicolas.rybowski@tessares.net>
> > >
> > > is_mptcp is a field from struct tcp_sock used to indicate that the
> > > current tcp_sock is part of the MPTCP protocol.
> > >
> > > In this protocol, a first socket (mptcp_sock) is created with
> > > sk_protocol set to IPPROTO_MPTCP (=3D262) for control purpose but it
> > > isn't directly on the wire. This is the role of the subflow (kernel)
> > > sockets which are classical tcp_sock with sk_protocol set to
> > > IPPROTO_TCP. The only way to differentiate such sockets from plain TC=
P
> > > sockets is the is_mptcp field from tcp_sock.
> > >
> > > Such an exposure in BPF is thus required to be able to differentiate
> > > plain TCP sockets from MPTCP subflow sockets in BPF_PROG_TYPE_SOCK_OP=
S
> > > programs.
> > >
> > > The choice has been made to silently pass the case when CONFIG_MPTCP =
is
> > > unset by defaulting is_mptcp to 0 in order to make BPF independent of
> > > the MPTCP configuration. Another solution is to make the verifier fai=
l
> > > in 'bpf_tcp_sock_is_valid_ctx_access' but this will add an additional
> > > '#ifdef CONFIG_MPTCP' in the BPF code and a same injected BPF program
> > > will not run if MPTCP is not set.
> > There is already bpf_skc_to_tcp_sock() and its returned tcp_sock pointe=
r
> > can access all fields of the "struct tcp_sock" without extending
> > the bpf_tcp_sock.
> >
> > iiuc, I believe the needs to extend bpf_tcp_sock here is to make the
> > same bpf sockops prog works for kernel with and without CONFIG_MPTCP
> > because tp->is_mptcp is not always available:
> >
> > struct tcp_sock {
> >         /* ... */
> >
> > #if IS_ENABLED(CONFIG_MPTCP)
> >         bool    is_mptcp;
> > #endif
> > };
> >
> > Andrii, do you think bpf_core_field_exists() can be used in
> > the bpf prog to test if is_mptcp is available in the running kernel
> > such that the same bpf prog can be used in kernel with and without
> > CONFIG_MPTCP?
>
> yep, absolutely:
>
> bool is_mptcp =3D bpf_core_field_exists(struct tcp_sock, is_mptcp) ?
> sock->is_mptcp : false;
>
> One can also directly check if CONFIG_MPTCP is set with the following
> in BPF-side code:
>
> extern bool CONFIG_MPTCP __kconfig;

Thanks Martin & Andrii, will update this in v4.

-Geliang
SUSE

>
