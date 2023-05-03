Return-Path: <netdev+bounces-111-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 6D08A6F52FD
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 10:20:31 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0D8F1281070
	for <lists+netdev@lfdr.de>; Wed,  3 May 2023 08:20:30 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 46574748D;
	Wed,  3 May 2023 08:20:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 7FDB97461
	for <netdev@vger.kernel.org>; Wed,  3 May 2023 08:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2FA0DC433D2;
	Wed,  3 May 2023 08:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683102021;
	bh=iBRLUxOOLNDNJJVdCjPD7ZNfD+zJIZUk4GzFTWLqUs8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=PVYEay/UZjdHAp4AUWK8+KJR69U9ycokpfc847p5wW8y6euvymhYIdjErvJwOBaF6
	 8lwRBlGeZGrCUeHxPsy8r+XKWIM2nKMUwyuPMDG10FEzUjPabUL0Qj9X5pxceMKVBT
	 quHh/aOhUTCnyUe7lczgyClbLYpcxHzv3RXBAsjbKVCAY+OkD0H09x2rBcZuy/r5O+
	 4CGDykW7TuAm6HcezGjVympOsWZeY3cZQ/cIWrRAFKjwoJn6K3LtqJEDFC9ihqAdHI
	 zgT3PvTPibyQuxRv1ZZbW+zjchk/vNohyQz2sp020CoDdFPTLBAeL54ozEao9njR7e
	 2QdZtkEOfkNXQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0B928C395FD;
	Wed,  3 May 2023 08:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] r8152: fix the autosuspend doesn't work
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168310202104.22454.6926310039404404080.git-patchwork-notify@kernel.org>
Date: Wed, 03 May 2023 08:20:21 +0000
References: <20230502033627.2795-413-nic_swsd@realtek.com>
In-Reply-To: <20230502033627.2795-413-nic_swsd@realtek.com>
To: Hayes Wang <hayeswang@realtek.com>
Cc: kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
 nic_swsd@realtek.com, linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 2 May 2023 11:36:27 +0800 you wrote:
> Set supports_autosuspend = 1 for the rtl8152_cfgselector_driver.
> 
> Fixes: ec51fbd1b8a2 ("r8152: add USB device driver for config selection")
> Signed-off-by: Hayes Wang <hayeswang@realtek.com>
> ---
>  drivers/net/usb/r8152.c | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net] r8152: fix the autosuspend doesn't work
    https://git.kernel.org/netdev/net/c/0fbd79c01a9a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



