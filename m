Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40A3F3A2012
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 00:30:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230171AbhFIWcL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Jun 2021 18:32:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:34338 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229845AbhFIWcB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Jun 2021 18:32:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id DD56B613F3;
        Wed,  9 Jun 2021 22:30:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623277805;
        bh=YqQxyJioWeck2E6hIE9e40Oy1FUPk1Nh6CwICIZNHwg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=V3sPJskoZbwMP1tjjQB4YCxLP+pzfs96mmDiK9V45drJ7IKwWDeVsuNeGpf0kCgjn
         fiAjv7J8UWWZkMX+99+R4jfSld8pXQQ1eJ/f2OVf9X5AjNq7kgx+rYFS+Upx0hJ8vm
         Obc6s131m9wxjs8c0K+TOUY7mpzqE31GYKI3DW21mgRXmlWNrUub8g3StjDeS1clcn
         EmBQfMezpfUlJguaQhM25eD2auZO2LdsjwkqlkXZhXm/6mYit8cfS9wpdxfq3C0K/O
         ABufJEqE89SbBTkmjyEYtGYp2OoUg8Qcp3bdc9dt1nY3WM9JUJ18Jnu+Wblf9YU8Yl
         a9bXSSCchdhqw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CFC4C60CE4;
        Wed,  9 Jun 2021 22:30:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: ti: am65-cpts: Use
 devm_platform_ioremap_resource_byname()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162327780584.20375.9824566952278975086.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Jun 2021 22:30:05 +0000
References: <20210609134537.3188927-1-yangyingliang@huawei.com>
In-Reply-To: <20210609134537.3188927-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 9 Jun 2021 21:45:37 +0800 you wrote:
> Use the devm_platform_ioremap_resource_byname() helper instead of
> calling platform_get_resource_byname() and devm_ioremap_resource()
> separately.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/net/ethernet/ti/am65-cpts.c | 4 +---
>  1 file changed, 1 insertion(+), 3 deletions(-)

Here is the summary with links:
  - [net-next] net: ethernet: ti: am65-cpts: Use devm_platform_ioremap_resource_byname()
    https://git.kernel.org/netdev/net-next/c/e77e2cf4a198

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


