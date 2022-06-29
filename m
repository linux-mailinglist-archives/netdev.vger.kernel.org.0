Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 00C71560B19
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 22:35:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229862AbiF2Ufz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 16:35:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbiF2Ufy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 16:35:54 -0400
Received: from mail-qk1-x72b.google.com (mail-qk1-x72b.google.com [IPv6:2607:f8b0:4864:20::72b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DCF2130F5D
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 13:35:53 -0700 (PDT)
Received: by mail-qk1-x72b.google.com with SMTP id n10so9537911qkn.10
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 13:35:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=isovalent-com.20210112.gappssmtp.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=e06NiwlzrDtucaME1T23A36SMVhatovaVuRYM5kc3js=;
        b=gSenJMJXQH60gXrQcKp6157X6re0UlV7vB44+S0ri+PGyiZqpxOICfVuyEd6agjs5M
         YujXaVikzY8Wkjn6QiJ9KO1p6suVNuJJgY87vDDeSO25nPNLac/ARW3RQwKPpHhuMwQ9
         r0rCu03420C8F6GKm5VoGveloFABhTlM7MKy9RLK9rgRA02Bwwqz8XR0hlrhGnz8xDvw
         nMFY/c597dtRuqs01qE/Bf2Ht31OfpzvvC0sAbubL4x2SfmDkhJPfmve0Dl9bjOus/4j
         iLwI2HWRzd4bONxrEAjqN35AW3v6TyTp98GOGTVDZIhcsg9GxCjVNkSWuLokirKjg5le
         SJ/Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=e06NiwlzrDtucaME1T23A36SMVhatovaVuRYM5kc3js=;
        b=6YqmaA2ge18wA04eB1dK3If9dKRcMsNT3gyhjzrXW7zRw+CxuAbf5gox/zcfbThe7o
         2EKtYpH81n2m6A7tV+s/DQjsD61ZqT5F+El/91/ONqFFi3Jw9Pr7B2BXLb3R6UDfLQFp
         WlX5UniNq9bR4ptmdS7wzRr9dzL3hWjrxCBeTHSrohiMI/3WCKQhGAy0rsacvUPp8N89
         YA71BhLb+P2Tu4AK+4cPDVDHfzgPPStHSIbIJXAubZsuSxlsMuRQZFZvaTp29lhUuP8l
         8DXXl+D99Cqus/SY7OcZm8pbjd8C3psZGScLWBhj2ChKyzmeu7IZHUHSEGld2akpaCkU
         7jkQ==
X-Gm-Message-State: AJIora9qXSMSRpgW91RPynAm6A+DnsQugXejOM9jjCRnQM9X5Ocypk0A
        M/yO+wcwT19ifJIeTtjxNkqK5mJgDb0ftShDiDoLxg==
X-Google-Smtp-Source: AGRyM1smOK0ndpCernZcqsD06UibwdE1lKGZGWA4naiOMfm63gZOa/25JLmWc8ktqGtCZrpQwG3Afsm0jluqjw01hfw=
X-Received: by 2002:a05:620a:6006:b0:6af:a58:a19 with SMTP id
 dw6-20020a05620a600600b006af0a580a19mr3722206qkb.534.1656534953046; Wed, 29
 Jun 2022 13:35:53 -0700 (PDT)
MIME-Version: 1.0
References: <20220629144019.75181-1-quentin@isovalent.com> <20220629144019.75181-2-quentin@isovalent.com>
 <20220629173251.zk33plyiqsrkfpzg@muellerd-fedora-MJ0AC3F3>
In-Reply-To: <20220629173251.zk33plyiqsrkfpzg@muellerd-fedora-MJ0AC3F3>
From:   Quentin Monnet <quentin@isovalent.com>
Date:   Wed, 29 Jun 2022 21:35:41 +0100
Message-ID: <CACdoK4Ktf4HWtrDK9_k0yMXEg3G90qYiG9+65NbbSn3aSVaBTQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/2] bpftool: Add feature list
 (prog/map/link/attach types, helpers)
To:     =?UTF-8?Q?Daniel_M=C3=BCller?= <deso@posteo.net>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Jun 2022 at 18:33, Daniel M=C3=BCller <deso@posteo.net> wrote:
>
> On Wed, Jun 29, 2022 at 03:40:18PM +0100, Quentin Monnet wrote:
> > Add a "bpftool feature list" subcommand to list BPF "features".
> > Contrarily to "bpftool feature probe", this is not about the features
> > available on the system. Instead, it lists all features known to bpftoo=
l
> > from compilation time; in other words, all program, map, attach, link
> > types known to the libbpf version in use, and all helpers found in the
> > UAPI BPF header.
> >
> > The first use case for this feature is bash completion: running the
> > command provides a list of types that can be used to produce the list o=
f
> > candidate map types, for example.
> >
> > Now that bpftool uses "standard" names provided by libbpf for the
> > program, map, link, and attach types, having the ability to list these
> > types and helpers could also be useful in scripts to loop over existing
> > items.
> >
> > Sample output:
> >
> >     # bpftool feature list prog_types | grep -vw unspec | head -n 6
> >     socket_filter
> >     kprobe
> >     sched_cls
> >     sched_act
> >     tracepoint
> >     xdp
> >
> >     # bpftool -p feature list map_types | jq '.[1]'
> >     "hash"
> >
> >     # bpftool feature list attach_types | grep '^cgroup_'
> >     cgroup_inet_ingress
> >     cgroup_inet_egress
> >     [...]
> >     cgroup_inet_sock_release
> >
> >     # bpftool feature list helpers | grep -vw bpf_unspec | wc -l
> >     207
> >
> > The "unspec" types and helpers are not filtered out by bpftool, so as t=
o
> > remain closer to the enums, and to preserve the indices in the JSON
> > arrays (e.g. "hash" at index 1 =3D=3D BPF_MAP_TYPE_HASH in map types li=
st).
> >
> > Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> > ---
> >  .../bpftool/Documentation/bpftool-feature.rst | 12 ++++
> >  tools/bpf/bpftool/bash-completion/bpftool     |  7 ++-
> >  tools/bpf/bpftool/feature.c                   | 55 +++++++++++++++++++
> >  3 files changed, 73 insertions(+), 1 deletion(-)
> >
> > diff --git a/tools/bpf/bpftool/Documentation/bpftool-feature.rst b/tool=
s/bpf/bpftool/Documentation/bpftool-feature.rst
> > index 4ce9a77bc1e0..4bf1724d0e8c 100644
> > --- a/tools/bpf/bpftool/Documentation/bpftool-feature.rst
> > +++ b/tools/bpf/bpftool/Documentation/bpftool-feature.rst
> > @@ -24,9 +24,11 @@ FEATURE COMMANDS
> >  =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
> >
> >  |    **bpftool** **feature probe** [*COMPONENT*] [**full**] [**unprivi=
leged**] [**macros** [**prefix** *PREFIX*]]
> > +|    **bpftool** **feature list** *GROUP*
> >  |    **bpftool** **feature help**
> >  |
> >  |    *COMPONENT* :=3D { **kernel** | **dev** *NAME* }
> > +|    *GROUP* :=3D { **prog_types** | **map_types** | **attach_types** =
| **helpers** }
>
> Is **link_types** missing from this enumeration?

Yes of course, thanks for catching this. And for the review! v2 is on its w=
ay.
Quentin
