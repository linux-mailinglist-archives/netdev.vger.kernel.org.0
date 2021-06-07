Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E6E039E818
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 22:10:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231517AbhFGUMD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 16:12:03 -0400
Received: from mail.kernel.org ([198.145.29.99]:39436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231481AbhFGUMB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 16:12:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0086061182;
        Mon,  7 Jun 2021 20:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623096610;
        bh=yJ9QGSlRQMk9WhfH04BuPQr3GLG1YjadDqwDOYv+P5U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=h08xOZfzWgH64I745SgCyLqA3eXwTagMvsEdSshXgXrdWM3bDNCZXELnY9E38AAHf
         0aHHBswOMRsZoVkRYzRHs7MydjIXlMnBltjbJOaRVsp5QaCACbUYGPEL3jn4J5eILn
         z0Rbm6AFqLjMBHutwldehBd9sJSt8YOjrYfT4MA9+Wg0duwKZAdjH/2zFXFTobc9Vh
         LvpCYKs80sOjh93/mz6NxLqC1+1r/1jEcU8E2JMExtJn9bHoSYpgqyivdmJAInWANn
         y9dBDfwBqqFtcEyvkBngNvD8VuBbSqIkyIZo9y9mbrtxrmZRE8H/btN9DYEVWJa1eX
         CWmQfs9v8ncbA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E932160A54;
        Mon,  7 Jun 2021 20:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: lantiq: Use
 devm_platform_get_and_ioremap_resource()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162309660995.3673.12457550053963961548.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 20:10:09 +0000
References: <20210605122127.2469235-1-yangyingliang@huawei.com>
In-Reply-To: <20210605122127.2469235-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Sat, 5 Jun 2021 20:21:27 +0800 you wrote:
> Use devm_platform_get_and_ioremap_resource() to simplify
> code.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
> v2:
>   remove 'res'
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: lantiq: Use devm_platform_get_and_ioremap_resource()
    https://git.kernel.org/netdev/net-next/c/d402af20315c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


