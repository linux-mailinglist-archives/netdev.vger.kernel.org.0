Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A92C3A07ED
	for <lists+netdev@lfdr.de>; Wed,  9 Jun 2021 01:40:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235677AbhFHXmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 19:42:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:58686 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235553AbhFHXl7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 19:41:59 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 1482D613AE;
        Tue,  8 Jun 2021 23:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623195606;
        bh=zjMp8X03dxB6hl9Pw3D/Gh8y9BKW3VhZoMkgXqYO+18=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mrvNkEiiOnRqWlpfMKIosLpDnwduid1aSJfJHCQ2sai4LAa1v1Dy3wzHS/flQ0pxP
         BdwN/yAGfzIX+zfkdy0XKH6vclVxB95oYvX8rccpxeNOEZfP5n6tG4xE1jeSs/lM9G
         MfnDl9XjqoQszvIiYBuZ5YTG2HLERSLl5cU0xwY4Tr2r5GY9ytVWUQaCST2/ug2ut3
         UQbYPJhIhKs2yiBTiy5fpSv0GCy+mmirGp7FBCkh624K7mAgXERdp3gn7OJgkN6XMq
         xJZ1C4jz0oGRTH1jNj3YhTSszoNRcWWtcE0FJPaw7ZJVO7hJYg8j1zi79V8RNNFH62
         0s7duvsn5EUrw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0AADF60CD1;
        Tue,  8 Jun 2021 23:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] sh_eth: Use devm_platform_get_and_ioremap_resource()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162319560603.24693.12811528730359738545.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Jun 2021 23:40:06 +0000
References: <20210608135718.3009950-1-yangyingliang@huawei.com>
In-Reply-To: <20210608135718.3009950-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        sergei.shtylyov@gmail.com, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 8 Jun 2021 21:57:18 +0800 you wrote:
> Use devm_platform_get_and_ioremap_resource() to simplify
> code.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/renesas/sh_eth.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Here is the summary with links:
  - [net-next] sh_eth: Use devm_platform_get_and_ioremap_resource()
    https://git.kernel.org/netdev/net-next/c/52481e585951

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


