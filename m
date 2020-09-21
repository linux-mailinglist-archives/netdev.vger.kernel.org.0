Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AEE94273697
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 01:21:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728797AbgIUXV0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Sep 2020 19:21:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38938 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728704AbgIUXVZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Sep 2020 19:21:25 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A6B8C061755;
        Mon, 21 Sep 2020 16:21:25 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id a2so11528122ybj.2;
        Mon, 21 Sep 2020 16:21:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=4ppIE63T8+klgrrV1b//SYrjSQ9cV9jIQpOjemLzGkE=;
        b=e7LUF12gT/sjott3YZVw4uasm0EcaWAjOw76wtIKu0QmqhNlpRNFI6Zsp4BFfi8F5N
         anGjD4GGT30dhEzANnzLozuRThPTv5fNuMLZuxE0cb/aB2v1C1dQU963YbLBMJBdbUru
         7HNOh023kYCvmeZ6wI4Oa6Hozx97VgyACGwjxnUWasGJH32HEdv7fLKRTrJlg7+1558H
         7GgKzFb8+T376bsL8dPAmfhIWw381jlQFtcQDgl+MGdoQ/pQef0qYAAHvFhTeD67C6ag
         GZKarxnjs8YE61kK72gCTcuykx/OGJ5bdGok/5D/dvgnBlaa1uSXZGV4nF9qeEt0bfOy
         UUjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=4ppIE63T8+klgrrV1b//SYrjSQ9cV9jIQpOjemLzGkE=;
        b=cuRE6ZujnO0LwH+mPdhzU/8ATqfSu8h0e5JV1fNmEo5hHDqPbKQPCIZTjT50D72+AN
         8psJenJpO4i0LcnjQM8FAxSGQ9Hkw8awmYSIz3+O5mGX/yASDIhX94MI2ba9Ae/GjRc2
         Oy98Eh2vP2iJSGrtFgsjKOpb3ZDuHuIUdu1vDfSxWFpDWcBDxp8DTnsUPPwf3DODhJ05
         Vqhg0zMLE51tij9QiL1WjbCAYOp+giL9EDjhJTtgFNJGbLBQXtdYpa7yse7CQSp8mBxj
         3XMAh0Yd6aWhFhMOai2BEOvfCmGnX24RiQvcE9yfrP0f0jOE1tiXklDBF/BwbDKGCQcF
         69VA==
X-Gm-Message-State: AOAM531HVvDMy1YkpdhZH7vLmLbFkkdO434qjRvLMJYy4F3wiVyUP0Vy
        k8ilX+sw9dq4br2HMSaKDIsTBH/f0dUnqsmXcY8=
X-Google-Smtp-Source: ABdhPJzG7hKT+5Pf2Xkly27tsT6EYjfkDqlrXgpZQr8YEeY6kqjP1peAzP91y+4GIxr23Io4nz9bya1GZKpd/0TLc+w=
X-Received: by 2002:a25:8541:: with SMTP id f1mr2881559ybn.230.1600730484879;
 Mon, 21 Sep 2020 16:21:24 -0700 (PDT)
MIME-Version: 1.0
References: <160051618267.58048.2336966160671014012.stgit@toke.dk> <160051619177.58048.3667955737003984962.stgit@toke.dk>
In-Reply-To: <160051619177.58048.3667955737003984962.stgit@toke.dk>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 21 Sep 2020 16:21:13 -0700
Message-ID: <CAEf4BzZCB5ZMiVoeU-63WV8j0k+oB4svLh_DJxrO3wJZ1A_CJg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v7 08/10] selftests: add test for multiple
 attachments of freplace program
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>,
        Eelco Chaudron <echaudro@redhat.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Sep 19, 2020 at 4:50 AM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> From: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
>
> This adds a selftest for attaching an freplace program to multiple target=
s
> simultaneously.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---
>  .../selftests/bpf/prog_tests/fexit_bpf2bpf.c       |  157 ++++++++++++++=
++----
>  .../selftests/bpf/progs/freplace_get_constant.c    |   15 ++
>  2 files changed, 140 insertions(+), 32 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/freplace_get_consta=
nt.c
>

LGTM.

Acked-by: Andrii Nakryiko <andriin@fb.com>

> +       err =3D bpf_prog_test_run(tgt_fd, 1, &pkt_v6, sizeof(pkt_v6),
> +                               NULL, NULL, &retval, &duration);
> +       if (CHECK(err || retval, "ipv6",
> +                 "err %d errno %d retval %d duration %d\n",
> +                 err, errno, retval, duration))
> +               goto out;
> +
> +       err =3D check_data_map(obj, 1, true);
> +       if (err)
> +               goto out;
> +
> +out:
> +       if (!IS_ERR_OR_NULL(link))
> +               bpf_link__destroy(link);

fyi, you don't need to check ERR_OR_NULL anymore, all destructors are
now handling that implicitly

> +       bpf_object__close(tgt_obj);
> +       return err;
> +}
> +

[...]
