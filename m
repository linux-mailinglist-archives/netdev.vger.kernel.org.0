Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CC2943F9865
	for <lists+netdev@lfdr.de>; Fri, 27 Aug 2021 13:20:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244964AbhH0LU4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Aug 2021 07:20:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:34100 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233082AbhH0LUz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 27 Aug 2021 07:20:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D51B760FD9;
        Fri, 27 Aug 2021 11:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630063206;
        bh=0KySjxQfIxpxmDUiJb0p6JoUXfD7dCcvzvPuqO/UH8U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BDoO+hJn5bB+Neh544GHYqz0aWIi8tpIGdTPxk84zwKFEz9JeyxC2oJsg0mX0RpxF
         b1FFR94qF+lD77fZQvuZmIvxK3oKEyoeDYe0hXaVfbA5q3NtCapkZbWQCRsQV7bRxs
         ZJo7guvrTf6ub1zR7CCxi5aTM0Up7762PshuOUZLd9A0W161g6U0+3COD7ejSv+bRD
         dLasopjlnJJbByb5io/+Q3tCzl8UNR/Kl8ctkk9xIX9cs1ABDOkO9XRQtHJQg9NEHL
         SSfwgFJDJhSaara0/lfp+RjYxCcSXknMSWB4eOBSbDrsfkz860SPrnEr8Cuv+a0b1H
         1SAtcXYV1sm2w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C8AD460A27;
        Fri, 27 Aug 2021 11:20:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] net: hns3: add some cleanups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163006320681.31502.1549571483307282348.git-patchwork-notify@kernel.org>
Date:   Fri, 27 Aug 2021 11:20:06 +0000
References: <1630056504-31725-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1630056504-31725-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 27 Aug 2021 17:28:16 +0800 you wrote:
> This series includes some cleanups for the HNS3 ethernet driver.
> 
> Guangbin Huang (1):
>   net: hns3: add macros for mac speeds of firmware command
> 
> Hao Chen (1):
>   net: hns3: uniform type of function parameter cmd
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] net: hns3: add macros for mac speeds of firmware command
    https://git.kernel.org/netdev/net-next/c/4c116f85ecf8
  - [net-next,2/8] net: hns3: add hns3_state_init() to do state initialization
    https://git.kernel.org/netdev/net-next/c/c511dfff4b65
  - [net-next,3/8] net: hns3: remove redundant param mbx_event_pending
    https://git.kernel.org/netdev/net-next/c/67821a0cf5c9
  - [net-next,4/8] net: hns3: use memcpy to simplify code
    https://git.kernel.org/netdev/net-next/c/304cd8e776dd
  - [net-next,5/8] net: hns3: remove redundant param to simplify code
    https://git.kernel.org/netdev/net-next/c/5f22a80f32de
  - [net-next,6/8] net: hns3: package new functions to simplify hclgevf_mbx_handler code
    https://git.kernel.org/netdev/net-next/c/d7517f8f6b3b
  - [net-next,7/8] net: hns3: merge some repetitive macros
    https://git.kernel.org/netdev/net-next/c/5a24b1fd301e
  - [net-next,8/8] net: hns3: uniform type of function parameter cmd
    https://git.kernel.org/netdev/net-next/c/0c5c135cdbda

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


