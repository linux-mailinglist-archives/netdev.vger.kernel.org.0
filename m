Return-Path: <netdev+bounces-10983-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 9EDDF730EAD
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 07:30:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 26B95281606
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 05:30:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3ED30803;
	Thu, 15 Jun 2023 05:30:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 03F02656
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 05:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7A3EBC433C8;
	Thu, 15 Jun 2023 05:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686807021;
	bh=TRU0Pgf4i4y0K3jEes+szDbDQ9RTMGOkDVYP6BIn3p0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=PmwnlzTTgQ5rSWL0/RDJFZmOLpN7vR80qUCqgWEJ4M/Gk0gZyDtRokM9nsd4D5no5
	 NkISgSE/k6sq2yaRKX7+ODWCIH7Xzpjv4pcyJClnrtmtV5cTIUWseRL66sOd/ueyJf
	 HmiJtT/ruNbmBjLf+vkOVKjjNmkuAvy+a87z4XkzPKgDBOMz+6b14diYGnojbswBDo
	 WW1YDW3CK6ws/B7WRbL5XrAMTLjVfQgc6kwD1AUQuUQwpTT9Dvqi8RovZZMs/DnHOW
	 4CjOE9NGgwofYA7fxzAcFYedktiKc11iyr+wowPbS++mh5tYz8G0eO9csSlBYS8xFh
	 XjDs0unTa55JA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4DBDAC3274B;
	Thu, 15 Jun 2023 05:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-2023-06-14
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168680702131.31702.14877751927236768045.git-patchwork-notify@kernel.org>
Date: Thu, 15 Jun 2023 05:30:21 +0000
References: <20230614075502.11765-1-johannes@sipsolutions.net>
In-Reply-To: <20230614075502.11765-1-johannes@sipsolutions.net>
To: Johannes Berg <johannes@sipsolutions.net>
Cc: netdev@vger.kernel.org, linux-wireless@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 14 Jun 2023 09:55:01 +0200 you wrote:
> Hi,
> 
> I know it's getting late in the game, but there were still
> a number of locking related fixes and some other things
> coming in recently, so here they are.
> 
> Please pull and let me know if there's any problem.
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-2023-06-14
    https://git.kernel.org/netdev/net/c/37cec6ed8dc5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



