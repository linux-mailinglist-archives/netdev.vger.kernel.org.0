Return-Path: <netdev+bounces-11010-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 449D1731158
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 09:50:43 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id F1C182816DF
	for <lists+netdev@lfdr.de>; Thu, 15 Jun 2023 07:50:41 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 41EE12117;
	Thu, 15 Jun 2023 07:50:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 216A12109
	for <netdev@vger.kernel.org>; Thu, 15 Jun 2023 07:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D714BC433CB;
	Thu, 15 Jun 2023 07:50:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1686815420;
	bh=7aieeTRa7tPR/AovRdkyWP6vwFoOiXMYrREul/dUktw=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=KaO4ivuTxOmMf7ybLoQx1bmXaLNiH/uTGWgnDEaqdX0QW+3GCGF8TtmMFVbPo8KGo
	 9qHU9Ral6oLtc/WrJKrRnIleatBB2rz2BKiGxzt+TQzT8Pek2ecoVwA0mhF3ghiGYU
	 l3VpJgjWAu+b1Ba1gxVjRlc6KuNapwbvYD9/9WXN2wFVR8/lXu0GrX+8VRwS6L14i4
	 Vm67kE53O0E3fjQ83nADdy29o4OajwJ4mDiVjpDIP4JpgU2UQYOv/W4b69CJ+h0mM9
	 5C+kwSxi0aO6CW9PZna5zMnc9cjS5T8bcZBi8kvMwEey1kS1mPVxP1Ae4pEIs25kwV
	 G3SU/kb2mqf0w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B7D3EC395C7;
	Thu, 15 Jun 2023 07:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] net: create device lookup API with reference
 tracking
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168681542074.22382.15571029013760079421.git-patchwork-notify@kernel.org>
Date: Thu, 15 Jun 2023 07:50:20 +0000
References: <20230612214944.1837648-1-kuba@kernel.org>
In-Reply-To: <20230612214944.1837648-1-kuba@kernel.org>
To: Jakub Kicinski <kuba@kernel.org>
Cc: davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
 pabeni@redhat.com, dsahern@gmail.com

Hello:

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Mon, 12 Jun 2023 14:49:42 -0700 you wrote:
> We still see dev_hold() / dev_put() calls without reference tracker
> getting added in new code. dev_get_by_name() / dev_get_by_index()
> seem to be one of the sources of those. Provide appropriate helpers.
> Allocating the tracker can obviously be done with an additional call
> to netdev_tracker_alloc(), but a single API feels cleaner.
> 
> v2:
>  - fix a dev_put() in ethtool
> v1: https://lore.kernel.org/all/20230609183207.1466075-1-kuba@kernel.org/
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: create device lookup API with reference tracking
    (no matching commit)
  - [net-next,v2,2/2] netpoll: allocate netdev tracker right away
    https://git.kernel.org/netdev/net-next/c/48eed027d310

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



