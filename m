Return-Path: <netdev+bounces-11295-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 0EEF77326F6
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:00:38 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 40E821C20F29
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 06:00:37 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4352E1104;
	Fri, 16 Jun 2023 06:00:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A8072EC7
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 06:00:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 407C0C433CA;
	Fri, 16 Jun 2023 06:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686895223;
	bh=qmcmgjwqTMCDq/JHveSAC3AaX8zts5IADhw+H2J9ox0=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=R7WLLJutFWWwwLfgoGmMfQ7MWYMpUU5R+PffBZxTmdXhDlgx36bWJhVV8kDLwwLV7
	 j2os7vVB1/Cas3d1HgzhYKqjgGDIq6I3CKC6yyZpOuj9T9UlJcc8BsySyz16ItAb6w
	 o5H3eetpjlkvIMnPUiQl1gioKOF5AWTbEcKWPDu5R2LOHfyBDNVWNi1YcG47lCBWmG
	 5vlAHRAfHgOVlpY6UuXRKGpkTJVVG5XpF3IO9AjsKzTZo7Fp1NXxV2IpJC+3eoJG7s
	 Kbp+KzsuwLO/Uh3YHJag0QWA/zDsqo0CuSz5s/XY6EzSvScNt8yJGbINfKaujwWMXC
	 FuA1mgqpoB/DA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 138BAE49F62;
	Fri, 16 Jun 2023 06:00:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] eth: fs_enet: fix print format for resource size
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168689522307.30897.16355114078429295626.git-patchwork-notify@kernel.org>
Date: Fri, 16 Jun 2023 06:00:23 +0000
References: <20230615035231.2184880-1-kuba@kernel.org>
In-Reply-To: <20230615035231.2184880-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, rdunlap@infradead.org, pantelis.antoniou@gmail.com,
 linuxppc-dev@lists.ozlabs.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 14 Jun 2023 20:52:31 -0700 you wrote:
> Randy forwarded report from Stephen that on PowerPC:
> 
> drivers/net/ethernet/freescale/fs_enet/mii-fec.c: In function 'fs_enet_mdio_probe':
> drivers/net/ethernet/freescale/fs_enet/mii-fec.c:130:50: warning: format '%x' expects argument of type 'unsigned int', but argument 4 has type 'resource_size_t' {aka 'long long unsigned int'} [-Wformat=]
>   130 |         snprintf(new_bus->id, MII_BUS_ID_SIZE, "%x", res.start);
>       |                                                 ~^   ~~~~~~~~~
>       |                                                  |      |
>       |                                                  |      resource_size_t {aka long long unsigned int}
>       |                                                  unsigned int
>       |                                                 %llx
> 
> [...]

Here is the summary with links:
  - [net-next] eth: fs_enet: fix print format for resource size
    https://git.kernel.org/netdev/net-next/c/8f72fb1578a9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



