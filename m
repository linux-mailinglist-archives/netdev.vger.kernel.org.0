Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA30D3B3585
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 20:20:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232546AbhFXSWZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 14:22:25 -0400
Received: from mail.kernel.org ([198.145.29.99]:56614 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232537AbhFXSWX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 24 Jun 2021 14:22:23 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 01E2A613CE;
        Thu, 24 Jun 2021 18:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624558804;
        bh=rdy2CjLrM3zFnLkMIvUODTRlsEtPqQwdOYK6lAR/aO4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hjMCfIO/y2xRp++TbM3fVTI+4YMQMBCOJfKQC/4nTaFWMayvnzRoW/wewUtDQKsEf
         zqaJLZLkWmqJg4zcbejUxJSjz/WKQLc1sh+jHxH60bQLtmf3PED6YdGrIvC0FgAlcg
         gShtBzabCG3WikHi9xo4peXFAZ0ftWDOyJ0d43vibBt0IMYzpOFh5hv05LtDBPPwqk
         Yd4wETkZ5iwsoVa0XfVeXBioYweYEM11fNetwS6js/n1UGeaCKrCDOdsNbC/vkgQQI
         wbOozqxCDCc5DkDz67RIPYzPLjBb3f2LfQHUrwXkPa6484S/8ZKibS6Usf3m2Uw2OR
         9BHzjNcJyiDtw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E3FF860ACA;
        Thu, 24 Jun 2021 18:20:03 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4] net: ip: avoid OOM kills with large UDP sends
 over loopback
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162455880392.31056.12656441466683804186.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Jun 2021 18:20:03 +0000
References: <20210623214438.2276538-1-kuba@kernel.org>
In-Reply-To: <20210623214438.2276538-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, willemb@google.com,
        eric.dumazet@gmail.com, dsahern@gmail.com, yoshfuji@linux-ipv6.org,
        brouer@redhat.com, dsj@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 23 Jun 2021 14:44:38 -0700 you wrote:
> Dave observed number of machines hitting OOM on the UDP send
> path. The workload seems to be sending large UDP packets over
> loopback. Since loopback has MTU of 64k kernel will try to
> allocate an skb with up to 64k of head space. This has a good
> chance of failing under memory pressure. What's worse if
> the message length is <32k the allocation may trigger an
> OOM killer.
> 
> [...]

Here is the summary with links:
  - [net-next,v4] net: ip: avoid OOM kills with large UDP sends over loopback
    https://git.kernel.org/netdev/net-next/c/6d123b81ac61

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


