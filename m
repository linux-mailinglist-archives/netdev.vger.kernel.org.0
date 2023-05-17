Return-Path: <netdev+bounces-3326-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from ny.mirrors.kernel.org (ny.mirrors.kernel.org [IPv6:2604:1380:45d1:ec00::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9591D706758
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 14:00:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by ny.mirrors.kernel.org (Postfix) with ESMTPS id 96A3C1C20B76
	for <lists+netdev@lfdr.de>; Wed, 17 May 2023 12:00:21 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id DD0532C74A;
	Wed, 17 May 2023 12:00:21 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 66B9E211C
	for <netdev@vger.kernel.org>; Wed, 17 May 2023 12:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 38DFCC433EF;
	Wed, 17 May 2023 12:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1684324820;
	bh=6QOv+KV7ott/jI5w0fGHd1rqlaUgjU3+ndOQiznEEVU=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=ahCQSwEfkd+NyUedQBS/5DSAqvcuRarmSvxXFArpM4f1Zo22SZ8ot5Vzjrp2+8E5q
	 qs0sEXndNcVZ+8WfCa9C/rfwCEGkjqCStgmdWlKhYWrg8wEPVCdHGZTMEjA3ar0CWA
	 SwuQ0otrDEKQPDbe1dWJAMce6S0syEg58zavO/i/4MbelP8na4orNbXfYNGFdhU0oP
	 YpEfuCGne5Umt+yznJXwGElKI/Rq5fBKAT9cAfXRQWQkRJdgkzmVyJkO3s/AJTpiTR
	 rW/ujuYPrRePdY/jliFJXBrTP2csCEG50ZOX80PR3VleoFy/KQmUyni3osSyshf7CY
	 /mxXmaTucx0Zw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 242D6E54228;
	Wed, 17 May 2023 12:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] vlan: fix a potential uninit-value in
 vlan_dev_hard_start_xmit()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168432482014.30872.16293912678961566657.git-patchwork-notify@kernel.org>
Date: Wed, 17 May 2023 12:00:20 +0000
References: <20230516142342.2915501-1-edumazet@google.com>
In-Reply-To: <20230516142342.2915501-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, eric.dumazet@gmail.com, syzkaller@googlegroups.com

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Tue, 16 May 2023 14:23:42 +0000 you wrote:
> syzbot triggered the following splat [1], sending an empty message
> through pppoe_sendmsg().
> 
> When VLAN_FLAG_REORDER_HDR flag is set, vlan_dev_hard_header()
> does not push extra bytes for the VLAN header, because vlan is offloaded.
> 
> Unfortunately vlan_dev_hard_start_xmit() first reads veth->h_vlan_proto
> before testing (vlan->flags & VLAN_FLAG_REORDER_HDR).
> 
> [...]

Here is the summary with links:
  - [net] vlan: fix a potential uninit-value in vlan_dev_hard_start_xmit()
    https://git.kernel.org/netdev/net/c/dacab578c7c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



