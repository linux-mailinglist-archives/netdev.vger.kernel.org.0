Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7C2B33AA470
	for <lists+netdev@lfdr.de>; Wed, 16 Jun 2021 21:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232915AbhFPTmO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Jun 2021 15:42:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:53786 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232851AbhFPTmL (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Jun 2021 15:42:11 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 96C50613AE;
        Wed, 16 Jun 2021 19:40:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623872405;
        bh=D4KRi1gYsknIvuv2o/chxH67UGKA1YY8i6LKzCIAEW4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=icS/As2e956nqybpzYfRhMfdNB/C0lzlb0lOEH3hnesKTKTU9Ogf8CuMv0f//dU1W
         puZDjA6gN8bvsHjSlcCp2v/ga2E9MB5pFjctV2asyrz7iRoPKiklFnqp3cuztsGuT+
         uZNiw5FMSZVzorv/P5++QNnjHeNzggqVfdWnW3BduLDm3x0rl3fxKrWPSfeDhQQpzt
         L0zGdtCxcQAe51TsGATmQRXPhlb0DF0AHlSVv0Rve1aNDHRK+dPVEJjztPf47Qsg4T
         zVP9V1vXoay6C61eRNwtDjt1Fst1u5vqCCSBkSRv1SHE5CUl0tgPMpqlX4B70zMD0P
         xWHerWxbe+upA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 90A9860A54;
        Wed, 16 Jun 2021 19:40:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/8] net: phy: fix some coding-style issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162387240558.6512.8561330273042168185.git-patchwork-notify@kernel.org>
Date:   Wed, 16 Jun 2021 19:40:05 +0000
References: <1623837686-22569-1-git-send-email-liweihang@huawei.com>
In-Reply-To: <1623837686-22569-1-git-send-email-liweihang@huawei.com>
To:     Weihang Li <liweihang@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, netdev@vger.kernel.org, linuxarm@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 16 Jun 2021 18:01:18 +0800 you wrote:
> Make some cleanups according to the coding style of kernel.
> 
> Changes since v1:
> - Update commit description of #1 and #3.
> - Avoid changing the indentation in #2.
> - Change a group of if-else statement into switch from #4 and put it into
>   a single patch.
> - Put '|' at the end of line in #5 and #7.
> - Avoid deleting spaces in definition of 'settings' in #5.
> - Drop #8 from the series which needs more discussion with David.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/8] net: phy: change format of some declarations
    https://git.kernel.org/netdev/net-next/c/775f25479df9
  - [v2,net-next,2/8] net: phy: correct format of block comments
    https://git.kernel.org/netdev/net-next/c/1953feb02215
  - [v2,net-next,3/8] net: phy: delete repeated words of comments
    https://git.kernel.org/netdev/net-next/c/e1f82127d67f
  - [v2,net-next,4/8] net: phy: fix space alignment issues
    https://git.kernel.org/netdev/net-next/c/3bdee6a8e92e
  - [v2,net-next,5/8] net: phy: fix formatting issues with braces
    https://git.kernel.org/netdev/net-next/c/169d7a402dfa
  - [v2,net-next,6/8] net: phy: print the function name by __func__ instead of an fixed string
    https://git.kernel.org/netdev/net-next/c/450bf1f0c60e
  - [v2,net-next,7/8] net: phy: remove unnecessary line continuation
    https://git.kernel.org/netdev/net-next/c/33ab463220e5
  - [v2,net-next,8/8] net: phy: replace if-else statements with switch
    https://git.kernel.org/netdev/net-next/c/16d4d650966d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


