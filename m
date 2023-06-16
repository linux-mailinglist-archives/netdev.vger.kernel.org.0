Return-Path: <netdev+bounces-11320-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id BEB80732988
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 10:10:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 7A646280CDD
	for <lists+netdev@lfdr.de>; Fri, 16 Jun 2023 08:10:24 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id C68689469;
	Fri, 16 Jun 2023 08:10:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 60AA79450
	for <netdev@vger.kernel.org>; Fri, 16 Jun 2023 08:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D3F50C433C9;
	Fri, 16 Jun 2023 08:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686903020;
	bh=rDiQIeucbPgkCAlc+8wcWwStmLWvape2wbhKI1y9/9U=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=U2+s70IKODe14P1cEtfhYn4e2x67GQIUbfvoNDute5161yJULjWNGAArb9i9LfBie
	 +63op26gnJWArVbzikq7bY9T0fvRdvVi53WVaRM/AU6SJCJ3oNR7TUNbsx2UFoaE/E
	 nhCkpLx2g9gkXpNbmX+A38gwZIc4twmwQAmjdJ4FkZt9pF1b5e/UzGqDspGpZGarK8
	 tAoW/5C0m65d3enrSwQ8fzEy9pwMgxkCxTugm+szl3f3Q/EtJ/BG8+SW7UQejlwAjG
	 keVXIbrOpgGY+ef+UgZ3qwK4GtqwkMyFr9y7NydoRKN8Hbyu2I2Lmk/7b6IJ/8g2uz
	 pQ2YEbfA0GBLg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B23CDE49BBF;
	Fri, 16 Jun 2023 08:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] s390/net: lcs: use IS_ENABLED() for kconfig detection
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168690302072.8823.785077843270614259.git-patchwork-notify@kernel.org>
Date: Fri, 16 Jun 2023 08:10:20 +0000
References: <20230615222152.13250-1-rdunlap@infradead.org>
In-Reply-To: <20230615222152.13250-1-rdunlap@infradead.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: linux-kernel@vger.kernel.org, wintera@linux.ibm.com, wenjia@linux.ibm.com,
 linux-s390@vger.kernel.org, netdev@vger.kernel.org, hca@linux.ibm.com,
 gor@linux.ibm.com, agordeev@linux.ibm.com, borntraeger@linux.ibm.com,
 svens@linux.ibm.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 15 Jun 2023 15:21:52 -0700 you wrote:
> When CONFIG_ETHERNET=m or CONFIG_FDDI=m, lcs.s has build errors or
> warnings:
> 
> ../drivers/s390/net/lcs.c:40:2: error: #error Cannot compile lcs.c without some net devices switched on.
>    40 | #error Cannot compile lcs.c without some net devices switched on.
> ../drivers/s390/net/lcs.c: In function 'lcs_startlan_auto':
> ../drivers/s390/net/lcs.c:1601:13: warning: unused variable 'rc' [-Wunused-variable]
>  1601 |         int rc;
> 
> [...]

Here is the summary with links:
  - s390/net: lcs: use IS_ENABLED() for kconfig detection
    https://git.kernel.org/netdev/net-next/c/128272336120

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



