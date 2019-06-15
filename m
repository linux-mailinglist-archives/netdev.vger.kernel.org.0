Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7F08847255
	for <lists+netdev@lfdr.de>; Sun, 16 Jun 2019 00:05:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726683AbfFOWF0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Jun 2019 18:05:26 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:42154 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725535AbfFOWF0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Jun 2019 18:05:26 -0400
Received: by mail-qt1-f195.google.com with SMTP id s15so6684440qtk.9;
        Sat, 15 Jun 2019 15:05:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sIK84/4fIQczM72saSv2RoZEV3A00521k5sfoE09TaM=;
        b=QJnkDiLAVGTFl31e2hY/3nE8CyAunz2Qqj9TcCCCJxwN1H1qiYBdwuOzdE+YyV+UN+
         R1KM1Z1GW8tYX4yjctiQGF1YGDZHQijLxx4tRXjNpc0vl/Mva6WLe9NtD67et8bTKJwz
         YKDWfDtdpI7hdr8RlVuRyYTHLHBwd+TRhBG+nk+ihB/BKsASPxYSNox2VWMb9k/4aag1
         Pgx8t1C3LggRrjI5o6oTbfsL+pHK14Ui3PQo8CpCm8q2WVq0BDqXuwHGQ567FAxZSNK1
         ogPyA1iHucZQMFxIOtwwHwTeRzYqR9ezndsszTz2Cv+Xa50GJgwV5Xr2gNq4GaeDLSV2
         2bHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sIK84/4fIQczM72saSv2RoZEV3A00521k5sfoE09TaM=;
        b=f+jNUygoQqLWBy0IrPGR1MLWbf2aP0+3vx5J78fHKZ2/jAlruQAyzEXVCSogiyanNr
         cSYM67+PjkqHrUbTZCN48IdIpcRN9sLp+d44omxnMjpgA/6FuGdMD7C6uF7uLsBjqQMM
         ExaW2IEGEWYEY/Qhq/ZmHGWMT/hcfq8wEBxYubHwGSM+fhdQ8jiXGeFDN+BkvKNlU+/P
         YhU2qAkHh2HZ0t3efAIUxYGhlD5j52pBvXUQaB9fIaKsnwFK/S1NVdNg5ZYO7MFjaN9r
         vnsde2OEa75OY6w5sicD55zTERFE4tyFUL73rcJX7j/HBs6o0wePnyvwG7/Pg0pzt7Pp
         z/Qw==
X-Gm-Message-State: APjAAAVgwmFyI4xvX9TldB+daTKNzPgQ0H3OS1JeEkojb6AgjrbLYSZV
        yfqkwYm667E22pXTidvflEVRCAxgU19E5yZ3zTfn/qeT
X-Google-Smtp-Source: APXvYqx68fwWNhLHOXo2tQY0nN8MHNkWnF/9b0hNr77GA3LjYermhSITI4EbffOOOr7dEagdJYVvzZwQqT1+gGNUu8I=
X-Received: by 2002:a0c:d0fc:: with SMTP id b57mr14887957qvh.78.1560636325218;
 Sat, 15 Jun 2019 15:05:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190611044747.44839-1-andriin@fb.com> <20190611044747.44839-8-andriin@fb.com>
In-Reply-To: <20190611044747.44839-8-andriin@fb.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Sat, 15 Jun 2019 15:05:14 -0700
Message-ID: <CAPhsuW5MNx4NvXJGNo9uPkQBHFgojHCbdy4eyVE31e6bENx8Mg@mail.gmail.com>
Subject: Re: [PATCH bpf-next 7/8] selftests/bpf: add test for BTF-defined maps
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 10, 2019 at 9:49 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Add file test for BTF-defined map definition.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  .../selftests/bpf/progs/test_btf_newkv.c      | 73 +++++++++++++++++++
>  tools/testing/selftests/bpf/test_btf.c        | 10 +--
>  2 files changed, 76 insertions(+), 7 deletions(-)
>  create mode 100644 tools/testing/selftests/bpf/progs/test_btf_newkv.c
>
> diff --git a/tools/testing/selftests/bpf/progs/test_btf_newkv.c b/tools/testing/selftests/bpf/progs/test_btf_newkv.c
> new file mode 100644
> index 000000000000..28c16bb583b6
> --- /dev/null
> +++ b/tools/testing/selftests/bpf/progs/test_btf_newkv.c
> @@ -0,0 +1,73 @@
> +/* SPDX-License-Identifier: GPL-2.0 */
> +/* Copyright (c) 2018 Facebook */
> +#include <linux/bpf.h>
> +#include "bpf_helpers.h"
> +
> +int _version SEC("version") = 1;
> +
> +struct ipv_counts {
> +       unsigned int v4;
> +       unsigned int v6;
> +};
> +
> +/* just to validate we can handle maps in multiple sections */
> +struct bpf_map_def SEC("maps") btf_map_legacy = {
> +       .type = BPF_MAP_TYPE_ARRAY,
> +       .key_size = sizeof(int),
> +       .value_size = sizeof(long long),
> +       .max_entries = 4,
> +};
> +
> +BPF_ANNOTATE_KV_PAIR(btf_map_legacy, int, struct ipv_counts);
> +
> +struct {
> +       int *key;
> +       struct ipv_counts *value;
> +       unsigned int type;
> +       unsigned int max_entries;
> +} btf_map SEC(".maps") = {
> +       .type = BPF_MAP_TYPE_ARRAY,
> +       .max_entries = 4,
> +};
> +
> +struct dummy_tracepoint_args {
> +       unsigned long long pad;
> +       struct sock *sock;
> +};
> +
> +__attribute__((noinline))
> +static int test_long_fname_2(struct dummy_tracepoint_args *arg)
> +{
> +       struct ipv_counts *counts;
> +       int key = 0;
> +
> +       if (!arg->sock)
> +               return 0;
> +
> +       counts = bpf_map_lookup_elem(&btf_map, &key);
> +       if (!counts)
> +               return 0;
> +
> +       counts->v6++;
> +
> +       /* just verify we can reference both maps */
> +       counts = bpf_map_lookup_elem(&btf_map_legacy, &key);
> +       if (!counts)
> +               return 0;
> +
> +       return 0;
> +}
> +
> +__attribute__((noinline))
> +static int test_long_fname_1(struct dummy_tracepoint_args *arg)
> +{
> +       return test_long_fname_2(arg);
> +}
> +
> +SEC("dummy_tracepoint")
> +int _dummy_tracepoint(struct dummy_tracepoint_args *arg)
> +{
> +       return test_long_fname_1(arg);
> +}
> +
> +char _license[] SEC("license") = "GPL";
> diff --git a/tools/testing/selftests/bpf/test_btf.c b/tools/testing/selftests/bpf/test_btf.c
> index 289daf54dec4..8351cb5f4a20 100644
> --- a/tools/testing/selftests/bpf/test_btf.c
> +++ b/tools/testing/selftests/bpf/test_btf.c
> @@ -4016,13 +4016,9 @@ struct btf_file_test {
>  };
>
>  static struct btf_file_test file_tests[] = {
> -{
> -       .file = "test_btf_haskv.o",
> -},
> -{
> -       .file = "test_btf_nokv.o",
> -       .btf_kv_notfound = true,
> -},
> +       { .file = "test_btf_haskv.o", },
> +       { .file = "test_btf_newkv.o", },
> +       { .file = "test_btf_nokv.o", .btf_kv_notfound = true, },
>  };
>
>  static int do_test_file(unsigned int test_num)
> --
> 2.17.1
>
