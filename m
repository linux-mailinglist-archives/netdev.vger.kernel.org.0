Return-Path: <netdev+bounces-1379-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 97D056FDA46
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:01:14 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 68F962812E4
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:01:13 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 6EA2E20B50;
	Wed, 10 May 2023 09:00:26 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5A71D648;
	Wed, 10 May 2023 09:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F3D70C433A7;
	Wed, 10 May 2023 09:00:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683709223;
	bh=PaH/3TBg61olk0KWleQOodKS0X6tmU8JA6gcuNrmgfw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Y32G3a2DI58Owka/LH6/Mz9D9+Muh+lvmFOQIS/FCEWuESXF40LwAIvJEAgb9hVS7
	 dKkMmm44JKVLsUbFDq/2Ql0xsqDpu+Pg1VdJTrLpk5NP9pjNT8imjCh03A6TZqA4xS
	 10gIikV53rPFxe8YmkVwTehY/e5i2RWl274G5jAFwZQqVGHyU5lqy3qoRX/SRQ+ZM7
	 /FopE146wa4C+I3NhIiKPwRaI5OdYGM1G0eMhqFwZ5AX8dOtehB2iYoQECijssW6hd
	 YhbHDaJGzywpGe7UmVatGZjtZcD3ITGYF4e1yn851abjT645CwzADCDKiSM20E9Ul5
	 lkGYJek6VorTA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CBF7EE501FF;
	Wed, 10 May 2023 09:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: veth: make PAGE_POOL_STATS optional
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168370922281.25656.18183130593399665986.git-patchwork-notify@kernel.org>
Date: Wed, 10 May 2023 09:00:22 +0000
References: <c9e132c3f08c456ad0462342bb0a104f0f8c0b24.1683622992.git.lorenzo@kernel.org>
In-Reply-To: <c9e132c3f08c456ad0462342bb0a104f0f8c0b24.1683622992.git.lorenzo@kernel.org>
To: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: netdev@vger.kernel.org, lorenzo.bianconi@redhat.com, bpf@vger.kernel.org,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 hawk@kernel.org, john.fastabend@gmail.com, linyunsheng@huawei.com,
 ast@kernel.org, daniel@iogearbox.net, jbenc@redhat.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue,  9 May 2023 11:05:16 +0200 you wrote:
> Since veth is very likely to be enabled and there are some drivers
> (e.g. mlx5) where CONFIG_PAGE_POOL_STATS is optional, make
> CONFIG_PAGE_POOL_STATS optional for veth too in order to keep it
> optional when required.
> 
> Suggested-by: Jiri Benc <jbenc@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net-next] net: veth: make PAGE_POOL_STATS optional
    https://git.kernel.org/netdev/net-next/c/5e316a818e75

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



