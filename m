Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0B4D840DA2F
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 14:41:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240009AbhIPMmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 08:42:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:43494 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239632AbhIPMlo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 08:41:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A601560F8F;
        Thu, 16 Sep 2021 12:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631796008;
        bh=lurUincUy548uOXSVXqM5GBNilsN2YgC4pJcySmyENQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XClWBAkfk8q+VbWvZZLCGlulh88gyMKC1nhkQoyzPhGsGPsWFIFCS6I+xN+dQNN8Q
         9vPK3qXFtyHZosOKOHJ07RgytD/IX23IBDEcliRF3yMItMWmaXEDmtQsGkwAt/PAvE
         J5IER5MV62hcK+Z5L3jMbh4JHjywtGsbWdZ74WwX4HNXCsogI9R3pdcVbC0PTGf2Qa
         hihMy0M1cM/MniYHK4i22jrFnH55X16d7x0Srn0W10wgRmtzDYC6gRRIfIlP5bATQG
         9sCxwXrw8WLpOvZxXApuKwEu/0kW6hIGWNLKwNLdX8kYz1ryAB8tBKJ2fm5Z4J6mdm
         E9VnDKDwpxI4w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9867760BD0;
        Thu, 16 Sep 2021 12:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethoc: Make use of the helper function dev_err_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163179600861.19379.14855472470345513186.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Sep 2021 12:40:08 +0000
References: <20210915145828.7516-1-caihuoqing@baidu.com>
In-Reply-To: <20210915145828.7516-1-caihuoqing@baidu.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 15 Sep 2021 22:58:27 +0800 you wrote:
> When possible use dev_err_probe help to properly deal with the
> PROBE_DEFER error, the benefit is that DEFER issue will be logged
> in the devices_deferred debugfs file.
> And using dev_err_probe() can reduce code size, and simplify the code.
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> 
> [...]

Here is the summary with links:
  - net: ethoc: Make use of the helper function dev_err_probe()
    https://git.kernel.org/netdev/net-next/c/015a22f46b25

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


