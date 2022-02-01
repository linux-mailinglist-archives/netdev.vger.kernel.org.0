Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 356804A5D55
	for <lists+netdev@lfdr.de>; Tue,  1 Feb 2022 14:20:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238315AbiBANUO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 08:20:14 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:54656 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231549AbiBANUN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 08:20:13 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 86B0561515;
        Tue,  1 Feb 2022 13:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D33FCC340EE;
        Tue,  1 Feb 2022 13:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643721611;
        bh=4y4Phd2U5ftYs0K8pGGutMcJt1KLSnDxZm8YfPNTjLc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iWhqBRHVWqnxHmLK+iN4SyZe8VceVOtIdbqEtzBqr+KowWU4C+CrQlfK4GQmTmDN1
         CBp+jxjFTJDorrZhnG0BR5uRJyaTYGP74N6ic9IN0bYyNVy5mgJHBPIJ6TJqRfH1h2
         DgfGvGCfybIzHikdEskroEdb/8wUi4v29CRGRCCMKpX8756L1hpiaghyjv/fTuiOAK
         9DCS5RpEuIyMyhlTWS5MnyEnItE403JjzvL4ze3ahK66/ynLDwcgNHpgWwGqgZ63F2
         yZiKjKYxqnNk6FfnRHwgvU32JBxOUEdLmTIZJTZe8QgnlAjZ7jRR7wpUP2l6RIXgFm
         OwJ6J1qCZHo4Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BA9F2E6BAC6;
        Tue,  1 Feb 2022 13:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/9][pull request] 10GbE Intel Wired LAN Driver
 Updates 2022-01-31
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164372161176.4494.1723540477448355962.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Feb 2022 13:20:11 +0000
References: <20220131183152.3085432-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220131183152.3085432-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        alexandr.lobakin@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bjorn@kernel.org,
        maciej.fijalkowski@intel.com, michal.swiatkowski@linux.intel.com,
        kafai@fb.com, songliubraving@fb.com, kpsingh@kernel.org,
        yhs@fb.com, andrii@kernel.org, bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Mon, 31 Jan 2022 10:31:43 -0800 you wrote:
> Alexander Lobakin says:
> 
> This is an interpolation of [0] to other Intel Ethernet drivers
> (and is (re)based on its code).
> The main aim is to keep XDP metadata not only in case with
> build_skb(), but also when we do napi_alloc_skb() + memcpy().
> 
> [...]

Here is the summary with links:
  - [net-next,1/9] i40e: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
    https://git.kernel.org/netdev/net-next/c/bc97f9c6f988
  - [net-next,2/9] i40e: respect metadata on XSK Rx to skb
    https://git.kernel.org/netdev/net-next/c/6dba29537c0f
  - [net-next,3/9] ice: respect metadata in legacy-rx/ice_construct_skb()
    https://git.kernel.org/netdev/net-next/c/ee803dca967a
  - [net-next,4/9] ice: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
    https://git.kernel.org/netdev/net-next/c/dc44572d195e
  - [net-next,5/9] ice: respect metadata on XSK Rx to skb
    https://git.kernel.org/netdev/net-next/c/45a34ca68070
  - [net-next,6/9] igc: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
    https://git.kernel.org/netdev/net-next/c/f9e61d365baf
  - [net-next,7/9] ixgbe: pass bi->xdp to ixgbe_construct_skb_zc() directly
    https://git.kernel.org/netdev/net-next/c/1fbdaa133868
  - [net-next,8/9] ixgbe: don't reserve excessive XDP_PACKET_HEADROOM on XSK Rx to skb
    https://git.kernel.org/netdev/net-next/c/8f405221a73a
  - [net-next,9/9] ixgbe: respect metadata on XSK Rx to skb
    https://git.kernel.org/netdev/net-next/c/f322a620be69

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


