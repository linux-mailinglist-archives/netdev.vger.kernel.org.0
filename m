Return-Path: <netdev+bounces-4063-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 7444570A5D5
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 08:00:37 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 643F71C20D2C
	for <lists+netdev@lfdr.de>; Sat, 20 May 2023 06:00:34 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2ADB381F;
	Sat, 20 May 2023 06:00:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C808C808
	for <netdev@vger.kernel.org>; Sat, 20 May 2023 06:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5D0E8C433A1;
	Sat, 20 May 2023 06:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684562423;
	bh=0EJD5dZPqAQJwNl/DUgGghqUZqPspoQI781Vn+pJfYM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=luh9RA1Ru7k2gm1P08YOS3XmEookL/KuHO6Y3GdWjPF9K6OSwWcAiM9zIsqtx3dtL
	 W81glSgSPvRrOwB1QgmZCKyNauRmikWJkTYXEcIvQDKdCxjIUVh8uI4Qv/DdyJdMfZ
	 cEFP42mihcV3/Gba+zatzXkdLvJs4a5qYumZEDeZJMPVxkrPPsCwRpphdxHJH4DnAp
	 ElSHn/tlAMjT9Cm86903hMfkd07xe24SmtyORRxYZrrEfIxxz8JN/8mge+A1CjG7G7
	 EPffqAg8sMRzQAxcWkUe/BAmGIvZSawGPdZ2EvVm2aDaj/CGafnZBli87g5GcQCEUt
	 cjX/SWRv558fw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 41EAFE5421C;
	Sat, 20 May 2023 06:00:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: bluetooth 2023-05-19
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168456242326.5388.6120665288365455777.git-patchwork-notify@kernel.org>
Date: Sat, 20 May 2023 06:00:23 +0000
References: <20230519233056.2024340-1-luiz.dentz@gmail.com>
In-Reply-To: <20230519233056.2024340-1-luiz.dentz@gmail.com>
To: Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc: davem@davemloft.net, kuba@kernel.org, linux-bluetooth@vger.kernel.org,
 netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 19 May 2023 16:30:56 -0700 you wrote:
> The following changes since commit 9025944fddfed5966c8f102f1fe921ab3aee2c12:
> 
>   net: fec: add dma_wmb to ensure correct descriptor values (2023-05-19 09:17:53 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2023-05-19
> 
> [...]

Here is the summary with links:
  - pull-request: bluetooth 2023-05-19
    https://git.kernel.org/netdev/net/c/67caf26d769e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



