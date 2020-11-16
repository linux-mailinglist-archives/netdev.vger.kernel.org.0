Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 227182B3D97
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 08:21:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727204AbgKPHTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 02:19:41 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726831AbgKPHTk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Nov 2020 02:19:40 -0500
Received: from mail-lj1-x22c.google.com (mail-lj1-x22c.google.com [IPv6:2a00:1450:4864:20::22c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64DA2C0613CF;
        Sun, 15 Nov 2020 23:19:40 -0800 (PST)
Received: by mail-lj1-x22c.google.com with SMTP id y16so18978180ljh.0;
        Sun, 15 Nov 2020 23:19:40 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=h6yq4RxQKFNJbv5LYFFym5s3TAbtk0ibN0KzJ9c9nlk=;
        b=W59GKviwI+4mQRASZ+TZt+dmYcXbOTGQqVfGVfzmmzPIjNTsctl4x+TpAorQCk3NOY
         QbRRCxplCsw3bRA6ws759bQfWLnAoxUwhHzzbPAIM3/+guN3kLfbPLCSHcvfLhE3px9x
         ggm23TzVPROlBSceJxOzFRJH8wu0S41xeUOtq6z7xe5+8TLHi6BHTpplFgszI6xWDRJp
         f+md9Q7uBylrx7gnmPqvEK6JvC8X+NlgH2bchlh2bBEhDoHBg4mb0IgAKuH/NmFrJ6Lo
         qjbC8siyJP/0d1LcXj6KdILQUKb2KgYFVFr6q8WIuGtt46f5N7uS3kfv7FYDjf9SH/No
         llQw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=h6yq4RxQKFNJbv5LYFFym5s3TAbtk0ibN0KzJ9c9nlk=;
        b=rgKgmRNfw79LWMg90WkPBpcJ0kClbj/kMGIrMAwdWW9RqlDUeg7dB1HbFXSt8w5ZEY
         ga8hmFeyXm8D4GLbaGBNRNjKaWB4iqhheZzJCobHMpWvUUX+OneG+pQwLAGA0KEjL/zR
         EFwBNNY1AYDjDI1MhcTOrHJ4FvK9qNl1b8+Xi8PrlGVSoQDLhk6gV+f0mR+EXkQbga10
         3lx7wKsSEcE47/BphXbdN5vIExUnkxF3dHoem2w2eUJM0AvTSJfdHeGOnkMwFTsvzYKO
         U6PngjK59f5ReIaXbnY3smSsDUulU9QJOUy1Ki/Nsk1qv/noBbAbVEddkCsK8H9Lj67s
         I/og==
X-Gm-Message-State: AOAM533lo2a4La5h/w+jaEzFW69KWoTmtZTa3tDNjMNqSq9OxvYrcsUS
        AjZwFo1JP6EBcBxSytaYfPOzYBCdUe1TnNt8ZqIlvDOgULA=
X-Google-Smtp-Source: ABdhPJymjAWioE1WOL8mdPvyK2ganrrEEYQkejsX+EOYRv4e8qrEOMF7M16Srm09uPMSlX2m0Ij5zMKbcBCavMv+jv4=
X-Received: by 2002:a2e:9681:: with SMTP id q1mr6025714lji.2.1605511178792;
 Sun, 15 Nov 2020 23:19:38 -0800 (PST)
MIME-Version: 1.0
References: <20201109070802.3638167-1-haliu@redhat.com> <20201116065305.1010651-1-haliu@redhat.com>
In-Reply-To: <20201116065305.1010651-1-haliu@redhat.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 15 Nov 2020 23:19:26 -0800
Message-ID: <CAADnVQ+LNBYq5fdTSRUPy2ZexTdCcB6ErNH_T=r9bJ807UT=pQ@mail.gmail.com>
Subject: Re: [PATCHv5 iproute2-next 0/5] iproute2: add libbpf support
To:     Hangbin Liu <haliu@redhat.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        David Ahern <dsahern@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        David Miller <davem@davemloft.net>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Jiri Benc <jbenc@redhat.com>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 15, 2020 at 10:56 PM Hangbin Liu <haliu@redhat.com> wrote:
>
> This series converts iproute2 to use libbpf for loading and attaching
> BPF programs when it is available. This means that iproute2 will
> correctly process BTF information and support the new-style BTF-defined
> maps, while keeping compatibility with the old internal map definition
> syntax.
>
> This is achieved by checking for libbpf at './configure' time, and using
> it if available. By default the system libbpf will be used, but static
> linking against a custom libbpf version can be achieved by passing
> LIBBPF_DIR to configure. LIBBPF_FORCE can be set to on to force configure
> abort if no suitable libbpf is found (useful for automatic packaging
> that wants to enforce the dependency), or set off to disable libbpf check
> and build iproute2 with legacy bpf.
>
> The old iproute2 bpf code is kept and will be used if no suitable libbpf
> is available. When using libbpf, wrapper code ensures that iproute2 will
> still understand the old map definition format, including populating
> map-in-map and tail call maps before load.
>
> The examples in bpf/examples are kept, and a separate set of examples
> are added with BTF-based map definitions for those examples where this
> is possible (libbpf doesn't currently support declaratively populating
> tail call maps).
>
> At last, Thanks a lot for Toke's help on this patch set.
>
> v5:
> a) Fix LIBBPF_DIR typo and description, use libbpf DESTDIR as LIBBPF_DIR
>    dest.
> b) Fix bpf_prog_load_dev typo.
> c) rebase to latest iproute2-next.

For the reasons explained multiple times earlier:
Nacked-by: Alexei Starovoitov <ast@kernel.org>
