Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A36CF37B29E
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 01:33:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230166AbhEKXeY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 19:34:24 -0400
Received: from mail.kernel.org ([198.145.29.99]:55362 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230018AbhEKXeR (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 19:34:17 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A8E3361932;
        Tue, 11 May 2021 23:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1620775990;
        bh=oJ3l4wlzf7QBL5jHf7APnaJatjUe/MBghkI25GjTwgo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qBsWqG9UP6inu2TCX4d+QYgGdNvFvL7TF7dOgfv+hyEy6+t5BLO1Htwb8gEn1ljVE
         OeSdrNh22EDcpUNG1GQNokpeRr0eXywy5vcC06k5Lys3hqUTYbEAv6BdyVoK5wy+cX
         9U6Z3mT5PHt4lBJGeNFXlmlAMfpBPwVNs/+m5PPCYN5s3CNlTN7Xxon8UFnuX6Uviq
         J3DtLlIIJA68fEUNE8fn0MxU5cssuwuzduoqTKIDZb/ko5jW6GoDfBPivwWCnbDDWl
         SD7J3CTjGYvXvxFfpHeDPoi7z3ylMI/uLln83aCSn/S9kEQ4kl7835RZj34dcpoNtn
         +FLCFx0gIvhfw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A2AF560A02;
        Tue, 11 May 2021 23:33:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/sched: taprio: Drop unnecessary NULL check after
 container_of
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162077599066.17752.10688844250342653861.git-patchwork-notify@kernel.org>
Date:   Tue, 11 May 2021 23:33:10 +0000
References: <20210511205449.1676407-1-linux@roeck-us.net>
In-Reply-To: <20210511205449.1676407-1-linux@roeck-us.net>
To:     Guenter Roeck <linux@roeck-us.net>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, jiri@resnulli.us,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 11 May 2021 13:54:49 -0700 you wrote:
> The rcu_head pointer passed to taprio_free_sched_cb is never NULL.
> That means that the result of container_of() operations on it is also
> never NULL, even though rcu_head is the first element of the structure
> embedding it. On top of that, it is misleading to perform a NULL check
> on the result of container_of() because the position of the contained
> element could change, which would make the check invalid. Remove the
> unnecessary NULL check.
> 
> [...]

Here is the summary with links:
  - net/sched: taprio: Drop unnecessary NULL check after container_of
    https://git.kernel.org/netdev/net-next/c/faa5f5da809b

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


