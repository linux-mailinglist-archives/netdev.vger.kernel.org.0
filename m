Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 51196435270
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 20:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230459AbhJTSOr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 14:14:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46944 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230031AbhJTSOo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Oct 2021 14:14:44 -0400
Received: from mail-yb1-xb36.google.com (mail-yb1-xb36.google.com [IPv6:2607:f8b0:4864:20::b36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E988AC06161C;
        Wed, 20 Oct 2021 11:12:28 -0700 (PDT)
Received: by mail-yb1-xb36.google.com with SMTP id g6so16635670ybb.3;
        Wed, 20 Oct 2021 11:12:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Qo1qyks3RfjarTon/kWWfHODVZOa8tJzDI6ulDaEkvI=;
        b=UAR4553aAhNe8U/BXmuaoBJpCZ6X4QDhSaVbE7+K2nHTzxnBneYMJweAyMz7vicP1S
         rUKFUCT+Fl0LQUz8DqGk3n4uVbHF86KSkUFI/0AuULjb0nZeISQJlZEYPKR4R/9hs0zz
         t0Y3xn9xhZWo4FsNxZY+zxYt4ZYuptBYb1rGH9WDnRzRCYNL38XIj5Wb+6CpYpZ9Wu76
         VJUEHDJSL3dO15vKToMzs16SSSbOTpVRMFwXt25RRSQXTPJpg4dlS+Ij9L8q/0KNSxJd
         TYod3WT2opj7s7oevcL2FS4HT2GHgbddN3w4y8D0RTVrl8uDp7aKFhU70D8vAUoq5qoc
         8IOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Qo1qyks3RfjarTon/kWWfHODVZOa8tJzDI6ulDaEkvI=;
        b=0gMvuK61qlSX8qzf9jDTtmm8YdZ0dmyJy4j53h8AlElsMVP1bMsWOKPM5xFHdqu8ub
         N4pKiFTNPgoTAP0Nc1nntUurBEe8rA3JLcn70L4jjqKEqBHlVIa+lZ+8AaK0DVena7kp
         V+iajs0jlGTCybuL++fc+Eyr7Wi+N3XKaiVYMlBfgdQD1TTDP/cVdBjJUQEvn0QlzTM0
         ZCK8phk+hBWdClC0Eu6FOVexvCedqZv99kaP1i4kZGw7oIbCiCQVqpfnODIVsC/UIWnM
         Q4YPVHjhz5heRrCekxkWIrfctcCaYr4DW30wdLb5psUqAmscBuPWKGQB47TxnsofPB+V
         m7oQ==
X-Gm-Message-State: AOAM53304NrVBMUUocobPoJv+N/7CWBqSCQeQPjyk0fk6NcMBbsgdzNS
        BH8PrjhsPd7ZCq792xHVvkeKrCA27Le40M0SdjI=
X-Google-Smtp-Source: ABdhPJyy0dNm7/vRasgSmZTuN3o1fsa57PAR6ldEoPeVbujPT0YYIw90GdX56tprl6iSdfSWP9TTLnNtFM28sKhu07s=
X-Received: by 2002:a25:d3c8:: with SMTP id e191mr602658ybf.455.1634753547590;
 Wed, 20 Oct 2021 11:12:27 -0700 (PDT)
MIME-Version: 1.0
References: <20211012161544.660286-1-sdf@google.com> <20211012161544.660286-3-sdf@google.com>
In-Reply-To: <20211012161544.660286-3-sdf@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 20 Oct 2021 11:12:16 -0700
Message-ID: <CAEf4Bza3wYs7sjtp2UNDhT58yH+49C5sQonVssbnDko7kkpMaA@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/3] bpftool: don't append / to the progtype
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 12, 2021 at 9:15 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Otherwise, attaching with bpftool doesn't work with strict section names.
>
> Also, switch to libbpf strict mode to use the latest conventions
> (note, I don't think we have any cli api guarantees?).
>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>
> ---
>  tools/bpf/bpftool/main.c |  4 ++++
>  tools/bpf/bpftool/prog.c | 15 +--------------
>  2 files changed, 5 insertions(+), 14 deletions(-)
>
> diff --git a/tools/bpf/bpftool/main.c b/tools/bpf/bpftool/main.c
> index 02eaaf065f65..8223bac1e401 100644
> --- a/tools/bpf/bpftool/main.c
> +++ b/tools/bpf/bpftool/main.c
> @@ -409,6 +409,10 @@ int main(int argc, char **argv)
>         block_mount = false;
>         bin_name = argv[0];
>
> +       ret = libbpf_set_strict_mode(LIBBPF_STRICT_ALL);

Quentin, any concerns about turning strict mode for bpftool? Either
way we should audit bpftool code to ensure that at least error
handling is done properly (see my comments on Dave's patch set about
== -1 checks).

> +       if (ret)
> +               p_err("failed to enable libbpf strict mode: %d", ret);
> +
>         hash_init(prog_table.table);
>         hash_init(map_table.table);
>         hash_init(link_table.table);
> diff --git a/tools/bpf/bpftool/prog.c b/tools/bpf/bpftool/prog.c
> index 277d51c4c5d9..17505dc1243e 100644
> --- a/tools/bpf/bpftool/prog.c
> +++ b/tools/bpf/bpftool/prog.c
> @@ -1396,8 +1396,6 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
>
>         while (argc) {
>                 if (is_prefix(*argv, "type")) {
> -                       char *type;
> -
>                         NEXT_ARG();
>
>                         if (common_prog_type != BPF_PROG_TYPE_UNSPEC) {
> @@ -1407,19 +1405,8 @@ static int load_with_options(int argc, char **argv, bool first_prog_only)
>                         if (!REQ_ARGS(1))
>                                 goto err_free_reuse_maps;
>
> -                       /* Put a '/' at the end of type to appease libbpf */
> -                       type = malloc(strlen(*argv) + 2);
> -                       if (!type) {
> -                               p_err("mem alloc failed");
> -                               goto err_free_reuse_maps;
> -                       }
> -                       *type = 0;
> -                       strcat(type, *argv);
> -                       strcat(type, "/");
> -
> -                       err = get_prog_type_by_name(type, &common_prog_type,
> +                       err = get_prog_type_by_name(*argv, &common_prog_type,
>                                                     &expected_attach_type);

Question not specifically to Stanislav, but anyone who's using bpftool
to load programs. Do we need to support program type overrides? Libbpf
has been inferring the program type for a long time now, are there
realistic use cases where this override logic is necessary? I see
there is bpf_object__for_each_program() loop down the code, it
essentially repeats what libbpf is already doing on
bpf_object__open(), why keep the duplicated logic?

libbpf_prog_type_by_name() is also a bad idea (IMO) and I'd like to
get rid of that in libbpf 1.0, so if we can stop using that from
bpftool, it would be great.

Thoughts?

> -                       free(type);
>                         if (err < 0)
>                                 goto err_free_reuse_maps;
>
> --
> 2.33.0.882.g93a45727a2-goog
>
