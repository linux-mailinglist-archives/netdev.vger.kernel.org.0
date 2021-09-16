Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B50240DA23
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 14:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239927AbhIPMlu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 08:41:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:43244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239808AbhIPMl3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 08:41:29 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6B1DE61207;
        Thu, 16 Sep 2021 12:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631796008;
        bh=LvqBeiSeau6DBPoq3v0EorcMRgkjlfJ6dvuMsTLz8j4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SiHVuu6pkTevE9tcbQpCJdX7ZYedYZ1huHydrTv6pbGU6bR8JGT1fOUqPFAwKxiA0
         FMFzLt2sYXTwxQ+5Uz7ZFkVf1whN9xRO80Xam3UrXj1DpCV6Tff4VX4rMF1hW39fI+
         Y8t4TtOxjXktBnI9A3Ty/G6mhyC8x/BKmFrSPDGUoaqs+Au42IaVQV539F3IjmtfNd
         X7o0WlY2RyPcHrN9nlQrn10/SXyWh9a+Q9PIl39//WMYfyvq71c5Xrc9tr8zcwuh5y
         NrHjFnEPW8IKUQBiFRI678V3F5c+hd29yPA/lriPpZb6B2tESMr/0isHPDlPw05lUr
         qlRD88Ux4/7fA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 5D8D260BD0;
        Thu, 16 Sep 2021 12:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: enetc: Make use of the helper function dev_err_probe()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163179600837.19379.12326247154053015433.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Sep 2021 12:40:08 +0000
References: <20210915145820.7463-1-caihuoqing@baidu.com>
In-Reply-To: <20210915145820.7463-1-caihuoqing@baidu.com>
To:     Cai Huoqing <caihuoqing@baidu.com>
Cc:     claudiu.manoil@nxp.com, davem@davemloft.net, kuba@kernel.org,
        yangbo.lu@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 15 Sep 2021 22:58:19 +0800 you wrote:
> When possible use dev_err_probe help to properly deal with the
> PROBE_DEFER error, the benefit is that DEFER issue will be logged
> in the devices_deferred debugfs file.
> And using dev_err_probe() can reduce code size, and simplify the code.
> 
> Signed-off-by: Cai Huoqing <caihuoqing@baidu.com>
> 
> [...]

Here is the summary with links:
  - net: enetc: Make use of the helper function dev_err_probe()
    https://git.kernel.org/netdev/net-next/c/a72691ee19ca

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


