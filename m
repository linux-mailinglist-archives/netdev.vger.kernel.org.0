Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C1D73896B6
	for <lists+netdev@lfdr.de>; Wed, 19 May 2021 21:30:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232064AbhESTbi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 May 2021 15:31:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56136 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232043AbhESTbg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 May 2021 15:31:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A06BB610E9;
        Wed, 19 May 2021 19:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621452616;
        bh=YGvzWMEITSu4iVPMLDrrfFqO3vKrsLHYNhfhIIgGB4A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JKQmBVJTlhUBrnmttq0rHoIe9jm2KXyeAKTo41dQScRn8xy5gwySu3vGQxxiEr9eL
         OcsS1sgTC8akwfDPDju+OX68fRr9zmcsUh4i3ydd6yTN5dDWuK6NbkgVD3P2cbsLlS
         K7EYXbdPiETqQfLrQcrnFEsSrBip7N78tXVjuqedC2+JMshrg4DQS+TIpFSSk6uF+2
         5ckrutRuPMEcfGeTVZ4TKYByW28zKQQ8h7JW7ih4/5Qt+K82T2yyk5mRJiqNJSmz5G
         WOe9YXAv66KzgEEqZ6N9d3R4KmAF1Q8o1dgMT3+UJdEpSMjFkNxc36VlkQejaDvQN4
         IaZwlIyUI2WeQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9A03E609F7;
        Wed, 19 May 2021 19:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] netlabel: remove unused parameter in
 netlbl_netlink_auditinfo()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162145261662.25646.2206689075457256532.git-patchwork-notify@kernel.org>
Date:   Wed, 19 May 2021 19:30:16 +0000
References: <20210519073438.3805430-1-zhengyejian1@huawei.com>
In-Reply-To: <20210519073438.3805430-1-zhengyejian1@huawei.com>
To:     Zheng Yejian <zhengyejian1@huawei.com>
Cc:     paul@paul-moore.com, netdev@vger.kernel.org,
        zhangjinhao2@huawei.com, yuehaibing@huawei.com,
        davem@davemloft.net, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 19 May 2021 15:34:38 +0800 you wrote:
> loginuid/sessionid/secid have been read from 'current' instead of struct
> netlink_skb_parms, the parameter 'skb' seems no longer needed.
> 
> Fixes: c53fa1ed92cd ("netlink: kill loginuid/sessionid/sid members from struct netlink_skb_parms")
> Signed-off-by: Zheng Yejian <zhengyejian1@huawei.com>
> ---
>  net/netlabel/netlabel_calipso.c   |  4 ++--
>  net/netlabel/netlabel_cipso_v4.c  |  4 ++--
>  net/netlabel/netlabel_mgmt.c      |  8 ++++----
>  net/netlabel/netlabel_unlabeled.c | 10 +++++-----
>  net/netlabel/netlabel_user.h      |  4 +---
>  5 files changed, 14 insertions(+), 16 deletions(-)

Here is the summary with links:
  - [net-next] netlabel: remove unused parameter in netlbl_netlink_auditinfo()
    https://git.kernel.org/netdev/net-next/c/f7e0318a314f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


