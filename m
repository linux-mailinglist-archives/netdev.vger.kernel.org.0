Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0C2E0397DB8
	for <lists+netdev@lfdr.de>; Wed,  2 Jun 2021 02:40:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229735AbhFBAlw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Jun 2021 20:41:52 -0400
Received: from mail.kernel.org ([198.145.29.99]:59546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229691AbhFBAls (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 1 Jun 2021 20:41:48 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 225F7613C0;
        Wed,  2 Jun 2021 00:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622594406;
        bh=bY2AyBhjWEXEwxvCeM7WRoAfAFZdMNYHHF61VIzHftQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uUqgOpX5OYg0PGtZBjTPyN6tDjlsB2uXjZrXCTIgzdsp6sBO/8/7dy7a4b1Qa6jca
         ITCjnAZ/yHD1zrtDkS8WZiPcSPmFWZzMz4AXrK0sjT7c+pbwpHi596MJLNg8++2dyD
         0Mm+xzB2ihdcZx9W1xF5lxYlbWInV2k8GdnM+AV89JU3FSxF9aGK1jjWyDksaamNkR
         ueqGN5wI+3os6XvLyHPCJrWcFSrOGv7TmXXHFfggrHCRp5zuc5N7C2aHWlojVIXtRA
         ZHK+5bYkUFiZ5cGIDniic4mFcmCDyL5dJl8EIi2rdDMZQOSdbtGhK7B+fByUrCeh3I
         U9qhPsLLXMcPA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 11D0F60953;
        Wed,  2 Jun 2021 00:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v8 0/3] net: qualcomm: rmnet: Enable Mapv5
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162259440606.2786.10278242816453240434.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Jun 2021 00:40:06 +0000
References: <1622575716-13415-1-git-send-email-sharathv@codeaurora.org>
In-Reply-To: <1622575716-13415-1-git-send-email-sharathv@codeaurora.org>
To:     Sharath Chandra Vurukala <sharathv@codeaurora.org>
Cc:     davem@davemloft.net, kuba@kernel.org, elder@kernel.org,
        cpratapa@codeaurora.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, subashab@codeaurora.org,
        stranche@codeaurora.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed,  2 Jun 2021 00:58:33 +0530 you wrote:
> This series introduces the MAPv5 packet format.
> 
>    Patch 0 documents the MAPv4/v5.
>    Patch 1 introduces the MAPv5 and the Inline checksum offload for RX/Ingress.
>    Patch 2 introduces the MAPv5 and the Inline checksum offload for TX/Egress.
> 
>    A new checksum header format is used as part of MAPv5.For RX checksum offload,
>    the checksum is verified by the HW and the validity is marked in the checksum
>    header of MAPv5. For TX, the required metadata is filled up so hardware can
>    compute the checksum.
> 
> [...]

Here is the summary with links:
  - [net-next,v8,1/3] docs: networking: Add documentation for MAPv5
    https://git.kernel.org/netdev/net-next/c/710b797cf61b
  - [net-next,v8,2/3] net: ethernet: rmnet: Support for ingress MAPv5 checksum offload
    https://git.kernel.org/netdev/net-next/c/e1d9a90a9bfd
  - [net-next,v8,3/3] net: ethernet: rmnet: Add support for MAPv5 egress packets
    https://git.kernel.org/netdev/net-next/c/b6e5d27e32ef

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


