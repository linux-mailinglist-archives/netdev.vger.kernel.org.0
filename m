Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 789B420BBE4
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 23:52:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725975AbgFZVwI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 17:52:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725959AbgFZVwH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Jun 2020 17:52:07 -0400
Received: from mail-qv1-xf43.google.com (mail-qv1-xf43.google.com [IPv6:2607:f8b0:4864:20::f43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8A0FC03E979;
        Fri, 26 Jun 2020 14:52:06 -0700 (PDT)
Received: by mail-qv1-xf43.google.com with SMTP id g11so5179438qvs.2;
        Fri, 26 Jun 2020 14:52:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=CYaBsecgNFBlic8HfAR0C1bLpXq6GkqdCX5Apw2muLI=;
        b=YtAWULVR6OJOdk2O51dzsCNOnrpG46L379wXaGHSgG6YF8RtLQx7l3fw4tmbaubgCD
         RDPMe9tvvzcYRqy2y1Tvi3MKu8Ernzx/zcwHYIcnUTKARNliemDjYIKk4I3MrWimlVt2
         3gDosgh1toy6xXJqOFXeHalT4YOgff4fnecMLTe61BKre/+7AKSwLbx2dwFSnwzE8/c6
         rWHo0h0UitvHjAg5/1aCr3BzjvIgidbzvsDFbyTyRjqcUSzEcihyiOIHtPg5AFlyoe8h
         l1NjhdGD7uiAGpk2o9Egj9nPy3DKScA+rxSV1ZorOU9tJ+zpSsVUMMfPRI4nOzsP3u8x
         c+2A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=CYaBsecgNFBlic8HfAR0C1bLpXq6GkqdCX5Apw2muLI=;
        b=PvKQoIeqzj6WiOj2tBpXDaz4IAL3ncapwQQWaoTN6qWr1uOETjLrDoj1WplwWYFTWi
         0gzbKk6ILMSUgMhrYqumRw6hWOEkOJYXXzuzc4z6jCSu6NOljGJu2imJjwLV8JCprB4Y
         BQww5Ie0f/6aXXYMU1AeY1zPjcNx/iQCW+uIiiklZcgKZGrngeExllbH814uRnbx2H4c
         rAt5b4En7AatxryR3Icg3huQzL1ilSG0UmUpbdXqjRirNPX6722WNBLZO823fZjusG0F
         u8A+JpeAVW3bjPnoBfhXUYt9+34PedBZDxrTSYHUeq/tyhoWbrZk+SjI/7K4R36eEtUY
         ZXmA==
X-Gm-Message-State: AOAM530oelb1uZquqO0mdDnCp7D73J5J4Y5A93mW2S1lNLiahm6+v8RU
        59JpICPqgGIjKbDhJT7MFNGkJV6d8lUQDrOz4ZQ=
X-Google-Smtp-Source: ABdhPJzj4/qqjzftXNQF1a6Jos7LSvT2leQfLConK5AyQOHoF2dlyflSwZDmU99JfM0QxSsQTeJ52PKEikWkj/MxmRk=
X-Received: by 2002:a0c:f388:: with SMTP id i8mr5195065qvk.224.1593208326044;
 Fri, 26 Jun 2020 14:52:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200625221304.2817194-1-jolsa@kernel.org> <20200625221304.2817194-12-jolsa@kernel.org>
In-Reply-To: <20200625221304.2817194-12-jolsa@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 26 Jun 2020 14:51:55 -0700
Message-ID: <CAEf4BzZi1KOY21SE__H2q8YjT4972QLYPhMX7tDeUPgnM8NFMw@mail.gmail.com>
Subject: Re: [PATCH v4 bpf-next 11/14] tools headers: Adopt verbatim copy of
 btf_ids.h from kernel sources
To:     Jiri Olsa <jolsa@kernel.org>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        David Miller <davem@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Wenbo Zhang <ethercflow@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Brendan Gregg <bgregg@netflix.com>,
        Florent Revest <revest@chromium.org>,
        Al Viro <viro@zeniv.linux.org.uk>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 25, 2020 at 4:48 PM Jiri Olsa <jolsa@kernel.org> wrote:
>
> It will be needed by bpf selftest for resolve_btfids tool.
>
> Also adding __PASTE macro as btf_ids.h dependency, which is
> defined in:
>
>   include/linux/compiler_types.h
>
> but because tools/include do not have this header, I'm putting
> the macro into linux/compiler.h header.
>
> Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> ---

I don't like `#define GUARD 1`, but besides that:

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/include/linux/btf_ids.h  | 108 +++++++++++++++++++++++++++++++++
>  tools/include/linux/compiler.h |   4 ++
>  2 files changed, 112 insertions(+)
>  create mode 100644 tools/include/linux/btf_ids.h
>

[...]
