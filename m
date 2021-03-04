Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 972D732DCA5
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 23:02:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240113AbhCDWBQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Mar 2021 17:01:16 -0500
Received: from mail.kernel.org ([198.145.29.99]:50948 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235662AbhCDWAs (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Mar 2021 17:00:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D88DA64FE4;
        Thu,  4 Mar 2021 22:00:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614895207;
        bh=v7STz+P0k+GaUBlknWIHfpFgVaRS8NW4K0lTnqmkkPo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eHjOjdLvRYvccgv1PFXXJGYCz+y29quVAhNUAh/bVd5RyjvnqShgyKWWvzvOiMfWi
         7QItNAaIYHQVYeewdpEhmPnlSmyvdeYs8fF9BI/vPMiCvDJa8DLMA2Qff1IfPVAf17
         MvkA893ogeGZmlN27vM5OKwVPgRjSs6N3c/F2i+HBkVOBL8B0xfdqfj9Oec33FfDPa
         /t8btbYnQQkuMY6WTTWFaRT5e+qqqOUzrXvDwEF9Lsqp8Uq5mWWoi2h4B+/CbV+nFn
         PACq+UUfQl507nVT16DGavJQBOfdUrnakKbtAaeBnhll/P3ZfNnz580V1WvV+c6MU4
         dBYQGZU/gfgvA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id CCA78609EA;
        Thu,  4 Mar 2021 22:00:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/2][pull request] Intel Wired LAN Driver Updates
 2021-03-04
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161489520783.31844.13465355266597081465.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Mar 2021 22:00:07 +0000
References: <20210304192017.1911095-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210304192017.1911095-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Thu,  4 Mar 2021 11:20:15 -0800 you wrote:
> This series contains updates to ixgbe and ixgbevf drivers.
> 
> Antony Antony adds a check to fail for non transport mode SA with
> offload as this is not supported for ixgbe and ixgbevf.
> 
> Dinghao Liu fixes a memory leak on failure to program a perfect filter
> for ixgbe.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/2] ixgbe: fail to create xfrm offload of IPsec tunnel mode SA
    https://git.kernel.org/netdev/net/c/d785e1fec601
  - [net,v2,2/2] ixgbe: Fix memleak in ixgbe_configure_clsu32
    https://git.kernel.org/netdev/net/c/7a766381634d

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


