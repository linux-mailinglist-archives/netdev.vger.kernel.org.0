Return-Path: <netdev+bounces-9744-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2ECDC72A610
	for <lists+netdev@lfdr.de>; Sat, 10 Jun 2023 00:00:27 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 66B95281A69
	for <lists+netdev@lfdr.de>; Fri,  9 Jun 2023 22:00:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41DC523C9C;
	Fri,  9 Jun 2023 22:00:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 033D623403
	for <netdev@vger.kernel.org>; Fri,  9 Jun 2023 22:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 86224C4339B;
	Fri,  9 Jun 2023 22:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686348021;
	bh=NZc8np0a+b1I0suEiJDqpaYn08ODnXmdxfenYL1eFhU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=dQigMMPWlRxxiSrWJqGm+TJc/DLZeTSsJUeGqlUmRdpPsE/DyM6wfYA7uq4oiCbPP
	 6UPFalMGmF9Rv/WkUQ6Nimt7kLBu2yGun03X9oys5K5KLA15NShVbrJemdQKmfHzkG
	 esHUW+JenAaHB+/61Wf/CXUkSeSllrEqu8i7X5GsHMRwNpoZhoh01BQXSO2E+PhbHZ
	 gWqtkX7R1SwrM/V8KPcPrLdvca09N06GWn8Xn+SHOqmBnIqMnCCPAFSGYKDKBA0Xlw
	 zwli90BMsAxZxQHoRLlQkIGwWKIRkJV9nFY/paAuOjLmFFm20yasxDh5tmHqh0ysUZ
	 x6I2wxTRTFrUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 613B5C395EC;
	Fri,  9 Jun 2023 22:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 iproute2-next] tc/taprio: print the offload xstats
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168634802139.26045.5253441652618429051.git-patchwork-notify@kernel.org>
Date: Fri, 09 Jun 2023 22:00:21 +0000
References: <20230607154504.4085041-1-vladimir.oltean@nxp.com>
In-Reply-To: <20230607154504.4085041-1-vladimir.oltean@nxp.com>
To: Vladimir Oltean <vladimir.oltean@nxp.com>
Cc: netdev@vger.kernel.org, dsahern@kernel.org, stephen@networkplumber.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Wed,  7 Jun 2023 18:45:04 +0300 you wrote:
> When the kernel reports offload counters through TCA_STATS2 ->
> TCA_STATS_APP for the taprio qdisc, decode and print them.
> 
> Usage:
> 
>  # Global stats
>  $ tc -s qdisc show dev eth0 root
>  # Per-tc stats
>  $ tc -s class show dev eth0
> 
> [...]

Here is the summary with links:
  - [v2,iproute2-next] tc/taprio: print the offload xstats
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=559ffd9e21bf

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



