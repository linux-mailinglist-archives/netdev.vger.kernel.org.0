Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 43EAB3AD28F
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 21:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234806AbhFRTMS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 15:12:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:60242 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234712AbhFRTMN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 15:12:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 2C416613E2;
        Fri, 18 Jun 2021 19:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624043404;
        bh=2kYRmnCZirTS5bNIUYF6JeR5W0FElc+MGyXAqXzAg1M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IKFufWP4+U8ZezAlscDxZxsCujJikPa6tgEYGRX1i6EaNhOkeCpXW/Z3xlL0dqAgC
         vgtTH3S9Yje00VMDQ7XvkR93iwkiI3xPf/uib5eN1v16nhhusXpo0T14CGe9fdqZXV
         ujwrVoM4k0CzLQ+gImX5wJcg5R/gQVRgrTeihK92qUb+DK1nOUD9PUTtVdhIgEMeH+
         wTUDg76GBTyjKxvMR1LSqwYM6hQibbWuQfRYKvFaZXEwlmvgH4coO85Exn5RDHudAX
         R7zXsIfFAiX02+zM6jwC4UQMq0MexjOA9UGQUK8NfsKo3xoaIMqDqyYAiKX4t92mNQ
         abH88eSDyOh4Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 2729760A17;
        Fri, 18 Jun 2021 19:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: vlan: pass thru all GSO_SOFTWARE in
 hw_enc_features
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162404340415.6189.18241591626926985919.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Jun 2021 19:10:04 +0000
References: <20210618045556.1260832-1-kuba@kernel.org>
In-Reply-To: <20210618045556.1260832-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, dcaratti@redhat.com, netdev@vger.kernel.org,
        willemb@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 17 Jun 2021 21:55:56 -0700 you wrote:
> Currently UDP tunnel devices on top of VLANs lose the ability
> to offload UDP GSO. Widen the pass thru features from TSO
> to all GSO_SOFTWARE.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/8021q/vlan.h | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: vlan: pass thru all GSO_SOFTWARE in hw_enc_features
    https://git.kernel.org/netdev/net-next/c/9d72b8da9f13

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


