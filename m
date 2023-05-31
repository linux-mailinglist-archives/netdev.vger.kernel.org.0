Return-Path: <netdev+bounces-6740-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 2233C717B68
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 11:11:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id B22EA1C20DE7
	for <lists+netdev@lfdr.de>; Wed, 31 May 2023 09:11:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id EC03912B98;
	Wed, 31 May 2023 09:10:30 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D1008C156
	for <netdev@vger.kernel.org>; Wed, 31 May 2023 09:10:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 889A9C433AA;
	Wed, 31 May 2023 09:10:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685524226;
	bh=iPO7fk89K1ZuBvv86QC5wK9zC9hBqJYur6LEHeduffI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=WQHXiUIglXWfF0cnjmMW1O3ov+KDXyE6h7leKpFT90Ph76BO8/Z3n4JPBx2nfmjFF
	 AoyP+1yflVqB23B4VDg19Upvn+pxl1t/YvhrlTK7KwfVCqH+0oib77GA3u4Y9ouQJY
	 SLI7dQmEZUHQKXXjd0fjx02x+kPsft5t3SJK5wxmcf8qYeM/0nCWtSDYrof+hPwUla
	 Xp5NupmjzHYnHelpidqGBkHzCIL67Cg0e7uMmzLLpn3keXDMP4vOU6jhOVgkq6xkK3
	 utpKLW2vaT30gKf316qWYXgnYo1U2J2DissN5zgbHWXRgs5uHAr4DJXG2juZt19qdG
	 KXREMSe4kztDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 685A7E52BF3;
	Wed, 31 May 2023 09:10:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: Make gro complete function to return void
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168552422642.12579.2690995399341266823.git-patchwork-notify@kernel.org>
Date: Wed, 31 May 2023 09:10:26 +0000
References: <20230529134430.492879-1-parav@nvidia.com>
In-Reply-To: <20230529134430.492879-1-parav@nvidia.com>
To: Parav Pandit <parav@nvidia.com>
Cc: edumazet@google.com, davem@davemloft.net, kuba@kernel.org,
 pabeni@redhat.com, dsahern@kernel.org, netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 29 May 2023 16:44:30 +0300 you wrote:
> tcp_gro_complete() function only updates the skb fields related to GRO
> and it always returns zero. All the 3 drivers which are using it
> do not check for the return value either.
> 
> Change it to return void instead which simplifies its callers as
> error handing becomes unnecessary.
> 
> [...]

Here is the summary with links:
  - [net-next] net: Make gro complete function to return void
    https://git.kernel.org/netdev/net-next/c/b1f2abcf817d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



