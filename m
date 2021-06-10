Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DE8D83A35A4
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 23:10:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231416AbhFJVML (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 17:12:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:47484 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231269AbhFJVMB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 17:12:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id B3DC161414;
        Thu, 10 Jun 2021 21:10:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623359404;
        bh=74k0FB0MOS9flV7hjGvwsSBCj4CuxSjp+u7UTSM4gws=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l7HiQrBpM+l/y6D42Q76T9YycnlRM1572wWex6UDvylTrk/Sa6lDO0HbP+nai4Iyr
         fguY9pgQzEL9bLKUNc98PQbrZsfs6v7H78LlZaYKoLEvE5za87hHe1WIUbXtD7DG/+
         l26p43bgmACZ/ff2Tv7oreOklWtY+H4ehSEJC/Ph3CZHZOdOpbPTl7YxO3ezGRuxRT
         GytnpyOr83JV29uK5U2W7gVZtAsr0FzF5d02H0+fi5kF7TfhfMYzBv33LsSG/gYXjA
         0TBN8NO9GaSEm5QQ/KYfll5QbDBrt3UAUw15oYXJgupjBoXzFRw67x0S3rzLSQnw5u
         47eFxV9dc+SrA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A7BA160A0C;
        Thu, 10 Jun 2021 21:10:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] mt76: mt7615: Use
 devm_platform_get_and_ioremap_resource()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162335940468.9889.1424151629345295812.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 21:10:04 +0000
References: <20210610092535.4156573-1-yangyingliang@huawei.com>
In-Reply-To: <20210610092535.4156573-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, nbd@nbd.name,
        lorenzo.bianconi83@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 10 Jun 2021 17:25:35 +0800 you wrote:
> Use devm_platform_get_and_ioremap_resource() to simplify
> code.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/wireless/mediatek/mt76/mt7615/soc.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] mt76: mt7615: Use devm_platform_get_and_ioremap_resource()
    https://git.kernel.org/netdev/net-next/c/9e2b7b0450cf

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


