Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F21B02311BF
	for <lists+netdev@lfdr.de>; Tue, 28 Jul 2020 20:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732382AbgG1SaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jul 2020 14:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44762 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729310AbgG1SaQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jul 2020 14:30:16 -0400
Received: from mail-qk1-x743.google.com (mail-qk1-x743.google.com [IPv6:2607:f8b0:4864:20::743])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FDEFC061794;
        Tue, 28 Jul 2020 11:30:16 -0700 (PDT)
Received: by mail-qk1-x743.google.com with SMTP id b79so19619313qkg.9;
        Tue, 28 Jul 2020 11:30:16 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=7bECQ5mdJV9juPwLlMc+XOTBw4TPn5avVxK6LBxKok4=;
        b=kcNywvwojc3NoFO2SgOzoHAllB1MTBbfYdhAMh5lJNKh4Bk2YpCzRmK8UDqHmGp1ST
         tsu9/yAJl50OODjnIHDdymdTaK3b1NpSIBg93JYkSTL5x5c0LrDNPDJH5iN6sJE1SWHw
         ETgmMMaHeqTAJCU79vCxIa7tWfRz9czHJEILMRcSjW1MsuprWPCdDZuFrpjRGrScFJwB
         KJ0LYwH4Hry29AOdEJPST9Zo6ZXIosi8OaqOFY9f6xTswrHYNyk9GnChtS1cle1L45BD
         hLEQA9lEPZM4ND6M+45id3MCB4R5unEpL3iIu9UjMuHsc8VxL1bz2PWQdWPgOe6Ttf0Y
         iOuA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7bECQ5mdJV9juPwLlMc+XOTBw4TPn5avVxK6LBxKok4=;
        b=dm+ojlMWZK/llLIGxFa+rXpOS7sug3tnBYqikK5VKJ+t7o5kP1HHEzSFVyHMMIoHQU
         AIb5vWSpQSBbYpJU5UDywIps/stqCl/gXWaUheIkGfwB+3ZILVLNFTM60+MNyBnqXruP
         +QLnzJz9bnr2mwZ2SO7I3U3MebHctEdwY6i+xrB+xio8iLf9GyqlVtceW3eEWrh95JD8
         KQuhGPwqLk/5Mqp306kQnYsShRDoqhG8xe2HWyqzvlhYy6Fwg0lHHI26ewYhmhKZOIvB
         Ilw1eAbb7AidZ2O2WqRGRbPWt1ev5oFZGe/Y4JWHk+uhJVe0H+VhwF7oicQEX+1pcD7i
         if1w==
X-Gm-Message-State: AOAM530Oe9VVB8GH7tFB4bJ5xF9qT3HI6JAT3/s8x9MViC8F+NcMt90w
        8L3Wbij1/M6rWEQZ6yjmPYdEdYW/LvnvuG4NLac=
X-Google-Smtp-Source: ABdhPJyJZITUBGPqppMcW0XhAR41Q00ZO+emE5RAHkhnRoTntX2fDp1VBhQTwfBqjxBZMhTB8hioVnmJPJb0IbSIphI=
X-Received: by 2002:a37:a655:: with SMTP id p82mr28886863qke.92.1595961015352;
 Tue, 28 Jul 2020 11:30:15 -0700 (PDT)
MIME-Version: 1.0
References: <20200727184506.2279656-1-guro@fb.com> <20200727184506.2279656-33-guro@fb.com>
 <CAEf4BzbCzEOKx2GMOcp6CTxBBN+BRAY-Z_mCJ26hoSto956KBQ@mail.gmail.com> <C739D492-23E2-4823-8A9A-81BF00FD450E@fb.com>
In-Reply-To: <C739D492-23E2-4823-8A9A-81BF00FD450E@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 28 Jul 2020 11:30:04 -0700
Message-ID: <CAEf4BzaNEnK6UpfvPpEPpU+fLi=Zsrr5YUc0+t20a_TK_oj22A@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 32/35] bpf: selftests: delete bpf_rlimit.h
To:     Song Liu <songliubraving@fb.com>
Cc:     Roman Gushchin <guro@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <Kernel-team@fb.com>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 27, 2020 at 11:11 PM Song Liu <songliubraving@fb.com> wrote:
>
>
>
> > On Jul 27, 2020, at 11:06 PM, Andrii Nakryiko <andrii.nakryiko@gmail.com> wrote:
> >
> > On Mon, Jul 27, 2020 at 12:25 PM Roman Gushchin <guro@fb.com> wrote:
> >>
> >> As rlimit-based memory accounting is not used by bpf anymore,
> >> there are no more reasons to play with memlock rlimit.
> >>
> >> Delete bpf_rlimit.h which contained a code to bump the limit.
> >>
> >> Signed-off-by: Roman Gushchin <guro@fb.com>
> >> ---
> >
> > We run test_progs on old kernels as part of libbpf Github CI. We'll
> > need to either leave setrlimit() or do it conditionally, depending on
> > detected kernel feature support.
>
> Hmm... I am surprised that running test_progs on old kernels is not
> too noisy. Have we got any issue with that?
>

For libbpf CI we maintain a list of enabled/disabled tests that are
not supposed to succeed on a given kernel. So it works OK in practice,
just needs an occasional update to those lists.


> Thanks,
> Song
>
> >
> >> samples/bpf/hbm.c                             |  1 -
> >> tools/testing/selftests/bpf/bpf_rlimit.h      | 28 -------------------
> >> .../selftests/bpf/flow_dissector_load.c       |  1 -
> >> .../selftests/bpf/get_cgroup_id_user.c        |  1 -
> >> .../bpf/prog_tests/select_reuseport.c         |  1 -
> >> .../selftests/bpf/prog_tests/sk_lookup.c      |  1 -
> >> tools/testing/selftests/bpf/test_btf.c        |  1 -
> >> .../selftests/bpf/test_cgroup_storage.c       |  1 -
> >> tools/testing/selftests/bpf/test_dev_cgroup.c |  1 -
> >> tools/testing/selftests/bpf/test_lpm_map.c    |  1 -
> >> tools/testing/selftests/bpf/test_lru_map.c    |  1 -
> >> tools/testing/selftests/bpf/test_maps.c       |  1 -
> >> tools/testing/selftests/bpf/test_netcnt.c     |  1 -
> >> tools/testing/selftests/bpf/test_progs.c      |  1 -
> >> .../selftests/bpf/test_skb_cgroup_id_user.c   |  1 -
> >> tools/testing/selftests/bpf/test_sock.c       |  1 -
> >> tools/testing/selftests/bpf/test_sock_addr.c  |  1 -
> >> .../testing/selftests/bpf/test_sock_fields.c  |  1 -
> >> .../selftests/bpf/test_socket_cookie.c        |  1 -
> >> tools/testing/selftests/bpf/test_sockmap.c    |  1 -
> >> tools/testing/selftests/bpf/test_sysctl.c     |  1 -
> >> tools/testing/selftests/bpf/test_tag.c        |  1 -
> >> .../bpf/test_tcp_check_syncookie_user.c       |  1 -
> >> .../testing/selftests/bpf/test_tcpbpf_user.c  |  1 -
> >> .../selftests/bpf/test_tcpnotify_user.c       |  1 -
> >> tools/testing/selftests/bpf/test_verifier.c   |  1 -
> >> .../testing/selftests/bpf/test_verifier_log.c |  2 --
> >> 27 files changed, 55 deletions(-)
> >> delete mode 100644 tools/testing/selftests/bpf/bpf_rlimit.h
> >>
> >
> > [...]
>
