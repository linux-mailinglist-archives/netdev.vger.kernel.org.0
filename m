Return-Path: <netdev+bounces-11052-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2BA007315C1
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 12:50:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id E34E3281730
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 10:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16A05566C;
	Thu, 15 Jun 2023 10:50:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D0BF53D7F
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 10:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 603E5C433CA;
	Thu, 15 Jun 2023 10:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686826220;
	bh=mmKn3ew/3ihNeUTsrH7kpRJDU9VC/tq1DF43WBYgUjc=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=XQb1yjyu7equ0BYhCU1QJjHdCwPx/7WS07cuh6Ee/ukzrWWJa1lOqiPrjFZ7bhIfN
	 rqCUw7iOdeMlQ9Sd/UBrbOA+krlqf3GAn3GdEoyfc6UKwyzmCTNn7jghlDT3pBTU6l
	 cWK/1mKjrVPpo/YRcAWseb2TvcyzHFORxlrToAV62W/je68U9PrS8+dftkAC64UZXW
	 AWNzPahr7Pl+Rn2y1yaqaWLwv3imYKQklYwYL/6YjiIGiQ+78GTit/u4OfD34Idahr
	 VZdGhjkog7/pya9NtGQ9RyKKftj1EPmI3MhfvHrdXxgAUurN34QcFeTsJoLkIES5Bs
	 XDiN23PvR+y4g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3709AE270FB;
	Thu, 15 Jun 2023 10:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: macsec: fix double free of percpu stats
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168682622021.15431.8579667893782171995.git-patchwork-notify@kernel.org>
Date: Thu, 15 Jun 2023 10:50:20 +0000
References: <20230613192220.159407-1-pchelkin@ispras.ru>
In-Reply-To: <20230613192220.159407-1-pchelkin@ispras.ru>
To: Fedor Pchelkin <pchelkin@ispras.ru>
Cc: davem@davemloft.net, sd@queasysnail.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, raeds@nvidia.com, liorna@nvidia.com,
 saeedm@nvidia.com, hannes@stressinduktion.org, netdev@vger.kernel.org,
 linux-kernel@vger.kernel.org, khoroshilov@ispras.ru,
 lvc-project@linuxtesting.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 13 Jun 2023 22:22:20 +0300 you wrote:
> Inside macsec_add_dev() we free percpu macsec->secy.tx_sc.stats and
> macsec->stats on some of the memory allocation failure paths. However, the
> net_device is already registered to that moment: in macsec_newlink(), just
> before calling macsec_add_dev(). This means that during unregister process
> its priv_destructor - macsec_free_netdev() - will be called and will free
> the stats again.
> 
> [...]

Here is the summary with links:
  - net: macsec: fix double free of percpu stats
    https://git.kernel.org/netdev/net/c/0c0cf3db83f8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



