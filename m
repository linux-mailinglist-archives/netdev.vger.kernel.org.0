Return-Path: <netdev+bounces-9788-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id F16A172A971
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 08:42:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 499251C21131
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 06:42:02 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 342761878;
	Sat, 10 Jun 2023 06:42:03 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id DE42A408C8
	for <netdev@vger.kernel.org>; Sat, 10 Jun 2023 06:42:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5CE62C4339B;
	Sat, 10 Jun 2023 06:42:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686379321;
	bh=dC/XB8adrx7TRfUdGJs0rfRjPM1LJL5QJ2tlffYmoE4=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=m0IfRvHBX4CjugTn7M566hPP8sDNVnr4vECYlyiHoCKgWnMK8rDoofdc5Uu0A3QD0
	 W3wrCS2EpRZK3yOT/XRzKYftw6hRcoWLoEWOIIj74PnQa/TvntbMb2XVueTa9LwilM
	 V7H7kTWv2j6udP/NiQwAPZoGeYp1QINvJA8LFph8MSM8xZJnJJM6xhuhygVJAAZAs5
	 mahljWfVu5j7fEo0aXyHmzjzpTrB4GPMzZl9y61iY5NnSf+bgsOOhZronQTep517uN
	 TJMG79c+fwPutIGa9w8Kjp56esExie2FhRmNs5G/0fDbUsmgqomFHvEbNciSqvPEHp
	 ExBEnujaCfgMA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3748BE1CF31;
	Sat, 10 Jun 2023 06:42:01 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-next-2023-06-09
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168637932120.22916.1742203530299730550.git-patchwork-notify@kernel.org>
Date: Sat, 10 Jun 2023 06:42:01 +0000
References: <87bkhohkbg.fsf@kernel.org>
In-Reply-To: <87bkhohkbg.fsf@kernel.org>
To: Kalle Valo <kvalo@kernel.org>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 09 Jun 2023 15:49:39 +0300 you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Note: git request-pull got the diffstat wrong, most likely it got
> confused due to our merge from the wireless tree. I fixed it manually by
> adding the output from git diff. Everything looks to be ok but I
> recommend double checking anyway.
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-next-2023-06-09
    https://git.kernel.org/netdev/net-next/c/cde11936cffb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



