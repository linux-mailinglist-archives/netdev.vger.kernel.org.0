Return-Path: <netdev+bounces-112-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 03FBB6F5302
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 10:21:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id EB7CE1C20CD0
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 08:21:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 997297461;
	Wed,  3 May 2023 08:20:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A718F7479
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 08:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 511AFC433A8;
	Wed,  3 May 2023 08:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683102021;
	bh=CBJq3Qzo+gYBYgEF8sVTwgX58FN6xQObhBg8mYl13L8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=oIwZEv0n6JHcZsjmG2XJ6JdFVGrG05haHcFj8KKiO29+q41QaS3gc5kJAKg8p7eM9
	 7Owgy8rtkvvwAcWST5jLpOFmXlSoQrcOnyh868zcSHVwDT278vNGzsBmhyhJe9iack
	 6Bz7orVCXa13Rbg9s1HeyLdQB0Xz72Bnglrq/H6+SIwSnxZ8RgWAkyiizokYK1PK0g
	 kDbzXnEwVFY9UbJMiZtxEUsH82s+W00AOJGR6DclqmX//Md5/3j1bX/elqd5qpyLna
	 o6HAfyZSIJftCNo9HvJUGdp7fAXZ3R3z8E+A0UxsJM5hy/82zQh5Gh3fTRZvkABs6i
	 PA6hCAAFhaPqQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3C10CC395C8;
	Wed,  3 May 2023 08:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] ethtool: Fix uninitialized number of lanes
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168310202124.22454.13945309263384603671.git-patchwork-notify@kernel.org>
Date: Wed, 03 May 2023 08:20:21 +0000
References: <20230502122050.917205-1-idosch@nvidia.com>
In-Reply-To: <20230502122050.917205-1-idosch@nvidia.com>
To: Ido Schimmel <idosch@nvidia.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
 pabeni@redhat.com, edumazet@google.com, danieller@nvidia.com,
 mlxsw@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue,  2 May 2023 15:20:50 +0300 you wrote:
> It is not possible to set the number of lanes when setting link modes
> using the legacy IOCTL ethtool interface. Since 'struct
> ethtool_link_ksettings' is not initialized in this path, drivers receive
> an uninitialized number of lanes in 'struct
> ethtool_link_ksettings::lanes'.
> 
> When this information is later queried from drivers, it results in the
> ethtool code making decisions based on uninitialized memory, leading to
> the following KMSAN splat [1]. In practice, this most likely only
> happens with the tun driver that simply returns whatever it got in the
> set operation.
> 
> [...]

Here is the summary with links:
  - [net] ethtool: Fix uninitialized number of lanes
    https://git.kernel.org/netdev/net/c/9ad685dbfe7e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



