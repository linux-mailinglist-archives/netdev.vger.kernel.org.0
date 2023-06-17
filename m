Return-Path: <netdev+bounces-11701-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8E583733F34
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 09:31:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D71A1C210D1
	for <lists+netdev@lfdr.de>; Sat, 17 Jun 2023 07:31:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id A7F58748E;
	Sat, 17 Jun 2023 07:30:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 1A6046AB7
	for <netdev@vger.kernel.org>; Sat, 17 Jun 2023 07:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8BC63C433C8;
	Sat, 17 Jun 2023 07:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686987020;
	bh=4tc8p4C5oifZtrUi/uCn7bMp/xiLkoZTzFGT+uM22KU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=H806mvH/qnDDKhFKPiWpGHAXo9evX/m8y7uLvvaigbeZBu12Iw5FfxbBUaMd4kSum
	 j8PbCxrhNcIqFmijXEIeqGCetcBoFWzUBkiHIm84/i1SDPN8saBOLkvhDH9u5AOMSp
	 hm4kHoo2k1MWHZwMFsc+3PkYkRlVnIfJZh4VTu1Fco0NAgF0/aRlafet9JCOY36O9e
	 DBHxR86txdeHl6wdGmwYPO8dRtlkrDIeL0yLFnVh8Bndx4XZB1ftE56jq1oTXY2Nsz
	 rTOoyRf+dyNQl1L7XDGG9RdulyOdscMy5D4cpvorEQ+CS8eSLUMR8DdzB7AFSdHo8W
	 B+GkZSSPAvP2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 70673C1614E;
	Sat, 17 Jun 2023 07:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sched: Remove unused qdisc_l2t()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168698702045.21379.10841788568408584472.git-patchwork-notify@kernel.org>
Date: Sat, 17 Jun 2023 07:30:20 +0000
References: <20230615124810.34020-1-yuehaibing@huawei.com>
In-Reply-To: <20230615124810.34020-1-yuehaibing@huawei.com>
To: YueHaibing <yuehaibing@huawei.com>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 15 Jun 2023 20:48:10 +0800 you wrote:
> This is unused since switch to psched_l2t_ns().
> 
> Signed-off-by: YueHaibing <yuehaibing@huawei.com>
> ---
>  include/net/sch_generic.h | 14 --------------
>  1 file changed, 14 deletions(-)

Here is the summary with links:
  - [net-next] net: sched: Remove unused qdisc_l2t()
    https://git.kernel.org/netdev/net-next/c/e16ad981e2a1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



