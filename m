Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 765B839E86F
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 22:30:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231322AbhFGUb4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 16:31:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:51152 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230251AbhFGUbz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 16:31:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 18BAC61139;
        Mon,  7 Jun 2021 20:30:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623097804;
        bh=Hf5W9L/jvScCtlagXjZ889wFRVocf7tcyh5gFLCdZ68=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Tcjv1NV4IueAhWNAHoknvZwQ+lnNyCDW54uGLWsEuj0P7DW6HHJzAO/BEvYa4doUp
         g94/du+Zgm/PJBThxZ2AFKVLvd4Qf7TqrFf8UTWTHwaUKvzmWeaVgQ8VMUsiS0+OvT
         n30V5bl3KWZWMKiTeoQjd6CxlUk3LGXF9wC/zGgfjQVlwPVjdEXEKHgunVNRZqaSmE
         SwLOlfR7Tem7Wy7nvx8lSVEoGbwNGjBRcWIuYY4gmyR7bqDzeAojXfyRHxZAWfBh3I
         Eaxhmv4pkmdKUmnFdUBAvFVcRa0Y3hvFIlR9dOuVTpnHG+bvc5zIxbTUkNosU9LzJI
         8zX58MbAQ6eWg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 0CE4460283;
        Mon,  7 Jun 2021 20:30:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net: gemini: Use
 devm_platform_get_and_ioremap_resource()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162309780404.13544.15986317200547289285.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 20:30:04 +0000
References: <20210607081145.1617593-1-yangyingliang@huawei.com>
In-Reply-To: <20210607081145.1617593-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        ulli.kroll@googlemail.com, linus.walleij@linaro.org,
        davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 7 Jun 2021 16:11:45 +0800 you wrote:
> Use devm_platform_get_and_ioremap_resource() to simplify
> code.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> v3:
>   remove netdev_info(...) in gemini_ethernet_port_probe()
> v2:
>   Also use devm_platform_get_and_ioremap_resource() in gemini_ethernet_probe().
>   Keep the error message to distinguish remap which address failed in
>   gemini_ethernet_port_probe().
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: gemini: Use devm_platform_get_and_ioremap_resource()
    https://git.kernel.org/netdev/net-next/c/ef91f7981036

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


