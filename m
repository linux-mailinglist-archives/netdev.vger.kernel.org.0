Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 31A421FD1C8
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 18:18:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726809AbgFQQSR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 12:18:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47754 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726540AbgFQQSP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 12:18:15 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC1F5C06174E;
        Wed, 17 Jun 2020 09:18:13 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id g139so860789lfd.10;
        Wed, 17 Jun 2020 09:18:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=DbdKwODoe45DOZ3Q5t/MAeoc7NKC4buXJp9RqrSI/NQ=;
        b=D6iQY8mc5Nsprr4zZZePshJV+pBfPfZD9w/gF32GkNcR7wD5Cbn7qKILI18fGYF0YI
         0OmLCvgqMHp0fd04hZ9UpZSvew0IqxBKHLVKOAZlsPjUDqN7xBf/odwH0+EXewZ3zZx4
         oRpyO222vus3XmDjbqASH+PPrJVOCLNobCazM5j8p4JuhTjjheLuCb63K6BCU8mvHzOb
         RZjrPADWcUryesYj4LlNeDQXKayLIR69ZbuE3rRSoWZeWLphGbFWruiZcAb8OjGEZE4U
         OEeO1CD9GR4BBNMk50+mLIFE/SbqpurbAddX5S7K5t91vLS+ISRyfs8jEDl/s9XJZDBR
         PmmA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=DbdKwODoe45DOZ3Q5t/MAeoc7NKC4buXJp9RqrSI/NQ=;
        b=eC1X/vb8HZr1kIX6vWdmVhQppRzhqU6TJ1PKYeC8SlGJNIghSY2sGL6amHQb7K/GaY
         rqsElH8Z/P8faCDd/hJYBa3pa3Vg4Bs4s6wCaX++yXPCP5N+qEkfea3/7jEo6CjBxwpk
         9E93fBdsyIkKJT1b+ifwwSZXxTW83vMAXAXC8BawD4S+eIpD8kja2/UxD6NrCANjj6Md
         wCiM5Ob8rIPhsUV4x8opt4Yi86q2mo/N16D8jYpOakrsahIKAJovn4qfdu1D+2K0ymTe
         WqH20lw4WtEABT/XoOLvG+HCSktlTns2B2anIGJp/sxvsPNtjf6tfe6mlACcDrpTds+M
         XGBA==
X-Gm-Message-State: AOAM533l6+z5jA+1p0t3L8LsLmMuo5rdcIMsWUeebKfPRjgJhcDdHQso
        6DKS9e1f+DXwr442IPaMAqN84zjJf5YXoxTkGt8=
X-Google-Smtp-Source: ABdhPJzHh4azELYorjEM/JxdcGGAZe5KgqqAHiNUES/BhrAGSNGCmxKe6SdeEYk6zfhnQMPtB5ot+XSphN/PbmUWyQI=
X-Received: by 2002:ac2:53a6:: with SMTP id j6mr4968199lfh.73.1592410692037;
 Wed, 17 Jun 2020 09:18:12 -0700 (PDT)
MIME-Version: 1.0
References: <20200617155539.1223558-1-andriin@fb.com>
In-Reply-To: <20200617155539.1223558-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 17 Jun 2020 09:17:59 -0700
Message-ID: <CAADnVQLqg5DSXQXMeVAmCBx001cz-ogkZO1TZ43aJ4Grp93cSA@mail.gmail.com>
Subject: Re: [PATCH bpf-next] libbpf: bump version to 0.0.10
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 17, 2020 at 8:59 AM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Let's start new cycle with another libbpf version bump.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---
>  tools/lib/bpf/libbpf.map | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index f732c77b7ed0..3b37b8867cec 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -270,3 +270,6 @@ LIBBPF_0.0.9 {
>                 ring_buffer__new;
>                 ring_buffer__poll;
>  } LIBBPF_0.0.8;
> +
> +LIBBPF_0.0.10 {
> +} LIBBPF_0.0.9;

How about 0.1.0 instead?
