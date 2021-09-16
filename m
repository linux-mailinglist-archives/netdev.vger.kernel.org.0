Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BC25D40EA5C
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 20:56:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343771AbhIPS5b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 14:57:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52160 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245360AbhIPS5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Sep 2021 14:57:25 -0400
Received: from mail-qk1-x730.google.com (mail-qk1-x730.google.com [IPv6:2607:f8b0:4864:20::730])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A878BC04A147;
        Thu, 16 Sep 2021 11:15:13 -0700 (PDT)
Received: by mail-qk1-x730.google.com with SMTP id t190so9228025qke.7;
        Thu, 16 Sep 2021 11:15:13 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=EAjkFUEsfXQq9m+NH377nLxFioGs0vqlQsNCCnQGszM=;
        b=Fmi/z6191sBg6d5GFTA+l4arFm1+p7Be0zRoZBL3weKZHgObfQG6Ae1q11vAUXfPbA
         vEaBXeXkXtuSwM3gB2Q6uxS9/mqqSRXEz9S0sNM2TFWNp5mkUb5g/BRr6wUZWOyfZ9t8
         p2OG64u70MQCs8SEUaQ58ntR0m3Gd/cevZF67FyckQiz0hDkWl2vITY6j2tnO2BJTBoc
         pGQo4TZZeLy1MNwGtHDjBhUrofp5clKEtENe+nmWs9w8nUyn8+o6sfncn3nBEyXZXiUN
         xfDklhjjmZ68GmjfBaxw24xbTFny+BMXMJWzrMAFmWs5yRW9tEeRfhi95362pn3/iwkY
         tMEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=EAjkFUEsfXQq9m+NH377nLxFioGs0vqlQsNCCnQGszM=;
        b=5DG0TAAydyy3SJxqoDajDpsszdidcJRst+cZkWot4W/k30u3GZZSNYI9KQ8Vpsxyt6
         RKd8KmN/Gny+F53WaHyie6WhJcH8Gskp7hvAKm2IGILW89dt2iW/OhZWX2cQmkM2X36H
         F8Fy6ksuQiSxLXseATMkuYhO+G1ZIEKgmXLeaYEFm+diaYi6nUBYGcU/xM/BYfs3OQr+
         jQTesAZW4b9O+ypdSD0MWnQcOSf57iTP3jqs/yo8nmxEA6jWUUSJkuPNClI2f31lmuZi
         SqUf5GoBFmbXGX25lvRYZJK1Z2vO9oU662nzj5kksYxoelYGmGmxqiT766+1QVR56xco
         4Bhw==
X-Gm-Message-State: AOAM530ielA8EPuuNArdm62+EIhgwwaw85AGrZNIyr5jyVnHwbf3VzSm
        Rf6SOmbn8s1x5gsioMpEcUXe+q0GaM98jb55FucpeGv0t20=
X-Google-Smtp-Source: ABdhPJwOTcoAREbB2hHzNgSIMj+VkJOgxTM+fwcIrAxa4Ds3cu+y2BPOWsdG+4whEAoSUXKA716SGF1HDyRbfiK/1Mc=
X-Received: by 2002:a5b:408:: with SMTP id m8mr8687138ybp.2.1631816112770;
 Thu, 16 Sep 2021 11:15:12 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1631785820.git.mchehab+huawei@kernel.org> <854e410df660c62e4e4c8f22c4ae9c6f6594f4a1.1631785820.git.mchehab+huawei@kernel.org>
In-Reply-To: <854e410df660c62e4e4c8f22c4ae9c6f6594f4a1.1631785820.git.mchehab+huawei@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Thu, 16 Sep 2021 11:15:01 -0700
Message-ID: <CAEf4BzYqW0Gc_tCtnykYiTVy3Z7-_WXsEfpVGaGPqaPR4aseLA@mail.gmail.com>
Subject: Re: [PATCH v2 06/23] libbpf: update index.rst reference
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Grant Seltzer <grantseltzer@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 2:55 AM Mauro Carvalho Chehab
<mchehab+huawei@kernel.org> wrote:
>
> Changeset d20b41115ad5 ("libbpf: Rename libbpf documentation index file")
> renamed: Documentation/bpf/libbpf/libbpf.rst
> to: Documentation/bpf/libbpf/index.rst.
>
> Update its cross-reference accordingly.
>
> Fixes: d20b41115ad5 ("libbpf: Rename libbpf documentation index file")
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---

Thanks!

Acked-by: Andrii Nakryiko <andrii@kernel.org>

>  Documentation/bpf/index.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/Documentation/bpf/index.rst b/Documentation/bpf/index.rst
> index 1ceb5d704a97..817a201a1282 100644
> --- a/Documentation/bpf/index.rst
> +++ b/Documentation/bpf/index.rst
> @@ -15,7 +15,7 @@ that goes into great technical depth about the BPF Architecture.
>  libbpf
>  ======
>
> -Documentation/bpf/libbpf/libbpf.rst is a userspace library for loading and interacting with bpf programs.
> +Documentation/bpf/libbpf/index.rst is a userspace library for loading and interacting with bpf programs.
>
>  BPF Type Format (BTF)
>  =====================
> --
> 2.31.1
>
