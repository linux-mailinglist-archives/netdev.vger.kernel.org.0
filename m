Return-Path: <netdev+bounces-2378-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 2787970198E
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 21:50:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id C9CDD2818E1
	for <lists+netdev@lfdr.de>; Sat, 13 May 2023 19:50:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 983D28F72;
	Sat, 13 May 2023 19:50:20 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id CF9582583
	for <netdev@vger.kernel.org>; Sat, 13 May 2023 19:50:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 77065C4339B;
	Sat, 13 May 2023 19:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684007418;
	bh=quiype2qjwuPOl5JFZWjttyiqSeX3ASAs8eeaRVy5W8=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=hTe5sI0vnqEG3p6sIEv38pr0yFw62+KCCqTV4kPpc+UQUSuqsWzJVBdkVzbYe8GqP
	 2qs5fPdKYPkl31jdfksM7ToGRR0fICTMa/neoCbHZ1YhtyVkBdaSErAROuVBmN9AYW
	 iQJjJ4nvd87W1NFYYRRkhkaZ04Puom2FSyYv3+mBuSRWRbQWPWnp8H9K1TTeGqBuYU
	 2KLOGmOvAc5t+vD7xw/O5WfrWtC27ePNIpmm0Ki5+NtM2SOLiNvXQQKBOkukKEdmJU
	 1fYL1NmZtPTJCnT82iHZOzxUl61oxYyhbIxyhom1mjg9MN0ptgvMRiHjzrt1B/ia5l
	 5XO4y8fuMzUAQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5DAEFE450BB;
	Sat, 13 May 2023 19:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4 0/1] Adjust macb max_tx_len for mpfs
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168400741837.29282.2422245224869605594.git-patchwork-notify@kernel.org>
Date: Sat, 13 May 2023 19:50:18 +0000
References: <20230512122032.2902335-1-daire.mcnamara@microchip.com>
In-Reply-To: <20230512122032.2902335-1-daire.mcnamara@microchip.com>
To: Daire McNamara <daire.mcnamara@microchip.com>
Cc: nicolas.ferre@microchip.com, claudiu.beznea@microchip.com,
 davem@davemloft.net, edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, conor.dooley@microchip.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 12 May 2023 13:20:31 +0100 you wrote:
> From: Daire McNamara <daire.mcnamara@microchip.com>
> 
> Several customers have reported unexpected ethernet issues whereby
> the GEM stops transmitting and receiving. Performing an action such
> as ifconfig <ethX> down; ifconfig <ethX> up clears this particular
> condition.
> 
> [...]

Here is the summary with links:
  - [v4,1/1] net: macb: Shorten max_tx_len to 4KiB - 56 on mpfs
    https://git.kernel.org/netdev/net-next/c/314cf958de2a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



