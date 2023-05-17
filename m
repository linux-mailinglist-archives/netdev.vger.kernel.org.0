Return-Path: <netdev+bounces-3241-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 1A47A7062DF
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:30:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9DEE281341
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 08:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 332CB5253;
	Wed, 17 May 2023 08:30:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB06A171B3
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 907FFC433EF;
	Wed, 17 May 2023 08:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684312220;
	bh=dRnBvoqZHdom1kemk8r+9ogry3jEW8Gqxag8ZiISorQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=tmO9GGLkjyf5T/Gp5TEaDoUVrnjdWiQ8eC6kL6TnDlt9XiL/57Us/k1bPHo1V8A5q
	 kTUhLxAJH+dbUFKaEUZ4Ezh3ZdViEfI1ScJT1XtJ/84s60kZlxxzgzX8FRt9mkQ0zE
	 4bqEs6rTg0BQjuK8e5QguweMG56zuSqp9O0Ow/WxSlWMsaow1SJB1gYWKOwJV/tOtP
	 EoMYAORvjWOVtQeyo+4nPOWw/eCr5ZHcnlmdsxfhJoBgGtTVK/QpUg6e52MJgHPjf8
	 IeSarqP/51IPR/s95NFimj9k8nAgJ3ICMjmnv0GIOMG5dWMZvSouoX+FJ8tKCZr7is
	 2o7uvpn8kptZQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 74F31C41672;
	Wed, 17 May 2023 08:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/3][pull request] Intel Wired LAN Driver Updates
 2023-05-16
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168431222046.29655.11286696607461346863.git-patchwork-notify@kernel.org>
Date: Wed, 17 May 2023 08:30:20 +0000
References: <20230516173610.2706835-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230516173610.2706835-1-anthony.l.nguyen@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org, leonro@nvidia.com

Hello:

This series was applied to netdev/net.git (main)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 16 May 2023 10:36:07 -0700 you wrote:
> This series contains updates to ice and iavf drivers.
> 
> Ahmed adds setting of missed condition for statistics which caused
> incorrect reporting of values for ice. For iavf, he removes a call to set
> VLAN offloads during re-initialization which can cause incorrect values
> to be set.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/3] ice: Fix stats after PF reset
    https://git.kernel.org/netdev/net/c/ab7470bc6d8f
  - [net,v2,2/3] ice: Fix ice VF reset during iavf initialization
    https://git.kernel.org/netdev/net/c/7255355a0636
  - [net,v2,3/3] iavf: send VLAN offloading caps once after VFR
    https://git.kernel.org/netdev/net/c/7dcbdf29282f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



