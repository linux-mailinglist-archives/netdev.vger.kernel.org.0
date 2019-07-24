Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3468C741E6
	for <lists+netdev@lfdr.de>; Thu, 25 Jul 2019 01:17:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729208AbfGXXRT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 19:17:19 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46658 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726388AbfGXXRT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jul 2019 19:17:19 -0400
Received: by mail-qt1-f195.google.com with SMTP id h21so47212402qtn.13;
        Wed, 24 Jul 2019 16:17:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SjBAHZNsJ9G7C5kbHMwYJJi0Yeyvai4Cc3VonCBMVk4=;
        b=o7OuW/H6QeytAGqg/U43pYyPcvbLQDwCPBqkwLY+u3ljNfcl2tymKBHGy4lf9sZd+Z
         ilZ5HCuzBXAsaHthZHZlEtVZlqSPFicU0cYVlZt93aQsKDdi1y9XEbpbBWWDLnmUthvs
         XNZoy/KqA9t0aBtzKSImiIYhXijKJYXGJo/or+dRK/Qgwt64m/7FW8V0V5FRn1VulM/8
         LVr46h3Q3EbDuodSM4/6GNhodJ2vi08ATInjOs027FT+LOc0lsI8JX/NiemjK3oYdRE7
         8Vx4F+cWBPWJdxCBUMi6UONR8PsDeaGPaa2rNI6PU9qmXAx4TGwsvnWxOcbfzvponYep
         lG0w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SjBAHZNsJ9G7C5kbHMwYJJi0Yeyvai4Cc3VonCBMVk4=;
        b=eaTyoknR2xnZ7mj+aRLrFXfznlt9xjK7YihEwRsudpKy4V2mLm/R5V9JmruRU7Z623
         CTTs4ZFQuVsBHvpLXrBwpE8d1ezHo8YftJe7fGbIK6GYtZ7BqrhdUcFe+HZkHm1embfn
         5wLfKqRPmoZ28HscDru3HS8zPXhxo47ab6GL94b0fYDWtx1X2T1N2j6MVmdsCnh0Jyyy
         H/eg6m33znXW+nG/GI3pyvwuQU3ZSo7Tgr41uvh9LPAq7hdf/3mab/MOG7a0/xFB0Rr8
         hiSsIIGZcyqGr/gR3vKab9YORzxGaiZCdworJciTmrdimaof7YeuG/uwJAFtEJNufkLL
         65dQ==
X-Gm-Message-State: APjAAAWjUERj8NjKnJnWWUyvQwXUy2UmBxrVqheJMPE6X56DsfOJi2bJ
        dngnVFVDa1lyo6cP8eXsy87bSweWw6xdNB9Sq1k=
X-Google-Smtp-Source: APXvYqxCF+DOH7xFu58DI9TruCUlWjfSa0vU9f0bLIpBxAG2rko8gI2JDHALU1VhIZv/OhM404jHHyvFgqrOXY14MhM=
X-Received: by 2002:ac8:34aa:: with SMTP id w39mr60724994qtb.118.1564010238437;
 Wed, 24 Jul 2019 16:17:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190724170018.96659-1-sdf@google.com> <20190724170018.96659-5-sdf@google.com>
In-Reply-To: <20190724170018.96659-5-sdf@google.com>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Wed, 24 Jul 2019 16:17:07 -0700
Message-ID: <CAPhsuW7Wh0qaR1PUH87yEDBjVyb+SZLhw1n40fKWmp=tFgUrWQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 4/7] tools/bpf: sync bpf_flow_keys flags
To:     Stanislav Fomichev <sdf@google.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Willem de Bruijn <willemb@google.com>,
        Petar Penkov <ppenkov@google.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 24, 2019 at 10:11 AM Stanislav Fomichev <sdf@google.com> wrote:
>
> Export bpf_flow_keys flags to tools/libbpf/selftests.
>
> Cc: Willem de Bruijn <willemb@google.com>
> Cc: Petar Penkov <ppenkov@google.com>
> Signed-off-by: Stanislav Fomichev <sdf@google.com>

Acked-by: Song Liu <songliubraving@fb.com>

> ---
>  tools/include/uapi/linux/bpf.h | 5 +++++
>  1 file changed, 5 insertions(+)
>
> diff --git a/tools/include/uapi/linux/bpf.h b/tools/include/uapi/linux/bpf.h
> index 4e455018da65..a0e1c891b56f 100644
> --- a/tools/include/uapi/linux/bpf.h
> +++ b/tools/include/uapi/linux/bpf.h
> @@ -3504,6 +3504,10 @@ enum bpf_task_fd_type {
>         BPF_FD_TYPE_URETPROBE,          /* filename + offset */
>  };
>
> +#define FLOW_DISSECTOR_F_PARSE_1ST_FRAG                (1U << 0)
> +#define FLOW_DISSECTOR_F_STOP_AT_FLOW_LABEL    (1U << 1)
> +#define FLOW_DISSECTOR_F_STOP_AT_ENCAP         (1U << 2)
> +
>  struct bpf_flow_keys {
>         __u16   nhoff;
>         __u16   thoff;
> @@ -3525,6 +3529,7 @@ struct bpf_flow_keys {
>                         __u32   ipv6_dst[4];    /* in6_addr; network order */
>                 };
>         };
> +       __u32   flags;
>  };
>
>  struct bpf_func_info {
> --
> 2.22.0.657.g960e92d24f-goog
>
