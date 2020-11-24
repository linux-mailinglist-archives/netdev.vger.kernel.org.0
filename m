Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B302C3446
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 00:01:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729521AbgKXXAG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 18:00:06 -0500
Received: from mail.kernel.org ([198.145.29.99]:58638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728404AbgKXXAG (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 18:00:06 -0500
Content-Type: text/plain; charset="utf-8"
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606258805;
        bh=JVUDvk47SnyR2f5xhpj8JB3bkMCNnXzwJpVV0356upU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jimY1Zrf94/dilv9CYAd5RJo0MmfeKnvsY39HkwrwHYpzUJQnyy1RgmYAZUT5y8YH
         /AzREVLIKs/X/qzLjClqL7kAU8LpcYS5IYwOm1foTjHS5CXN2A0OyonzxMjBNAgNHf
         NYVgCDhti4KEqvA7HnurNX4oLQG0r8kzYqSYh5F8=
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] dpaa2-eth: Fix compile error due to missing devlink
 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <160625880541.8800.564472300134890025.git-patchwork-notify@kernel.org>
Date:   Tue, 24 Nov 2020 23:00:05 +0000
References: <20201123163553.1666476-1-ciorneiioana@gmail.com>
In-Reply-To: <20201123163553.1666476-1-ciorneiioana@gmail.com>
To:     Ioana Ciornei <ciorneiioana@gmail.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, ezequiel@collabora.com,
        ioana.ciornei@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 23 Nov 2020 18:35:53 +0200 you wrote:
> From: Ezequiel Garcia <ezequiel@collabora.com>
> 
> The dpaa2 driver depends on devlink, so it should select
> NET_DEVLINK in order to fix compile errors, such as:
> 
> drivers/net/ethernet/freescale/dpaa2/dpaa2-eth.o: in function `dpaa2_eth_rx_err':
> dpaa2-eth.c:(.text+0x3cec): undefined reference to `devlink_trap_report'
> drivers/net/ethernet/freescale/dpaa2/dpaa2-eth-devlink.o: in function `dpaa2_eth_dl_info_get':
> dpaa2-eth-devlink.c:(.text+0x160): undefined reference to `devlink_info_driver_name_put'
> 
> [...]

Here is the summary with links:
  - [net] dpaa2-eth: Fix compile error due to missing devlink support
    https://git.kernel.org/netdev/net/c/078eb55cdf25

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


