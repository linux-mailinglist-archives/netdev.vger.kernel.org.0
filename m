Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9ED35A78C
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 22:00:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234789AbhDIUAx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 16:00:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:38260 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234545AbhDIUAv (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Apr 2021 16:00:51 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id CA0D1610F7;
        Fri,  9 Apr 2021 20:00:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617998437;
        bh=5GOsJGNIQOU/Km0eb1zrsnUs1UIHbxOflqi7W93KoMY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Z8OjJlDIgTO9sc1y5OyRJWfKVCRoOBLFj+kJ2iRCHZEvHLpVeU0AHB0Qius7AdAMA
         gsKj9yHmmmVhvZEZXV8iEIcfEn8oliUk4/XZPvGlAtycJlNBGglCRjO0DFPbUw9aIj
         SnLgUTdoIN5EyJlnxtNYL+A6fnGFXfn3vXsl++o0IZmTH1b8JkaCau6GVtz/7XtFM8
         gcL12BXoZV6hVQ+GTFunVVTMpRyXPQKmt7SYv87+rrMqRSWDm3/qVEYQoMerIJHvlO
         flbr8C9m+LGrJW1nxyMPq+Kku394fOx7ijb0pUSOg/hQdPDYvPqBASU/KOepkFS1EL
         GdhTPZYSfzggg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BD0E060A71;
        Fri,  9 Apr 2021 20:00:37 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: hns3: Trivial spell fix in hns3 driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161799843776.9153.13095418822431780218.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Apr 2021 20:00:37 +0000
References: <20210409074223.32480-1-salil.mehta@huawei.com>
In-Reply-To: <20210409074223.32480-1-salil.mehta@huawei.com>
To:     Salil Mehta <salil.mehta@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@huawei.com,
        linuxarm@openeuler.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 9 Apr 2021 08:42:23 +0100 you wrote:
> Some trivial spelling mistakes which caught my eye during the
> review of the code.
> 
> Signed-off-by: Salil Mehta <salil.mehta@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hns3/hns3pf/hclge_main.c   | 2 +-
>  drivers/net/ethernet/hisilicon/hns3/hns3vf/hclgevf_main.c | 4 ++--
>  2 files changed, 3 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net] net: hns3: Trivial spell fix in hns3 driver
    https://git.kernel.org/netdev/net/c/cd7e963d2f08

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


