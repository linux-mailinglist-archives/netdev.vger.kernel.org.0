Return-Path: <netdev+bounces-11775-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id DA443734667
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 15:40:24 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 80DC428115F
	for <lists+netdev@lfdr.de>; Sun, 18 Jun 2023 13:40:23 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 4F66D184C;
	Sun, 18 Jun 2023 13:40:22 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from smtp.kernel.org (aws-us-west-2-korg-mail-1.web.codeaurora.org [10.30.226.201])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id 0887A1FB1
	for <netdev@vger.kernel.org>; Sun, 18 Jun 2023 13:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7FC6AC433CA;
	Sun, 18 Jun 2023 13:40:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
	s=k20201202; t=1687095620;
	bh=ksBY58pUUPLXq9Scdwe047QCRQQppi1I9NYOg0WmnBg=;
	h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
	b=N53GSca7DMDmOSeuyU9fwOwkBVdwgII9gF5euxqm3pHcLU+CRB0LkRJmnAg8y/88P
	 381RbzL7Xv1eW9ywbJrhtEPbPtdj+ODWkN2Fq/r4Cd0zf9pmSmA7+PqNrjpBDvkFnd
	 jkJdT7uD9c1qBabdF4JKEdB12kuq1+GPmI1DWpKpHz3f7AHKy7T8R2nziM1fRX0doi
	 Gy7NUKGbRLEBrC2/uqXogAH1/3cQxMlEJvUpGRFsk6ITIWbRHPtOYRc+MZCCR2odCK
	 /jiAxEACblGeKZCmbWhvWOLMG8/xr0klhrPlarMJyR3Llu2szAqWb694bMHhVsTibZ
	 +Md4Z+RST8S5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
	by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5E4D7E29F3A;
	Sun, 18 Jun 2023 13:40:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ipv6: also use netdev_hold() in ip6_route_check_nh()
From: patchwork-bot+netdevbpf@kernel.org
Message-Id: 
 <168709562038.22941.13973849280942177014.git-patchwork-notify@kernel.org>
Date: Sun, 18 Jun 2023 13:40:20 +0000
References: <20230616085752.3348131-1-edumazet@google.com>
In-Reply-To: <20230616085752.3348131-1-edumazet@google.com>
To: Eric Dumazet <edumazet@google.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
 netdev@vger.kernel.org, eric.dumazet@gmail.com, syzkaller@googlegroups.com,
 dsahern@kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 16 Jun 2023 08:57:52 +0000 you wrote:
> In blamed commit, we missed the fact that ip6_validate_gw()
> could change dev under us from ip6_route_check_nh()
> 
> In this fix, I use GFP_ATOMIC in order to not pass too many additional
> arguments to ip6_validate_gw() and ip6_route_check_nh() only
> for a rarely used debug feature.
> 
> [...]

Here is the summary with links:
  - [net-next] ipv6: also use netdev_hold() in ip6_route_check_nh()
    https://git.kernel.org/netdev/net-next/c/3515440df461

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html



