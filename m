Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7B88327835C
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 10:56:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727648AbgIYI4U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Sep 2020 04:56:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726990AbgIYI4U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Sep 2020 04:56:20 -0400
Received: from mail-ot1-x341.google.com (mail-ot1-x341.google.com [IPv6:2607:f8b0:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6395BC0613CE
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 01:56:20 -0700 (PDT)
Received: by mail-ot1-x341.google.com with SMTP id m13so1598667otl.9
        for <netdev@vger.kernel.org>; Fri, 25 Sep 2020 01:56:20 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cloudflare.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FB7t6ED/jnfRp/WWE+Uf20Xlr4Bf0WcN1ZTT/JNoDp0=;
        b=OkqZQyLSpm2BFcmX3BKpRZHcC5Up/n7KOiShD6Wy9SnzehkGjXoqQ85DpcDItuCc2W
         ASlpP5rhKJ4kGvRArHfJYf0krRlj3JAVJDGINDv7LCUzljtZiDA3pKbBrRWjcoRF4m/W
         AhEPZpX44afMbY6zG6I6iH3UbOV+HDngbC6LU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FB7t6ED/jnfRp/WWE+Uf20Xlr4Bf0WcN1ZTT/JNoDp0=;
        b=PlsORBTk/SOLa3tX7gJi9LCD/s2vb1Sqh+Jp4L6kEcsy1P5pdQxvu/zVRFPfD9bTkl
         oSW8obBVNJSiDBTzkXhbVaiux8LogfnamY8IHt7m9AuzcGMgWgT02j/vmNhYFFfEa7nH
         fyuWPSuoJT5qg9RWq8l/sDARRePFFTpx+ETQ/d2g3ZF+3yWSRIrI4X58UBknS7ZeJ7ND
         pHKoJHnFnc1XuFPCfUhmvx9wjfFMZWwAy+oJStKz3L3NA9x4kbjbhB8lDnmHdowkuPiN
         zRqWZjheCVfI7uGfjNS64tW28aWVq1QFIsaYkq5lLSOcZg1QSkWMzj9q8J/b5oUHWxs9
         g2CQ==
X-Gm-Message-State: AOAM532BQFwllvGpH+yc3xuiQxlJ3MF1AMgfQXGWuoL90vOiyvVq5Bjl
        6QmD0oymaXukK5ZkTndC7atZ++0nBWsE876eRPVsDg==
X-Google-Smtp-Source: ABdhPJzXhRHbXp7/MqUFTmGFztnj0j5darnr+4M82u76LoSyY6ISvUt1aOWxX3qG7RKR0/8jwhO06mJsCZdN4BeXyUo=
X-Received: by 2002:a9d:6e90:: with SMTP id a16mr2111658otr.132.1601024179755;
 Fri, 25 Sep 2020 01:56:19 -0700 (PDT)
MIME-Version: 1.0
References: <160097751992.13115.10446086919232254389.stgit@john-Precision-5820-Tower>
In-Reply-To: <160097751992.13115.10446086919232254389.stgit@john-Precision-5820-Tower>
From:   Lorenz Bauer <lmb@cloudflare.com>
Date:   Fri, 25 Sep 2020 09:56:08 +0100
Message-ID: <CACAyw9_norMfT3pdNG=Qm5e-cWbBwZTYZEmgYR7j+9-aoVfCag@mail.gmail.com>
Subject: Re: [bpf-next PATCH] bpf: Add comment to document BTF type PTR_TO_BTF_ID_OR_NULL
To:     John Fastabend <john.fastabend@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andriin@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, Martin Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 24 Sep 2020 at 20:58, John Fastabend <john.fastabend@gmail.com> wrote:
>
> The meaning of PTR_TO_BTF_ID_OR_NULL differs slightly from other types
> denoted with the *_OR_NULL type. For example the types PTR_TO_SOCKET
> and PTR_TO_SOCKET_OR_NULL can be used for branch analysis because the
> type PTR_TO_SOCKET is guaranteed to _not_ have a null value.
>
> In contrast PTR_TO_BTF_ID and BTF_TO_BTF_ID_OR_NULL have slightly
> different meanings. A PTR_TO_BTF_TO_ID may be a pointer to NULL value,
> but it is safe to read this pointer in the program context because
> the program context will handle any faults. The fallout is for
> PTR_TO_BTF_ID the verifier can assume reads are safe, but can not
> use the type in branch analysis. Additionally, authors need to be
> extra careful when passing PTR_TO_BTF_ID into helpers. In general
> helpers consuming type PTR_TO_BTF_ID will need to assume it may
> be null.
>
> Seeing the above is not obvious to readers without the back knowledge
> lets add a comment in the type definition.
>
> Editorial comment, as networking and tracing programs get closer
> and more tightly merged we may need to consider a new type that we
> can ensure is non-null for branch analysis and also passing into
> helpers.

Yeah, I was going back and forth with Martin on this as well. I think
we need better descriptions for possibly-NULL-at-runtime for the
purpose of helper call invariants, and possibly-NULL-at-verification
time.

>
> Signed-off-by: John Fastabend <john.fastabend@gmail.com>

Acked-by: Lorenz Bauer <lmb@cloudflare.com>

> ---
>  include/linux/bpf.h |   18 ++++++++++++++++--
>  1 file changed, 16 insertions(+), 2 deletions(-)
>
> diff --git a/include/linux/bpf.h b/include/linux/bpf.h
> index fc5c901c7542..dd765ba1c730 100644
> --- a/include/linux/bpf.h
> +++ b/include/linux/bpf.h
> @@ -382,8 +382,22 @@ enum bpf_reg_type {
>         PTR_TO_TCP_SOCK_OR_NULL, /* reg points to struct tcp_sock or NULL */
>         PTR_TO_TP_BUFFER,        /* reg points to a writable raw tp's buffer */
>         PTR_TO_XDP_SOCK,         /* reg points to struct xdp_sock */
> -       PTR_TO_BTF_ID,           /* reg points to kernel struct */
> -       PTR_TO_BTF_ID_OR_NULL,   /* reg points to kernel struct or NULL */
> +       /* PTR_TO_BTF_ID points to a kernel struct that does not need
> +        * to be null checked by the BPF program. This does not imply the
> +        * pointer is _not_ null and in practice this can easily be a null
> +        * pointer when reading pointer chains. The assumption is program
> +        * context will handle null pointer dereference typically via fault
> +        * handling. The verifier must keep this in mind and can make no
> +        * assumptions about null or non-null when doing branch analysis.
> +        * Further, when passed into helpers the helpers can not, without
> +        * additional context, assume the value is non-null.
> +        */
> +       PTR_TO_BTF_ID,
> +       /* PTR_TO_BTF_ID_OR_NULL points to a kernel struct that has not
> +        * been checked for null. Used primarily to inform the verifier
> +        * an explicit null check is required for this struct.
> +        */
> +       PTR_TO_BTF_ID_OR_NULL,
>         PTR_TO_MEM,              /* reg points to valid memory region */
>         PTR_TO_MEM_OR_NULL,      /* reg points to valid memory region or NULL */
>         PTR_TO_RDONLY_BUF,       /* reg points to a readonly buffer */
>


-- 
Lorenz Bauer  |  Systems Engineer
6th Floor, County Hall/The Riverside Building, SE1 7PB, UK

www.cloudflare.com
