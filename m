Return-Path: <netdev+bounces-5607-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E19A97123E7
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 11:40:36 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 99F3F281711
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 09:40:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A21451549C;
	Fri, 26 May 2023 09:40:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 75D3311C87
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 09:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3916FC4339E;
	Fri, 26 May 2023 09:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685094020;
	bh=GA/nUrW68igVVODUsm3NmjZcijF3mXleaqwRJhtM2pQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=aRx5rxngtup5kfY2ZQP8NGugfyzElg54OHUj4dq2J3Ox4xwCclJD+whU0Z/Bym88L
	 8Bat6L84gjJiGHWfa7uagSfr96MVivSQHHJUddlysT9eeBdofz5hUV+sOZU+BueETg
	 X/pYgCHxHJ+AHjXreszUO2QfBUIJMGnxvgR4VoSnG3N6MP3MoxOHYaeFBpF2fawWTM
	 hDw+PC05HIVhCk5WwFgqYR3tJvoXk4QjQQMFekE0wm9oE5TGDOf6T5JLR0ivvEAncJ
	 bfYd2qFF7Fm8KSgxglXrUOTnp2dHeM3iJXi7AYqP83OnyzPoucTarKoGKiTussvJYf
	 4MK1GiB+HNayQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 24853E22B06;
	Fri, 26 May 2023 09:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ynl: prefix uAPI header include with uapi/
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168509402014.30918.11720131499399473326.git-patchwork-notify@kernel.org>
Date: Fri, 26 May 2023 09:40:20 +0000
References: <20230524170901.2036275-1-kuba@kernel.org>
In-Reply-To: <20230524170901.2036275-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, chuck.lever@oracle.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 24 May 2023 10:09:01 -0700 you wrote:
> To keep things simple we used to include the uAPI header
> in the kernel in the #include <linux/$family.h> format.
> This works well enough, most of the genl families should
> have headers in include/net/ so linux/$family.h ends up
> referring to the uAPI header, anyway. And if it doesn't
> no big deal, we'll just include more info than we need.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ynl: prefix uAPI header include with uapi/
    https://git.kernel.org/netdev/net-next/c/9b66ee06e5ca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



