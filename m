Return-Path: <netdev+bounces-5502-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 8C95B711EA7
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 06:10:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 0A19B1C20F66
	for <lists+netdev@lfdr.de>; Fri, 26 May 2023 04:10:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F3D1210C;
	Fri, 26 May 2023 04:10:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 3470F1C26
	for <netdev@vger.kernel.org>; Fri, 26 May 2023 04:10:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D4CBFC433EF;
	Fri, 26 May 2023 04:10:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1685074220;
	bh=S03/rwZFU6ZANAPN65OkpbucS7R0TOCqSSv+r+OkvsA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=EoHzLUFX2B6CMm0aydljKeLRcNV6To7uUaFXk9SQ+b8o5RuK+hD3YxiTlHzKDJJF1
	 LjGOgsynNJtMUOMaHonh/ULSGH2dGbWp9zWZpt4rLe3+8i2mKTvweVdaCNVjJd85KH
	 eqM6SW/sKLrT1VviQJKZ22iuBnNdVNgamyzTmA6xWPt2s3U40G78lPQfXYmwD0j+zl
	 i4GSko8GBSaHaNSw5z+jyFe5b4fY71VeL3b0VKyZBeiudn3NYcFE5HzeHq6QHp5864
	 v6LnAU6IATgKWexeuWrL2hODI9fbnpvd8lQHqrbfa8QpuW0UIUu/r2jhDqCYZqZMsK
	 ZULadeKYThBzQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BCF08E22B06;
	Fri, 26 May 2023 04:10:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] netrom: fix info-leak in nr_write_internal()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168507422076.22221.12261922662684960346.git-patchwork-notify@kernel.org>
Date: Fri, 26 May 2023 04:10:20 +0000
References: <20230524141456.1045467-1-edumazet@google.com>
In-Reply-To: <20230524141456.1045467-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, eric.dumazet@gmail.com, szymon@kapadia.pl

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 May 2023 14:14:56 +0000 you wrote:
> Simon Kapadia reported the following issue:
> 
> <quote>
> 
> The Online Amateur Radio Community (OARC) has recently been experimenting
> with building a nationwide packet network in the UK.
> As part of our experimentation, we have been testing out packet on 300bps HF,
> and playing with net/rom.  For HF packet at this baud rate you really need
> to make sure that your MTU is relatively low; AX.25 suggests a PACLEN of 60,
> and a net/rom PACLEN of 40 to go with that.
> However the Linux net/rom support didn't work with a low PACLEN;
> the mkiss module would truncate packets if you set the PACLEN below about 200 or so, e.g.:
> 
> [...]

Here is the summary with links:
  - [net] netrom: fix info-leak in nr_write_internal()
    https://git.kernel.org/netdev/net/c/31642e7089df

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



