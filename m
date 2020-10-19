Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BF061292D8C
	for <lists+netdev@lfdr.de>; Mon, 19 Oct 2020 20:28:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730785AbgJSS22 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Oct 2020 14:28:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729369AbgJSS21 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Oct 2020 14:28:27 -0400
Received: from mail-yb1-xb44.google.com (mail-yb1-xb44.google.com [IPv6:2607:f8b0:4864:20::b44])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47A89C0613CE;
        Mon, 19 Oct 2020 11:28:26 -0700 (PDT)
Received: by mail-yb1-xb44.google.com with SMTP id c3so426810ybl.0;
        Mon, 19 Oct 2020 11:28:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZL5YDl6hNmbkB+VpLWE2qHhC7lZo4UK+RqjNiE2QNK4=;
        b=EtoIW9Jh2ojao1SiML3i0pk9oVO+o8TncTVzbAFpFbQtolDxYIvQZzSoPVGaYv6VXI
         9iQplBLr9221apT92qhuI8c65N1y6mNzD866ckA66sfMVIZXshSe5bcvxG81x2vbPGfY
         +f6hHWLULw4axD0cw9Lh4s9iGZij7vR75YLAypDGmzzahnLHs+ZFGWhfJ3RqqQ0F+EAa
         5Hb13YAFuEQzqlSt51DrWl+tj3CCvbP9MxFWj3iAKftCF9ssw313XfU2XymQd+32nfEV
         PhrGT5Lm/gXMLEJrMIWWlA4qVVYzpxEY3VT+wecLr3ZBFVLdi5z4O0C7PuACCacuBm3M
         G1uw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZL5YDl6hNmbkB+VpLWE2qHhC7lZo4UK+RqjNiE2QNK4=;
        b=aVNN03h+LE5rMl1dyjbMGV8R/pptlGvi+W8pIcWp/WTZWbRdyOlyg1YLN6Cwn2yYtF
         PRlubnGHE8B043G3Cj9PzoTzmpUP6iqm8FXmlC7sa0OinevZDjaI5Q34cJODl3bW50fx
         b+NPn1OxpEacJrDqK1k3ndmAzdtzaKH0vGFnlTArUs4w0xojTamDTXeyJKp8FUNs85Ys
         Z6bK653EXQckxZqISjvtgrkjBFP/ApP+uZnSLxOjsiSrjzOe6k09RH5ufOkPlrptIo7U
         ZinErnnYjpyVk0drFjnDMa90WGBGBQrtWCx9V0Qvc+nrdzTRPPMkt7nVeAoilTDoCyGD
         RDxA==
X-Gm-Message-State: AOAM530CVD4LmxQZb36VkpWVSanz+VEb+0DcF2lWXeTGCYcuu/g+UCBl
        tVJPM/wkTPY36mU+PN4uR+AzkAD+xWspTTHLaMY=
X-Google-Smtp-Source: ABdhPJzMdWOJYtBlbNpUHOt6MIZx+gCaEELEjrSHkVKLh/kkizysAtv930DbisYV9sY+77EdbA0GVk1Z/Bad5INjipE=
X-Received: by 2002:a25:cb10:: with SMTP id b16mr746460ybg.459.1603132105610;
 Mon, 19 Oct 2020 11:28:25 -0700 (PDT)
MIME-Version: 1.0
References: <20201019173846.1021-1-trix@redhat.com>
In-Reply-To: <20201019173846.1021-1-trix@redhat.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Mon, 19 Oct 2020 11:28:14 -0700
Message-ID: <CAEf4BzZMAeH71jT6foAcrarURXmTnDyb-qhJthoh8GqhDZ-PRw@mail.gmail.com>
Subject: Re: [PATCH] bpf: remove unneeded break
To:     trix@redhat.com
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin Lau <kafai@fb.com>, Song Liu <songliubraving@fb.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        john fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Oct 19, 2020 at 10:38 AM <trix@redhat.com> wrote:
>
> From: Tom Rix <trix@redhat.com>
>
> A break is not needed if it is preceded by a return
>
> Signed-off-by: Tom Rix <trix@redhat.com>
> ---

Probably refactoring left over, looks good:

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  kernel/bpf/syscall.c | 1 -
>  1 file changed, 1 deletion(-)
>
> diff --git a/kernel/bpf/syscall.c b/kernel/bpf/syscall.c
> index 1110ecd7d1f3..8f50c9c19f1b 100644
> --- a/kernel/bpf/syscall.c
> +++ b/kernel/bpf/syscall.c
> @@ -2913,7 +2913,6 @@ attach_type_to_prog_type(enum bpf_attach_type attach_type)
>         case BPF_CGROUP_INET_INGRESS:
>         case BPF_CGROUP_INET_EGRESS:
>                 return BPF_PROG_TYPE_CGROUP_SKB;
> -               break;
>         case BPF_CGROUP_INET_SOCK_CREATE:
>         case BPF_CGROUP_INET_SOCK_RELEASE:
>         case BPF_CGROUP_INET4_POST_BIND:
> --
> 2.18.1
>
