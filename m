Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2B2442FF86
	for <lists+netdev@lfdr.de>; Sat, 16 Oct 2021 02:50:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239374AbhJPAwQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Oct 2021 20:52:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:32848 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S234607AbhJPAwP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 15 Oct 2021 20:52:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 929346124B;
        Sat, 16 Oct 2021 00:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634345408;
        bh=k6JZthnvltBnxbQPdVsj7V5FEkmK1pFdhnHkzxEjwwU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SXO/mYnRmFw0GYW2MTTucD9CRRZcZpsc2ueDz8kEnlso2LEBhWGyVEZ91cxHC1QeZ
         vP4OKqjTNOEnotM/sH75eViqj4lLWUADWSfoMZAyJtIgZwAgddhp0tuwIYbTIEYUzk
         TOM5cnO/GpRTMheZ3O7jxBwfXwrL992/7aaMHJETt1Y+kB3VTduTMp8cGjKVeysfbI
         EWYSw9548UPZ4eTbUXBPci6t/aHVZlINQG7NxmEwMTNzHGriNGPmnas3A/vi2DBVXX
         kCzyak3TJaxcdixj2oiSmDN+d87cDe5w1cCgcyyVosjC6gePqbaDo/Q8oBX1zTQsiy
         2aMxQwWmlXeiw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 86062609ED;
        Sat, 16 Oct 2021 00:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates
 2021-10-14
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163434540854.9644.5390320523220662313.git-patchwork-notify@kernel.org>
Date:   Sat, 16 Oct 2021 00:50:08 +0000
References: <20211014181953.3538330-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211014181953.3538330-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-rdma@vger.kernel.org, shiraz.saleem@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu, 14 Oct 2021 11:19:49 -0700 you wrote:
> This series contains updates to ice driver only.
> 
> Brett ensures RDMA nodes are removed during release and rebuild. He also
> corrects fw.mgmt.api to include the patch number for proper
> identification.
> 
> Dave stops ida_free() being called when an IDA has not been allocated.
> 
> [...]

Here is the summary with links:
  - [net,1/4] ice: Fix failure to re-add LAN/RDMA Tx queues
    https://git.kernel.org/netdev/net/c/ff7e93219442
  - [net,2/4] ice: Avoid crash from unnecessary IDA free
    https://git.kernel.org/netdev/net/c/73e30a62b19b
  - [net,3/4] ice: fix getting UDP tunnel entry
    https://git.kernel.org/netdev/net/c/e4c2efa1393c
  - [net,4/4] ice: Print the api_patch as part of the fw.mgmt.api
    https://git.kernel.org/netdev/net/c/b726ddf984a5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


