Return-Path: <netdev+bounces-6541-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2A305716DC1
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 21:40:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5DAF228130F
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 19:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A16192D268;
	Tue, 30 May 2023 19:40:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 08DA9200AD
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 19:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ABFD7C4339B;
	Tue, 30 May 2023 19:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685475619;
	bh=jWONL33WEqH+PxYjePv/E3ZVN10jwVT8QvIE9IZGua0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=amDIx+DGM9JvMDyLNigvbzwAASh5Isk3PZVdD+z2qchW6fbsfUiiwDXVKrvA3hsAr
	 pRuCvicScGuWVTFEkIamXKVOJUJ8oLc4tfZv1obD6hUFEfMeNMMEOmZVR5KFZljdEf
	 qcO0KNPhunrS3h4DteKy4aYy96wcsUMPLSESeCcb0/GbRobZT8Mazo7KASsoYyr58n
	 KJDH8zCx0XxVvgI8vFCp5Eh8WX0GGLwG+YSadnxT37rgZVUq7j6qnKD2PKh3Ft/iia
	 7lOodPQH1RNUkUYbrhxHMRR7g9GIarCRrN+kh+1NGlUWmGkPHHzqD4qGuxNOjNBeQ2
	 +cgMd7NBHfhnw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8C15AE52BF5;
	Tue, 30 May 2023 19:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2 v4 0/2] vxlan: option printing
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168547561956.17778.5053424187290301776.git-patchwork-notify@kernel.org>
Date: Tue, 30 May 2023 19:40:19 +0000
References: <20230526174141.5972-1-stephen@networkplumber.org>
In-Reply-To: <20230526174141.5972-1-stephen@networkplumber.org>
To: Stephen Hemminger <stephen@networkplumber.org>
Cc: netdev@vger.kernel.org

Hello:

This series was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Fri, 26 May 2023 10:41:39 -0700 you wrote:
> This patchset makes printing of vxlan details more consistent.
> It also adds extra verbose output. The boolean options
> are now brinted after all the non-boolean options.
> 
> Before:
> $ ip -d link show dev vxlan0
> 4: vxlan0: <BROADCAST,MULTICAST> mtu 1450 qdisc noop state DOWN mode DEFAULT group default qlen 1000
>     link/ether e6:a4:54:b2:34:85 brd ff:ff:ff:ff:ff:ff promiscuity 0  allmulti 0 minmtu 68 maxmtu 65535
>     vxlan id 42 group 239.1.1.1 dev enp2s0 srcport 0 0 dstport 4789 ttl auto ageing 300 udpcsum noudp6zerocsumtx noudp6zerocsumrx addrgenmode eui64 numtxqueues 1 numrxqueues 1 gso_max_size 64000 gso_max_segs 64 tso_max_size 64000 tso_max_segs 64 gro_max_size 65536
> 
> [...]

Here is the summary with links:
  - [iproute2,v4,1/2] vxlan: use print_nll for gbp and gpe
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=a183eba71bc2
  - [iproute2,v4,2/2] vxlan: make option printing more consistent
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



