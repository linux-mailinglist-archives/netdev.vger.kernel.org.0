Return-Path: <netdev+bounces-10689-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A7BAB72FC75
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 13:30:34 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68688281302
	for <lists+netdev@lfdr.de>; Wed, 14 Jun 2023 11:30:33 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DA49979D5;
	Wed, 14 Jun 2023 11:30:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 73A0B8463
	for <netdev@vger.kernel.org>; Wed, 14 Jun 2023 11:30:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EF61AC433C9;
	Wed, 14 Jun 2023 11:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686742223;
	bh=rW9RjcKDiFRKHUziP2VDCMl746XBXrkMotKpHtxqTnM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=tXBOce/Zkhxyyv4hqxDqjZ+0faudqdNIEIAswXw1K/EOzow0MQY1REfmbvMlBC95P
	 O8kAu4bTMUmLqCWpAmEEsW9AzbkStKNkzQNQJYyZJ7OJtvpkqdIIZO+MESSyYfnP8X
	 W86XQM0Oj+ZIRW8Ej+uu5IwGcfmiDT0hTifFtiiL6hyyNskifTN8kLgihtPWZE+oDf
	 v/ixCB7wFepqR/M6zs3/lUJSudtH7qrTQlX9p15Id225+qx7vRyLzU4lX/DVaIqxJm
	 IUzc6b+YUX3SYuQUib/faJ5aBlBTM7fm48v7nm55+pmYXwzBYHqiBEgMWBkxjw7PDG
	 6yBUCLM2GKMOg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CC8DAC3274B;
	Wed, 14 Jun 2023 11:30:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10] mlxsw: Preparations for
 out-of-order-operations patches
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168674222282.23990.8151831714077509932.git-patchwork-notify@kernel.org>
Date: Wed, 14 Jun 2023 11:30:22 +0000
References: <cover.1686581444.git.petrm@nvidia.com>
In-Reply-To: <cover.1686581444.git.petrm@nvidia.com>
To: Petr Machata <petrm@nvidia.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, idosch@nvidia.com,
 amcohen@nvidia.com, mlxsw@nvidia.com

Hello:

This series was applied to netdev/net-next.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 12 Jun 2023 17:30:59 +0200 you wrote:
> The mlxsw driver currently makes the assumption that the user applies
> configuration in a bottom-up manner. Thus netdevices need to be added to
> the bridge before IP addresses are configured on that bridge or SVI added
> on top of it. Enslaving a netdevice to another netdevice that already has
> uppers is in fact forbidden by mlxsw for this reason. Despite this safety,
> it is rather easy to get into situations where the offloaded configuration
> is just plain wrong.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] mlxsw: spectrum_router: Extract a helper from mlxsw_sp_port_vlan_router_join()
    https://git.kernel.org/netdev/net-next/c/e0db883b6949
  - [net-next,02/10] mlxsw: spectrum_router: Add a helper specifically for joining a LAG
    https://git.kernel.org/netdev/net-next/c/76962b802efe
  - [net-next,03/10] mlxsw: spectrum_router: Access rif->dev through a helper
    https://git.kernel.org/netdev/net-next/c/fb6ac45e8666
  - [net-next,04/10] mlxsw: spectrum_router: Access rif->dev from params in mlxsw_sp_rif_create()
    https://git.kernel.org/netdev/net-next/c/2019b5eeae2a
  - [net-next,05/10] mlxsw: spectrum_router: Access nh->rif->dev through a helper
    https://git.kernel.org/netdev/net-next/c/69f4ba177d6b
  - [net-next,06/10] mlxsw: spectrum_router: Access nhgi->rif through a helper
    https://git.kernel.org/netdev/net-next/c/532b6e2bbc19
  - [net-next,07/10] mlxsw: spectrum_router: Extract a helper to free a RIF
    https://git.kernel.org/netdev/net-next/c/571c56911b45
  - [net-next,08/10] mlxsw: spectrum_router: Add a helper to check if netdev has addresses
    (no matching commit)
  - [net-next,09/10] mlxsw: spectrum_router: Extract a helper for RIF migration
    https://git.kernel.org/netdev/net-next/c/440273e763f5
  - [net-next,10/10] mlxsw: spectrum_router: Move IPIP init up
    https://git.kernel.org/netdev/net-next/c/d4a37bf0943d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



