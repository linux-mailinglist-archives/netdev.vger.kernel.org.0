Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 91F013CB1A5
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 06:36:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231961AbhGPEi5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 00:38:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbhGPEi5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 00:38:57 -0400
Received: from mail-yb1-xb2a.google.com (mail-yb1-xb2a.google.com [IPv6:2607:f8b0:4864:20::b2a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EA485C06175F;
        Thu, 15 Jul 2021 21:36:02 -0700 (PDT)
Received: by mail-yb1-xb2a.google.com with SMTP id p22so12785224yba.7;
        Thu, 15 Jul 2021 21:36:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VSbSop3izgeubGr72M1TZ17oEfxYdb+oPnDmq2ERdJE=;
        b=QCldMWFcxmyZhgS/CMP9jxunTvvT1SXY3ORp5JYXBPUkvOeS9FG3IU/oAcObIxVE/u
         cAniWR1rPffQ8imHplGiw6DoAzJlQTUCjqXYw1DwD8tKs5rFSXRq9jcKObWafhhtApif
         0bodfTpRriAatb+kfsdmbouEW4nzbYn2E4SVK/TtYFK7vCaca2umQ3YRYgRSVx6VPR9k
         aw1/tF8XEYu7oJe1zZy5VRXDUll8bgU2TCnoQkzPZIxLZV7szHmWB875n/aH66BazwsM
         bkTD47nFGggfgzlwZFHnJyNoLz6c2rSr/orhrdcHQlVLro6AQyQKFre2lr7dFE+b+O5f
         NcSQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VSbSop3izgeubGr72M1TZ17oEfxYdb+oPnDmq2ERdJE=;
        b=Z6dkntw2sdOVxGA/lg3neh7b9QA+hNEeXt5OEhVaxxksgRxMeQ4Z1/gtU9V1NCCzix
         l3BqYj6eM+2r9YZLFZhke4YH0Nd1HjzYTO3hdk6KkNvLJk7NtHoyAzUe+/p2S58zTRw1
         0Lup4h+omuUMhqIPBzBH86dysp/N9F1vPR02gP49nTHNwO/OCpj8wlpCy9GAbWMVrHFg
         a7ZBe0+VczEIY8s+VKBWHuMVRzGGhXqV+jFZosTqULREYV1WsD81YaKVq7dL8pU0fR9r
         MguXgcBU7i2/DO0DvEdeEsB6g3nYBjchEWOmthdzY2YAP4Baca/oQCL6qOeibTwM7roH
         Lcaw==
X-Gm-Message-State: AOAM533XPO5qElO2WI1Jmi/mANJ6Y/llkoxZT1GTBI9L1X0atUJNdQZY
        g/cj25rZUrkXJN1IurZGOb17hpw5516Ur6kAx6k=
X-Google-Smtp-Source: ABdhPJyne69Xms4EY5IIVROcGtSdIQZQBMUFKKVrjg/M4Te3+wF3zKW+YLY0+W5UVQ3NtGdn0jbfBv9qr79IU21GyYQ=
X-Received: by 2002:a25:1ec4:: with SMTP id e187mr9873506ybe.425.1626410162298;
 Thu, 15 Jul 2021 21:36:02 -0700 (PDT)
MIME-Version: 1.0
References: <20210714141532.28526-1-quentin@isovalent.com> <20210714141532.28526-3-quentin@isovalent.com>
In-Reply-To: <20210714141532.28526-3-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 15 Jul 2021 21:35:51 -0700
Message-ID: <CAEf4BzbgxKnTyjHuVmPOune=yxkE7WAqKn6KXjw8-pEyL1svog@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/6] libbpf: rename btf__get_from_id() as btf__load_from_kernel_by_id()
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 14, 2021 at 7:15 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Rename function btf__get_from_id() as btf__load_from_kernel_by_id() to
> better indicate what the function does.
>
> The other tools calling the deprecated btf__get_from_id() function will
> be updated in a future commit.
>
> References:
>
> - https://github.com/libbpf/libbpf/issues/278
> - https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#btfh-apis
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/lib/bpf/btf.c      | 4 +++-
>  tools/lib/bpf/btf.h      | 1 +
>  tools/lib/bpf/libbpf.c   | 2 +-
>  tools/lib/bpf/libbpf.map | 1 +
>  4 files changed, 6 insertions(+), 2 deletions(-)
>
> diff --git a/tools/lib/bpf/btf.c b/tools/lib/bpf/btf.c
> index 7e0de560490e..05b63b63083a 100644
> --- a/tools/lib/bpf/btf.c
> +++ b/tools/lib/bpf/btf.c
> @@ -1383,7 +1383,7 @@ struct btf *btf_get_from_fd(int btf_fd, struct btf *base_btf)
>         return btf;
>  }
>
> -int btf__get_from_id(__u32 id, struct btf **btf)
> +int btf__load_from_kernel_by_id(__u32 id, struct btf **btf)

we can't change existing btf__get_from_id(), but for the new
btf__load_from_kernel_by_id() let's keep them in line with other BTF
"constructor" APIs (btf__new and btf__parse) and return resulting
struct btf, instead of passing it in output argument. With the new
libbpf error reporting strategy (NULL on error + errno for those who
care about specific error code), it has a better usability and will
just be more consistent.

>  {
>         struct btf *res;
>         int err, btf_fd;
