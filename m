Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 06602740FB
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 23:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388306AbfGXVlj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 17:41:39 -0400
Received: from mail-qt1-f193.google.com ([209.85.160.193]:34905 "EHLO
        mail-qt1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388258AbfGXVli (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 17:41:38 -0400
Received: by mail-qt1-f193.google.com with SMTP id d23so47093249qto.2;
        Wed, 24 Jul 2019 14:41:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SXgrDPZl1Nx0gc/Z4+vGOz1EBSRGtiA2GEjwV+C/2Nw=;
        b=DnK2VX7IyV9cJiOAcso1Ce2kkpLQqmXirSrU5Bk2J2L50X4fkFBzjvP1RTqHKNuz5K
         5mUHVH7XOwbbbVOKzK2qt2aa8GYCcmvGiU9Hb8NUJnRkG2vdKNAt3f4k2fs6oWRDUVtH
         OH62lyTzJfu8YgusgtSWCKNaafuxfjCU4PW1WsAFd9UGes0HHy92MxWi+0cIrYBnjO0U
         zMbGcUqFfUVO4vP+CTVFn2ccxogLs7hYRNOvp6ZLo+71exqVk/efjqzM6l5S7IFq6D5R
         9UjhaYyXfTdfEoQeHBN7gzY0YEeL1sIC8A8o65wDBTrfOeUhIFDF1ilkowHYKtyp5Rrx
         KCWQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SXgrDPZl1Nx0gc/Z4+vGOz1EBSRGtiA2GEjwV+C/2Nw=;
        b=BxpfWawtefbhJuW/SyCHEYr3Aj/ayvKZfYMf96D8skwW5G4wJJf4T3lpkhXsscRtLW
         cvphKiiYOCKdkfXt8Vqje0ZuzBNzLUsrmIEC2C6HoEc+GQAq19pkzAnf0ZZXxyrErtSx
         fhqMvdoWSqF0AKUt+/zmoM/3W/2Z+sToypgApwyHInEjNFhPFSMX8lQGUtCcsRZ7cDgV
         soHg8XSuvUajC1dpUawrIjVu1xr9nA5o/6EpRU+Esmo2b1EVaQbAiN2ysM+DkRsnVi1m
         KdnN/uXEagcgn198HKaWb00+PWbWaqDiDAGyq8lJAch2pseD/WXvnRZYvTr/yVJ/Clzw
         gD+A==
X-Gm-Message-State: APjAAAWUxRghmwozAvlNX0pnR/wKEJLdGNv2DOove1JSPYvcv+kJz3eW
        VnOgf70EsfTwDLc67egnKewyOMnUeI4xNlUkT9E=
X-Google-Smtp-Source: APXvYqwczFrTkLCmzuyxOq4+jkMjWS+UVaYf2Xyq9X+UbhwJTqE7349Z8QhntyhVw0/8cdRVfrbH8O2d3cKfSNRGVMg=
X-Received: by 2002:ad4:4423:: with SMTP id e3mr47642602qvt.145.1564004497597;
 Wed, 24 Jul 2019 14:41:37 -0700 (PDT)
MIME-Version: 1.0
References: <20190724165803.87470-1-brianvv@google.com> <20190724165803.87470-4-brianvv@google.com>
In-Reply-To: <20190724165803.87470-4-brianvv@google.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 24 Jul 2019 14:41:26 -0700
Message-ID: <CAPhsuW6kLnd4GexxZ5nhxfVwKx14XghfJnG_kh4kaXgRvKD7vA@mail.gmail.com>
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
>                 perf_buffer__new;
>                 perf_buffer__new_raw;
>                 perf_buffer__poll;
> +               bpf_map_dump;
> +               bpf_map_dump_flags;
>  } LIBBPF_0.0.3;

libbpf.map change should go with 4/6.

> --
> 2.22.0.657.g960e92d24f-goog
>
