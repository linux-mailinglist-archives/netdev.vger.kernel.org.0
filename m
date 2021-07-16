Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D53593CB1A2
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 06:32:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229911AbhGPEfj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 00:35:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbhGPEfi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 16 Jul 2021 00:35:38 -0400
Received: from mail-yb1-xb29.google.com (mail-yb1-xb29.google.com [IPv6:2607:f8b0:4864:20::b29])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4374BC06175F;
        Thu, 15 Jul 2021 21:32:44 -0700 (PDT)
Received: by mail-yb1-xb29.google.com with SMTP id t186so12787763ybf.2;
        Thu, 15 Jul 2021 21:32:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=C69MsQVDPPlpMPawzLQE4rHMDWQtOp+i0QM+nr+cVuA=;
        b=DxU0RlfjGctV72B1NyXita0bm0Ad+aTdyYkPeXXss7RXWxCDDvDUp8YQKK65RiaqXb
         6TUKohHMw5i6qPbd9S/nEQYUxvwhHD6RAFPaXqScXBJb+UdWTZnwN5pYX7ixCnWX7bnd
         RY7XETsBCzcGXq9XCxJ6Hrn1mhbd/F0ygHPts2ohcrTSr/DNZEiea0FgW8HXiEMh0CRC
         /mXnV1IbMS/2r5DOsudBORNrY3NKPSbpcXdIHxw8nciNEbIdI/KTiu19VtISlKnNnLz1
         zA3W0UO9H7dA2Lg88FcY2XBkPckHmgPVW+f8fDCKepAR8Pc4FkpEFIrm+BAhc/jkl0+F
         Je5w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=C69MsQVDPPlpMPawzLQE4rHMDWQtOp+i0QM+nr+cVuA=;
        b=iOoEcWlTTv5x3PejuTn8iLDXBBvYDmI3zobSeKxIHQZfvqW5CC8BYfS1ysc2weNes7
         TnV3/SlWoc2Lk9BodsKDyAVbrQWDbyZk6SdEdQ9i0RN4oJnRDPmwMoV+8xTUeN+QlM4N
         Uv81wG9Q+dTBxljj+MDIQN09MdDeW43AzZqnWEoEj3FRLVBomcTiWHs8Pce7FN/HMiJh
         wCYQIqhG3VwSrRc92s+RnjuYNZKHFk3FSZVpOWjgnNaAQiGlf+KEAg7HqVPtEkLj2rOX
         wylzS74c5SBA4v01Qczosrt+r26iLTAuYgIrZmtgrPNhXkagz+y7Ul2N5MrKf+p7RQMQ
         RTUw==
X-Gm-Message-State: AOAM530xkaRLnOT0/+7BjIOT7MG8hhygPf4YHSwYN8u71MB1L+9YT02z
        sN15VdLiIxeob2rhBAURBsGOhNC7KZrvxDivVKE=
X-Google-Smtp-Source: ABdhPJwDtSo8UD4CBDuKpZ/S73XHiSMuw2f1I0OyWzD0PN++utddalac0c4ZnkHUfqIVDNX9i2jC5EW+TWKThdjkOnM=
X-Received: by 2002:a25:d349:: with SMTP id e70mr10125011ybf.510.1626409963541;
 Thu, 15 Jul 2021 21:32:43 -0700 (PDT)
MIME-Version: 1.0
References: <20210714141532.28526-1-quentin@isovalent.com> <20210714141532.28526-2-quentin@isovalent.com>
In-Reply-To: <20210714141532.28526-2-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 15 Jul 2021 21:32:32 -0700
Message-ID: <CAEf4Bza=5GjYyDCZNMbUFyQskXunT8S3R1jCfvZmy3f1joRVFQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next 1/6] libbpf: rename btf__load() as btf__load_into_kernel()
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
> As part of the effort to move towards a v1.0 for libbpf, rename
> btf__load() function, used to "upload" BTF information into the kernel,
> and rename it instead as btf__load_into_kernel().
>
> This new name better reflects what the function does, and should be less
> confusing.
>
> References:
>
> - https://github.com/libbpf/libbpf/issues/278
> - https://github.com/libbpf/libbpf/wiki/Libbpf:-the-road-to-v1.0#btfh-apis
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  tools/lib/bpf/btf.c      | 3 ++-
>  tools/lib/bpf/btf.h      | 1 +
>  tools/lib/bpf/libbpf.c   | 2 +-
>  tools/lib/bpf/libbpf.map | 5 +++++
>  4 files changed, 9 insertions(+), 2 deletions(-)
>

[...]

> diff --git a/tools/lib/bpf/libbpf.map b/tools/lib/bpf/libbpf.map
> index 944c99d1ded3..d42f20b0e9e4 100644
> --- a/tools/lib/bpf/libbpf.map
> +++ b/tools/lib/bpf/libbpf.map
> @@ -375,3 +375,8 @@ LIBBPF_0.5.0 {
>                 bpf_object__gen_loader;
>                 libbpf_set_strict_mode;
>  } LIBBPF_0.4.0;
> +
> +LIBBPF_0.6.0 {

we haven't released v0.5 yet, so this will go into 0.5, probably

> +       global:
> +               btf__load_into_kernel;
> +} LIBBPF_0.5.0;
> --
> 2.30.2
>
