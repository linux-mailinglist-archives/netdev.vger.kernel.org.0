Return-Path: <netdev+bounces-3245-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 0580570631B
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 10:40:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B3CCF1C20E1A
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 08:40:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B2D6E4418;
	Wed, 17 May 2023 08:40:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4F6D864C
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 08:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E62C8C433D2;
	Wed, 17 May 2023 08:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684312820;
	bh=CetRLm/szK5PDpfF8j3cFi0OKGdJ0rA7kYaS9hPuWLk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=QNiK5OzKdckLRSzxsVVwLTVpW6xPodsx+yDFnUnGIFWUhVm0DTwzYnGiaeEWCgRUU
	 PuLrNjkaJQHZJuqiS328jC6VKxk3bIpgfxu38g/RVVku7ueZNJnFAP1O6xiG1xVe1c
	 +5QU4qRdm1fxFwb8WVOTI2C2WuqwCRe3XQAlJidosrVbJ2p+4tcdOpYIDxYZCkzfnD
	 /usxDabLgNGXGPw6byW+1qO9Q6dH5ygPSwWd9josThAi1YZdpxa9p2ZFCbYIvFw/k+
	 7DZXREHd5YG3UVeTU9/vpi2ngHLGTi9Wmk9vFcrLqxC/2cOzP5jlhJZcyHoL4PQ9fJ
	 NoSgXKkZ8yo0g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C5A4BC41672;
	Wed, 17 May 2023 08:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mailmap: add entries for Nikolay Aleksandrov
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168431281980.4168.6312097734867233658.git-patchwork-notify@kernel.org>
Date: Wed, 17 May 2023 08:40:19 +0000
References: <20230516084849.2165114-1-razor@blackwall.org>
In-Reply-To: <20230516084849.2165114-1-razor@blackwall.org>
To: Nikolay Aleksandrov <razor@blackwall.org>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 16 May 2023 11:48:49 +0300 you wrote:
> Turns out I missed a few patches due to use of old addresses by
> senders. Add a mailmap entry with my old addresses.
> 
> Signed-off-by: Nikolay Aleksandrov <razor@blackwall.org>
> ---
>  .mailmap | 5 +++++
>  1 file changed, 5 insertions(+)

Here is the summary with links:
  - [net] mailmap: add entries for Nikolay Aleksandrov
    https://git.kernel.org/netdev/net/c/66353baf3762

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



