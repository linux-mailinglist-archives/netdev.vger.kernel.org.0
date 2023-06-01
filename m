Return-Path: <netdev+bounces-7077-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 98304719AFF
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 13:30:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 51CE828175F
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 11:30:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C599123427;
	Thu,  1 Jun 2023 11:30:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0D8AA23404
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 11:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C785C433EF;
	Thu,  1 Jun 2023 11:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685619019;
	bh=nZcwgW7xBictvCErCoWGsWs1oqpGOIByQ0oGnpcuCzg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=QwrukkJ0BSyOd4Q6RSFnpJhfmp+6yuRfolfKjECi08OK2i4RVZrRbFF7Yl2BY1K5M
	 znpc888PGsYQuzF6sdkllam0S7KlRmJXDhY7j3xcmJvo/QGAaXAGjfoFkHOVOAeth1
	 k77TIUPsIEu19zDKsFrr+kYYemnDOpykYbcHvy1l3QWErc6XwE9m6EmWykHQeV/uzU
	 TJN2Xr15HrPMGnHgrsNXDMZvdwR8LQB7yEkgSZEhHUhur8mFCIxs0ic9vwPeaMXm2V
	 YcT9p/SlFDeI3bYiR/7aj9oqVYXeg+YmUr3/jKtKv5dtHPn+7GSw839pQSYDecxBjB
	 L/bAuipCcTgBw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 430C0C395E0;
	Thu,  1 Jun 2023 11:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v4] tcp: fix mishandling when the sack compression is
 deferred.
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168561901927.15218.5820204567180741386.git-patchwork-notify@kernel.org>
Date: Thu, 01 Jun 2023 11:30:19 +0000
References: <20230531080150.GA20424@didi-ThinkCentre-M920t-N000>
In-Reply-To: <20230531080150.GA20424@didi-ThinkCentre-M920t-N000>
To: fuyuanli <fuyuanli@didiglobal.com>
Cc: edumazet@google.com, davem@davemloft.net, dsahern@kernel.org,
 kuba@kernel.org, pabeni@redhat.com, ncardwell@google.com, ycheng@google.com,
 toke@toke.dk, netdev@vger.kernel.org, zhangweiping@didiglobal.com,
 tiozhang@didiglobal.com, kerneljasonxing@gmail.com

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 31 May 2023 16:01:50 +0800 you wrote:
> In this patch, we mainly try to handle sending a compressed ack
> correctly if it's deferred.
> 
> Here are more details in the old logic:
> When sack compression is triggered in the tcp_compressed_ack_kick(),
> if the sock is owned by user, it will set TCP_DELACK_TIMER_DEFERRED
> and then defer to the release cb phrase. Later once user releases
> the sock, tcp_delack_timer_handler() should send a ack as expected,
> which, however, cannot happen due to lack of ICSK_ACK_TIMER flag.
> Therefore, the receiver would not sent an ack until the sender's
> retransmission timeout. It definitely increases unnecessary latency.
> 
> [...]

Here is the summary with links:
  - [net,v4] tcp: fix mishandling when the sack compression is deferred.
    https://git.kernel.org/netdev/net/c/30c6f0bf9579

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



