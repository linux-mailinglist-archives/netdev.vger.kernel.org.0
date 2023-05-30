Return-Path: <netdev+bounces-6239-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id B04FB7154E1
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 07:20:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 5AF56281071
	for <lists+netdev@lfdr.de>; Tue, 30 May 2023 05:20:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A2B8D63B2;
	Tue, 30 May 2023 05:20:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 23B4C4A1A
	for <netdev@vger.kernel.org>; Tue, 30 May 2023 05:20:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C2835C433D2;
	Tue, 30 May 2023 05:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685424019;
	bh=wZZq4xCSbnEzSxxDzNSdM/f6gmgE/fPraERIcsOOXSY=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=KPdzcVFcU1Dj/iaZ6ZXL7f7Y77v6LV9i2v6bsRwu7tfn6E9qvSTUrN0ngTBezl5Z1
	 iZopWniLKkd1Bz4DdXk3p+TeiOxJVgqCkYIA037TAXLnZbGfAhZBCC/2wgO7dfdR/x
	 RXf8rhJw9CVe9qTjzDZb5x/MrkmmnOyghBYODzsFJuoDHqUfx3C3sdMwASvK6G1uE2
	 pw1YnrBMvMjfb8FRRhjfeAtjObVyrw71UTthasvqlKjWt7RwCUy/M+jlC/wtskFbJJ
	 npLPR3O/G3votTZ1nIcY8/VXnAqUqVBLi8GG0Vz0n+POshW3jB1di7pz8I7eg+0WKj
	 1wU6EoXTCPwkQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9EA69E52BF7;
	Tue, 30 May 2023 05:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: usb: qmi_wwan: Set DTR quirk for BroadMobi BM818
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168542401964.30709.17776180857500968814.git-patchwork-notify@kernel.org>
Date: Tue, 30 May 2023 05:20:19 +0000
References: <20230526-bm818-dtr-v1-1-64bbfa6ba8af@puri.sm>
In-Reply-To: <20230526-bm818-dtr-v1-1-64bbfa6ba8af@puri.sm>
To: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
Cc: bjorn@mork.no, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, angus@akkea.ca, bob.ham@puri.sm, netdev@vger.kernel.org,
 linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org, kernel@puri.sm,
 stable@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 26 May 2023 16:38:11 +0200 you wrote:
> BM818 is based on Qualcomm MDM9607 chipset.
> 
> Fixes: 9a07406b00cd ("net: usb: qmi_wwan: Add the BroadMobi BM818 card")
> Cc: stable@vger.kernel.org
> Signed-off-by: Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>
> ---
>  drivers/net/usb/qmi_wwan.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> [...]

Here is the summary with links:
  - net: usb: qmi_wwan: Set DTR quirk for BroadMobi BM818
    https://git.kernel.org/netdev/net/c/36936a56e181

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



