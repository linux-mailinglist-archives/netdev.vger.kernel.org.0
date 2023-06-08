Return-Path: <netdev+bounces-9129-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 58A3372766F
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 07:00:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 694221C20EFE
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 05:00:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3B7FA46B2;
	Thu,  8 Jun 2023 05:00:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9263346AD
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 05:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F3410C4339B;
	Thu,  8 Jun 2023 05:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686200423;
	bh=mzmgiLFmkgzd7p7jgtW9UVDwTKkjPyYrTnk96ur9iT8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=DB8j62jOoSmAvFv6nD5wOoZZ6LzC/1nOuv3zCUEnFn/1jRkQPu71wDT5F3tqiy6gc
	 9tWykryIdAXXwKfhBIWI87RXfZ4gVSpJe793XY9RlpEwLiIz5lplXihIyPRs7XswxC
	 OVpfPhegf3ebmQ4+AWDg3t1oePvfOeRr2wGA0kYtrGERiMLZ12CVa3jK8J/lNgl+6i
	 yYotOK8XEgWMNOfToOeDwISkSQkeo5LXVFrVyO4DT13gFcp8BJMO3mq2bZzcBTgyY7
	 0iGWGImX8+3x7oIVCbfHQN1iAwP+EjuUplbmDhVKEK/1fpBrv6tc75yUmKG8dTF/YJ
	 DqRakDx8JHdFg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D4804E49FA3;
	Thu,  8 Jun 2023 05:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] eth: bnxt: fix the wake condition
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168620042286.23382.12101004657888061395.git-patchwork-notify@kernel.org>
Date: Thu, 08 Jun 2023 05:00:22 +0000
References: <20230607010826.960226-1-kuba@kernel.org>
In-Reply-To: <20230607010826.960226-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, davidhwei@meta.com, michael.chan@broadcom.com

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  6 Jun 2023 18:08:25 -0700 you wrote:
> The down condition should be the negation of the wake condition,
> IOW when I moved it from:
> 
>  if (cond && wake())
> to
>  if (__netif_txq_completed_wake(cond))
> 
> [...]

Here is the summary with links:
  - [net,1/2] eth: bnxt: fix the wake condition
    https://git.kernel.org/netdev/net/c/649c3fed3673
  - [net,2/2] eth: ixgbe: fix the wake condition
    https://git.kernel.org/netdev/net/c/f0d751973f73

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



