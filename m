Return-Path: <netdev+bounces-4859-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8A53470EC75
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 06:20:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 540271C20ADF
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 04:20:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 810F315D0;
	Wed, 24 May 2023 04:20:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id E642015CE
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 04:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8DA7AC433EF;
	Wed, 24 May 2023 04:20:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684902019;
	bh=Kfj7uQjDJMXFM0cm9fLG2FGT/MmRT8alZ3jos2HL3GM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=HQs/iIvQ7Nkck3O4YJvE072GCSUylXaKcu1ve9sXuGhukKB48U4YpwDvvA5ZaLg/9
	 yItTfz3q3T6qcD9aWIa9AgDtlQfGN5ZD+vkC4H7q3KzLWrPdP87YA9nfmjN1TVAhmy
	 HjXUth4v5/UO/Id87OfNugJrrRTDrvWXJac/EotU3ve+eW7TDIMKSLyvROasLPYHnw
	 EkNLAd8XEaTGlUgx/WMJmDYMFWcPuuE1YJlb2C8pIbsDCwwPCy/kdoFUICwxVx93mn
	 NkUaRcb/NY4FNzx7gazxV6fMxhBrdXnXEWlFBcVkuJFP3E47igVmVeg8N1jjVXusXg
	 k2U9qw3mpFQwg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6CD9DE21ECF;
	Wed, 24 May 2023 04:20:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: fix skb leak in __skb_tstamp_tx()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168490201944.21222.1273870966646702952.git-patchwork-notify@kernel.org>
Date: Wed, 24 May 2023 04:20:19 +0000
References: <20230522153020.32422-1-ptyadav@amazon.de>
In-Reply-To: <20230522153020.32422-1-ptyadav@amazon.de>
To: Pratyush Yadav <ptyadav@amazon.de>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, kuniyu@amazon.com, willemb@google.com, nmanthey@amazon.de,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 22 May 2023 17:30:20 +0200 you wrote:
> Commit 50749f2dd685 ("tcp/udp: Fix memleaks of sk and zerocopy skbs with
> TX timestamp.") added a call to skb_orphan_frags_rx() to fix leaks with
> zerocopy skbs. But it ended up adding a leak of its own. When
> skb_orphan_frags_rx() fails, the function just returns, leaking the skb
> it just cloned. Free it before returning.
> 
> This bug was discovered and resolved using Coverity Static Analysis
> Security Testing (SAST) by Synopsys, Inc.
> 
> [...]

Here is the summary with links:
  - [net] net: fix skb leak in __skb_tstamp_tx()
    https://git.kernel.org/netdev/net/c/8a02fb71d719

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



