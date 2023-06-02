Return-Path: <netdev+bounces-7306-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id A7A7871F97F
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 07:00:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66F202819CC
	for <lists+netdev@lfdr.de>; Fri,  2 Jun 2023 05:00:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4755E23417;
	Fri,  2 Jun 2023 05:00:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 6FE4710F6
	for <netdev@vger.kernel.org>; Fri,  2 Jun 2023 05:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1081C4339C;
	Fri,  2 Jun 2023 05:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685682020;
	bh=XACk+phot0nZsqghK6CgtRWXOMVWO7Yuo/U34t/kZlE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=mW/sVs0mU/fNQk7ca8tIxRRF5s/+JHv9DCW/2dUORBo7mtSOzLUcsOzgUHlYxsHzk
	 4L1qNS58RI9RsXhCVCsqX2/31x/kx4H94VOm+ya2Sgw3TKe7dew9aTMx0ugFBHwXz9
	 X3kUzhbzus7F3rKlXtX8qVN2ianGN3Yd6I7kLB30rHi+oScY2jWp54YQ3MoRFiTycx
	 FIU9x9wEr9N9B3dE3DB0qYn427uNrWDkG967mUmV4WGp0f8ELgm4c9ett0GpTYQEtP
	 nqTDde84lMSOUVsOEMyimZWNypnznYRbuD8O/dVxa85pKucHuNMt41ERF1RFurv16L
	 2bwRkSjDRmkMQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B7C7FE49FA9;
	Fri,  2 Jun 2023 05:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: use dev_err_probe in all appropriate places
 in rtl_init_one()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168568202074.24823.13702084281559292966.git-patchwork-notify@kernel.org>
Date: Fri, 02 Jun 2023 05:00:20 +0000
References: <f0596a19-d517-e301-b649-304f9247b75a@gmail.com>
In-Reply-To: <f0596a19-d517-e301-b649-304f9247b75a@gmail.com>
To: Heiner Kallweit <hkallweit1@gmail.com>
Cc: kuba@kernel.org, davem@davemloft.net, nic_swsd@realtek.com,
 edumazet@google.com, pabeni@redhat.com, netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 31 May 2023 22:41:32 +0200 you wrote:
> In addition to properly handling probe deferrals dev_err_probe()
> conveniently combines printing an error message with returning
> the errno. So let's use it for every error path in rtl_init_one()
> to simplify the code.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] r8169: use dev_err_probe in all appropriate places in rtl_init_one()
    https://git.kernel.org/netdev/net-next/c/733b3e27650b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



