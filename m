Return-Path: <netdev+bounces-7625-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 746E4720E19
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 08:29:08 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E40D21C20F60
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 06:29:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 516588487;
	Sat,  3 Jun 2023 06:29:05 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3D4B21FD5;
	Sat,  3 Jun 2023 06:29:03 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1AFB2C433EF;
	Sat,  3 Jun 2023 06:29:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685773743;
	bh=Wiuxa1+8QYKknVhddlSm/F5Lb+9iVthbSGuYu93OxcM=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=Yema+zUopvlkA8rR8wGx6+08RUKnlGqzwfFZHCz8QyevE954MpZopWm8BnAoPjcvW
	 zKKjGA53k3S+7h1i0MLYb4lgHBA9d4O6ZOD/2OGAAwGjGStU4zf0RYQGKtattw03eb
	 GrrxLozMw9Gdkv6T/nrP4dSXGAneXENYH9aonnnfsgC/HCIUSA4Pj4iOk6/f26dBzL
	 gw0D0pkfRIs7u2ErF3RkmNyURMY2hXe5dq4fEziKkoIKCWaGJNV9+2MpwgRHcq70te
	 ND2tnA+N/F4WiOvLAstouqhuRYNHuDF4G+4n+M7sA2/VUtY7nspF7+6RMdqGRVY65M
	 jeypGOhx/n6Pg==
Date: Fri, 2 Jun 2023 23:29:02 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: virtualization@lists.linux-foundation.org, "Michael S. Tsirkin"
 <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
 <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John
 Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org,
 bpf@vger.kernel.org
Subject: Re: [PATCH vhost v10 00/10] virtio core prepares for AF_XDP
Message-ID: <20230602232902.446e1d71@kernel.org>
In-Reply-To: <20230602092206.50108-1-xuanzhuo@linux.alibaba.com>
References: <20230602092206.50108-1-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  2 Jun 2023 17:21:56 +0800 Xuan Zhuo wrote:
> Thanks for the help from Christoph.

That said you haven't CCed him on the series, isn't the general rule to
CC anyone who was involved in previous discussions?

