Return-Path: <netdev+bounces-1997-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 3A6536FFE4A
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 03:11:03 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id EAA62281984
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 01:11:01 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 0BACA7FA;
	Fri, 12 May 2023 01:10:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 4EF1C7FD
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 01:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DE671C433AA;
	Fri, 12 May 2023 01:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683853821;
	bh=KiHFanH/JboXV27bY1pLsYXosGoxMWgCv9S/LB2f0YM=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=mLP4wNfeVwsHQztqh9NAAGwjmd4zEiseKmizNEfJ4IWP0hhx1QHF+AMt3NK2HAYGo
	 0y2FzDl3h7MFVzuZKeCJEOlP9o6yUeoRH/MWErFhINpjvVcgnd1RBcb/JhCAMNnfkw
	 XjRcfUHuUlWZOSb1we8hSa4yVl8inxXUxhZ3qrlOBISTWIixTGCrO+lOM+A91ZqhIl
	 /a+aQrPwXMbtAjaNvbPrO661U3dDIslPQoIOSRILrsH9FHS8QZJYg3t7XbyH6zGTcf
	 X6097rWvgwXwNdjJfz69LpkJAVdRkIqXQ3m0Y0uIvP3ZBo0ZU07Y6C+5M7xlILLhPm
	 XhM3gkC6wJqYw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C9EC6E49F61;
	Fri, 12 May 2023 01:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: enc28j60: Use threaded interrupt instead of
 workqueue
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168385382182.13567.17908827053703617655.git-patchwork-notify@kernel.org>
Date: Fri, 12 May 2023 01:10:21 +0000
References: <342380d989ce26bc49f0e5d45fbb0416a5f7809f.1683606193.git.lukas@wunner.de>
In-Reply-To: <342380d989ce26bc49f0e5d45fbb0416a5f7809f.1683606193.git.lukas@wunner.de>
To: Lukas Wunner <lukas@wunner.de>
Cc: davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
 pabeni@redhat.com, netdev@vger.kernel.org, p.rosenberger@kunbus.com,
 hanzhi09@gmail.com

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 9 May 2023 06:28:56 +0200 you wrote:
> From: Philipp Rosenberger <p.rosenberger@kunbus.com>
> 
> The Microchip ENC28J60 SPI Ethernet driver schedules a work item from
> the interrupt handler because accesses to the SPI bus may sleep.
> 
> On PREEMPT_RT (which forces interrupt handling into threads) this
> old-fashioned approach unnecessarily increases latency because an
> interrupt results in first waking the interrupt thread, then scheduling
> the work item.  So, a double indirection to handle an interrupt.
> 
> [...]

Here is the summary with links:
  - [net-next] net: enc28j60: Use threaded interrupt instead of workqueue
    https://git.kernel.org/netdev/net-next/c/995585ecdf42

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



