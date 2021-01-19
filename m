Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2889F2FC4F4
	for <lists+netdev@lfdr.de>; Wed, 20 Jan 2021 00:42:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730932AbhASXli (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Jan 2021 18:41:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:60646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730751AbhASXku (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 19 Jan 2021 18:40:50 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 1D83323104;
        Tue, 19 Jan 2021 23:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1611099609;
        bh=MssI9+vwhZGCSP3/2VaSQwrblQaQ4nMnm3sP6p6ESjA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sJjxlJZNbTzHFKr5aZMdBcHqRPI0x6H3O+w+Ckn3a69NsLYEgEI3eVSMxs2e4exLh
         j0myakPrLIjZwPjpO+TUMRLlZyoxB50et6SuJUGO1rFvVdh0yFuf16TBO+xFLSYtGU
         FgprJw5zJ7vb78pLo5eribzPFF7gdL4ZMeYmbOR7ZNOf6U0/ajvJd0Ze8/Ze4VvF/y
         4TZJwaf3w5yNo9PPJFoSpGNRjm39sFVeiVAvnwquAILIKfBRRO7OijpM+K4f0WDdQT
         9uq3qqW91cwrwse4HUSPUqGo9n1QOY8zwNMbJSsgNBVhzKDAU00ezzj8IvbyyJyhZY
         10GtUueOdoZZA==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id 02C34604FC;
        Tue, 19 Jan 2021 23:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: support SCTP CRC csum offload for tunneling
 packets in some drivers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161109960900.4067.12876636834749313206.git-patchwork-notify@kernel.org>
Date:   Tue, 19 Jan 2021 23:40:09 +0000
References: <cover.1610777159.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1610777159.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, linux-sctp@vger.kernel.org,
        marcelo.leitner@gmail.com, nhorman@tuxdriver.com,
        davem@davemloft.net, kuba@kernel.org, alexander.duyck@gmail.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        intel-wired-lan@lists.osuosl.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Sat, 16 Jan 2021 14:13:36 +0800 you wrote:
> This patchset introduces inline function skb_csum_is_sctp(), and uses it
> to validate it's a sctp CRC csum offload packet, to make SCTP CRC csum
> offload for tunneling packets supported in some HW drivers.
> 
> Xin Long (6):
>   net: add inline function skb_csum_is_sctp
>   net: igb: use skb_csum_is_sctp instead of protocol check
>   net: igbvf: use skb_csum_is_sctp instead of protocol check
>   net: igc: use skb_csum_is_sctp instead of protocol check
>   net: ixgbe: use skb_csum_is_sctp instead of protocol check
>   net: ixgbevf: use skb_csum_is_sctp instead of protocol check
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: add inline function skb_csum_is_sctp
    https://git.kernel.org/netdev/net-next/c/fa8211701043
  - [net-next,2/6] net: igb: use skb_csum_is_sctp instead of protocol check
    https://git.kernel.org/netdev/net-next/c/8bcf02035bd5
  - [net-next,3/6] net: igbvf: use skb_csum_is_sctp instead of protocol check
    https://git.kernel.org/netdev/net-next/c/d2de44443caf
  - [net-next,4/6] net: igc: use skb_csum_is_sctp instead of protocol check
    https://git.kernel.org/netdev/net-next/c/609d29a9d242
  - [net-next,5/6] net: ixgbe: use skb_csum_is_sctp instead of protocol check
    https://git.kernel.org/netdev/net-next/c/f8c4b01d3a68
  - [net-next,6/6] net: ixgbevf: use skb_csum_is_sctp instead of protocol check
    https://git.kernel.org/netdev/net-next/c/fc186d0a4ef8

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


