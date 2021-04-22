Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9675F368426
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 17:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238006AbhDVPrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 11:47:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236709AbhDVPrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 11:47:09 -0400
Received: from ms.lwn.net (ms.lwn.net [IPv6:2600:3c01:e000:3a1::42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE441C06174A;
        Thu, 22 Apr 2021 08:46:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:281:8300:104d::5f6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id B5ECB44A;
        Thu, 22 Apr 2021 15:46:33 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net B5ECB44A
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1619106393; bh=pdu7hsbhhGkYv58bQsi3XOeVvdvaYtVS+UWp9QvoCTY=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=hJUO+/8Gd/vq2XZ/FfniFxLt5R08sOGkT6GpZOSy5VhUxfoJXQdlDRhrcZ/NsUp/l
         FfsZ7G7PnWaEym9PvkYnIgXIgP86Duc80zXfj4y7IacbUmsWiA0M0T93cIOrjVGLg3
         UyxKgDEfeNsAiNDKtAOuBnCRD4eKf1tDsPf8BuUzv/KlqDwO/yHDFCahNmgHagbX3x
         4J/zJFCrcnOc7EIPKiiwxR4Sv2Gbb1cJP1MggB8bBdeISoRpIJghlZ0V6c3EIGcS9h
         3akHauOObQHiV2hCF2WuEWDnnXowsAATBOskzd3zNJXhlHz5DfVNGIGvEr39Sump37
         2glQpjkvFq6Ew==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        linux-doc@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        Xuefeng Li <lixuefeng@loongson.cn>
Subject: Re: [PATCH bpf-next v4] bpf: Fix some invalid links in
 bpf_devel_QA.rst
In-Reply-To: <1619089790-6252-1-git-send-email-yangtiezhu@loongson.cn>
References: <1619089790-6252-1-git-send-email-yangtiezhu@loongson.cn>
Date:   Thu, 22 Apr 2021 09:46:33 -0600
Message-ID: <87pmymcofa.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tiezhu Yang <yangtiezhu@loongson.cn> writes:

> There exist some errors "404 Not Found" when I click the link
> of "MAINTAINERS" [1], "samples/bpf/" [2] and "selftests" [3]
> in the documentation "HOWTO interact with BPF subsystem" [4].
>
> As Jesper Dangaard Brouer said, the links work if you are browsing
> the document via GitHub [5], so I think maybe it is better to use
> the corresponding GitHub links to fix the issues in the kernel.org
> official document [4], this change has no influence on GitHub and
> looks like more clear.

No, we really don't want to link to GitHub, that's what we have
kernel.org for.

> [1] https://www.kernel.org/doc/html/MAINTAINERS
> [2] https://www.kernel.org/doc/html/samples/bpf/
> [3] https://www.kernel.org/doc/html/tools/testing/selftests/bpf/
> [4] https://www.kernel.org/doc/html/latest/bpf/bpf_devel_QA.html
> [5] https://github.com/torvalds/linux/blob/master/Documentation/bpf/bpf_devel_QA.rst
>
> Fixes: 542228384888 ("bpf, doc: convert bpf_devel_QA.rst to use RST formatting")
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
>
> The initial aim is to fix the invalid links, sorry for the noisy.
>
> v4: Use the corresponding GitHub links
>
> v3: Remove "MAINTAINERS" and "samples/bpf/" links and
>     use correct link of "selftests"
>
> v2: Add Fixes: tag
>
>  Documentation/bpf/bpf_devel_QA.rst | 6 +++---
>  1 file changed, 3 insertions(+), 3 deletions(-)
>
> diff --git a/Documentation/bpf/bpf_devel_QA.rst b/Documentation/bpf/bpf_devel_QA.rst
> index 2ed89ab..36a9b62 100644
> --- a/Documentation/bpf/bpf_devel_QA.rst
> +++ b/Documentation/bpf/bpf_devel_QA.rst
> @@ -645,10 +645,10 @@ when:
>  
>  .. Links
>  .. _Documentation/process/: https://www.kernel.org/doc/html/latest/process/
> -.. _MAINTAINERS: ../../MAINTAINERS
> +.. _MAINTAINERS: https://github.com/torvalds/linux/blob/master/MAINTAINERS

https://www.kernel.org/doc/html/latest/process/maintainers.html

>  .. _netdev-FAQ: ../networking/netdev-FAQ.rst
> -.. _samples/bpf/: ../../samples/bpf/
> -.. _selftests: ../../tools/testing/selftests/bpf/
> +.. _samples/bpf/: https://github.com/torvalds/linux/tree/master/samples/bpf

https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/samples/bpf

...etc.

Thanks,

jon
