Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3DC223A50C7
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 23:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231431AbhFLVM1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Jun 2021 17:12:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:44588 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229753AbhFLVMZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 12 Jun 2021 17:12:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 338DA61009;
        Sat, 12 Jun 2021 21:10:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623532225;
        bh=vISTxnNCH4cZAzIm4j+RJ46TMBgMiM3mwpRjIkvwTg0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E0VanTqFC3Z4EcpQ1UAx+nT1uxDq89Uct/sBNTP8JHbeN1aIqFKjZi+zhSD1rP0mn
         iylqDnvWHODohWs9Y/XbAHz1X9pGDIg1BH+RP0r21hfLaqr4oP2L7Ju9eBLniQpxMe
         pMv/FlXTkZnwD77uGDL9xWeTZLmtXbrASj5ixvIp7F1+CtPuWr5F2SroW8SaWxMNsV
         Wy43fKQjWgGdB8I83QkCfoDQRbr94ZgIsZ7Mp1AdEyVCKgpr7FeqN6V4HvyJA//WdK
         gXA9+puqnY/AwDxjeWMh30M6Li1yyYAb8rQ38C5Tqx2KmUKOEWxJ6M5B2hPBsgZuba
         SsHOQaTobWYig==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 217B160CE2;
        Sat, 12 Jun 2021 21:10:25 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/4] net: Add WWAN link creation support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162353222513.27672.3139028019417802781.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Jun 2021 21:10:25 +0000
References: <1623486057-13075-1-git-send-email-loic.poulain@linaro.org>
In-Reply-To: <1623486057-13075-1-git-send-email-loic.poulain@linaro.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     kuba@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        m.chetan.kumar@intel.com, johannes.berg@intel.com, leon@kernel.org,
        ryazanov.s.a@gmail.com, parav@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 12 Jun 2021 10:20:53 +0200 you wrote:
> Most of the modern WWAN modems are able to support multiple network
> contexts, allowing user to connect to different APNs (e.g. Internet,
> MMS, etc...). These contexts are usually dynamically configured via
> a control channel such as MBIM, QMI or AT.
> 
> Each context is naturally represented as a network link/device, and
> the muxing of these links is usually vendor/bus specific (QMAP, MBIM,
> intel iosm...). Today some drivers create a static collection of
> netdevs at init time, some relies on VLAN link for associating a context
> (cdc-mbim), some exposes sysfs attribute for dynamically creating
> additional netdev (qmi_wwan add_mux attr) or relies on vendor specific
> link type (rmnet) for performing the muxing... so there is no generic
> way to handle WWAN links, making user side integration painful.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/4] rtnetlink: add alloc() method to rtnl_link_ops
    https://git.kernel.org/netdev/net-next/c/8c713dc93ca9
  - [net-next,v3,2/4] rtnetlink: add IFLA_PARENT_[DEV|DEV_BUS]_NAME
    https://git.kernel.org/netdev/net-next/c/00e77ed8e64d
  - [net-next,v3,3/4] wwan: add interface creation support
    https://git.kernel.org/netdev/net-next/c/88b710532e53
  - [net-next,v3,4/4] net: mhi_net: Register wwan_ops for link creation
    https://git.kernel.org/netdev/net-next/c/13adac032982

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


