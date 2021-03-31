Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 768B0350A26
	for <lists+netdev@lfdr.de>; Thu,  1 Apr 2021 00:21:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232956AbhCaWU7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Mar 2021 18:20:59 -0400
Received: from mail.kernel.org ([198.145.29.99]:50190 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230309AbhCaWUS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 31 Mar 2021 18:20:18 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7E53C60FEF;
        Wed, 31 Mar 2021 22:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617229218;
        bh=XR2GhFJDG0uscdht9bNZ0OChS0oMBvs3rgKRpgNmwjI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ldguJ9DKRH0UlysgAzc6tCCzef7qbCNBs/k1+72pIW9T/jdJZUhM5QJPpTkMsC67Y
         OPL3TsiIzve4vRyD5rIBjmQMhBuFT/RbNxQWOnjnzMxxoocRQLX5qbWLC/8KoHMIt+
         scIeFQf9ww8IVgeIgEHtb4TXM8y5FOkktOc5CwvJzUNV0vlY8txdRudG0UDOJhN2AR
         mK/ClLLBhb8mZj+gcGQsbuYn9dQLZVlnGPmlew04VH2yM42kOzQkfrvfEiGuh07dC6
         dYlyEWnoWpZWxC6x9eYo4bc3o6V5PakTYzz+bQ9x/xXU684Xwc/JauI0pra/924YVW
         gE7CQ0AD/shiw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 7518060727;
        Wed, 31 Mar 2021 22:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9] XDP for NXP ENETC
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161722921847.2890.11454275035323776176.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Mar 2021 22:20:18 +0000
References: <20210331200857.3274425-1-olteanv@gmail.com>
In-Reply-To: <20210331200857.3274425-1-olteanv@gmail.com>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        bpf@vger.kernel.org, alexander.duyck@gmail.com,
        ioana.ciornei@nxp.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, ilias.apalodimas@linaro.org,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 31 Mar 2021 23:08:48 +0300 you wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This series adds support to the enetc driver for the basic XDP primitives.
> The ENETC is a network controller found inside the NXP LS1028A SoC,
> which is a dual-core Cortex A72 device for industrial networking,
> with the CPUs clocked at up to 1.3 GHz. On this platform, there are 4
> ENETC ports and a 6-port embedded DSA switch, in a topology that looks
> like this:
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] net: enetc: consume the error RX buffer descriptors in a dedicated function
    https://git.kernel.org/netdev/net-next/c/2fa423f5f0c6
  - [net-next,2/9] net: enetc: move skb creation into enetc_build_skb
    https://git.kernel.org/netdev/net-next/c/a800abd3ecb9
  - [net-next,3/9] net: enetc: add a dedicated is_eof bit in the TX software BD
    https://git.kernel.org/netdev/net-next/c/d504498d2eb3
  - [net-next,4/9] net: enetc: clean the TX software BD on the TX confirmation path
    https://git.kernel.org/netdev/net-next/c/1ee8d6f3bebb
  - [net-next,5/9] net: enetc: move up enetc_reuse_page and enetc_page_reusable
    https://git.kernel.org/netdev/net-next/c/65d0cbb414ce
  - [net-next,6/9] net: enetc: add support for XDP_DROP and XDP_PASS
    https://git.kernel.org/netdev/net-next/c/d1b15102dd16
  - [net-next,7/9] net: enetc: add support for XDP_TX
    https://git.kernel.org/netdev/net-next/c/7ed2bc80074e
  - [net-next,8/9] net: enetc: increase RX ring default size
    https://git.kernel.org/netdev/net-next/c/d6a2829e82cf
  - [net-next,9/9] net: enetc: add support for XDP_REDIRECT
    https://git.kernel.org/netdev/net-next/c/9d2b68cc108d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


