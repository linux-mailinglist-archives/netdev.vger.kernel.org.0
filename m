Return-Path: <netdev+bounces-10270-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 5815672D5FE
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 02:20:26 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 0E06128113C
	for <lists+netdev@lfdr.de>; Tue, 13 Jun 2023 00:20:25 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 36C2664C;
	Tue, 13 Jun 2023 00:20:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id AA0A7621
	for <netdev@vger.kernel.org>; Tue, 13 Jun 2023 00:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 20D18C433EF;
	Tue, 13 Jun 2023 00:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686615621;
	bh=r3wHtTgFcd3sqwEbQcaQ8YKMz+0rKQ6IMFKcSM9i/Sk=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=YGWJv+oE6VGgeJy/kb+XWAmSS5vIQz+XS7mWFCfk/CRGL7I8/ynDoilv2d0LGksuj
	 3x7zSmj+4VeSsW5Us6U+Pvio7oKlCmw11SGt2FjsRwuCCQb4stKcS6zvOimbBPeZ/+
	 KAPdh4vaRYXwX4U46w5TV5z/0pxbPZUZWnWb3WTbN8RDXjyqu9rKc9k3GTr076DWI7
	 +Ih5mKrJzPcBxyrqYzTXEiPiW6ToZu6zwOjihuJvN/u4flRZmymMq3HrYg8nzXQMBB
	 WptEWCcbC19bawdXsh7WO6opu6awsKMprQgIZIS3+lSM3KL5M0RsaGXnjp3gYLbr6g
	 HrTV7Gn50WoPw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0ADC7E21EC0;
	Tue, 13 Jun 2023 00:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v7 0/3] net: flower: add cfm support
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168661562104.20896.14385022155812695573.git-patchwork-notify@kernel.org>
Date: Tue, 13 Jun 2023 00:20:21 +0000
References: <20230608105648.266575-1-zahari.doychev@linux.com>
In-Reply-To: <20230608105648.266575-1-zahari.doychev@linux.com>
To: Zahari Doychev <zahari.doychev@linux.com>
Cc: netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
 jiri@resnulli.us, davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, hmehrtens@maxlinear.com, aleksander.lobakin@intel.com,
 simon.horman@corigine.com, idosch@idosch.org, zdoychev@maxlinear.com

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  8 Jun 2023 12:56:45 +0200 you wrote:
> From: Zahari Doychev <zdoychev@maxlinear.com>
> 
> The first patch adds cfm support to the flow dissector.
> The second adds the flower classifier support.
> The third adds a selftest for the flower cfm functionality.
> 
> iproute2 changes will come in follow up patches.
> 
> [...]

Here is the summary with links:
  - [net-next,v7,1/3] net: flow_dissector: add support for cfm packets
    https://git.kernel.org/netdev/net-next/c/d7ad70b5ef5a
  - [net-next,v7,2/3] net: flower: add support for matching cfm fields
    https://git.kernel.org/netdev/net-next/c/7cfffd5fed3e
  - [net-next,v7,3/3] selftests: net: add tc flower cfm test
    https://git.kernel.org/netdev/net-next/c/1668a55a73f5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



