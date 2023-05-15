Return-Path: <netdev+bounces-2539-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DE93770266B
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 09:51:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id E63231C20A75
	for <lists+netdev@lfdr.de>; Mon, 15 May 2023 07:51:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 9C33BA935;
	Mon, 15 May 2023 07:50:27 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D27ED8F53
	for <netdev@vger.kernel.org>; Mon, 15 May 2023 07:50:25 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6FA07C4339C;
	Mon, 15 May 2023 07:50:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684137025;
	bh=BI3T77xUar9pZVGDIG2tFsY5WD9lb09gxS4rHOjoJUE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=iKtybsZIWjY0O165rvuM2n1xr76GoepOMKMjVCQc90zG2sKRUn5HpsGCW3JO9OoJw
	 klgD1GwMA3E9ieO5C86PCUPra0dIm7p3qQ1u0tqzV94t7KB6PPorJP45OSITVk5NSG
	 WL+bAnRERewHM0ghxv8U9r4bvVfQmNdKIXor5wufhHuVqP1vPyH0ZYeU3RGWFJH/cf
	 C9+lKe3WtmfYhfV+U18OWxEw/xDiigjCw03xcBnWYcBWkNelZVfEPP9bGfhjwvMlA/
	 IVVqDkg+1oQS9O7oevoBv851rxBOjIlR6xfNDe5EpnE3MyKwktbsCJgsDbmamWVjqR
	 yL9vqjqaYePtQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4B47BE5421D;
	Mon, 15 May 2023 07:50:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: Remove low_thresh in ip defrag
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168413702530.26935.9409301901790238640.git-patchwork-notify@kernel.org>
Date: Mon, 15 May 2023 07:50:25 +0000
References: <20230512010152.1602-1-angus.chen@jaguarmicro.com>
In-Reply-To: <20230512010152.1602-1-angus.chen@jaguarmicro.com>
To: Angus Chen <angus.chen@jaguarmicro.com>
Cc: davem@davemloft.net, dsahern@kernel.org, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 12 May 2023 09:01:52 +0800 you wrote:
> As low_thresh has no work in fragment reassembles,del it.
> And Mark it deprecated in sysctl Document.
> 
> Signed-off-by: Angus Chen <angus.chen@jaguarmicro.com>
> ---
> 
> v2:
>  Fix some spelling errors,and remove low_thresh from struct fqdir.
>  suggested by Jakub Kicinski <kuba@kernel.org>.
> 
> [...]

Here is the summary with links:
  - [v2] net: Remove low_thresh in ip defrag
    https://git.kernel.org/netdev/net-next/c/b2cbac9b9b28

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



