Return-Path: <netdev+bounces-8795-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id E6F7D725D23
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 13:31:05 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id A1B8F28120D
	for <lists+netdev@lfdr.de>; Wed,  7 Jun 2023 11:31:04 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 1E6EE30B9F;
	Wed,  7 Jun 2023 11:30:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 87F7513AD6
	for <netdev@vger.kernel.org>; Wed,  7 Jun 2023 11:30:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EEFD4C433A4;
	Wed,  7 Jun 2023 11:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686137422;
	bh=02ohk6uho+wdZeYJ3NbWDHfzlrRx7UjDJg/ozOIJ858=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=aJPzAKAWNoHnrRlCFfkwyFZkdKwr/8sC1yDwDvNni0dIaGnb9sZO1hMaTXWKP2/L6
	 cK6GToNOnBKU0X6ZV+QCuoRM63kpYqVP0k3FxdpDt6BKo4C4qiH8qf28kdTiNhnYWn
	 ZWvSYv3uIpRyPVBntWG6sgmS3+FgekjkNjHLeKWNFcKCn/hUrryq9uOk+7GxlhIqhK
	 urtW2UTZPuJMEPN31EoS6YMqxE/uKJTY8W/doJxNhXaa4mzDGKJHGNMKLNKjArSNRk
	 Gxcf+mCIb0PPeX2GmQkD2D0hO5FezHBxz6CP9kJz+Pis/HrsmA89wJigD4KVqEYjgs
	 6braM724ICC0w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D6B06E4F13A;
	Wed,  7 Jun 2023 11:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: liquidio: fix mixed module-builtin object
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168613742187.29815.12409173950657122077.git-patchwork-notify@kernel.org>
Date: Wed, 07 Jun 2023 11:30:21 +0000
References: <20230606171849.2025648-1-masahiroy@kernel.org>
In-Reply-To: <20230606171849.2025648-1-masahiroy@kernel.org>
To: Masahiro Yamada <masahiroy@kernel.org>
Cc: linux-kbuild@vger.kernel.org, netdev@vger.kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 linux-kernel@vger.kernel.org, dchickles@marvell.com, sburla@marvell.com,
 fmanlunas@marvell.com, simon.horman@corigine.com, terrelln@fb.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed,  7 Jun 2023 02:18:49 +0900 you wrote:
> With CONFIG_LIQUIDIO=m and CONFIG_LIQUIDIO_VF=y (or vice versa),
> $(common-objs) are linked to a module and also to vmlinux even though
> the expected CFLAGS are different between builtins and modules.
> 
> This is the same situation as fixed by commit 637a642f5ca5 ("zstd:
> Fixing mixed module-builtin objects").
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: liquidio: fix mixed module-builtin object
    https://git.kernel.org/netdev/net-next/c/f71be9d084c9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



