Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9327A26B6F7
	for <lists+netdev@lfdr.de>; Wed, 16 Sep 2020 02:15:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727250AbgIPAOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Sep 2020 20:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41034 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726526AbgIPAO3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Sep 2020 20:14:29 -0400
Received: from mail-yb1-xb42.google.com (mail-yb1-xb42.google.com [IPv6:2607:f8b0:4864:20::b42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED43FC06174A;
        Tue, 15 Sep 2020 17:14:28 -0700 (PDT)
Received: by mail-yb1-xb42.google.com with SMTP id v60so4010557ybi.10;
        Tue, 15 Sep 2020 17:14:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=K5Ll6sUN+I8bojusjxSoPadm5ma0qWSeVPQrhHjvQ1g=;
        b=G7QKuq0tbyi5oYS8LKrsmBT8dm+ZhC6teoDJa0HjL4QzWIH/wfSf+bCyHKVflmmsrp
         8Bsxo6Vmmgqy+IFmysfmUa5mQsCvqsW3sJf42mgwrxhWLXRU4NHu9FEumAx1voiaPwLD
         oaS3hvNzqmkFuU9rpAiDb/+VRaSMAnKN6GPQXFpvdMLd6CqxksqFTkKdsISIedKRlHcC
         HzqTmogXLyF8vWZRMRSzydQs0IZL4o+UOIeUKbfG+t2y4N+hk45CHsodLhtqGm0uJdiL
         RVR+L6YhUWfbUETwue0zvUvwJG4JkaxStC21pgGgAzwOPnJPvFHusFtSiU1tSdwoOjTS
         TUBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=K5Ll6sUN+I8bojusjxSoPadm5ma0qWSeVPQrhHjvQ1g=;
        b=HkagxeWSdJ+aZpPPqevVm/JSpUh6v6nmn6Z+OV6w1mYKZq9/BQ0taKXeZYWQVhk7Qi
         doCbs0IySCDstFO9y6stUIg2+/rtfvTv+FeR8PY0ad1tTvS4h6DxeZ/s4SF8MabfZuTK
         ppxfV+rEI2yWZY5OzQYpBkXvzDx1OsBZcnAmZxkM1quVIZe5es7dSf/+DGJKbuJQ+UsE
         X3T2pblTP0iORWQNlbaUd1XHDfD/yGFqA2nxb6C77dxbb2TvF9YvI0+LF+gVifkvcaHX
         XSQCm9jHDb6XWnZyaQxJ6oRCpPrGz3Gnykp1uUPISuEaRmcdN2e++zE8OINwsMhIpD9l
         Vj4Q==
X-Gm-Message-State: AOAM531Q6pInT5BUxflZ06+YFT4kDhqE5uc4bRk2wiFsOVr6CzM/qz2o
        ar9EOzxAvBR2z4XH6/3jSHs32TLnOS+BF6XGFpU=
X-Google-Smtp-Source: ABdhPJwZWSwauZGuF7o6YsgkQ8gBo3mmCtzRUpi5y2Lvq00iXiujWQxc1W8Zq0oNpnJeG/vp15S0MkQmDDA0YzI8Qps=
X-Received: by 2002:a25:da90:: with SMTP id n138mr11893648ybf.260.1600215267437;
 Tue, 15 Sep 2020 17:14:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200915014341.2949692-1-andriin@fb.com> <20200915233750.imml2qj6p72olga4@ast-mbp.dhcp.thefacebook.com>
In-Reply-To: <20200915233750.imml2qj6p72olga4@ast-mbp.dhcp.thefacebook.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 15 Sep 2020 17:14:16 -0700
Message-ID: <CAEf4BzaQdbR8BMRTOJpQtNc2oe77F9Uu2=EmJXXP5fQjXY414w@mail.gmail.com>
Subject: Re: [PATCH v2 bpf-next] selftests/bpf: merge most of test_btf into test_progs
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Sep 15, 2020 at 4:37 PM Alexei Starovoitov
<alexei.starovoitov@gmail.com> wrote:
>
> On Mon, Sep 14, 2020 at 06:43:41PM -0700, Andrii Nakryiko wrote:
> > Move almost 200 tests from test_btf into test_progs framework to be exercised
> > regularly. Pretty-printing tests were left alone and renamed into
> > test_btf_pprint because they are very slow and were not even executed by
> > default with test_btf.
>
> I think would be good to run them by default.
> The following trivial tweak makes them fast:

Sounds good, I'll debug why it was failing now that I can run it reasonably.

> diff --git a/tools/testing/selftests/bpf/test_btf.c b/tools/testing/selftests/bpf/test_btf.c
> index c75fc6447186..589afd4f0e47 100644
> --- a/tools/testing/selftests/bpf/test_btf.c
> +++ b/tools/testing/selftests/bpf/test_btf.c
> @@ -4428,7 +4428,7 @@ static struct btf_raw_test pprint_test_template[] = {
>         .value_size = sizeof(struct pprint_mapv),
>         .key_type_id = 3,       /* unsigned int */
>         .value_type_id = 16,    /* struct pprint_mapv */
> -       .max_entries = 128 * 1024,
> +       .max_entries = 128,
>  },
>
>  {
> @@ -4493,7 +4493,7 @@ static struct btf_raw_test pprint_test_template[] = {
>         .value_size = sizeof(struct pprint_mapv),
>         .key_type_id = 3,       /* unsigned int */
>         .value_type_id = 16,    /* struct pprint_mapv */
> -       .max_entries = 128 * 1024,
> +       .max_entries = 128,
>  },
>
>  {
> @@ -4564,7 +4564,7 @@ static struct btf_raw_test pprint_test_template[] = {
>         .value_size = sizeof(struct pprint_mapv),
>         .key_type_id = 3,       /* unsigned int */
>         .value_type_id = 16,    /* struct pprint_mapv */
> -       .max_entries = 128 * 1024,
> +       .max_entries = 128,
>  },
>
> Martin,
> do you remember why you picked such large numbers of entries
> for the test?
> If I read the code correctly smaller number doesn't reduce the test coverage.
>
> > All the test_btf tests that were moved are modeled as proper sub-tests in
> > test_progs framework for ease of debugging and reporting.
> >
> > No functional or behavioral changes were intended, I tried to preserve
> > original behavior as close to the original as possible. `test_progs -v` will
> > activate "always_log" flag to emit BTF validation log.
> >
> > Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> > ---
> >
> > v1->v2:
> >  - pretty-print BTF tests were renamed test_btf -> test_btf_pprint, which
> >    allowed GIT to detect that majority of  test_btf code was moved into
> >    prog_tests/btf.c; so diff is much-much smaller;
>
> Thanks. I hope with addition to pprint test the diff will be even smaller.
> I think it's worth to investigate why they're failing if moved to test_progs.
> I think they're the only tests that exercise seq_read logic.
> Clearly the bug:
> [   25.960993] WARNING: CPU: 2 PID: 1995 at kernel/bpf/hashtab.c:717 htab_map_get_next_key+0x7fc/0xab0
> is still there.
> If pprint tests were part of test_progs we would have caught that earlier.

yep, with pretty-printing tests in test_btf diff should be very small

>
> Yonghong,
> please take a look at that issue.
