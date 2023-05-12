Return-Path: <netdev+bounces-2066-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [147.75.199.223])
	by mail.lfdr.de (Postfix) with ESMTPS id 98231700282
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 10:30:25 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 6E3A71C2113C
	for <lists+netdev@lfdr.de>; Fri, 12 May 2023 08:30:22 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id B1DB3EDA;
	Fri, 12 May 2023 08:30:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0C63EBA47
	for <netdev@vger.kernel.org>; Fri, 12 May 2023 08:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A80E2C4339B;
	Fri, 12 May 2023 08:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683880220;
	bh=8xKLdXOahEVeWe/nnP1C8VNUIukSGkOc5IsoLGF4QRQ=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=bq9S6lbVrPvGry5V+voG+sRr9Xb7PY2R3YX1secaalKfbki8VMyqJfernxPksurFt
	 b74k1zj5uyJkwIF6imnOhCEVW5QU6ERPuhK/XJcyR2jaVuhIdCiVO2Uuwwu9ShMtUL
	 ZK4gYw4F7blUcuPM53VhksLGAlW638GcEJfLcvu5oxbstpulZLO6NZYGr2a8rn2xAN
	 JwAKiDXriWLyTWgXBszvFckpl1sWHJIEWWCjE3OdMJHIMeNKtRHw2cImmu7YjBHMA3
	 yrXDkyhwtKC8q1BhVOSMBQB7d4Rl24RS0V7mHF+rrEXlrL0S+tsAbqKtjSlN/FKoRy
	 +2fTP1I/8nkIA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8923AE26D2A;
	Fri, 12 May 2023 08:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] ice: Fix undersized tx_flags variable
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168388022055.32195.11176038688986628299.git-patchwork-notify@kernel.org>
Date: Fri, 12 May 2023 08:30:20 +0000
References: <20230511155319.3424211-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20230511155319.3424211-1-anthony.l.nguyen@intel.com>
To: Tony Nguyen <anthony.l.nguyen@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 edumazet@google.com, netdev@vger.kernel.org, jan.sokolowski@intel.com,
 maciej.fijalkowski@intel.com, daniel@iogearbox.net, mschmidt@redhat.com,
 simon.horman@corigine.com, aleksander.lobakin@intel.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu, 11 May 2023 08:53:19 -0700 you wrote:
> From: Jan Sokolowski <jan.sokolowski@intel.com>
> 
> As not all ICE_TX_FLAGS_* fit in current 16-bit limited
> tx_flags field that was introduced in the Fixes commit,
> VLAN-related information would be discarded completely.
> As such, creating a vlan and trying to run ping through
> would result in no traffic passing.
> 
> [...]

Here is the summary with links:
  - [net,v2] ice: Fix undersized tx_flags variable
    https://git.kernel.org/netdev/net/c/9113302bb43c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



