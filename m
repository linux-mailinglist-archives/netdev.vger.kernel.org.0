Return-Path: <netdev+bounces-12144-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 00F19736680
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 10:40:42 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 331A71C20BAE
	for <lists+netdev@lfdr.de>; Tue, 20 Jun 2023 08:40:42 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 31B11AD56;
	Tue, 20 Jun 2023 08:40:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id C6751848A
	for <netdev@vger.kernel.org>; Tue, 20 Jun 2023 08:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 914FDC433C9;
	Tue, 20 Jun 2023 08:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687250421;
	bh=STn26UReOdww+gFkvsGcZseosgz8Mkk/DE9VpCXMDcE=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=iPnFzEpavGuXn1Fxxqhmwcf+EkhEUoA49Rn68EQgHOmM7fu9HpgK/wc+l1tN9p92/
	 xooSuJxdO8rouy0Np0titl1n3yycrdqglfd5veXKtRQD2X+SNdf/JGXCr6ts4dNYr1
	 lwHlHXnnOlq6V+afSkxPPYXzI4s0fIz392oyK1uZxAQydru+JLJCvZlKZRslGep6f7
	 M+VmdruPB2BMpW+POPUf4TddmHmnmUzFACqSpe43HnOy6JA/++WR4bU7bls90kHC4L
	 Xl3vJsGUZBhBVDfebiC40kcSKSe/cIE8mfCCqRPOG43wZMfDLXrFULRBq6LmLrsyQo
	 oyRcXKZHxK+lg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 738BAC43157;
	Tue, 20 Jun 2023 08:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: ieee802154 for net 2023-06-19
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168725042146.7255.2793148637060076867.git-patchwork-notify@kernel.org>
Date: Tue, 20 Jun 2023 08:40:21 +0000
References: <20230619070927.825332-1-stefan@datenfreihafen.org>
In-Reply-To: <20230619070927.825332-1-stefan@datenfreihafen.org>
To: Stefan Schmidt <stefan@datenfreihafen.org>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 linux-wpan@vger.kernel.org, alex.aring@gmail.com, miquel.raynal@bootlin.com,
 netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 19 Jun 2023 09:09:27 +0200 you wrote:
> Hello Dave, Jakub, Paolo.
> 
> An update from ieee802154 for your *net* tree:
> 
> Two small fixes and MAINTAINERS update this time.
> 
> Azeem Shaikh ensured consistent use of strscpy through the tree and fixed
> the usage in our trace.h.
> 
> [...]

Here is the summary with links:
  - pull-request: ieee802154 for net 2023-06-19
    https://git.kernel.org/netdev/net/c/8340eef98d45

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



