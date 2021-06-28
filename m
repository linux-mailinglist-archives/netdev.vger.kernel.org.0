Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5EF973B69D1
	for <lists+netdev@lfdr.de>; Mon, 28 Jun 2021 22:41:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237282AbhF1Un2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Jun 2021 16:43:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:45696 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233916AbhF1UnU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 28 Jun 2021 16:43:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 456A261CDA;
        Mon, 28 Jun 2021 20:40:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624912854;
        bh=+PcefzA3fizVHCFf54jx5/Ry5NYU+O+0AOH89mdL5pI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hysMDLqJNdJ7G4qBCj+mmGJyJQwCDFl/0TkUAWRGnmiMXWZvZxNVkYWG45jNUn7a3
         23XraJLR5rtXeeGJ5oQp8X3UtqoMh68JSxLKM7XFHDFJTRLcqFGvCn8Mq7egYvZKxV
         utVVGs2M4ADWFQAuu+s1Axsl8kNZ0ERYfXswIOCaJvJr5KITrFfLCzb0m0XFvpYLnN
         DRwFAjOE7b1AJndR9gsKArAw+k6v028bmF+p8Toy3+ePcP0W3U1pC5J+4pHSLplZ81
         X6zds+dlXRZU/JWz1/O4ZUGhx0rrrX8T2ovJnTRzqzZIZUOFf+wvXbFHQTlN5mBAmT
         N4gEqg0dka4Wg==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 3920160A6C;
        Mon, 28 Jun 2021 20:40:54 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 01/17] esp: drop unneeded assignment in esp4_gro_receive()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162491285422.18293.3691707524656867154.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Jun 2021 20:40:54 +0000
References: <20210628054522.1718786-2-steffen.klassert@secunet.com>
In-Reply-To: <20210628054522.1718786-2-steffen.klassert@secunet.com>
To:     Steffen Klassert <steffen.klassert@secunet.com>
Cc:     davem@davemloft.net, kuba@kernel.org, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Mon, 28 Jun 2021 07:45:06 +0200 you wrote:
> From: Yang Li <yang.lee@linux.alibaba.com>
> 
> Making '!=' operation with 0 directly after calling
> the function xfrm_parse_spi() is more efficient,
> assignment to err is redundant.
> 
> Eliminate the following clang_analyzer warning:
> net/ipv4/esp4_offload.c:41:7: warning: Although the value stored to
> 'err' is used in the enclosing expression, the value is never actually
> read from 'err'
> 
> [...]

Here is the summary with links:
  - [01/17] esp: drop unneeded assignment in esp4_gro_receive()
    https://git.kernel.org/netdev/net-next/c/335a2a1fcefc
  - [02/17] xfrm: add state hashtable keyed by seq
    https://git.kernel.org/netdev/net-next/c/fe9f1d8779cb
  - [03/17] net: Remove unnecessary variables
    https://git.kernel.org/netdev/net-next/c/a925316af80a
  - [04/17] xfrm: remove description from xfrm_type struct
    https://git.kernel.org/netdev/net-next/c/152bca090243
  - [05/17] xfrm: policy: fix a spelling mistake
    https://git.kernel.org/netdev/net-next/c/7a7ae1eba24a
  - [06/17] xfrm: ipv6: add xfrm6_hdr_offset helper
    https://git.kernel.org/netdev/net-next/c/9acf4d3b9ec1
  - [07/17] xfrm: ipv6: move mip6_destopt_offset into xfrm core
    https://git.kernel.org/netdev/net-next/c/37b9e7eb5565
  - [08/17] xfrm: ipv6: move mip6_rthdr_offset into xfrm core
    https://git.kernel.org/netdev/net-next/c/848b18fb7fbd
  - [09/17] xfrm: remove hdr_offset indirection
    https://git.kernel.org/netdev/net-next/c/d1002d2490e3
  - [10/17] xfrm: merge dstopt and routing hdroff functions
    https://git.kernel.org/netdev/net-next/c/3ca5ca83e206
  - [11/17] xfrm: delete xfrm4_output_finish xfrm6_output_finish declarations
    https://git.kernel.org/netdev/net-next/c/1b50dd478f49
  - [12/17] xfrm: avoid compiler warning when ipv6 is disabled
    https://git.kernel.org/netdev/net-next/c/30ad6a84f60b
  - [13/17] xfrm: replay: avoid xfrm replay notify indirection
    https://git.kernel.org/netdev/net-next/c/cfc61c598e43
  - [14/17] xfrm: replay: remove advance indirection
    https://git.kernel.org/netdev/net-next/c/c7f877833c9f
  - [15/17] xfrm: replay: remove recheck indirection
    https://git.kernel.org/netdev/net-next/c/25cfb8bc97c2
  - [16/17] xfrm: replay: avoid replay indirection
    https://git.kernel.org/netdev/net-next/c/adfc2fdbae30
  - [17/17] xfrm: replay: remove last replay indirection
    https://git.kernel.org/netdev/net-next/c/b5a1d1fe0cbb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


