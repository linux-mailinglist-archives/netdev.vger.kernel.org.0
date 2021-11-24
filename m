Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90F2B45B2F1
	for <lists+netdev@lfdr.de>; Wed, 24 Nov 2021 05:00:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240903AbhKXEDT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Nov 2021 23:03:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:60632 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240896AbhKXEDS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 23 Nov 2021 23:03:18 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 5327360FD9;
        Wed, 24 Nov 2021 04:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637726409;
        bh=cqj+GZucNbMAj5bFJ6npvwirdWGOMi1+TJsKiEqKdvw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=o/rnEo7kUYm5HuAhLOAHyFVgJtUZNHuAUvW+npz01sX11H959Fip0x902bUjXXcZF
         B1MM6FFfXGWZpa2avOEv8LW8AKBVv/sD5AxWObSFJZx2JxzwUw5L7L0KG/0ThntzNa
         y0+cMEGQQQTcE3/2eqq18wKzxh9PEeC28K1Ykf7QKS7YwgM0Sf1MiLRc5c02arNkpY
         KXXtoYebTcwtjzPTNUuBmLXsoRI0P+KV7QzMTtnXju5BFxD7BrPyVUR0RnMl5mJQ6E
         lADjqGeP3e7P8BFGIGYA4hny/Ko+aMzBQuGV26kfmQmpVBEHIa+kqUrSOEfI4FMHaC
         xa+QM2jJI8ehQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 37DFC609B3;
        Wed, 24 Nov 2021 04:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next  1/1] tc-testing: Add link for reviews with TC
 MAINTAINERS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163772640922.5735.5608611906202875889.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Nov 2021 04:00:09 +0000
References: <20211122144252.25156-1-jhs@emojatatu.com>
In-Reply-To: <20211122144252.25156-1-jhs@emojatatu.com>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, dcaratti@redhat.com,
        marcelo.leitner@gmail.com, vladbu@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 22 Nov 2021 09:42:52 -0500 you wrote:
> From: Jamal Hadi Salim <jhs@mojatatu.com>
> 
> Signed-off-by: Jamal Hadi Salim <jhs@mojatatu.com>
> ---
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - [net-next,1/1] tc-testing: Add link for reviews with TC MAINTAINERS
    https://git.kernel.org/netdev/net/c/0afefdced47d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


