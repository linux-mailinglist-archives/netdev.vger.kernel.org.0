Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B0E728F960
	for <lists+netdev@lfdr.de>; Thu, 15 Oct 2020 21:26:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391502AbgJOT02 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 15 Oct 2020 15:26:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:57904 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2391493AbgJOT01 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 15 Oct 2020 15:26:27 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 55A6E206B2;
        Thu, 15 Oct 2020 19:26:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602789987;
        bh=kSAb21hpwT1aCd33FktRvAwhXCN3mQbWCGEF448daDc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=wYvXM3LElR+nLi1kXzzt1Tv+vEGEi1aXzwdWs0VVuZZzD3RNjbYz2UMGJYzUXyv3r
         gw4QEVcwBRxGSZVUTDcmIP46vi6LluzwtL42/+pAGgIxZYqM5x5J6d4ve3EPkX2lYP
         znJ7jfAWL4rllyd+QOGYMa+/9iTgJRpC5rn9wIis=
Date:   Thu, 15 Oct 2020 12:26:24 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     YueHaibing <yuehaibing@huawei.com>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Masahiro Yamada <masahiroy@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] bpfilter: Fix build error with CONFIG_BPFILTER_UMH
Message-ID: <20201015122624.0ca7b58c@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CAADnVQLVvd_2zJTQJ7m=322H7M7NdTFfFE7f800XA=9HXVY28Q@mail.gmail.com>
References: <20201014091749.25488-1-yuehaibing@huawei.com>
        <20201015093748.587a72b5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAADnVQKJ=iDMiJpELmuATsdf2vxGJ=Y9r+vjJG6m4BDRNPmP3g@mail.gmail.com>
        <20201015115643.3a4d4820@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <CAADnVQLVvd_2zJTQJ7m=322H7M7NdTFfFE7f800XA=9HXVY28Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 15 Oct 2020 12:03:14 -0700 Alexei Starovoitov wrote:
> On Thu, Oct 15, 2020 at 11:56 AM Jakub Kicinski <kuba@kernel.org> wrote:
> > How so? It's using in-tree headers instead of system ones.
> > Many samples seem to be doing the same thing.  
> 
> There is no such thing as "usr/include" in the kernel build and source trees.

Hm. I thought bpfilter somehow depends on make headers. But it doesn't
seem to. Reverting now.

> > > Also please don't take bpf patches.  
> >
> > You had it marked it as netdev in your patchwork :/  
> 
> It was delegated automatically by the patchwork system.
> I didn't have time to reassign, but you should have known better
> when you saw 'bpfilter' in the subject.

The previous committers for bpfilter are almost all Dave, so I checked
your patchwork to make sure and it was netdev...

I'll do better next time :)
