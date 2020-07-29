Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C81B2232694
	for <lists+netdev@lfdr.de>; Wed, 29 Jul 2020 23:06:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726877AbgG2VGX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jul 2020 17:06:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:37046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726476AbgG2VGW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 Jul 2020 17:06:22 -0400
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D29DE2250E;
        Wed, 29 Jul 2020 21:06:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596056782;
        bh=ueGCrlTHZf0CRfYXBT+w5ROCnO+gC3NkQFou1ASiPJM=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=wnUfZOe1z1bdSDJ03r/muyQ9yir2kK2heQ2UD/DcT1KesUm3lII2Kipm76COhjCG+
         Zf2AA8WGuUGbs+jGZRAsGfWusJTMCb+nCY0gvjdRjgtY3fISl7SMuy+ezhbu5jH3PU
         vS1oSSRGq77BR8P2XYCzVlHAZOqRBMNdXqf3qrOc=
Received: by mail-lf1-f50.google.com with SMTP id b30so13791211lfj.12;
        Wed, 29 Jul 2020 14:06:21 -0700 (PDT)
X-Gm-Message-State: AOAM531d6hrV+htt8ZIxnGWs+ULBbzLDD2DL1xFJFEXjafFNMDdY7pld
        8fCSIKdaVsF2e+UtN988PLQXrMov0Ufxrms0rqo=
X-Google-Smtp-Source: ABdhPJxyF5POFFPO8i7lMsfFqs9+19XH7Zn+S8Z+XDeZm1y50XRsaVlCP1fr66fhMHfEa4N3Q+fffiPjA55ITMZRyMI=
X-Received: by 2002:a19:ec12:: with SMTP id b18mr56556lfa.52.1596056780070;
 Wed, 29 Jul 2020 14:06:20 -0700 (PDT)
MIME-Version: 1.0
References: <1596028555-32028-1-git-send-email-yangtiezhu@loongson.cn>
In-Reply-To: <1596028555-32028-1-git-send-email-yangtiezhu@loongson.cn>
From:   Song Liu <song@kernel.org>
Date:   Wed, 29 Jul 2020 14:06:09 -0700
X-Gmail-Original-Message-ID: <CAPhsuW5CYF+iiXL8mcLTerFxhUG2i1sTB8+qoFnZRT3K0XXb4w@mail.gmail.com>
Message-ID: <CAPhsuW5CYF+iiXL8mcLTerFxhUG2i1sTB8+qoFnZRT3K0XXb4w@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] Documentation/bpf: Use valid and new links in index.rst
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        "Tobin C. Harding" <me@tobin.cc>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 29, 2020 at 6:17 AM Tiezhu Yang <yangtiezhu@loongson.cn> wrote:
>
> There exists an error "404 Not Found" when I click the html link of
> "Documentation/networking/filter.rst" in the BPF documentation [1],
> fix it.
>
> Additionally, use the new links about "BPF and XDP Reference Guide"
> and "bpf(2)" to avoid redirects.
>
> [1] https://www.kernel.org/doc/html/latest/bpf/
>
> Fixes: d9b9170a2653 ("docs: bpf: Rename README.rst to index.rst")
> Fixes: cb3f0d56e153 ("docs: networking: convert filter.txt to ReST")
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
>
> v2:
>   - Fix a typo "clik" to "click" in the commit message, sorry for that
>
>  Documentation/bpf/index.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/bpf/index.rst b/Documentation/bpf/index.rst
> index 26f4bb3..1b901b4 100644
> --- a/Documentation/bpf/index.rst
> +++ b/Documentation/bpf/index.rst
> @@ -68,7 +68,7 @@ Testing and debugging BPF
>
>
>  .. Links:
> -.. _Documentation/networking/filter.rst: ../networking/filter.txt
> +.. _Documentation/networking/filter.rst: ../networking/filter.html

This should be filter.rst, no?

>  .. _man-pages: https://www.kernel.org/doc/man-pages/
> -.. _bpf(2): http://man7.org/linux/man-pages/man2/bpf.2.html
> -.. _BPF and XDP Reference Guide: http://cilium.readthedocs.io/en/latest/bpf/
> +.. _bpf(2): https://man7.org/linux/man-pages/man2/bpf.2.html
> +.. _BPF and XDP Reference Guide: https://docs.cilium.io/en/latest/bpf/
> --
> 2.1.0
>
