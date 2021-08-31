Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 138023FC6B6
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 14:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241526AbhHaLlC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 07:41:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:37056 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231622AbhHaLlB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 07:41:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9004B60FF2;
        Tue, 31 Aug 2021 11:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630410006;
        bh=Un5kEQZgv1W73bzbBsGf4vBeBVvYn5JtOa3G9PjaoHs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ItFaqXpaHleGKxTiIWK//LOwV+cihNaS/vSBoKuBmqMycN4dyx3yFycgPrSx33/UB
         jX++lWwV77Mzv+6Dk3GcV4Egp0GGW1gEh7dUYKuJsgh1auF/5gNIOzEnCHU23pLM4l
         b9lvU3yP/TiKbOMgk7wtEcj9BFbyrFraEuUUv0WnpiAbG1hWkl55eaKGwnYNgBLK+Y
         HHt3khJz0ZE9QkPaYknTwr8BNIgPw4uJSCVdUP8WbEzuCgGU32q9FGzLsRTfBNeAeX
         x1yB03bZfG9w2piL/MZxbYjOXtkFiva7AThqqgqdpCKCVMauZQqYzTxR3b4MlXAQxD
         BlYQP4PRDH9Zg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8596460A7D;
        Tue, 31 Aug 2021 11:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: hns3: add some cleanups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163041000654.19308.10342773765722613685.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Aug 2021 11:40:06 +0000
References: <1630331469-13707-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1630331469-13707-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 30 Aug 2021 21:51:05 +0800 you wrote:
> This series includes some cleanups for the HNS3 ethernet driver.
> 
> Guojia Liao (1):
>   net: hns3: clean up a type mismatch warning
> 
> Hao Chen (2):
>   net: hns3: add some required spaces
>   net: hns3: remove unnecessary spaces
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: hns3: refine function hns3_set_default_feature()
    https://git.kernel.org/netdev/net-next/c/dc9b5ce03124
  - [net-next,2/4] net: hns3: clean up a type mismatch warning
    https://git.kernel.org/netdev/net-next/c/e79c0e324b01
  - [net-next,3/4] net: hns3: add some required spaces
    https://git.kernel.org/netdev/net-next/c/c74e503572ea
  - [net-next,4/4] net: hns3: remove unnecessary spaces
    https://git.kernel.org/netdev/net-next/c/7f2d4b7ffa42

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


