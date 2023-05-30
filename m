Return-Path: <netdev+bounces-6234-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 2C90D7154BF
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:11:02 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id DA34428103B
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 05:11:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0D1813D74;
	Tue, 30 May 2023 05:10:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7BB8246BE
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 05:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F458C4339C;
	Tue, 30 May 2023 05:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685423421;
	bh=pZpXDwCwKFydPJLOC5DKVnInYzqvr1Z0x+0M4uGB9CY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=XNkItbrcLz8ms0M/a+fqWUHayJefCWfGfTz1D+ABqMjnC6ypAMkIQwDWf+Y4An19K
	 cWYdnDqAOSe6VlOrn802dqvIKO+opALQlYuHzggqDZKPAKCwWq6GgP5wHIvQSO+nBk
	 JZgoMvqvEh7xfGSSXx6SWWx70l2+znMJSf7IXX+7d0q000gvvao3f8W+Xq9i3NhfVr
	 xCOg8fTA98uvtjfyhfBRNFszu8O8pjkDytYOSp6pRHmX3ebDSqysyQKnkFogogBX+X
	 +I4+JJUBGprnUWLCqxFKOVl0SNhE7L44cEoSoAThBAZX3Vq+vYQL+Ztxpn/BKG43Gi
	 Wi46nhpv9lm3w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E4C45E52BF7;
	Tue, 30 May 2023 05:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] devlink: Spelling corrections
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168542342093.26777.6363721779418935781.git-patchwork-notify@kernel.org>
Date: Tue, 30 May 2023 05:10:20 +0000
References: <20230526-devlink-spelling-v1-1-9a3e36cdebc8@kernel.org>
In-Reply-To: <20230526-devlink-spelling-v1-1-9a3e36cdebc8@kernel.org>
To: Simon Horman <horms@kernel.org>
Cc: kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
 pabeni@redhat.com, jiri@resnulli.us, netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 26 May 2023 15:45:13 +0200 you wrote:
> Make some minor spelling corrections in comments.
> 
> Found by inspection.
> 
> Signed-off-by: Simon Horman <horms@kernel.org>
> ---
>  include/net/devlink.h  | 2 +-
>  net/devlink/leftover.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] devlink: Spelling corrections
    https://git.kernel.org/netdev/net-next/c/45402f04c582

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



