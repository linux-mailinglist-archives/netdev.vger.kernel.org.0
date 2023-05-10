Return-Path: <netdev+bounces-1399-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 058CE6FDAF5
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:42:17 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id D12E0280E48
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:42:15 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 240EF6FB7;
	Wed, 10 May 2023 09:40:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 47E776AD6
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6BA6C4339B;
	Wed, 10 May 2023 09:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683711622;
	bh=k6Rlzw3LIHIMiiFbiLk9EhrQQrrxnh5beODydsiRn9E=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=erqtQm4ycythGAuNtcySPWxXLNx37rBnBo5/412Onbd+h0eCZp/axFZLi0/HOnjHL
	 UKPfGfWdZu6tMX2CnJKX1ZBYSxbk+xAiBvHtLfxV8mRGwyaHBzjrRfStxn6Y99PYRO
	 WYmi7mJNszxiAN4Xv5nw+0UYJQH3KY56A2beJsGROmKCWgENl381Jf6YZDQkt/UjIY
	 vmE5O2VmCAPo1htD6IKrDAHmAsPtA4u079VUWBUHd6CpCtNutPLCVLuvEzAG03XU4i
	 u/ZGS0hl/m1JFgI6BRZUshRew5L8M5hcvY8JvOXD3FnN7g8ZtlmJlsGyFqW2ISYfrL
	 YSDIfVidJEQkg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C9D11E501FF;
	Wed, 10 May 2023 09:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2] ipvlan:Fix out-of-bounds caused by unclear skb->cb
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168371162182.29703.5823026443850415461.git-patchwork-notify@kernel.org>
Date: Wed, 10 May 2023 09:40:21 +0000
References: <20230510035044.3082562-1-fengtao40@huawei.com>
In-Reply-To: <20230510035044.3082562-1-fengtao40@huawei.com>
To: t.feng <fengtao40@huawei.com>
Cc: netdev@vger.kernel.org, lucien.xin@gmail.com, luwei32@huawei.com,
 pabeni@redhat.com, kuba@kernel.org, edumazet@google.com, davem@davemloft.net,
 yanan@huawei.com, fw@strlen.de

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 10 May 2023 11:50:44 +0800 you wrote:
> If skb enqueue the qdisc, fq_skb_cb(skb)->time_to_send is changed which
> is actually skb->cb, and IPCB(skb_in)->opt will be used in
> __ip_options_echo. It is possible that memcpy is out of bounds and lead
> to stack overflow.
> We should clear skb->cb before ip_local_out or ip6_local_out.
> 
> v2:
> 1. clean the stack info
> 2. use IPCB/IP6CB instead of skb->cb
> 
> [...]

Here is the summary with links:
  - [V2] ipvlan:Fix out-of-bounds caused by unclear skb->cb
    https://git.kernel.org/netdev/net/c/90cbed524743

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



