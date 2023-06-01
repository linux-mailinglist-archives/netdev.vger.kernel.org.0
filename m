Return-Path: <netdev+bounces-7074-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id B9B4F719AA6
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 13:10:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 4D8281C20AFC
	for <lists+netdev@lfdr.de>; Thu,  1 Jun 2023 11:10:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E77FF2341E;
	Thu,  1 Jun 2023 11:10:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 9909E23404
	for <netdev@vger.kernel.org>; Thu,  1 Jun 2023 11:10:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EC958C4339B;
	Thu,  1 Jun 2023 11:10:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685617820;
	bh=6KkexGhJ46cI86YrxWzyDynW2Ra0U5h1qcMfn2jQgYE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=TNNCoWAQLMdouk10ckVumNA6y7Rvo6wHfSTVPEljRa9dr1C6dGAWbsFKqfjkBFFdw
	 8my0AaIMHXkTkO3xfLAQuD7D9v7MAhza0qFJ7YTtFGvEUh8/7MXVDhYI/4so0P7p1y
	 dpunlyCBVoIDulKCwjbSVKxbmDsHUDCi40uDb3QRwSys+kGgkXYWbO7E9m+NX7guiG
	 0i5GLRVIM3K8+CsYeNI39TjXJA2itL/w3RV1U/roPrVzwNgwcUjbbeGuV92lg6CF+/
	 WSHqv1SCpJmmzHu1feZsZEXCRx7sV15Wc2JKPKwtGVPjHJK20A4vuYWSMnk3GvIej5
	 CG/D92qcCN3fg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C358FE52C02;
	Thu,  1 Jun 2023 11:10:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net/sched: flower: fix possible OOB write in
 fl_set_geneve_opt()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168561781979.6344.740416824710659310.git-patchwork-notify@kernel.org>
Date: Thu, 01 Jun 2023 11:10:19 +0000
References: <20230531102805.27090-1-hbh25y@gmail.com>
In-Reply-To: <20230531102805.27090-1-hbh25y@gmail.com>
To: Hangyu Hua <hbh25y@gmail.com>
Cc: jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 simon.horman@corigine.com, pieter.jansen-van-vuuren@amd.com,
 netdev@vger.kernel.org, linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 31 May 2023 18:28:04 +0800 you wrote:
> If we send two TCA_FLOWER_KEY_ENC_OPTS_GENEVE packets and their total
> size is 252 bytes(key->enc_opts.len = 252) then
> key->enc_opts.len = opt->length = data_len / 4 = 0 when the third
> TCA_FLOWER_KEY_ENC_OPTS_GENEVE packet enters fl_set_geneve_opt. This
> bypasses the next bounds check and results in an out-of-bounds.
> 
> Fixes: 0a6e77784f49 ("net/sched: allow flower to match tunnel options")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] net/sched: flower: fix possible OOB write in fl_set_geneve_opt()
    https://git.kernel.org/netdev/net/c/4d56304e5827

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



