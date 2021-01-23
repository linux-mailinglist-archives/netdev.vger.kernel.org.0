Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38784301294
	for <lists+netdev@lfdr.de>; Sat, 23 Jan 2021 04:21:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726512AbhAWDUv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jan 2021 22:20:51 -0500
Received: from mail.kernel.org ([198.145.29.99]:45896 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726013AbhAWDUu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Jan 2021 22:20:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 9CDDA23B1F;
        Sat, 23 Jan 2021 03:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611372009;
        bh=IkYeoChj4CQkUTXFcn+omAqTEVCNWaauc0FqaFfemGQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZKtUM9v60Q7vne2EN4WF4P88bDLJuxkta0NfwuNzb64xOEC5WEj87VMxA2Dr90/Cn
         gyKFt4+P0J8yAYP6vk+G3IhKYWWXroketp/3/httd1hxJVbcsvNTK1Xte3impdSdQG
         6rG/g9dIm/Rqxb7j+CkryBRyaO83CzfsVdFN7h1IcPdjafN1J+LYonrQ8kBYi1PhlH
         ECo7D7lt5YqaL+KIiLG3XK/klb32iHOSy2aJNwK2QJvGDxUAD6AU+w0JQ6Ls+cKXD3
         VYsc0obuu+YYUo3bQxII2/LGrsHShPszENn7iM1mgqhEzZHIEZkR6Bg4b6GK3yknhN
         xk7WnnORUzVFA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 91DA8652DA;
        Sat, 23 Jan 2021 03:20:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: add TTL to SCM_TIMESTAMPING_OPT_STATS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161137200959.26578.14381066986651927132.git-patchwork-notify@kernel.org>
Date:   Sat, 23 Jan 2021 03:20:09 +0000
References: <20210120204155.552275-1-ysseung@google.com>
In-Reply-To: <20210120204155.552275-1-ysseung@google.com>
To:     Yousuk Seung <ysseung@google.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        ncardwell@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 20 Jan 2021 12:41:55 -0800 you wrote:
> This patch adds TCP_NLA_TTL to SCM_TIMESTAMPING_OPT_STATS that exports
> the time-to-live or hop limit of the latest incoming packet with
> SCM_TSTAMP_ACK. The value exported may not be from the packet that acks
> the sequence when incoming packets are aggregated. Exporting the
> time-to-live or hop limit value of incoming packets helps to estimate
> the hop count of the path of the flow that may change over time.
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: add TTL to SCM_TIMESTAMPING_OPT_STATS
    https://git.kernel.org/netdev/net-next/c/e7ed11ee9454

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


