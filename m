Return-Path: <netdev+bounces-1398-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id A40846FDAF4
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 11:41:49 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 8D2C41C20C50
	for <lists+netdev@lfdr.de>; Wed, 10 May 2023 09:41:46 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 803556FDE;
	Wed, 10 May 2023 09:40:24 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 415926AC0
	for <netdev@vger.kernel.org>; Wed, 10 May 2023 09:40:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D28C1C433D2;
	Wed, 10 May 2023 09:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683711621;
	bh=i813gVwW0eh94Hd0e9c4CgUV/9xwc/BrxxEBD+CKKdA=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=NBgL9grkPb/ZTnmxNLJb31JSvXfjPp4ctudvrekaFEBvtxWCLCP6YqU+GsqCTjd9O
	 1XvRJAYv+wSdTN1r5tLgLCK7oiHjlRpVyNFcXkvl6q7kRROhS6TtLHheVYyaZvu3Gx
	 6PFRYzYfRO5cIuAtO8TCKKXjBSYV/XeV8xItUZvfwNQAB65V96tslV+l4pP/UgPoDq
	 yMojXDyz2FbD6+1CTzBnsNWsGYAu4yJiWJFy8N1t6cv4XZIzTMzoMsl2WmXbMm04NT
	 I21opM3P420uSBoiEqa2u2Swg2F3tG928pWZeOPSqmHod1RAe92RjswM/S2e2iFyYP
	 93Y+lWJeX11GA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B6C7DE270C4;
	Wed, 10 May 2023 09:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] docs: networking: fix x25-iface.rst heading & index order
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168371162174.29703.9835991823894241053.git-patchwork-notify@kernel.org>
Date: Wed, 10 May 2023 09:40:21 +0000
References: <20230510022914.2230-1-rdunlap@infradead.org>
In-Reply-To: <20230510022914.2230-1-rdunlap@infradead.org>
To: Randy Dunlap <rdunlap@infradead.org>
Cc: netdev@vger.kernel.org, mchehab@kernel.org, davem@davemloft.net,
 edumazet@google.com, kuba@kernel.org, pabeni@redhat.com, corbet@lwn.net,
 linux-doc@vger.kernel.org, ms@dev.tdt.de, linux-x25@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue,  9 May 2023 19:29:14 -0700 you wrote:
> Fix the chapter heading for "X.25 Device Driver Interface" so that it
> does not contain a trailing '-' character, which makes Sphinx
> omit this heading from the contents.
> 
> Reverse the order of the x25.rst and x25-iface.rst files in the index
> so that the project introduction (x25.rst) comes first.
> 
> [...]

Here is the summary with links:
  - docs: networking: fix x25-iface.rst heading & index order
    https://git.kernel.org/netdev/net/c/77c964dad99a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



