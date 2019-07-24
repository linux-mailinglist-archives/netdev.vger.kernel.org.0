Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B7C42741D8
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 01:10:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388588AbfGXXKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 19:10:16 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:34822 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2387660AbfGXXKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 19:10:16 -0400
Received: by mail-qk1-f194.google.com with SMTP id r21so35113695qke.2;
        Wed, 24 Jul 2019 16:10:15 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NYfu4BBToJkzHCpkGTGdP9uzED79e2Jr1vPy4Ta8WW8=;
        b=pdz5Esjgqb/yw/4RlxbxE+BFd5IinIkwR4MdHedDbMV5BHtMvP1WFU/dzS8BHmzJ2e
         3byDHT9zDSPZopVRSMnu/NYF2xPfMW9PBwmVo0haJEfFhEIZq5ZzRpQc9K4lzTQDKZ3A
         l/dlYLNcGSrCRfR0Ooj+5+WmnE9pdnqrHykeUG+jJkTdGiKawTW/iqrnDjsRZ/AYSGY5
         I244Tjv8sYE/Nr0n85gzRTkLtjiD1t13m5bHPNlcJupo3wzppOmLv2as4zkJ066TUBHH
         p5HJJosMEF1jmZqDXjR90447F2gKcy2IzzmYT1M9m8tnGR4Shy+lbl+zgzKwyAVb4JlP
         Zdug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NYfu4BBToJkzHCpkGTGdP9uzED79e2Jr1vPy4Ta8WW8=;
        b=aGmqxvOjnfYNIlnpYnrRqFA+i5AQc+ofFLpIh2OdmT2THzaQ9Np/DX6/L5v5Vz4rIG
         p5/bpXqcua22M6GrvgxnU6VR2+PtNxGz/eUXoI68ITOoIy8w7mCtgizOK4LkqgsiYQzY
         9Guc6Wz/JCZGp1ipNRUAqHVtsDHrApdM27UuM1gF5I7mse6LRN5GciY5+cM1eATbNVVY
         NZ4iv6zB5pdqxcvuH6A7XKXb8Qf8aT+3kOTfrzPFwAsHlbweXgring7a+OkxPrFg0Lrs
         5fv/c2Z2cHs/MwhbwF/whf20yt3xdoC7u6ruk/vGNi5mkZjxAn9GQ2WQkDRD0Zd6xdsS
         Ev5w==
X-Gm-Message-State: APjAAAUvoO/2sUK36jKNeRqgFKDprPhhsboTroSZRFk5b33JqSIx6FM+
        uumVh6b/okD0qRJHGStt2qFl8ydhj6WzDPyyELE=
X-Google-Smtp-Source: APXvYqxJV6kR8eWDqRQccHsXqNT8bhd0gcOsWWJl050wcWUaFwcR9DV+coBd6DnJWzn1rT7+QQLxdTPJV4S7EG9eofA=
X-Received: by 2002:a05:620a:16a6:: with SMTP id s6mr55971937qkj.39.1564009815364;
 Wed, 24 Jul 2019 16:10:15 -0700 (PDT)
MIME-Version: 1.0
References: <20190724165803.87470-1-brianvv@google.com> <20190724165803.87470-4-brianvv@google.com>
In-Reply-To: <20190724165803.87470-4-brianvv@google.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Wed, 24 Jul 2019 16:10:04 -0700
Message-ID: <CAEf4BzaCUBA40DKUYm6rSa0v-jQMK7aPu867oYkZhfZGB4wiSA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 3/6] bpf: keep bpf.h in sync with tools/
To:     Brian Vazquez <brianvv@google.com>
Cc:     Brian Vazquez <brianvv.kernel@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S . Miller" <davem@davemloft.net>,
        Stanislav Fomichev <sdf@google.com>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 10:10 AM Brian Vazquez <brianvv@google.com> wrote:
>
> Adds bpf_attr.dump structure to libbpf.
>
> Suggested-by: Stanislav Fomichev <sdf@google.com>
> Signed-off-by: Brian Vazquez <brianvv@google.com>
> ---
>  tools/include/uapi/linux/bpf.h | 9 +++++++++
>  tools/lib/bpf/libbpf.map       | 2 ++
>  2 files changed, 11 insertions(+)
>
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 4e455018da65f..e127f16e4e932 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -106,6 +106,7 @@ enum bpf_cmd {
>         BPF_TASK_FD_QUERY,
>         BPF_MAP_LOOKUP_AND_DELETE_ELEM,
>         BPF_MAP_FREEZE,
> +       BPF_MAP_DUMP,
>  };
>
>  enum bpf_map_type {
> @@ -388,6 +389,14 @@ union bpf_attr {
>                 __u64           flags;
>         };
>
> +       struct { /* struct used by BPF_MAP_DUMP command */
> +               __aligned_u64   prev_key;
> +               __aligned_u64   buf;
> +               __aligned_u64   buf_len; /* input/output: len of buf */
> +               __u64           flags;
> +               __u32           map_fd;
> +       } dump;
> +
>         struct { /* anonymous struct used by BPF_PROG_LOAD command */
>                 __u32           prog_type;      /* one of enum bpf_prog_type */
>                 __u32           insn_cnt;
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index f9d316e873d8d..cac3723d5c45c 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -183,4 +183,6 @@ LIBBPF_0.0.4 {

LIBBPF_0.0.4 is closed, this needs to go into LIBBPF_0.0.5.

>                 perf_buffer__new;
>                 perf_buffer__new_raw;
>                 perf_buffer__poll;
> +               bpf_map_dump;
> +               bpf_map_dump_flags;

As the general rule, please keep those lists of functions in alphabetical order.

>  } LIBBPF_0.0.3;
> --
> 2.22.0.657.g960e92d24f-goog
>
