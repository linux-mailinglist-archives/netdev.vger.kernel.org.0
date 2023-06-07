Return-Path: <netdev+bounces-8805-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id D5173725D71
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:41:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0D52D1C20D58
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:41:35 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 66FF130B87;
	Wed,  7 Jun 2023 11:40:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5871C17AAA
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C570AC4339B;
	Wed,  7 Jun 2023 11:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686138019;
	bh=NfzoinfF6ITp25gHnJr6r4gON/9GQA7t0s5VVkXdFPI=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=BxZzXX0o2IoZK1YUjbI/11bK+JvPeRAKRehF+ANuZ0EJKhNaSLvgWUxvbwBDmEN7/
	 z9O4cWDP/x4/iZATNG/m88qJWi/Aki0DNLjTPeTqMNX7p+29SAelnAn79AD49RNjOQ
	 VOMTLIAqKjyX7L1p3j5rMpxF8Kw0+RV0HYvcqG6zCt+k4j4AeqUlmIMRYWu72LLrUq
	 TCtmtl0WU4AviPgHTzX1Ro5BQUCeflhgi1f7PtLDylXntx3ANhh8upEVoONqqGySn+
	 GMn/yEQWCPkLqYjg/eB7Tl5lYHGYD0kvrKYQs6QnrgE14lDlD324VJW+deXqzStFnc
	 D6IC/fh3Wz8jg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A9000E29F3C;
	Wed,  7 Jun 2023 11:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: sched: fix possible refcount leak in
 tc_chain_tmplt_add()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168613801968.3806.8503105086077075937.git-patchwork-notify@kernel.org>
Date: Wed, 07 Jun 2023 11:40:19 +0000
References: <20230607022301.6405-1-hbh25y@gmail.com>
In-Reply-To: <20230607022301.6405-1-hbh25y@gmail.com>
To: Hangyu Hua <hbh25y@gmail.com>
Cc: jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 simon.horman@corigine.com, larysa.zaremba@intel.com, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed,  7 Jun 2023 10:23:01 +0800 you wrote:
> try_module_get will be called in tcf_proto_lookup_ops. So module_put needs
> to be called to drop the refcount if ops don't implement the required
> function.
> 
> Fixes: 9f407f1768d3 ("net: sched: introduce chain templates")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] net: sched: fix possible refcount leak in tc_chain_tmplt_add()
    https://git.kernel.org/netdev/net/c/44f8baaf230c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



