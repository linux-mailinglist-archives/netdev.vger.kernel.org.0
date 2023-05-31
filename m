Return-Path: <netdev+bounces-6773-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id DDFFC717DB8
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 13:10:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99B8E281424
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 11:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A4D8812B74;
	Wed, 31 May 2023 11:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A5378C8CB;
	Wed, 31 May 2023 11:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 50A5AC4339C;
	Wed, 31 May 2023 11:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685531421;
	bh=T8Q6n/l1L/+GVFPA0YkBgMJ2AUVa+CCuYBZqfpHD+bs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=hSEPmdPrT5pnV3Y5QQlXnyZfPnSRo+aac029iiOHeTCvB6RzcyAoCvjAkcMibUtxd
	 zvm9dIcbWZbThoCKFfEBUgzhZEg+NFpionTBvVGL9Zbp/6tjXFLYXJocoCe308GtUY
	 mrm0Vo/61vHXUE54SUhh0ZEsFM0xsOE4gMh2gtWEFcvI1wROp1UQd3eFdUv5sQI/KO
	 VytsQIHLHfSy2cIWUxB2PO0GO/h5m4217LYP+D0MdA4CyWl+YZ0ljuGx40KVHXREWa
	 bCbaru3Y8XpH3bk2pF2bvaCGskjpDVTCFzE69V573HZCa5iEnpisx6OpKzqtwXl4Im
	 zp/fLtsNi2BGg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2DCA5E52BF3;
	Wed, 31 May 2023 11:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] samples/bpf: xdp1 and xdp2 reduce XDPBUFSIZE to 60
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168553142118.8778.13734140798263621950.git-patchwork-notify@kernel.org>
Date: Wed, 31 May 2023 11:10:21 +0000
References: <168545704139.2996228.2516528552939485216.stgit@firesoul>
In-Reply-To: <168545704139.2996228.2516528552939485216.stgit@firesoul>
To: Jesper Dangaard Brouer <brouer@redhat.com>
Cc: ttoukan.linux@gmail.com, borkmann@iogearbox.net, ast@kernel.org,
 andrii.nakryiko@gmail.com, bpf@vger.kernel.org, tariqt@nvidia.com,
 gal@nvidia.com, lorenzo@kernel.org, netdev@vger.kernel.org,
 andrew.gospodarek@broadcom.com

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 30 May 2023 16:30:41 +0200 you wrote:
> Default samples/pktgen scripts send 60 byte packets as hardware
> adds 4-bytes FCS checksum, which fulfils minimum Ethernet 64 bytes
> frame size.
> 
> XDP layer will not necessary have access to the 4-bytes FCS checksum.
> 
> This leads to bpf_xdp_load_bytes() failing as it tries to copy
> 64-bytes from an XDP packet that only have 60-bytes available.
> 
> [...]

Here is the summary with links:
  - [bpf-next] samples/bpf: xdp1 and xdp2 reduce XDPBUFSIZE to 60
    https://git.kernel.org/bpf/bpf-next/c/60548b825b08

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



