Return-Path: <netdev+bounces-1964-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [139.178.88.99])
	by mail.lfdr.de (Postfix) with ESMTPS id 81B016FFBC7
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 23:20:28 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 3926128195F
	for <lists+netdev@lfdr.de>; Thu, 11 May 2023 21:20:27 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 16E66174DC;
	Thu, 11 May 2023 21:20:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id A1A1912B86
	for <netdev@vger.kernel.org>; Thu, 11 May 2023 21:20:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 509AAC433D2;
	Thu, 11 May 2023 21:20:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683840021;
	bh=Y9nJtDNy9jLa17i94QrIMshchhJC8BF9zoQ9N8u3QIs=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=vPWW/SCdGXGnMbIegwS+ng0bc24uts+dBd/cZZ6QOSVgfVHp5WOzYTZT+5mr2PIVd
	 Ly9q2kNHHlnnRaT+6VCbPKb59igaNw2jySQuSu1X8BP3EDgAt1zjy9OQbN0+WBg4+S
	 m9CyyrauGsqbQ0IEqc+Jzw4ba7M0Z7NFUZkCpFEO79hIvB0efVPPTK8yebebmEo3tu
	 GfZbIAFLSUZ5zlcBNwAZIAH6GrdCb+Lw6wdmsjNQkNtrJHnzt5goEhddWLfb2sb6IF
	 DJaj2msKTjTxhHjonV6Cc8HQLkADkJIW59+QKMJyzX/Q3piL3V97CrzbUAfISF1pHz
	 /9XkdjyCdS8ow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 36545E4D011;
	Thu, 11 May 2023 21:20:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] iproute2: optimize code and fix some mem-leak risk
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168384002121.32472.18227250102851292214.git-patchwork-notify@kernel.org>
Date: Thu, 11 May 2023 21:20:21 +0000
References: <20230511003726.32443-2-izhaoshuang@163.com>
In-Reply-To: <20230511003726.32443-2-izhaoshuang@163.com>
To: zhaoshuang <izhaoshuang@163.com>
Cc: pawel.chmielewski@intel.com, netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Thu, 11 May 2023 08:37:26 +0800 you wrote:
> From: zhaoshuang <zhaoshuang@uniontech.com>
> 
> Signed-off-by: zhaoshuang <izhaoshuang@163.com>
> ---
>  bridge/mdb.c      |  4 ++++
>  devlink/devlink.c | 21 +++++++++------------
>  ip/ipaddrlabel.c  |  1 +
>  ip/ipfou.c        |  1 +
>  ip/ipila.c        |  1 +
>  ip/ipnetconf.c    |  1 +
>  ip/ipnexthop.c    |  4 ++++
>  ip/iproute.c      |  6 ++++++
>  ip/iprule.c       |  1 +
>  ip/iptuntap.c     |  1 +
>  ip/tunnel.c       |  2 ++
>  tc/tc_class.c     |  1 +
>  tc/tc_filter.c    |  1 +
>  tc/tc_qdisc.c     |  1 +
>  14 files changed, 34 insertions(+), 12 deletions(-)

Here is the summary with links:
  - iproute2: optimize code and fix some mem-leak risk
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=7e8cdfa2eac5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



