Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3976F470382
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 16:09:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242687AbhLJPNM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 10:13:12 -0500
Received: from mail.netfilter.org ([217.70.188.207]:45724 "EHLO
        mail.netfilter.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242684AbhLJPM7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 10:12:59 -0500
Received: from netfilter.org (unknown [78.30.32.163])
        by mail.netfilter.org (Postfix) with ESMTPSA id 87C3B6006E;
        Fri, 10 Dec 2021 16:06:53 +0100 (CET)
Date:   Fri, 10 Dec 2021 16:09:14 +0100
From:   Pablo Neira Ayuso <pablo@netfilter.org>
To:     Kumar Kartikeya Dwivedi <memxor@gmail.com>
Cc:     bpf@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        Maxim Mikityanskiy <maximmi@nvidia.com>,
        Florian Westphal <fw@strlen.de>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>,
        netdev@vger.kernel.org, netfilter-devel@vger.kernel.org
Subject: Re: [PATCH bpf-next v3 7/9] net/netfilter: Add unstable CT lookup
 helpers for XDP and TC-BPF
Message-ID: <YbNtmlaeqPuHHRgl@salvia>
References: <20211210130230.4128676-1-memxor@gmail.com>
 <20211210130230.4128676-8-memxor@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20211210130230.4128676-8-memxor@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Dec 10, 2021 at 06:32:28PM +0530, Kumar Kartikeya Dwivedi wrote:
[...]
>  net/netfilter/nf_conntrack_core.c | 252 ++++++++++++++++++++++++++++++
>  7 files changed, 497 insertions(+), 1 deletion(-)
>
[...]
> diff --git a/net/netfilter/nf_conntrack_core.c b/net/netfilter/nf_conntrack_core.c
> index 770a63103c7a..85042cb6f82e 100644
> --- a/net/netfilter/nf_conntrack_core.c
> +++ b/net/netfilter/nf_conntrack_core.c

Please, keep this new code away from net/netfilter/nf_conntrack_core.c
