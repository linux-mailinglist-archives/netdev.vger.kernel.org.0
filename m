Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D9142DEED
	for <lists+netdev@lfdr.de>; Thu, 14 Oct 2021 18:10:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232957AbhJNQMN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 12:12:13 -0400
Received: from mail.kernel.org ([198.145.29.99]:50714 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229823AbhJNQMN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 12:12:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 253EF611B0;
        Thu, 14 Oct 2021 16:10:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634227808;
        bh=I6a7yLGrAVwPYcLE1rMls/YTFOgpA1312JL0EaldnNg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=axJI4ZZgpszxkwiRwJVTnuQXygBTovjy+0L/YGUKlvBxKd23Bo7j4QZ6xW3kdSfk6
         8yZxjUuO5gDKhDh7n6GZL//V/VyILLN8tZj29s/e9cC7kmSEn5wj1O0vmZfHUeNlAZ
         f+WvrawgDPy/xu+2YR6cfrdGNBDasEAfltjs4pCzrFfYrf5FRYGvB6xGyCxKaICk5h
         8TR6tsO0lUfMzCRoDOnwWwXUpu9FGYyjzcx3WcGoxzDKiMBWZs0vdT4lfWyc/BecB1
         7yACsdJiwEVi1p0WtsBYaLm7FLMkNlYcOmB6cDcPJkqmElikrlmHO5Dh+2QDKb9RTo
         ojnNmDeepWUYw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 056E060A38;
        Thu, 14 Oct 2021 16:10:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/4][pull request] 100GbE Intel Wired LAN Driver
 Updates 2021-10-14
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163422780801.16312.9362436454441664676.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Oct 2021 16:10:08 +0000
References: <20211014153531.2908804-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211014153531.2908804-1-anthony.l.nguyen@intel.com>
To:     Nguyen@ci.codeaurora.org, Anthony L <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        maciej.machnikowski@intel.com, richardcochran@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu, 14 Oct 2021 08:35:27 -0700 you wrote:
> Maciej Machnikowski says:
> 
> Extend the driver implementation to support PTP pins on E810-T and
> derivative devices.
> 
> E810-T adapters are equipped with:
> - 2 external bidirectional SMA connectors
> - 1 internal TX U.FL shared with SMA1
> - 1 internal RX U.FL shared with SMA2
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/4] ice: Refactor ice_aqc_link_topo_addr
    https://git.kernel.org/netdev/net-next/c/e00ae1a2aaf2
  - [net-next,v2,2/4] ice: Implement functions for reading and setting GPIO pins
    https://git.kernel.org/netdev/net-next/c/3bb6324b3dcb
  - [net-next,v2,3/4] ice: Add support for SMA control multiplexer
    https://git.kernel.org/netdev/net-next/c/885fe6932a11
  - [net-next,v2,4/4] ice: Implement support for SMA and U.FL on E810-T
    https://git.kernel.org/netdev/net-next/c/325b2064d00a

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


