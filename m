Return-Path: <netdev+bounces-9366-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id CBC187289FA
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 23:10:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 2F606281768
	for <lists+netdev@lfdr.de>; Thu,  8 Jun 2023 21:10:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 461C634475;
	Thu,  8 Jun 2023 21:10:25 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id D6E262D279
	for <netdev@vger.kernel.org>; Thu,  8 Jun 2023 21:10:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 42A90C433EF;
	Thu,  8 Jun 2023 21:10:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686258623;
	bh=hzDZmhOS74HCc6niY6csKlNbHoPH+pWVWXObmcq9ULg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=bAJ1K5oq15e9GMHQ+P0MLtRG7Yg+X/NKekgyCiqh4QCq51Dbz4nVfpyCxDjGsGF9k
	 Dr8N4evrNHukHXh/E03jDU6SvVyESjZ+44Yx0XkX3ax6nNgvbqfkgCaiQ4BejuDv2R
	 ihhSgv8dFUOcUuDjgq5g76fuPCuu83kcG/I+vNPdqXP86O19P0y1lz3WPp2v0lRqQm
	 wXQchrL40iTpIPIEGgzKE4O/n5Wjust6yzw5cr7Jtu0B14pKkgNkij0rTIzs+LHmWK
	 sB9r3SmWnwVpXSd5/nZIvfMg6pkL7STkWOBXBnEN7Wg1PuEL9mgFpbYwe2XGvsrI7G
	 VQZ0BZxsosdGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1E4A6E49FA3;
	Thu,  8 Jun 2023 21:10:23 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/11] tools: ynl: generate code for the devlink
 family
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168625862311.22404.18384932380225543261.git-patchwork-notify@kernel.org>
Date: Thu, 08 Jun 2023 21:10:23 +0000
References: <20230607202403.1089925-1-kuba@kernel.org>
In-Reply-To: <20230607202403.1089925-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, jiri@resnulli.us

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  7 Jun 2023 13:23:52 -0700 you wrote:
> Another chunk of changes to support more capabilities in the YNL
> code gen. Devlink brings in deep nesting and directional messages
> (requests and responses have different IDs). We need a healthy
> dose of codegen changes to support those (I wasn't planning to
> support code gen for "directional" families initially, but
> the importance of devlink and ethtool is undeniable).
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] netlink: specs: devlink: fill in some details important for C
    https://git.kernel.org/netdev/net-next/c/8947e5037371
  - [net-next,02/11] tools: ynl-gen: use enum names in op strmap more carefully
    https://git.kernel.org/netdev/net-next/c/9858bfc271de
  - [net-next,03/11] tools: ynl-gen: refactor strmap helper generation
    https://git.kernel.org/netdev/net-next/c/6f115d4575ab
  - [net-next,04/11] tools: ynl-gen: enable code gen for directional specs
    https://git.kernel.org/netdev/net-next/c/ff6db4b58c93
  - [net-next,05/11] tools: ynl-gen: try to sort the types more intelligently
    https://git.kernel.org/netdev/net-next/c/6afaa0ef9b0e
  - [net-next,06/11] tools: ynl-gen: inherit struct use info
    https://git.kernel.org/netdev/net-next/c/37487f93b125
  - [net-next,07/11] tools: ynl-gen: walk nested types in depth
    https://git.kernel.org/netdev/net-next/c/eae7af21bdb9
  - [net-next,08/11] tools: ynl-gen: don't generate forward declarations for policies
    https://git.kernel.org/netdev/net-next/c/168dea20ecef
  - [net-next,09/11] tools: ynl-gen: don't generate forward declarations for policies - regen
    https://git.kernel.org/netdev/net-next/c/0a9471219672
  - [net-next,10/11] tools: ynl: generate code for the devlink family
    https://git.kernel.org/netdev/net-next/c/5d1a30eb989a
  - [net-next,11/11] tools: ynl: add sample for devlink
    https://git.kernel.org/netdev/net-next/c/fff8660b5425

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



