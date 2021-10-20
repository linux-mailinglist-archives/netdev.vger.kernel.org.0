Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F13A4349CF
	for <lists+netdev@lfdr.de>; Wed, 20 Oct 2021 13:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229864AbhJTLMj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 20 Oct 2021 07:12:39 -0400
Received: from mail.kernel.org ([198.145.29.99]:58316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230181AbhJTLM1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 20 Oct 2021 07:12:27 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id D2783613E6;
        Wed, 20 Oct 2021 11:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634728212;
        bh=1ufr3JCCPTDF4UHHjYhBe5K+6viZjdecGfVaaVds82Q=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U9xzvhKV6cPdmo1GGtPO0rURcWmubOfi9t8goYJGbay1HV3Jdh3r6/OW7lrKskEVi
         0O1ROjNWA7QrDwIXIETAcNx20KQPXsOKEuffi7zxCE5wzOm8TNOvVqsYt8+wNkBWrz
         5ef02u6srMTvYy62gnpjQyeH65sqeCDqFkxThiFQAHUzOMe9H85zryPFXD0DtVpTTl
         XiOkrn36yEwHufa9sjv17b+nMuOCLmV9Lah2x0nRFXk2KfoE2OKwI8b688WNKfhhlN
         Ei+I6Jp4u+njObQLbwKYcKmV+nx0hnNYEt7tZEzmLfn5NJAGlYH9ZRFqN81LILsfST
         H70K87OFw13Xw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id C2BD3609D1;
        Wed, 20 Oct 2021 11:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/10][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-10-19
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163472821279.2036.12556887164174208256.git-patchwork-notify@kernel.org>
Date:   Wed, 20 Oct 2021 11:10:12 +0000
References: <20211019183027.2820413-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211019183027.2820413-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 19 Oct 2021 11:30:17 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Brett implements support for ndo_set_vf_rate allowing for min_tx_rate
> and max_tx_rate to be set for a VF.
> 
> Jesse updates DIM moderation to improve latency and resolves problems
> with reported rate limit and extra software generated interrupts.
> 
> [...]

Here is the summary with links:
  - [net-next,01/10] ice: Add support for VF rate limiting
    https://git.kernel.org/netdev/net-next/c/4ecc8633056b
  - [net-next,02/10] ice: update dim usage and moderation
    https://git.kernel.org/netdev/net-next/c/d8eb7ad5e46c
  - [net-next,03/10] ice: fix rate limit update after coalesce change
    https://git.kernel.org/netdev/net-next/c/d16a4f45f3a3
  - [net-next,04/10] ice: fix software generating extra interrupts
    https://git.kernel.org/netdev/net-next/c/23be7075b318
  - [net-next,05/10] ice: Forbid trusted VFs in switchdev mode
    https://git.kernel.org/netdev/net-next/c/1281b7459657
  - [net-next,06/10] ice: Manage act flags for switchdev offloads
    https://git.kernel.org/netdev/net-next/c/73b483b79029
  - [net-next,07/10] ice: Refactor PR ethtool ops
    https://git.kernel.org/netdev/net-next/c/3f13f570ff2c
  - [net-next,08/10] ice: Make use of the helper function devm_add_action_or_reset()
    https://git.kernel.org/netdev/net-next/c/7c1b694adab1
  - [net-next,09/10] ice: use devm_kcalloc() instead of devm_kzalloc()
    https://git.kernel.org/netdev/net-next/c/6f3323536aa8
  - [net-next,10/10] ice: fix an error code in ice_ena_vfs()
    https://git.kernel.org/netdev/net-next/c/8702ed0b0de1

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


