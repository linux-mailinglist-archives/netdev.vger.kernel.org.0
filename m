Return-Path: <netdev+bounces-4851-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 828D570EC1A
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 05:50:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 17351281171
	for <lists+netdev@lfdr.de>; Wed, 24 May 2023 03:50:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 3EF6315B3;
	Wed, 24 May 2023 03:50:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id BEA5DEC2
	for <netdev@vger.kernel.org>; Wed, 24 May 2023 03:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 672A6C4339B;
	Wed, 24 May 2023 03:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684900219;
	bh=DbQdca9+4F4QVagpm9i5Mc3AN2K1FbZgMbSjkXHJ7mw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=Viv+VZmwdkPdYdwNAJRs/YMNvbHzutc08Bn24xxigyVthXX/T/vgIDjty/RqC026a
	 9lDCivaftqXmiw3lKPi5FiulBWUaB+C6GsVyZxPxnqIpme+1lhQCieSHMn7E6eYQGu
	 /tbsgFzb4IQ7yKLNjEB7lxHJLOYelqZonWohxx/wdwYHkrKxYu3SfWCWkPXzhP2Jkn
	 ql/7swZcTNCurZTsE6kocA7bzjEtz1KsNK71BndKuE0V/lNdkY8cb/rIPzOG41U+JE
	 txxgqrBtw1ddcAypOOAs9sBXEVGxCKub+Z3NmWQsUjohhC2cPFkliuNPbFYgoex/8F
	 OymkwgBrh8qlA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 48147C395F8;
	Wed, 24 May 2023 03:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] r8169: Use a raw_spinlock_t for the register locks.
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168490021929.7545.5401674402592156945.git-patchwork-notify@kernel.org>
Date: Wed, 24 May 2023 03:50:19 +0000
References: <20230522134121.uxjax0F5@linutronix.de>
In-Reply-To: <20230522134121.uxjax0F5@linutronix.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc: netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
 hkallweit1@gmail.com, kuba@kernel.org, efault@gmx.de, pabeni@redhat.com,
 tglx@linutronix.de, nic_swsd@realtek.com

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 22 May 2023 15:41:21 +0200 you wrote:
> The driver's interrupt service routine is requested with the
> IRQF_NO_THREAD if MSI is available. This means that the routine is
> invoked in hardirq context even on PREEMPT_RT. The routine itself is
> relatively short and schedules a worker, performs register access and
> schedules NAPI. On PREEMPT_RT, scheduling NAPI from hardirq results in
> waking ksoftirqd for further processing so using NAPI threads with this
> driver is highly recommended since it NULL routes the threaded-IRQ
> efforts.
> 
> [...]

Here is the summary with links:
  - [net-next] r8169: Use a raw_spinlock_t for the register locks.
    https://git.kernel.org/netdev/net/c/d6c36cbc5e53

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



