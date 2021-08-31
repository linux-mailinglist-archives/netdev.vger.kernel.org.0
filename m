Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A03713FC66B
	for <lists+netdev@lfdr.de>; Tue, 31 Aug 2021 13:33:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241431AbhHaLLF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Aug 2021 07:11:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:58610 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234296AbhHaLLD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Aug 2021 07:11:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 195B360FED;
        Tue, 31 Aug 2021 11:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1630408208;
        bh=laEgecllWo3HZQZQm4KsHHgKSpVOvxotCIRheH9D/9I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iM8h5Kxjfyprh9xXSAqW+D4eNU39/9dGzMpiBl57P5nlGy1GpopVPQpz98jEyTdLk
         k0wPy8YWm61pluNLa6KTNRJhqanOYIbWf4IoUpwWO3/vsKeo8yWxFzwU+HoiwcEc6+
         HlZks4qGEvTNrduDSZgON4MVkl8pX7uafXitqziGSiiNE+EVOF+CSwMhiB9tlAn15w
         w30x60EkwjrMKZpZKwH958PacXJAF1vcCFvHdAnvYl7Nt51m6Dvn16dL+ccEQrp9YQ
         rec/dE9ngF7Ta5GHjOrNwnaao/RZz4o4U5/c1KZTRpcw/T1921d0zrjgoIdx0jRrgK
         5QV699/zMVG5g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 10F7660A6C;
        Tue, 31 Aug 2021 11:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: mdio-ipq4019: Make use of
 devm_platform_ioremap_resource()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163040820806.5377.12595138032913861807.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Aug 2021 11:10:08 +0000
References: <20210831075658.788-1-caihuoqing@baidu.com>
In-Reply-To: <20210831075658.788-1-caihuoqing@baidu.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     andrew@lunn.ch, hkallweit1@gmail.com, linux@armlinux.org.uk,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Tue, 31 Aug 2021 15:56:58 +0800 you wrote:
> Use the devm_platform_ioremap_resource() helper instead of
> calling platform_get_resource() and devm_ioremap_resource()
> separately
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> ---
>  drivers/net/mdio/mdio-ipq4019.c | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)

Here is the summary with links:
  - net: mdio-ipq4019: Make use of devm_platform_ioremap_resource()
    https://git.kernel.org/netdev/net-next/c/fa14d03e014a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


