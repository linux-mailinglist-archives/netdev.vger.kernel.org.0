Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11223205A90
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 20:28:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733247AbgFWS1z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 14:27:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34918 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1733149AbgFWS1y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 14:27:54 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2B6F2C061573;
        Tue, 23 Jun 2020 11:27:53 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id h18so982901qvl.3;
        Tue, 23 Jun 2020 11:27:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1O7Td08iMpY38VhWo9qpN3mfhIo1AkQ4yxdxtTVUSKI=;
        b=C4Z6PxZ7dPp2FeUzakh1U0BaGjvPDOVJwIY3BF01MLMyoe3J+Au1dDJSl3pGewmUm6
         a4iAcdnBLbNR66P2UX4zNNnhFO+kb7pY1mOcrWJwyGXyHBi63rVN1eZEln3HbSWvrxAK
         iKgpasZP1z9hJ/QdxQvESY1EKV2rTz2wCdb3t2vX08JDzuA86D+mrnx5B+1Y5P3AVPPT
         7RBJIMv3Q69svIIzcPaPaTLWarwk5nQWXJUk4FVztpASTPSH+sVFdrASMsxAg7Iw5Xst
         mMmwh2Y1mtnjxjG2ceEuzuVb4PKOzVdMRH35zCk90sQyTkJLDa9oVvq9oUKNhAKUL/iD
         O0ug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1O7Td08iMpY38VhWo9qpN3mfhIo1AkQ4yxdxtTVUSKI=;
        b=GkeCVYN36PwzQ61p9GTvyMRHPb34eQXYAL30GeRBHPuvOILge11DnZXQCiRN9CjXbh
         ecIFD++ffgYkPOGR88r3PmoXmLXDLmm9AcorNPLhYD7WvaOlValoLdfeIe1sUbHGWYuV
         hKFVVSDyVF0QWX/ATtCMZS6DkfgZnZ4UnKZ0bjS1RTrEnIxTnp93eXZjfbKrcRhijPKz
         d3ORVod1SbFEY187G12pf0yX5G/IHwLYecw+7B0IvbKZLVkpby/lpUtM2TGGAVeYvYPz
         0Pc9xiuoSOZklRdkYjERCzSw7rUXxogJgcDmuJC61bWOiCOWs0YrN5LKuDKb+os2nbyt
         XH5A==
X-Gm-Message-State: AOAM533byE6k3HqMYvJaaHtc1BiWIHoXNjFncubqPIF8tP+t0ykb3s0I
        lpgz3n3h5ZwaFQaDirLdoIdyg9rPF2FFT1S0jN0=
X-Google-Smtp-Source: ABdhPJwJmXrjSQDs/EBrVI5rSGdFDfk7TBwk2HUW4cUl5dpqT4pVxde1BjC+9Z5vvDIlXuOAPdvHqMucrK+LPBTCMY0=
X-Received: by 2002:a0c:f388:: with SMTP id i8mr27473026qvk.224.1592936872342;
 Tue, 23 Jun 2020 11:27:52 -0700 (PDT)
MIME-Version: 1.0
References: <20200623155157.13082-1-quentin@isovalent.com>
In-Reply-To: <20200623155157.13082-1-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 23 Jun 2020 11:27:41 -0700
Message-ID: <CAEf4BzYeP784xwgnSsoCn=vy37-bLa4=jZUDW35t3MNMUGVdmA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] tools: bpftool: do not pass json_wtr to emit_obj_refs_json()
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 8:54 AM Quentin Monnet <quentin@isovalent.com> wrot=
e:
>
> Building bpftool yields the following complaint:
>
>     pids.c: In function =E2=80=98emit_obj_refs_json=E2=80=99:
>     pids.c:175:80: warning: declaration of =E2=80=98json_wtr=E2=80=99 sha=
dows a global declaration [-Wshadow]
>       175 | void emit_obj_refs_json(struct obj_refs_table *table, __u32 i=
d, json_writer_t *json_wtr)
>           |                                                              =
   ~~~~~~~~~~~~~~~^~~~~~~~
>     In file included from pids.c:11:
>     main.h:141:23: note: shadowed declaration is here
>       141 | extern json_writer_t *json_wtr;
>           |                       ^~~~~~~~
>
> json_wtr being exposed in main.h (included in pids.c) as an extern, it
> is directly available and there is no need to pass it through the
> function. Let's simply use the global variable.

I don't think it's a good approach to assume that emit_obj_refs_json
is always going to be using a global json writer. I think this shadow
warning is bogus in this case, honestly. But if it bothers you, let's
just rename json_wtr into whatever other name of argument you prefer.

>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/bpf/bpftool/btf.c  | 2 +-
>  tools/bpf/bpftool/link.c | 2 +-
>  tools/bpf/bpftool/main.h | 3 +--
>  tools/bpf/bpftool/map.c  | 2 +-
>  tools/bpf/bpftool/pids.c | 2 +-
>  tools/bpf/bpftool/prog.c | 2 +-
>  6 files changed, 6 insertions(+), 7 deletions(-)
>

[...]
