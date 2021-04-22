Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5AFF5367D87
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 11:16:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235621AbhDVJQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 05:16:32 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:29071 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S235597AbhDVJQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 05:16:31 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1619082956;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZpZ4/lZdrqpUFu+LeCWRgSEcQffomnP0+mjACx6gy8c=;
        b=A72lalvqTo0i1rfKgUi+Z7inRVuNse7Glc3M7AcX/SiD6fr8075LHJRp+t/rQ2otQS9z1k
        82xtYHyfwKoB7VbgDMrlZLRNzu+xLOI8PFolEzfxZta2ndyz7x+jgaMdcC+szBvL10smvz
        a+tx7ympxsswd/h+VbW6czG8Qj6UyFw=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-277-GUXQldHaP8ag-HXEf6Mkrg-1; Thu, 22 Apr 2021 05:15:52 -0400
X-MC-Unique: GUXQldHaP8ag-HXEf6Mkrg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 2270F107ACCD;
        Thu, 22 Apr 2021 09:15:50 +0000 (UTC)
Received: from carbon (unknown [10.36.110.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A000919726;
        Thu, 22 Apr 2021 09:15:41 +0000 (UTC)
Date:   Thu, 22 Apr 2021 11:15:40 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Tiezhu Yang <yangtiezhu@loongson.cn>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, linux-doc@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, Xuefeng Li <lixuefeng@loongson.cn>,
        brouer@redhat.com
Subject: Re: [PATCH bpf-next v3] bpf: Fix some invalid links in
 bpf_devel_QA.rst
Message-ID: <20210422111540.7e37c004@carbon>
In-Reply-To: <1619062560-30483-1-git-send-email-yangtiezhu@loongson.cn>
References: <1619062560-30483-1-git-send-email-yangtiezhu@loongson.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 22 Apr 2021 11:36:00 +0800
Tiezhu Yang <yangtiezhu@loongson.cn> wrote:

> There exist some errors "404 Not Found" when I click the link
> of "MAINTAINERS" [1], "samples/bpf/" [2] and "selftests" [3]
> in the documentation "HOWTO interact with BPF subsystem" [4].

The links work if you are browsing the document via GitHub:
 https://github.com/torvalds/linux/blob/master/Documentation/bpf/bpf_devel_QA.rst

But I'm fine with removing those links as the official doc is here:
 https://www.kernel.org/doc/html/latest/bpf/bpf_devel_QA.html


> As Alexei Starovoitov suggested, just remove "MAINTAINERS" and
> "samples/bpf/" links and use correct link of "selftests".
> 
> [1] https://www.kernel.org/doc/html/MAINTAINERS
> [2] https://www.kernel.org/doc/html/samples/bpf/
> [3] https://www.kernel.org/doc/html/tools/testing/selftests/bpf/
> [4] https://www.kernel.org/doc/html/latest/bpf/bpf_devel_QA.html
> 
> Fixes: 542228384888 ("bpf, doc: convert bpf_devel_QA.rst to use RST formatting")
> Signed-off-by: Tiezhu Yang <yangtiezhu@loongson.cn>
> ---
> 
> v3: Remove "MAINTAINERS" and "samples/bpf/" links and
>     use correct link of "selftests"
> 
> v2: Add Fixes: tag
> 
>  Documentation/bpf/bpf_devel_QA.rst | 17 ++++++++---------
>  1 file changed, 8 insertions(+), 9 deletions(-)
> 
> diff --git a/Documentation/bpf/bpf_devel_QA.rst b/Documentation/bpf/bpf_devel_QA.rst
> index 2ed89ab..d05e67e 100644
> --- a/Documentation/bpf/bpf_devel_QA.rst
> +++ b/Documentation/bpf/bpf_devel_QA.rst
> @@ -29,7 +29,7 @@ list:
>  This may also include issues related to XDP, BPF tracing, etc.
>  
>  Given netdev has a high volume of traffic, please also add the BPF
> -maintainers to Cc (from kernel MAINTAINERS_ file):
> +maintainers to Cc (from kernel ``MAINTAINERS`` file):
>  
>  * Alexei Starovoitov <ast@kernel.org>
>  * Daniel Borkmann <daniel@iogearbox.net>
> @@ -234,11 +234,11 @@ be subject to change.
>  
>  Q: samples/bpf preference vs selftests?
>  ---------------------------------------
> -Q: When should I add code to `samples/bpf/`_ and when to BPF kernel
> -selftests_ ?
> +Q: When should I add code to ``samples/bpf/`` and when to BPF kernel
> +selftests_?
>  
>  A: In general, we prefer additions to BPF kernel selftests_ rather than
> -`samples/bpf/`_. The rationale is very simple: kernel selftests are
> +``samples/bpf/``. The rationale is very simple: kernel selftests are
>  regularly run by various bots to test for kernel regressions.
>  
>  The more test cases we add to BPF selftests, the better the coverage
> @@ -246,9 +246,9 @@ and the less likely it is that those could accidentally break. It is
>  not that BPF kernel selftests cannot demo how a specific feature can
>  be used.
>  
> -That said, `samples/bpf/`_ may be a good place for people to get started,
> +That said, ``samples/bpf/`` may be a good place for people to get started,
>  so it might be advisable that simple demos of features could go into
> -`samples/bpf/`_, but advanced functional and corner-case testing rather
> +``samples/bpf/``, but advanced functional and corner-case testing rather
>  into kernel selftests.
>  
>  If your sample looks like a test case, then go for BPF kernel selftests
> @@ -645,10 +645,9 @@ when:
>  
>  .. Links
>  .. _Documentation/process/: https://www.kernel.org/doc/html/latest/process/
> -.. _MAINTAINERS: ../../MAINTAINERS
>  .. _netdev-FAQ: ../networking/netdev-FAQ.rst
> -.. _samples/bpf/: ../../samples/bpf/
> -.. _selftests: ../../tools/testing/selftests/bpf/
> +.. _selftests:
> +   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/tools/testing/selftests/bpf/
>  .. _Documentation/dev-tools/kselftest.rst:
>     https://www.kernel.org/doc/html/latest/dev-tools/kselftest.html
>  .. _Documentation/bpf/btf.rst: btf.rst



-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

