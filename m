Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F386439C2A5
	for <lists+netdev@lfdr.de>; Fri,  4 Jun 2021 23:40:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231545AbhFDVmE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Jun 2021 17:42:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:40468 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230041AbhFDVlw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Jun 2021 17:41:52 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 224256140C;
        Fri,  4 Jun 2021 21:40:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622842806;
        bh=tMqLt15fstFS3l/WtxDHTRJrSAwmSiGCPygRccIuxXs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DcRw+2U9nT7XgTECeosRWHHEV+prtq7p+kKx7xmwXfbPEt6UDv5D/K2KvEMuyYv0Q
         QqGhPe2CTk6R71vkZXxB2N4Yiu3CTph6tk+GRngxKxUJmZh3e+awP486ihfih5lzEw
         cyyvoM8RvbOkkgHJdZiY6XYEXzwg6MRnFlH4AZfuhuOqMhY4XPOQbnwzOkasDjEeIR
         0GMiG7LjyfAHmxwG6o2OuISnFTdkc1YExtux59GP48x4f6zYzOQ0AaatHIUDBNvZBu
         pK9gdC+vhJ97e56+gACW3QqmwMj3xUYroFqGnwf7ocsGGnvdWcaG/aOPI4hM8KaDmV
         5iKerZ/0R/64w==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 18CA160BFB;
        Fri,  4 Jun 2021 21:40:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: enetc: use get/put_unaligned helpers for MAC
 address handling
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162284280609.31903.540810448159156117.git-patchwork-notify@kernel.org>
Date:   Fri, 04 Jun 2021 21:40:06 +0000
References: <20210604134212.6982-1-michael@walle.cc>
In-Reply-To: <20210604134212.6982-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        claudiu.manoil@nxp.com, davem@davemloft.net, kuba@kernel.org,
        vladimir.oltean@nxp.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Fri,  4 Jun 2021 15:42:12 +0200 you wrote:
> The supplied buffer for the MAC address might not be aligned. Thus
> doing a 32bit (or 16bit) access could be on an unaligned address. For
> now, enetc is only used on aarch64 which can do unaligned accesses, thus
> there is no error. In any case, be correct and use the get/put_unaligned
> helpers.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: enetc: use get/put_unaligned helpers for MAC address handling
    https://git.kernel.org/netdev/net-next/c/ecb0605810f3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


