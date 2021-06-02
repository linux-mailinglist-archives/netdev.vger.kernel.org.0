Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9BD04397D68
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 02:00:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235251AbhFBABq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 20:01:46 -0400
Received: from mail.kernel.org ([198.145.29.99]:54920 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235213AbhFBABq (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 20:01:46 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 4AD0F613AE;
        Wed,  2 Jun 2021 00:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622592004;
        bh=eQ6Fp0dEwGHmiZDqLfsGa4lQFLr/JX9opQed8/5ImNA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=i3Zz6zZfvUSDsTFSmXDkCrzCmXnsC5/sueIAy9Ol9Pl0zvVjPtiu/0P/8OYNyi54F
         ayzZhIu7NKt/HC136K1MRdrqSby8Yx57yjfpnoILiACKREkTBFtwUL6wiSFUPq1op2
         qYk3aZxzIhrB9nZgd/fV5fH/A+1GjGX8P3paVU31XGQH0PP/2awzmOsn1QVRiKp4ui
         +9zSeiujRsdWZpgA7gSYVBWbBXHjW/r7WNgdQ7EaZbuxnGl5fZI/mX3k2Pdoi66lqJ
         UuMzQQwdNQqJqrxgrrGVgSm91/WqAGemXWflGAknxxRGb7Os98eG1xfw10oJ6LJEjk
         GeTiKh4Uy+YZg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3E6C860A6F;
        Wed,  2 Jun 2021 00:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/3] net/sched: act_vlan: Fix modify to allow 0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162259200425.18494.7708189927860051377.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 00:00:04 +0000
References: <20210601123052.3887-1-boris.sukholitko@broadcom.com>
In-Reply-To: <20210601123052.3887-1-boris.sukholitko@broadcom.com>
To:     Boris Sukholitko <boris.sukholitko@broadcom.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, jiri@resnulli.us,
        xiyou.wangcong@gmail.com, davem@davemloft.net,
        linux-kselftest@vger.kernel.org, shuah@kernel.org,
        ilya.lifshits@broadcom.com, shmulik.ladkani@gmail.com,
        kuba@kernel.org, dcaratti@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue,  1 Jun 2021 15:30:49 +0300 you wrote:
> Currently vlan modification action checks existence of vlan priority by
> comparing it to 0. Therefore it is impossible to modify existing vlan
> tag to have priority 0.
> 
> For example, the following tc command will change the vlan id but will
> not affect vlan priority:
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/3] net/sched: act_vlan: Fix modify to allow 0
    https://git.kernel.org/netdev/net-next/c/9c5eee0afca0
  - [net-next,v4,2/3] net/sched: act_vlan: No dump for unset priority
    https://git.kernel.org/netdev/net-next/c/8323b20f1d76
  - [net-next,v4,3/3] net/sched: act_vlan: Test priority 0 modification
    https://git.kernel.org/netdev/net-next/c/8fd52b1f923c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


