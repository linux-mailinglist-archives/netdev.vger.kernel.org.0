Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D094A49E7C1
	for <lists+netdev@lfdr.de>; Thu, 27 Jan 2022 17:40:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243855AbiA0QkR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Jan 2022 11:40:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229477AbiA0QkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Jan 2022 11:40:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35A34C061714;
        Thu, 27 Jan 2022 08:40:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 00146B80A39;
        Thu, 27 Jan 2022 16:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A07DDC340EA;
        Thu, 27 Jan 2022 16:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643301611;
        bh=vnzHk441dxrzWNCJqG2DgNbOSn7HXMTUjg7WLIQyXgY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PqT0P8Iz66z5YbgkYeOL6eQW3jjh9+EO/Vkqa4U3nOzUEha+FAF8SJZJ+GF1ndYXc
         9X8blpFNh1rJnzE+t6mqVsNHZnQz0Hcq2rk9ThpX9UCmQn0XOhg0gPfrD0Zv41Ez37
         hNXAXchFET1TQUe0wdfWmDU8h2rARoUHyDVaXozGiisRJt4EULBPyk32ta63RM+mvU
         c9acY4huZz9GdpQ7MCVjBJTPuRXrwKPtIXEZWyJoUOTsU94Pz/X0FNh64L4ElF6zdf
         2/Ruml2Gi61+fMMs/5AiAJWbkXsVbJRzsIrkdGGrNSSay8155DMenIdnvcA/XG+SeY
         0RaJV8Q0Y3+oA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8B0A3E5D08C;
        Thu, 27 Jan 2022 16:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 bpf-next 0/8] xsk: Intel driver improvements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164330161156.2559.11459056156013759056.git-patchwork-notify@kernel.org>
Date:   Thu, 27 Jan 2022 16:40:11 +0000
References: <20220125160446.78976-1-maciej.fijalkowski@intel.com>
In-Reply-To: <20220125160446.78976-1-maciej.fijalkowski@intel.com>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     bpf@vger.kernel.org, ast@kernel.org, daniel@iogearbox.net,
        netdev@vger.kernel.org, magnus.karlsson@intel.com,
        alexandr.lobakin@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Tue, 25 Jan 2022 17:04:38 +0100 you wrote:
> Hi,
> 
> Unfortunately, similar scalability issues that were addressed for XDP
> processing in ice, exist for XDP in the zero-copy driver used by AF_XDP.
> Let's resolve them in mostly the same way as we did in [0] and utilize
> the Tx batching API from XSK buffer pool.
> 
> [...]

Here is the summary with links:
  - [bpf-next,v5,1/8] ice: remove likely for napi_complete_done
    https://git.kernel.org/bpf/bpf-next/c/a4e186693cbe
  - [bpf-next,v5,2/8] ice: xsk: force rings to be sized to power of 2
    https://git.kernel.org/bpf/bpf-next/c/296f13ff3854
  - [bpf-next,v5,3/8] ice: xsk: handle SW XDP ring wrap and bump tail more often
    https://git.kernel.org/bpf/bpf-next/c/3876ff525de7
  - [bpf-next,v5,4/8] ice: make Tx threshold dependent on ring length
    https://git.kernel.org/bpf/bpf-next/c/3dd411efe1ed
  - [bpf-next,v5,5/8] i40e: xsk: move tmp desc array from driver to pool
    https://git.kernel.org/bpf/bpf-next/c/d1bc532e99be
  - [bpf-next,v5,6/8] ice: xsk: avoid potential dead AF_XDP Tx processing
    https://git.kernel.org/bpf/bpf-next/c/86e3f78c8d32
  - [bpf-next,v5,7/8] ice: xsk: improve AF_XDP ZC Tx and use batching API
    https://git.kernel.org/bpf/bpf-next/c/126cdfe1007a
  - [bpf-next,v5,8/8] ice: xsk: borrow xdp_tx_active logic from i40e
    https://git.kernel.org/bpf/bpf-next/c/59e92bfe4df7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


