Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E471B2DA6AF
	for <lists+netdev@lfdr.de>; Tue, 15 Dec 2020 04:17:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726499AbgLODRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Dec 2020 22:17:33 -0500
Received: from mail.kernel.org ([198.145.29.99]:36506 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727967AbgLODMb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 14 Dec 2020 22:12:31 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608001848;
        bh=TdbuvnYRHcjFAPRd+U0fy6suP8KFnFlq93aX1xvthMc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kwWNHUvUYW+ZD9ynmyDSu1EZg5oYClADLB9IjCc772bI2cHesSwkj6G3jtPTY5uJY
         18e+WlDunCPnwCML5dGX/6qcVJpkWpW96CzYpZ9nzgv3fd6mQ5qne296g3iVSEqNwY
         cSMyNnvuD8A48vYgIaPyF28z4ycBY+r6KvLUZGBPx4FqGAdqde7fVzgP0SkR5TzTz7
         vf0+UHLlGLsTx09BnEm5nn0YjfZFaA7pu61rO4NoNtinkYq7g7e6sQeNs4Anh5FRgj
         t3ot0OH9RU2tKn6uR0Ys6xTomaI4l8j6j9DcoZOowHMEwxI49GWZ9E2tDjCGNC6g/x
         hSEZdqs29Vtag==
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] inet_ecn: Use csum16_add() helper for
 IP_ECN_set_* helpers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160800184810.22481.8355588003609867021.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Dec 2020 03:10:48 +0000
References: <20201211142638.154780-1-toke@redhat.com>
In-Reply-To: <20201211142638.154780-1-toke@redhat.com>
To:     =?utf-8?b?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2VuIDx0b2tlQHJlZGhhdC5jb20+?=@ci.codeaurora.org
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        chromatix99@gmail.com, pete@heistp.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri, 11 Dec 2020 15:26:38 +0100 you wrote:
> Jakub pointed out that the IP_ECN_set* helpers basically open-code
> csum16_add(), so let's switch them over to using the helper instead.
> 
> v2:
> - Use __be16 for check_add stack variable in IP_ECN_set_ce() (kbot)
> v3:
> - Turns out we need __force casts to do arithmetic on __be16 types
> 
> [...]

Here is the summary with links:
  - [net-next,v3] inet_ecn: Use csum16_add() helper for IP_ECN_set_* helpers
    https://git.kernel.org/netdev/net-next/c/0780b4145634

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


