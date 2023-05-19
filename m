Return-Path: <netdev+bounces-3839-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 28D97709120
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 10:01:09 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D5B01281BD0
	for <lists+netdev@lfdr.de>; Fri, 19 May 2023 08:01:07 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A8DA95670;
	Fri, 19 May 2023 08:00:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7285C2105
	for <netdev@vger.kernel.org>; Fri, 19 May 2023 08:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 155FAC433A8;
	Fri, 19 May 2023 08:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684483221;
	bh=ajoz+QZt/V+ZvhtJXnyHxpX9YnvE/OWqqChV7pmYZvg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=J32+wSR50YlFG8rxuMKXbmNKp7ETUsiU4FKU0tuJdnB3bYZrJwN0g7MqTlVzjgplf
	 7SbF0lWAi68TjnGWvQ8NyKW40Xhl4OgWQyEpJ9N1mPCzN9LyPLkwLdLxLYeFF+5qYe
	 5BhCG46As+VMApWq2T8l6dDGECYJlM3DfphWwXy1byQHzS4rgIigkJ56RSy1zNXDei
	 iJtez8hJnqxECXzQLDpgMc7nFHuUWPxeqw6D7Ma4ucTE1tc01yJkhLYH46MPAidwn8
	 d8gGdsNz0vrEmN/+XfKuXnhgYguobe8IARKKo+FovlH4dV/QvKDod+DuNt/h6wsNMN
	 /eTCWejexWzyw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D5C46E21EFE;
	Fri, 19 May 2023 08:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] sfc: fix devlink info error handling
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168448322087.32188.2506975752365071338.git-patchwork-notify@kernel.org>
Date: Fri, 19 May 2023 08:00:20 +0000
References: <20230518054822.20242-1-alejandro.lucero-palau@amd.com>
In-Reply-To: <20230518054822.20242-1-alejandro.lucero-palau@amd.com>
To: Lucero@codeaurora.org, Palau@codeaurora.org,
	Alejandro <alejandro.lucero-palau@amd.com>
Cc: netdev@vger.kernel.org, linux-net-drivers@amd.com, davem@davemloft.net,
 kuba@kernel.org, pabeni@redhat.com, edumazet@google.com,
 martin.habets@amd.com, edward.cree@amd.com, linux-doc@vger.kernel.org,
 corbet@lwn.net, jiri@nvidia.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 May 2023 06:48:22 +0100 you wrote:
> From: Alejandro Lucero <alejandro.lucero-palau@amd.com>
> 
> Avoid early devlink info return if errors arise with MCDI commands
> executed for getting the required info from the device. The rationale
> is some commands can fail but later ones could still give useful data.
> Moreover, some nvram partitions could not be present which needs to be
> handled as a non error.
> 
> [...]

Here is the summary with links:
  - [net] sfc: fix devlink info error handling
    https://git.kernel.org/netdev/net/c/cfcb942863f6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



