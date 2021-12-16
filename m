Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 90A74477DD7
	for <lists+netdev@lfdr.de>; Thu, 16 Dec 2021 21:51:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241464AbhLPUvm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 15:51:42 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:57510 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229845AbhLPUvl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Dec 2021 15:51:41 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6F54161F7E
        for <netdev@vger.kernel.org>; Thu, 16 Dec 2021 20:51:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C8A04C36AEC;
        Thu, 16 Dec 2021 20:51:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639687900;
        bh=RUrpAB/N4k10oopSQ3kg0seaei+vCtHuGrGQdRKinZg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mA+IvLMByx7DBun8fuj3BA3StIz+1d2zk9JaQWBczCCAUucqgyilQ2SukAgk2c6F3
         qpHUniEhhGAtWjwklDzM3rsbngAlK94/FBCppxqdokD1J5bhptqKb2ZMq6pdm+5oeQ
         S4dd25OrE7GQIExtKC7xYog26pEk+22IyMuXAiUNRTcU68tn0vjZN+YJ1CD0BtCvG8
         dcqL7DZ7CQMYYapVLXtIgXUUzfibOguxB3YX2KOAu+gbPD2tdxATisKaPJJO/pImlI
         ZGWJypYIO/At2D/grZqkY9e4tRtlJDc1v8if+sjbJDV5w+Uf2cTLIbuCb1Ryl816TL
         gP44S7aAkQGLA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id A627B60A9C;
        Thu, 16 Dec 2021 20:51:40 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: Fix double 0x prefix print in SKB dump
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163968790067.17466.9672814386764242322.git-patchwork-notify@kernel.org>
Date:   Thu, 16 Dec 2021 20:51:40 +0000
References: <20211216092826.30068-1-gal@nvidia.com>
In-Reply-To: <20211216092826.30068-1-gal@nvidia.com>
To:     Gal Pressman <gal@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 16 Dec 2021 11:28:25 +0200 you wrote:
> When printing netdev features %pNF already takes care of the 0x prefix,
> remove the explicit one.
> 
> Fixes: 6413139dfc64 ("skbuff: increase verbosity when dumping skb data")
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> ---
>  net/core/skbuff.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] net: Fix double 0x prefix print in SKB dump
    https://git.kernel.org/netdev/net/c/8a03ef676ade

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


