Return-Path: <netdev+bounces-4861-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 4735170EC7C
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 06:21:01 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0CE1C2810DD
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 04:21:00 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0696D15CE;
	Wed, 24 May 2023 04:20:28 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 57941187F
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 04:20:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E94DC4339C;
	Wed, 24 May 2023 04:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684902026;
	bh=MZEKp6nvRwrHGLX+wrNSIS3+w/mfpFuWH+boQEHyeFA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=kEqb76gBvAOI/nyjLPwXQypYybRX9T8qpOCq6hcWKwrcn5d+ZeYsBXBK4p/eIsllN
	 uEEbHCC49LAJa9xyegDSWbbZ616fV8wjZ0iZNlvrWCoXhIKDOxiOyaYrk2MK4KNAtc
	 Hg0DxqvP7vkBnOYdJQUBpYh8uC4gAD42Pkj+UtgQDatQsiYhOkeX1gDM/7U66kaygf
	 4c4YqvrQoQNXSSwZe3dZ29NRJCKI+AFE8wJZSQ6HLY7ZltGvx0+3PhIgBN3oLxo83n
	 JUMl8UI5Rj/ug8Zp/9G42MgYSKO0p6pzUhMUz3pjMst6GhhmJUIfngb95NkEccxGdK
	 6ahfRzhBNy+jg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 06F99E22AEC;
	Wed, 24 May 2023 04:20:26 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] gve: Support IPv6 Big TCP on DQ
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168490202602.21222.2407680817927618149.git-patchwork-notify@kernel.org>
Date: Wed, 24 May 2023 04:20:26 +0000
References: <20230522201552.3585421-1-ziweixiao@google.com>
In-Reply-To: <20230522201552.3585421-1-ziweixiao@google.com>
To: Ziwei Xiao <ziweixiao@google.com>
Cc: netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
 lixiaoyan@google.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 22 May 2023 13:15:52 -0700 you wrote:
> From: Coco Li <lixiaoyan@google.com>
> 
> Add support for using IPv6 Big TCP on DQ which can handle large TSO/GRO
> packets. See https://lwn.net/Articles/895398/. This can improve the
> throughput and CPU usage.
> 
> Perf test result:
> ip -d link show $DEV
> gso_max_size 185000 gso_max_segs 65535 tso_max_size 262143 tso_max_segs 65535 gro_max_size 185000
> 
> [...]

Here is the summary with links:
  - [net-next] gve: Support IPv6 Big TCP on DQ
    https://git.kernel.org/netdev/net-next/c/a695641c8eaa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



