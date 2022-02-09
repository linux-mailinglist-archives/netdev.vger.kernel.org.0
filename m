Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7A984AE618
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 01:36:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240143AbiBIAf5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Feb 2022 19:35:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240154AbiBIAfv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Feb 2022 19:35:51 -0500
Received: from mail-il1-x131.google.com (mail-il1-x131.google.com [IPv6:2607:f8b0:4864:20::131])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE11BC061576;
        Tue,  8 Feb 2022 16:35:50 -0800 (PST)
Received: by mail-il1-x131.google.com with SMTP id i10so425665ilm.4;
        Tue, 08 Feb 2022 16:35:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+YWDH4eHWrUs+PczL2NaxuiVLZlAbGyakS668c6eLak=;
        b=bwoDTM16u7oDn1CPlqKqLcy5pChqFvKVLokKfP0cEseywUB2c1KLfZRCgVol6fPK09
         6OfXhgTMBQ38lbx9Ug+G4dZh1zczJzjt/OmBFqRffiYLzoWq2TiWE+C8mqCCNbQvmCE0
         g/AiVPQpb4HkZP/XdzSkLn2kCFbP1CQ5tKw8veVr8bPClYdoQbGThhT+NJ1biTKxJoyg
         meDgbGb8BV8DfwNGYpljRcxeZI3Oox5rHV9mmas1UyV9WGWyTiZeuyZLCvGmUxzQBt7q
         jbejjCT16EwsCmbdiBRMFpY2E+KR86s4aeC/InxuOFOAff9tXJxhdZG9TkJtd1qe6Wbb
         h0Iw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+YWDH4eHWrUs+PczL2NaxuiVLZlAbGyakS668c6eLak=;
        b=7JbMhnpsv4tcI5SuhysNfJHIpo/l4djU5PElb2W5ljXm+NKHr9N26DWyfEcNayRlFx
         Vx3/T22h1xqrxndxwppHQbpNi5yiVwagbJYJGJxf1vD3QWITwR+NGWu+L3C0OTJhZw10
         CtqJKukcfx1U0491TWvL0uelfk964A31tn2dQzRmUYSFEMVFZw7VqZS54u5/Y9EcQ3C2
         6V9fQTe/qbXYMMZ+Wqnwan9wM2USAEWUevkwKPTyo3n3FBBfwyuQAEOcWM3rB9vNiE/3
         6ns751G4FkRoydVcTW9xTt4IcN/t2K3R70AU8QkVVddDKn4zTTDW+7OMKb6uPKx3E4An
         Vp5w==
X-Gm-Message-State: AOAM530YjUvL6XZptYEgqh0GSRfwUUeGR947pLHKJDOXXKRRRxE+0euq
        gEc4934paofkOF2WmuNf5pW8qlBnooppZjNu4aRjRNNC
X-Google-Smtp-Source: ABdhPJyRGl2DdC3jBFNtbIKvppHoU/K3MAgFnADqdOmVIzsyNrwr9872zhb2xL9e6PD0y/aUtmXwPl91hRf+Ki6Qq3E=
X-Received: by 2002:a05:6e02:1bcd:: with SMTP id x13mr3454687ilv.98.1644366949988;
 Tue, 08 Feb 2022 16:35:49 -0800 (PST)
MIME-Version: 1.0
References: <20220208120648.49169-1-quentin@isovalent.com> <20220208120648.49169-3-quentin@isovalent.com>
In-Reply-To: <20220208120648.49169-3-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 8 Feb 2022 16:35:38 -0800
Message-ID: <CAEf4BzaWJtOkinVVet1hzHioCo4sZ++o+N2cXhNbV7r7iP=Krg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 2/3] libbpf: Add "libbpversion" make target to
 print version
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 8, 2022 at 4:06 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> Add a target to libbpf's Makefile to print its version number, in a
> similar way to what running "make kernelversion" at the root of the
> repository does.
>
> This is to avoid re-implementing the parsing of the libbpf.map file in
> case some other tools want to extract the version of the libbpf sources
> they are using.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/lib/bpf/Makefile | 3 +++
>  1 file changed, 3 insertions(+)
>
> diff --git a/tools/lib/bpf/Makefile b/tools/lib/bpf/Makefile
> index b8b37fe76006..91136623edf9 100644
> --- a/tools/lib/bpf/Makefile
> +++ b/tools/lib/bpf/Makefile
> @@ -108,6 +108,9 @@ MAKEOVERRIDES=
>
>  all:
>
> +libbpfversion:

I don't think we need it (see next patch), but if we end up keeping
it, please call it just "version". Worst case, "libbpf-version" seems
better still.

> +       @echo $(LIBBPF_VERSION)
> +
>  export srctree OUTPUT CC LD CFLAGS V
>  include $(srctree)/tools/build/Makefile.include
>
> --
> 2.32.0
>
