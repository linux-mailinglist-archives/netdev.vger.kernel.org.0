Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6EC3F32BD
	for <lists+netdev@lfdr.de>; Fri, 20 Aug 2021 20:06:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230395AbhHTSG5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Aug 2021 14:06:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57768 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229560AbhHTSG4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Aug 2021 14:06:56 -0400
Received: from mail-lf1-x12f.google.com (mail-lf1-x12f.google.com [IPv6:2a00:1450:4864:20::12f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4208CC061756
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 11:06:18 -0700 (PDT)
Received: by mail-lf1-x12f.google.com with SMTP id o10so22212262lfr.11
        for <netdev@vger.kernel.org>; Fri, 20 Aug 2021 11:06:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=kinvolk.io; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=kpdK3tQnsd5kU/S6cdE5TTNsWchQfKmPnLEhEuoCOSw=;
        b=bFdIYjl85UxRyepXF+qWt5RpSgjuLshaALianuSS1+dNYiRsSCpeN9ncBk7nOAnPqM
         bMZ+RJGsTz3VI+uitqqY8sspqhku9zFS3rvC8C0HEQ94s3Rm2ivOnnWGPKHt9qcW0Nte
         MlwQeacxXGMFYnYfINZdZu8dYeYIGXMcHFwZA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=kpdK3tQnsd5kU/S6cdE5TTNsWchQfKmPnLEhEuoCOSw=;
        b=s5d6VDjvQSn8ku7uU2daZJIo+mGKpJjPc5bewgVGYik+j2BHw46u37E6ClOonNpxYV
         hf0cLlzUwFObpKtydN7sgZmjEadO/OlVf5mvBNuA6sRSxITy7ntR4o+i1dGlexiHhd4L
         Q9ohSyqD8w6Zv2YXebnlGuu6G0Z5C2IToRoX28wRoojzDW11Q6zVt7fma1tdpDTXa4dk
         apZ3LWDY4wv0pb3pBVd516YbGRr4kE66KIXzxHfZzc7zEWEt0XB1znOEIuARiF4Xwy5D
         DjUcAgeE3Alv4rm8w4k8TD0Dd0KDysqAKpH1I6bbFkkS1KOZFPi6iutpT8K7VxvQ2ORm
         YQWg==
X-Gm-Message-State: AOAM533F6IcMQqnAHzbLm2+Kv6Bg4Yq7YLhdvBb5rrsI8F8yoQUolRxT
        gknuvuPRhQv6sUjI3Tfkaq/6riR6PwM+FeeK4rA79odVZsUR3BAz
X-Google-Smtp-Source: ABdhPJyDvw/lD+z2kmSTqPAlkIyBYwbU08Q/RU9cGlUTWre3D154WzXg2hJq2G29Cv1+Z20vZK1V7PTOSjALTtZizxk=
X-Received: by 2002:ac2:5a0b:: with SMTP id q11mr15164118lfn.578.1629482775755;
 Fri, 20 Aug 2021 11:06:15 -0700 (PDT)
MIME-Version: 1.0
References: <20210820165511.72890-1-mauricio@kinvolk.io>
In-Reply-To: <20210820165511.72890-1-mauricio@kinvolk.io>
From:   =?UTF-8?Q?Mauricio_V=C3=A1squez_Bernal?= <mauricio@kinvolk.io>
Date:   Fri, 20 Aug 2021 13:06:04 -0500
Message-ID: <CAHap4zvz5JW2paVnkYERq=L98pDBBk2mfkJrQ=pHAU3cfqMkAg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: remove unused variable
To:     netdev@vger.kernel.org, bpf@vger.kernel.org
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        =?UTF-8?Q?Mauricio_V=C3=A1squez?= <mauriciov@microsoft.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 20, 2021 at 11:55 AM Mauricio V=C3=A1squez <mauricio@kinvolk.io=
> wrote:
>
> From: Mauricio V=C3=A1squez <mauriciov@microsoft.com>
>
> Fixes: ddc7c3042614 ("libbpf: implement BPF CO-RE offset relocation algor=
ithm")
>
> Signed-off-by: Mauricio V=C3=A1squez <mauriciov@microsoft.com>
> ---
>  tools/lib/bpf/relo_core.c | 7 -------
>  1 file changed, 7 deletions(-)
>
> diff --git tools/lib/bpf/relo_core.c tools/lib/bpf/relo_core.c
> index 4016ed492d0c..52d8125b7cbe 100644
> --- tools/lib/bpf/relo_core.c
> +++ tools/lib/bpf/relo_core.c
> @@ -417,13 +417,6 @@ static int bpf_core_match_member(const struct btf *l=
ocal_btf,
>                                 return found;
>                 } else if (strcmp(local_name, targ_name) =3D=3D 0) {
>                         /* matching named field */
> -                       struct bpf_core_accessor *targ_acc;
> -
> -                       targ_acc =3D &spec->spec[spec->len++];
> -                       targ_acc->type_id =3D targ_id;
> -                       targ_acc->idx =3D i;
> -                       targ_acc->name =3D targ_name;
> -
>                         *next_targ_id =3D m->type;
>                         found =3D bpf_core_fields_are_compat(local_btf,
>                                                            local_member->=
type,
> --
> 2.25.1
>

Forget that, it's used indeed. Sorry for the noise.
