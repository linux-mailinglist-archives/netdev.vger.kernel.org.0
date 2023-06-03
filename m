Return-Path: <netdev+bounces-7630-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0376E720E1F
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 08:32:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3A5A9281B6F
	for <lists+netdev@lfdr.de>; Sat,  3 Jun 2023 06:32:12 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 785148834;
	Sat,  3 Jun 2023 06:31:55 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 607CD1FD5;
	Sat,  3 Jun 2023 06:31:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B1B3DC433EF;
	Sat,  3 Jun 2023 06:31:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685773914;
	bh=J+zA804W5CIwsPp0or882YYvzsNBrtmFTxO6nzeLnX8=;
	h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
	b=SHDkU7kq/KrmiEpWpi7l98MFYWy6DaL0yq+G2B4JGU23T+K1SXlLTl8YVCUnWo+cR
	 PqiU4QEcgwIWKejnYe7IcIY//bVe62Vq44GTjD7A48Thl3fDfYwMsyRtj3vscbMJwi
	 w8GiiXkHtWX4x9wo/0FwgRUBNAMcgcJktrecE8sBvdDsPXXz8i9P3iRqghIosT20Fy
	 6dFAvjuWBgef6sVzTolUHHr5f/B6xp4e7Oon4oeUOtr3YdPDirDqUwcooJXGXnUUSF
	 c8oUvo2iRL8VMEzen/Ek3Wq6dMCHEyTbuivndIC06sY3QHNiIco8aqwAXgqf+wQ4Ja
	 99KOF/L+8SYzg==
Date: Fri, 2 Jun 2023 23:31:52 -0700
From: Jakub Kicinski <kuba@kernel.org>
To: Xuan Zhuo <xuanzhuo@linux.alibaba.com>
Cc: virtualization@lists.linux-foundation.org, "Michael S. Tsirkin"
 <mst@redhat.com>, Jason Wang <jasowang@redhat.com>, "David S. Miller"
 <davem@davemloft.net>, Eric Dumazet <edumazet@google.com>, Paolo Abeni
 <pabeni@redhat.com>, Alexei Starovoitov <ast@kernel.org>, Daniel Borkmann
 <daniel@iogearbox.net>, Jesper Dangaard Brouer <hawk@kernel.org>, John
 Fastabend <john.fastabend@gmail.com>, netdev@vger.kernel.org,
 bpf@vger.kernel.org
Subject: Re: [PATCH vhost v10 10/10] virtio_net: support dma premapped
Message-ID: <20230602233152.4d9b9ba4@kernel.org>
In-Reply-To: <20230602092206.50108-11-xuanzhuo@linux.alibaba.com>
References: <20230602092206.50108-1-xuanzhuo@linux.alibaba.com>
	<20230602092206.50108-11-xuanzhuo@linux.alibaba.com>
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit

On Fri,  2 Jun 2023 17:22:06 +0800 Xuan Zhuo wrote:
>  drivers/net/virtio_net.c | 163 +++++++++++++++++++++++++++++++++------

ack for this going via the vhost tree, FWIW, but you'll potentially
need to wait for the merge window to move forward with the actual
af xdp patches, in this case.

