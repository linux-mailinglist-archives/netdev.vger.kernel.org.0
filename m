Return-Path: <netdev+bounces-4847-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 65BD370EBF5
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 05:41:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DB254281161
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 03:40:59 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id F2C00EC2;
	Wed, 24 May 2023 03:40:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7C05E15B3
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 03:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 31FEEC433AC;
	Wed, 24 May 2023 03:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684899620;
	bh=aExXT1OVy+LMeONxgVg6Xk0W224b39Oj+2KPQikjkas=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=UWV+bxGt9zLVgkvN3VlYItLEjKPy71Dfk3vUJjJpsgSYjSAixjuJ9lQ3LIOsJxIgq
	 IBrGnEMi+YTEGOej3r8UMFcJKazW3ko3950wM7YaX4woTgXwRdHJo+m0GC+3TmI1ag
	 fkYCHigNnLbyLBlxtp24PvmZhF4zXJxE2X+XnW8ER27vrfykRKVA82MD13QuBXNoft
	 S/2qAgifYwcsKPMkdsLDCQfeDBPhEHkcu45mRsuJpiTD3avHaotrRI373IIWJusC9I
	 0z/0Yxya1eGOc+0RmZ03XFGkSqTCVWEM4Mc+2lzFi0AjJB9gmURW6IBEyjKc5IzwSA
	 jdZIQbiDqz5zw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 12CA8E21ECF;
	Wed, 24 May 2023 03:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] nfp: add L4 RSS hashing on UDP traffic
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168489962007.3716.10267854807151239349.git-patchwork-notify@kernel.org>
Date: Wed, 24 May 2023 03:40:20 +0000
References: <20230522141335.22536-1-louis.peens@corigine.com>
In-Reply-To: <20230522141335.22536-1-louis.peens@corigine.com>
To: Louis Peens <louis.peens@corigine.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 simon.horman@corigine.com, netdev@vger.kernel.org, oss-drivers@corigine.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 22 May 2023 16:13:35 +0200 you wrote:
> From: Jaco Coetzee <jaco.coetzee@corigine.com>
> 
> Add layer 4 RSS hashing on UDP traffic to allow for the
> utilization of multiple queues for multiple connections on
> the same IP address.
> 
> Previously, since the introduction of the driver, RSS hashing
> was only performed on the source and destination IP addresses
> of UDP packets thereby limiting UDP traffic to a single queue
> for multiple connections on the same IP address. The transport
> layer is now included in RSS hashing for UDP traffic, which
> was not previously the case. The reason behind the previous
> limitation is unclear - either a historic limitation of the
> NFP device, or an oversight.
> 
> [...]

Here is the summary with links:
  - [net-next] nfp: add L4 RSS hashing on UDP traffic
    https://git.kernel.org/netdev/net-next/c/57910a47ffe9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



