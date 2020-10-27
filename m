Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3956D29A371
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 04:52:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2505268AbgJ0Dw2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 23:52:28 -0400
Received: from mail-yb1-f195.google.com ([209.85.219.195]:45824 "EHLO
        mail-yb1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2406264AbgJ0Dw2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Oct 2020 23:52:28 -0400
Received: by mail-yb1-f195.google.com with SMTP id s89so53429ybi.12;
        Mon, 26 Oct 2020 20:52:27 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=9nphxJVmTbUWX0rr0q3zrqbNS0a5QftmlRITwZ4vwlM=;
        b=H+1mI6wl6ItecOIe9YKHldJdtQevaFtB9Q+ZsKyVlYPnE6lDhb0VcO5xgUPp24VdSK
         VozsXJ5eSWA3xGYhNJuffbLMLuoa6tnoCXvzcEKsH2myME8YRAiEuefhWcOL7glCZ7hA
         6h9T0y6/MwqtqytvAEbvS7bPTGcFNgBrpnx7q9GyyiqAXmRjiRmAjUclt79/ciD2u5Ru
         TBZ/0mbjmdqSFgFEOcfEI0OYBrfxBkdg+Ljl8BYxTqXwxUmXaA0KllCXhWEdtXCLrkI1
         Ts9MQTqS0ruGxmza4KqIqy6RhYeE5WYe1tz7t4QAXGJfga3cKWHELzCCFvvCSERbKaqx
         Fhfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=9nphxJVmTbUWX0rr0q3zrqbNS0a5QftmlRITwZ4vwlM=;
        b=DSNaBkUAA2Yn5wq1hZUJXJyXYKjI0n1U9zwuNSvXONk1Z5P+AYDbyFXoCFd7EcoXds
         WjHH0jMVrtWk041lu8Wn+I2rS2eJn93cqCPtAyc6RUcRFA+nFPyuQGlveYqyXC6ch9yx
         Ze4vrrF4QKUFyT0HDS3taIe2kBtjBrnHAM6+l2nGS645IvMtQd/367FlB49A0UQOn5xJ
         KMRfUfdOf6kt6vPB49C1sQLrw+VxlCHzUar0ecQcI9i5g31WfqnaKWF6Wo+TFDbUfQP2
         /FqZzLpgCqKXgqEHno+/AM13+kwOpvHqe5C2YOD5hHb+wMEOVZMMSiQpFUi8mY70kVb7
         Lz8Q==
X-Gm-Message-State: AOAM531da29tn2nDaLeK6Yhk7242FLy5TfIFZrYeR3nj1QyGFaSRYkE+
        FWpZswkFT3Mm7R2MQTd5IsiMG7McYs//avzEsbFwvlnArGfSdQ==
X-Google-Smtp-Source: ABdhPJx1ADpjG2ouAXDcOFss1s/KXMTS4IufS3bzg1jSqMIwudP3c1y8SaeRCMlagp4Xzl4WhRys+U6kiJH6ygCYTOc=
X-Received: by 2002:a25:cb10:: with SMTP id b16mr388044ybg.459.1603770746796;
 Mon, 26 Oct 2020 20:52:26 -0700 (PDT)
MIME-Version: 1.0
References: <20201026233623.91728-1-toke@redhat.com>
In-Reply-To: <20201026233623.91728-1-toke@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 26 Oct 2020 20:52:15 -0700
Message-ID: <CAEf4BzbQ_zN-3X0cxUrJ6nF1AbLmznzCFo2M2tPbSN=_Pe7mOQ@mail.gmail.com>
Subject: Re: [PATCH bpf] samples/bpf: Set rlimit for memlock to infinity in
 all samples
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 26, 2020 at 5:10 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> The memlock rlimit is a notorious source of failure for BPF programs. Mos=
t
> of the samples just set it to infinity, but a few used a lower limit. The
> problem with unconditionally setting a lower limit is that this will also
> override the limit if the system-wide setting is *higher* than the limit
> being set, which can lead to failures on systems that lock a lot of memor=
y,
> but set 'ulimit -l' to unlimited before running a sample.
>
> One fix for this is to only conditionally set the limit if the current
> limit is lower, but it is simpler to just unify all the samples and have
> them all set the limit to infinity.
>
> Signed-off-by: Toke H=C3=B8iland-J=C3=B8rgensen <toke@redhat.com>
> ---

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  samples/bpf/task_fd_query_user.c    | 2 +-
>  samples/bpf/tracex2_user.c          | 2 +-
>  samples/bpf/tracex3_user.c          | 2 +-
>  samples/bpf/xdp_redirect_cpu_user.c | 2 +-
>  samples/bpf/xdp_rxq_info_user.c     | 2 +-
>  5 files changed, 5 insertions(+), 5 deletions(-)
>
> diff --git a/samples/bpf/task_fd_query_user.c b/samples/bpf/task_fd_query=
_user.c
> index 4a74531dc403..b68bd2f8fdc9 100644
> --- a/samples/bpf/task_fd_query_user.c
> +++ b/samples/bpf/task_fd_query_user.c
> @@ -290,7 +290,7 @@ static int test_debug_fs_uprobe(char *binary_path, lo=
ng offset, bool is_return)
>
>  int main(int argc, char **argv)
>  {
> -       struct rlimit r =3D {1024*1024, RLIM_INFINITY};
> +       struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
>         extern char __executable_start;
>         char filename[256], buf[256];
>         __u64 uprobe_file_offset;
> diff --git a/samples/bpf/tracex2_user.c b/samples/bpf/tracex2_user.c
> index 3e36b3e4e3ef..3d6eab711d23 100644
> --- a/samples/bpf/tracex2_user.c
> +++ b/samples/bpf/tracex2_user.c
> @@ -116,7 +116,7 @@ static void int_exit(int sig)
>
>  int main(int ac, char **argv)
>  {
> -       struct rlimit r =3D {1024*1024, RLIM_INFINITY};
> +       struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
>         long key, next_key, value;
>         struct bpf_link *links[2];
>         struct bpf_program *prog;
> diff --git a/samples/bpf/tracex3_user.c b/samples/bpf/tracex3_user.c
> index 70e987775c15..83e0fecbb01a 100644
> --- a/samples/bpf/tracex3_user.c
> +++ b/samples/bpf/tracex3_user.c
> @@ -107,7 +107,7 @@ static void print_hist(int fd)
>
>  int main(int ac, char **argv)
>  {
> -       struct rlimit r =3D {1024*1024, RLIM_INFINITY};
> +       struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
>         struct bpf_link *links[2];
>         struct bpf_program *prog;
>         struct bpf_object *obj;
> diff --git a/samples/bpf/xdp_redirect_cpu_user.c b/samples/bpf/xdp_redire=
ct_cpu_user.c
> index 6fb8dbde62c5..f78cb18319aa 100644
> --- a/samples/bpf/xdp_redirect_cpu_user.c
> +++ b/samples/bpf/xdp_redirect_cpu_user.c
> @@ -765,7 +765,7 @@ static int load_cpumap_prog(char *file_name, char *pr=
og_name,
>
>  int main(int argc, char **argv)
>  {
> -       struct rlimit r =3D {10 * 1024 * 1024, RLIM_INFINITY};
> +       struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
>         char *prog_name =3D "xdp_cpu_map5_lb_hash_ip_pairs";
>         char *mprog_filename =3D "xdp_redirect_kern.o";
>         char *redir_interface =3D NULL, *redir_map =3D NULL;
> diff --git a/samples/bpf/xdp_rxq_info_user.c b/samples/bpf/xdp_rxq_info_u=
ser.c
> index caa4e7ffcfc7..93fa1bc54f13 100644
> --- a/samples/bpf/xdp_rxq_info_user.c
> +++ b/samples/bpf/xdp_rxq_info_user.c
> @@ -450,7 +450,7 @@ static void stats_poll(int interval, int action, __u3=
2 cfg_opt)
>  int main(int argc, char **argv)
>  {
>         __u32 cfg_options=3D NO_TOUCH ; /* Default: Don't touch packet me=
mory */
> -       struct rlimit r =3D {10 * 1024 * 1024, RLIM_INFINITY};
> +       struct rlimit r =3D {RLIM_INFINITY, RLIM_INFINITY};
>         struct bpf_prog_load_attr prog_load_attr =3D {
>                 .prog_type      =3D BPF_PROG_TYPE_XDP,
>         };
> --
> 2.29.0
>
