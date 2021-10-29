Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 641E243FCA2
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 14:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231502AbhJ2Mwi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 08:52:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:56424 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230492AbhJ2Mwg (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 08:52:36 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7EBD66117A;
        Fri, 29 Oct 2021 12:50:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635511808;
        bh=8A7jVNKhe8n8XuPnA2FudeVKdnsBoqU4jLdS3VqA9qY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MO+MMIoX1Xef2V56xXg0iplJ3Lsbgv5Khn1yzzgmbbBikRlUPsT3VMA5HcM8hwzcD
         06up2y94ZXTxsTopa2oqAaxpMcfWjm866Ol/C5S12+CukDJkB+VPUBn1E/pErAV0Y9
         prOD6k2UO6GaMAwZul1TA5k/w10U+S+WrZ9HF6ioZS/QXKhg0pBCLVHnk9cf1eBUM7
         SMec7DoQB03j7QfLGbZhmvp1aHxxZ3hN69c4P0LDNymyDeaywSdX2STrJVqYV1+RXf
         X3xI3mya+Y3luPNdpeznFT+4burC3/lBcEQzNVUEw2EMb1Z72TB6eJIEazeUkhwU53
         RNsV/ntpNdehA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 67C0A60AA4;
        Fri, 29 Oct 2021 12:50:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: bridge: fix uninitialized variables when
 BRIDGE_CFM is disabled
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163551180842.32606.14897066407826010805.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Oct 2021 12:50:08 +0000
References: <20211028155835.2134753-1-ivecera@redhat.com>
In-Reply-To: <20211028155835.2134753-1-ivecera@redhat.com>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     netdev@vger.kernel.org, henrik.bjoernlund@microchip.com,
        roopa@nvidia.com, nikolay@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, horatiu.vultur@microchip.com,
        bridge@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 28 Oct 2021 17:58:35 +0200 you wrote:
> Function br_get_link_af_size_filtered() calls br_cfm_{,peer}_mep_count()
> that return a count. When BRIDGE_CFM is not enabled these functions
> simply return -EOPNOTSUPP but do not modify count parameter and
> calling function then works with uninitialized variables.
> Modify these inline functions to return zero in count parameter.
> 
> Fixes: b6d0425b816e ("bridge: cfm: Netlink Notifications.")
> Cc: Henrik Bjoernlund <henrik.bjoernlund@microchip.com>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] net: bridge: fix uninitialized variables when BRIDGE_CFM is disabled
    https://git.kernel.org/netdev/net/c/829e050eea69

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


