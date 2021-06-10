Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57B3E3A3519
	for <lists+netdev@lfdr.de>; Thu, 10 Jun 2021 22:50:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230323AbhFJUwF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Jun 2021 16:52:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:41648 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230059AbhFJUwC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 10 Jun 2021 16:52:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A871C613E9;
        Thu, 10 Jun 2021 20:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623358205;
        bh=nDPXjGVUvWJP8WgMSZftcr/O2Qn5kU3KWnLTxuhM5pE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jekCwlthO6mJXMTBksnAv6vCySTL1/QJLEqH6MhvARegSuXA+AvHCjBSWzh3TMI9d
         fgAe/aydfCopjbu+z9dTlJaQysnzM7uATtzpRrh/3THtsjQgCI0qrZdJF7ulTyRBj7
         g4TGahMg1omAflbNZQQZaQMA5rM0JVaLtRWI6+3Nxua0IyytN9o+EJ85k9NQJvYPLl
         xlXH4oGsKQCptbH8cuT6YySrGqS72L/+KAHoMTT/OPrDQTi/FqoF2aQu+3/uVf2+A8
         mXTp/KcuCWaGH6ufrEzobAdK0BP819fW2SWYzTXpQqQbomla1mZdPOI4RCAChTXCcT
         u0slUQUeu1amQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9BEFC60952;
        Thu, 10 Jun 2021 20:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2021-06-09
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162335820563.975.2284808192421945722.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Jun 2021 20:50:05 +0000
References: <20210609204803.234983-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20210609204803.234983-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Wed,  9 Jun 2021 13:48:01 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Maciej informs the user when XDP is not supported due to the driver
> being in the 'safe mode' state. He also adds a parameter to Tx queue
> configuration to resolve an issue in configuring XDP queues as it cannot
> rely on using the number Tx or Rx queues.
> 
> [...]

Here is the summary with links:
  - [net,1/2] ice: add ndo_bpf callback for safe mode netdev ops
    https://git.kernel.org/netdev/net/c/ebc5399ea1df
  - [net,2/2] ice: parameterize functions responsible for Tx ring management
    https://git.kernel.org/netdev/net/c/2e84f6b3773f

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


