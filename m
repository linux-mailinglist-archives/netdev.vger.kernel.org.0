Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3FA038DBD1
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 18:08:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231857AbhEWQJZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 12:09:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231800AbhEWQJY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 23 May 2021 12:09:24 -0400
Received: from bombadil.infradead.org (bombadil.infradead.org [IPv6:2607:7c80:54:e::133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 282F1C061574;
        Sun, 23 May 2021 09:07:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20210309; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description;
        bh=YjMoxwr94CpOc6dJiHNAtzWBKsQW76MYcER0tgF7dRY=; b=L2/bywvmr7ZsZ1/cyT7PkdwupN
        RGX3WtpVC2pg0i+Dq2HdrHNvkJGjMww5w/mRYeY/gy0uEzieVbO1govHtQsdcir4/Jyao0dx9Hpz+
        tQ0EI5xejPMftoarc/gq7BpldSTZ6fRSapPYNSSvYeB0hnkQoF7csoPx8oMU9rFv8GRAEPIR8uuKl
        9GYuuhcSPdhq8jWgoXftBTI3UPzd7XhvRAllRohxe3KQZJSlnioAIn5ayRm8i78dnuauRUyhvdRpi
        hW2Sif7rQGvVp5/mxypsj8lUQ4G+y/1r/emgzQwfjMTE2HMSuEyx1tcI9o83+vNvGOpKNlLspY1VN
        caGVyoJQ==;
Received: from [2601:1c0:6280:3f0::7376]
        by bombadil.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lkqdv-000UQ5-NX; Sun, 23 May 2021 16:07:55 +0000
Subject: Re: [PATCH v2] samples: bpf: ix kernel-doc syntax in file header
To:     Aditya Srivastava <yashsri421@gmail.com>, kafai@fb.com
Cc:     lukas.bulwahn@gmail.com, linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org,
        linux-doc@vger.kernel.org, dledford@redhat.com, jgg@ziepe.ca,
        ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        kpsingh@kernel.org, linux-rdma@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
References: <20210523150917.21748-1-yashsri421@gmail.com>
 <20210523151408.22280-1-yashsri421@gmail.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <33cd99d5-8d4a-df36-8ab0-e68da879aa69@infradead.org>
Date:   Sun, 23 May 2021 09:07:54 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.0
MIME-Version: 1.0
In-Reply-To: <20210523151408.22280-1-yashsri421@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/23/21 8:14 AM, Aditya Srivastava wrote:
> The opening comment mark '/**' is used for highlighting the beginning of
> kernel-doc comments.
> The header for samples/bpf/ibumad_kern.c follows this syntax, but
> the content inside does not comply with kernel-doc.
> 
> This line was probably not meant for kernel-doc parsing, but is parsed
> due to the presence of kernel-doc like comment syntax(i.e, '/**'), which
> causes unexpected warnings from kernel-doc:
> warning: This comment starts with '/**', but isn't a kernel-doc comment. Refer Documentation/doc-guide/kernel-doc.rst
>  * ibumad BPF sample kernel side
> 
> Provide a simple fix by replacing this occurrence with general comment
> format, i.e. '/*', to prevent kernel-doc from parsing it.
> 
> Signed-off-by: Aditya Srivastava <yashsri421@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
> Changes in v2: Include changes for both, samples/bpf/ibumad_kern.c and samples/bpf/ibumad_user.c in the same patch
> 
>  samples/bpf/ibumad_kern.c | 2 +-
>  samples/bpf/ibumad_user.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/samples/bpf/ibumad_kern.c b/samples/bpf/ibumad_kern.c
> index 26dcd4dde946..9b193231024a 100644
> --- a/samples/bpf/ibumad_kern.c
> +++ b/samples/bpf/ibumad_kern.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
>  
> -/**
> +/*
>   * ibumad BPF sample kernel side
>   *
>   * This program is free software; you can redistribute it and/or
> diff --git a/samples/bpf/ibumad_user.c b/samples/bpf/ibumad_user.c
> index d83d8102f489..0746ca516097 100644
> --- a/samples/bpf/ibumad_user.c
> +++ b/samples/bpf/ibumad_user.c
> @@ -1,6 +1,6 @@
>  // SPDX-License-Identifier: GPL-2.0 OR Linux-OpenIB
>  
> -/**
> +/*
>   * ibumad BPF sample user side
>   *
>   * This program is free software; you can redistribute it and/or
> 


-- 
~Randy

