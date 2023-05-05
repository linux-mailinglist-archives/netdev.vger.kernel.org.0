Return-Path: <netdev+bounces-526-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id CB4796F7F47
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 10:41:40 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 875D8280F60
	for <lists+netdev@lfdr.de>; Fri,  5 May 2023 08:41:39 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id E0AA779D8;
	Fri,  5 May 2023 08:40:23 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 5F77F5386;
	Fri,  5 May 2023 08:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F0E4EC433AA;
	Fri,  5 May 2023 08:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1683276020;
	bh=bebRVNhzgwIPztnh171SZ71+mdgzFplV8Peuz7/+N4k=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=k/lV4KwCAfgmIc6EA85TKiIObphiOmwPHxxPpwAKTAX0pISjLFwU9/HCdn227Q2L4
	 VyRwhymYhnABsh1tRNbudkDWy4cs8CiIF/E+6IZG2atsBVj0DWJjM2p6v7A8TD5veS
	 48+ND4qN2p33hifg0LWZ2qELwu6aHV7iCKkUjKl5z5A9DQDmJ8kShpTUzME6LOA5m4
	 TwubHzhSiQi7GmxdJVXSqrdab6o4By2uqKOkibW86gAOQL7P7P9nlh6yhvuFNEH7Iz
	 hv70EV1e/IDnDlan5gVir3NEiEXzfNyZOsu0x31JjzHSGQGtj3eemhp1Nlr/KnAOMQ
	 j+1k0qrRjOnDA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DC1EFE5FFC9;
	Fri,  5 May 2023 08:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net] bonding: add xdp_features support
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168327601989.11276.13964453810908332063.git-patchwork-notify@kernel.org>
Date: Fri, 05 May 2023 08:40:19 +0000
References: <5969591cfc2336e45de08e1d272bdcee30942fb7.1683191281.git.lorenzo@kernel.org>
In-Reply-To: <5969591cfc2336e45de08e1d272bdcee30942fb7.1683191281.git.lorenzo@kernel.org>
To: Lorenzo Bianconi <lorenzo@kernel.org>
Cc: netdev@vger.kernel.org, lorenzo.bianconi@redhat.com, j.vosburgh@gmail.com,
 andy@greyhouse.net, davem@davemloft.net, edumazet@google.com,
 kuba@kernel.org, pabeni@redhat.com, bpf@vger.kernel.org, andrii@kernel.org,
 mykolal@fb.com, ast@kernel.org, daniel@iogearbox.net, martin.lau@linux.dev,
 alardam@gmail.com, memxor@gmail.com, sdf@google.com, brouer@redhat.com,
 toke@redhat.com, joamaki@gmail.com

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Thu,  4 May 2023 11:52:49 +0200 you wrote:
> Introduce xdp_features support for bonding driver according to the slave
> devices attached to the master one. xdp_features is required whenever we
> want to xdp_redirect traffic into a bond device and then into selected
> slaves attached to it.
> 
> Reviewed-by: Simon Horman <simon.horman@corigine.com>
> Acked-by: Jay Vosburgh <jay.vosburgh@canonical.com>
> Fixes: 66c0e13ad236 ("drivers: net: turn on XDP features")
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> 
> [...]

Here is the summary with links:
  - [v3,net] bonding: add xdp_features support
    https://git.kernel.org/netdev/net-next/c/cb9e6e584d58

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



