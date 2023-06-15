Return-Path: <netdev+bounces-11243-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 217DB732280
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 00:10:32 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 529FB1C20AF1
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 22:10:31 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 2D9E517AB4;
	Thu, 15 Jun 2023 22:10:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1D7E1772D
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 22:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 43C39C433CD;
	Thu, 15 Jun 2023 22:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686867021;
	bh=li6U7QEqXs993UbSExdtT+XQZfWQ3XJYdL3IG7rk37Q=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=dxnn6E9s0P/fMBKBk4cwnNIUFKP4GNLiLtYuMIeVjCZZoMEVd5uX3rKdQO5tTrkDt
	 U5G+CvVU8mXDIX/FcQYhsWGMFNhlB84lMXMRuGbn+cUDcpjyEbuvudjTPzaTIyb0TF
	 /Ksjc1Sa0/cJr4RP7sSmKu0vjwfbnJ7L1NxQQ0TLs5cl52fmRfuDMM/leb8/lkq1e0
	 XhmXjQI3Om1Il2lJJNSiMzMW8L5YoB/lhW7ht+lsMqGlLYhpgh2c6MD+AIFJNe+FXb
	 Cy+TffEu9rZFDtLIHq3JFjZO74i6UWXajlQ0D9rF5oW9/cF/nu/prRwRoeeQIKbGKH
	 urF0WeOORLg+Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 20A96C395E0;
	Thu, 15 Jun 2023 22:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: tipc: resize nlattr array to correct size
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168686702113.9701.9079835464800467411.git-patchwork-notify@kernel.org>
Date: Thu, 15 Jun 2023 22:10:21 +0000
References: <20230614120604.1196377-1-linma@zju.edu.cn>
In-Reply-To: <20230614120604.1196377-1-linma@zju.edu.cn>
To: Lin Ma <linma@zju.edu.cn>
Cc: davem@davemloft.net, netdev@vger.kernel.org,
 tipc-discussion@lists.sourceforge.net, tung.q.nguyen@dektech.com.au

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 14 Jun 2023 20:06:04 +0800 you wrote:
> According to nla_parse_nested_deprecated(), the tb[] is supposed to the
> destination array with maxtype+1 elements. In current
> tipc_nl_media_get() and __tipc_nl_media_set(), a larger array is used
> which is unnecessary. This patch resize them to a proper size.
> 
> Fixes: 1e55417d8fc6 ("tipc: add media set to new netlink api")
> Fixes: 46f15c6794fb ("tipc: add media get/dump to new netlink api")
> Signed-off-by: Lin Ma <linma@zju.edu.cn>
> 
> [...]

Here is the summary with links:
  - [v2] net: tipc: resize nlattr array to correct size
    https://git.kernel.org/netdev/net/c/44194cb1b604

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



