Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 182622CE54F
	for <lists+netdev@lfdr.de>; Fri,  4 Dec 2020 02:45:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726619AbgLDBpB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Dec 2020 20:45:01 -0500
Received: from mail.kernel.org ([198.145.29.99]:56916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726028AbgLDBpA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Dec 2020 20:45:00 -0500
Date:   Thu, 3 Dec 2020 17:44:17 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607046260;
        bh=hesPmy1nwGmsLRTCW6Jx89Xg2zduiUm6o8IB8GX/LsM=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=qkYd/fQKBfLTCGlE/4raBI6GDJ8UPTzsY/eXN430DMOeWmdFnC7P2e8e7oE+Wrzxd
         ffeo1agq/5kP8Vzsjbq7ZB+Tjt+pYxB9RK1Witez/azllIoJO4gzssaJyZ9PoRR0FP
         qH0tllmJp9u3+lObh0r6+21V32bS74RyAyZaw90p0DnNglGgeSJeiUFIJm3tAApwjm
         89xGCn9ASpX0D0lIp9o7Q1q4kWEmSm50piq7J1dShLBrHh10ZH6ZmyVy6Q/1ZRv16o
         1zRegudG/bMPBRoljwzLEoGFRn3r0e1i7/ui25+KktabljvpLb2+ul0JGh35/kYD18
         FxDQjjh8+3y4A==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Toke =?UTF-8?B?SMO4aWxhbmQtSsO4cmdlbnNlbg==?= <toke@redhat.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andriin@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@chromium.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Romain Perier <romain.perier@gmail.com>,
        Allen Pais <apais@linux.microsoft.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Simon Horman <simon.horman@netronome.com>,
        "Gustavo A. R. Silva" <gustavoars@kernel.org>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        Wei Yongjun <weiyongjun1@huawei.com>,
        Jiri Benc <jbenc@redhat.com>, oss-drivers@netronome.com,
        linux-omap@vger.kernel.org, netdev@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH bpf 3/7] netdevsim: Add debugfs toggle to reject BPF
 programs in verifier
Message-ID: <20201203174417.46255de5@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <160703132036.162669.7719186299991611592.stgit@toke.dk>
References: <160703131710.162669.9632344967082582016.stgit@toke.dk>
        <160703132036.162669.7719186299991611592.stgit@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 03 Dec 2020 22:35:20 +0100 Toke H=C3=B8iland-J=C3=B8rgensen wrote:
> diff --git a/drivers/net/netdevsim/netdevsim.h b/drivers/net/netdevsim/ne=
tdevsim.h
> index 827fc80f50a0..d1d329af3e61 100644
> --- a/drivers/net/netdevsim/netdevsim.h
> +++ b/drivers/net/netdevsim/netdevsim.h
> @@ -190,6 +190,7 @@ struct nsim_dev {
>  	struct bpf_offload_dev *bpf_dev;
>  	bool bpf_bind_accept;
>  	u32 bpf_bind_verifier_delay;
> +	bool bpf_bind_verifier_accept;
>  	struct dentry *ddir_bpf_bound_progs;

nit: if you respin please reorder the bpf_bind_verifier_* fields so
that the structure packs better.

Acked-by: Jakub Kicinski <kuba@kernel.org>

Thanks for fixing this test!
