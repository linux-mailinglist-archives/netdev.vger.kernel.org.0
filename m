Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7BEAF43E0BA
	for <lists+netdev@lfdr.de>; Thu, 28 Oct 2021 14:20:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbhJ1MWo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 08:22:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:51296 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230201AbhJ1MWl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 08:22:41 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id E9FAB61108;
        Thu, 28 Oct 2021 12:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635423613;
        bh=yYfVPPSlTQA6d2hNV7LKPElOdB6vkIJs4eY+dmuh48o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Tm0Q64ifSujdTliCPgt3Ss5AyRJAg78UA7mAIbo1p/rM7kRaO6uRJuqdRbkth9xc+
         WIljBYzmdV9SS0zX83OR/pZ98hXQo7wC+ZrDE6+UaXCTQeD8M7ci88EPwFPM76SVFj
         T7TGnRLuy/WQJJ6K4SM0DEza7vaGTH9pzAAGAH9mtGioar+OOiROOY7OCU9AGg+ko3
         NVdruFD0HIml6Xdn6F3L7+dT4FJhMeQHSiky3T2LasioUj97T0Q4hnwiC2mYverC3x
         KhbVhmOmRG2BuJizRFHzpHG7b3M+zqgjtKCgJwnVX0mDxKhZN0HPNV+hzsZrs5/Ts7
         AkfpqKMbzlNqg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id E516160972;
        Thu, 28 Oct 2021 12:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] firewire: don't write directly to netdev->dev_addr
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163542361293.29870.11627651089310306022.git-patchwork-notify@kernel.org>
Date:   Thu, 28 Oct 2021 12:20:12 +0000
References: <20211026175352.3197750-1-kuba@kernel.org>
In-Reply-To: <20211026175352.3197750-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        stefanr@s5r6.in-berlin.de, linux1394-devel@lists.sourceforge.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 26 Oct 2021 10:53:52 -0700 you wrote:
> Commit 406f42fa0d3c ("net-next: When a bond have a massive amount
> of VLANs...") introduced a rbtree for faster Ethernet address look
> up. To maintain netdev->dev_addr in this tree we need to make all
> the writes to it go through appropriate helpers.
> 
> Prepare fwnet_hwaddr on the stack and use dev_addr_set() to copy
> it to netdev->dev_addr. We no longer need to worry about alignment.
> union fwnet_hwaddr does not have any padding and we set all fields
> so we don't need to zero it upfront.
> 
> [...]

Here is the summary with links:
  - [net-next] firewire: don't write directly to netdev->dev_addr
    https://git.kernel.org/netdev/net-next/c/aaaaa1377e7a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


