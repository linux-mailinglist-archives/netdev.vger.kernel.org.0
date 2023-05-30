Return-Path: <netdev+bounces-6511-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 1C50D716BC1
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 20:00:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id CB50028105E
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 18:00:26 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 08B072A9C9;
	Tue, 30 May 2023 18:00:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 8563C1EA76
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 18:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 25B6AC4339E;
	Tue, 30 May 2023 18:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685469623;
	bh=xq7m8rI304dRcUpNXWSqhQOmb8B3Oo0mAKgRfkGMRd4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=M1IMcQyqfsPUbcf7XE91NhOYesUFd393VvO7aivplpRc10iS9sTlnypnAhNotzfOP
	 m8Q3WbFpzI8GBytMSBxAS8zDU2EZaiDE/FSJn94snun/MboP4J718P2ONBJNyW9/p8
	 ae+M4wE0Z/tk/hUzJwjP2bu/tXWlkXOHz2JSk2jwqWecphZRTTKhtom/aVrNADIO4o
	 I7jJk88mhPJyAnxFouGSYQShSEZOv3MAnoTCz2KOH/xovOu7Peabq8pbb1qsVrJOz/
	 hg9W2Bw6zJD0HH93xSxMxKMLDnnof6AZ92NotuWonCmysRDuLKy7XCUp+8uKnw3KG/
	 /g3ZPnLRLW/kA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E56F8E52C11;
	Tue, 30 May 2023 18:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next v2 00/15] devlink: move port ops into separate
 structure
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168546962293.29160.17316375243648056499.git-patchwork-notify@kernel.org>
Date: Tue, 30 May 2023 18:00:22 +0000
References: <20230526102841.2226553-1-jiri@resnulli.us>
In-Reply-To: <20230526102841.2226553-1-jiri@resnulli.us>
To: Jiri Pirko <jiri@resnulli.us>
Cc: netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com,
 davem@davemloft.net, edumazet@google.com, leon@kernel.org, saeedm@nvidia.com,
 moshe@nvidia.com, jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
 tariqt@nvidia.com, idosch@nvidia.com, petrm@nvidia.com,
 simon.horman@corigine.com, ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
 michal.wilczynski@intel.com, jacob.e.keller@intel.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 26 May 2023 12:28:26 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> In devlink, some of the objects have separate ops registered alongside
> with the object itself. Port however have ops in devlink_ops structure.
> For drivers what register multiple kinds of ports with different ops
> this is not convenient.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/15] devlink: introduce port ops placeholder
    https://git.kernel.org/netdev/net-next/c/6acdf43d8abe
  - [net-next,v2,02/15] ice: register devlink port for PF with ops
    https://git.kernel.org/netdev/net-next/c/b2857685372b
  - [net-next,v2,03/15] mlxsw_core: register devlink port with ops
    https://git.kernel.org/netdev/net-next/c/865a1a1b97b6
  - [net-next,v2,04/15] nfp: devlink: register devlink port with ops
    https://git.kernel.org/netdev/net-next/c/ab8ccc6c1347
  - [net-next,v2,05/15] devlink: move port_split/unsplit() ops into devlink_port_ops
    https://git.kernel.org/netdev/net-next/c/f58a3e4dfe24
  - [net-next,v2,06/15] mlx4: register devlink port with ops
    https://git.kernel.org/netdev/net-next/c/8a756d91d26c
  - [net-next,v2,07/15] devlink: move port_type_set() op into devlink_port_ops
    https://git.kernel.org/netdev/net-next/c/65a4c44bf937
  - [net-next,v2,08/15] sfc: register devlink port with ops
    https://git.kernel.org/netdev/net-next/c/7bfb3d0a83b6
  - [net-next,v2,09/15] mlx5: register devlink ports with ops
    https://git.kernel.org/netdev/net-next/c/aa3aff8264f2
  - [net-next,v2,10/15] devlink: move port_fn_hw_addr_get/set() to devlink_port_ops
    https://git.kernel.org/netdev/net-next/c/71c93e37cf3d
  - [net-next,v2,11/15] devlink: move port_fn_roce_get/set() to devlink_port_ops
    https://git.kernel.org/netdev/net-next/c/933c13275c49
  - [net-next,v2,12/15] devlink: move port_fn_migratable_get/set() to devlink_port_ops
    https://git.kernel.org/netdev/net-next/c/4a490d7154b3
  - [net-next,v2,13/15] devlink: move port_fn_state_get/set() to devlink_port_ops
    https://git.kernel.org/netdev/net-next/c/216aa67f3e98
  - [net-next,v2,14/15] devlink: move port_del() to devlink_port_ops
    https://git.kernel.org/netdev/net-next/c/216ba9f4adc8
  - [net-next,v2,15/15] devlink: save devlink_port_ops into a variable in devlink_port_function_validate()
    https://git.kernel.org/netdev/net-next/c/4b5ed2b5a145

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



