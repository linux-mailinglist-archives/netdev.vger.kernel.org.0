Return-Path: <netdev+bounces-6990-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 13C61719270
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 07:41:20 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C2A40281613
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 05:41:18 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1D1E86FAD;
	Thu,  1 Jun 2023 05:40:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C80D36FAE
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 05:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 51C0CC4339E;
	Thu,  1 Jun 2023 05:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685598021;
	bh=C4BGuPyakxBBukf5sp3y//G5VLw46F2ig/1RK57Vios=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=OP2yLzc5f07YhNC0OdzhNacR8AVmY2PaWFFu9V/xDL7c1zLy+UU9qPLeQ1uLDc+ln
	 RyULGNs+cFwfNjeD4+RbA+gTdpDEi79jWTCG9EUdfVD5TZyhTMPTcnqQLq593a5M0Q
	 uqpystJbIFWBSwgBSMQFvT+kFKLqLxT0qjFkmYuetKiw3Bh1cDmDJ/n7sVlPzmuI6y
	 mmHay5tSCz0b5WLrRi7e8KYoFeuh48h7zI7QYbZSEsEPgBaj4FBK+37pYloXSXrM7q
	 pc1XTtp3Aokz0Bl5EPsMBylV8v977579dvJ6OLgWygoaYtgxwSctGaJwHxJfvGSdEl
	 TjpV/lKo8NbfA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2BCF4C395F0;
	Thu,  1 Jun 2023 05:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] devlink: make health report on unregistered instance
 warn just once
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168559802117.10778.5926262727222751655.git-patchwork-notify@kernel.org>
Date: Thu, 01 Jun 2023 05:40:21 +0000
References: <20230531015523.48961-1-kuba@kernel.org>
In-Reply-To: <20230531015523.48961-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, jiri@resnulli.us

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 30 May 2023 18:55:23 -0700 you wrote:
> Devlink health is involved in error recovery. Machines in bad
> state tend to be fairly unreliable, and occasionally get stuck
> in error loops. Even with a reasonable grace period devlink health
> may get a thousand reports in an hour.
> 
> In case of reporting on an unregistered devlink instance
> the subsequent reports don't add much value. Switch to
> WARN_ON_ONCE() to avoid flooding dmesg and fleet monitoring
> dashboards.
> 
> [...]

Here is the summary with links:
  - [net-next] devlink: make health report on unregistered instance warn just once
    https://git.kernel.org/netdev/net-next/c/6f4b98147b8d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



