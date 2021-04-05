Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C51935487D
	for <lists+netdev@lfdr.de>; Tue,  6 Apr 2021 00:11:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242709AbhDEWK3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Apr 2021 18:10:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:40620 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232696AbhDEWKP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 5 Apr 2021 18:10:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0DDA361241;
        Mon,  5 Apr 2021 22:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617660609;
        bh=qUnyiLfCtx7AT0eJT24/4KZxQ/bPdYD6/1vODc9n84Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qBWC1F60EjAaPP0/AcA/vGUBjUvLKpkkHgaskFf7XFVRvAz/GKUwAOMVGf+eB23fa
         IF7dJJJMSgHmMIZoJ1tb6oZpHfzQd8fPXK6GxUzLhHM/doJCIRoUtr+fp9Y5h/8uJI
         3VAs+w93tOCPbRyHoL/Sq+DG+p158rJBZ74oPH+Mcy8+D6aeEQWXZ/Nt0haDm7nd6y
         4Sa1VqtTjY00+Ivb0XbzLByAUxXWH7vtDQd3QMz0nm4GfbesHF1G8KctVKuVPDL2Js
         Qg5fQBR/YPBbIopYV+Q/dzl1FZlpiGI2DDizwOAJxjGeovf8w5ULW9P2w+OSXtlpp+
         LjHz0TOdSJoCQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F012760A19;
        Mon,  5 Apr 2021 22:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net 0/2] Misc. fixes for hns3 driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161766060897.24414.11853477881014511196.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Apr 2021 22:10:08 +0000
References: <20210405170645.29620-1-salil.mehta@huawei.com>
In-Reply-To: <20210405170645.29620-1-salil.mehta@huawei.com>
To:     Salil Mehta <salil.mehta@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        linuxarm@openeuler.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon, 5 Apr 2021 18:06:43 +0100 you wrote:
> Fixes for the miscellaneous problems found during the review of the code.
> 
> Change Summary:
>  Patch 1/2, Change V1->V2:
>    [1] Fixed comments from Leon Romanovsky
>        Link: https://lkml.org/lkml/2021/4/4/14
>  Patch 2/2, Change V1->V2:
>    None
> 
> [...]

Here is the summary with links:
  - [V2,net,1/2] net: hns3: Remove the left over redundant check & assignment
    https://git.kernel.org/netdev/net/c/9a6aaf61487e
  - [V2,net,2/2] net: hns3: Remove un-necessary 'else-if' in the hclge_reset_event()
    https://git.kernel.org/netdev/net/c/0600771fa6b2

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


