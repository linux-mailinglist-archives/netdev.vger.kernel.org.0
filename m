Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4A253463418
	for <lists+netdev@lfdr.de>; Tue, 30 Nov 2021 13:20:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241505AbhK3MXb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 07:23:31 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:55196 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237270AbhK3MXa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 07:23:30 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 61079B818AB;
        Tue, 30 Nov 2021 12:20:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1853EC53FD3;
        Tue, 30 Nov 2021 12:20:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638274809;
        bh=KKGscqz2GT9cYg5Qa0tAq4MUqlpoum9QwbrX2J9dTJU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Egm7xbgQ6IrhXaKkvxQpUHk5vWck/kVZhwWLcJu81vKf+gWejGxTknlMJRXt8K/eP
         h3gZjtpBRlE5Qr5v7+e25OYYxmMeRzMwegkVM31XRg/uDwvJbxHx0CqzI0C6OhYkzp
         YEztBbcESdQWExLiSqSEvaPp7mtuxglgJOgB8aNLdo6SCnXox490VQ05JK+dmni1xk
         y/0wHMvPCcPf226znbwjrfmiUiRVVPl4MJ9r+9b9FK7CqtU5RED4GRrY9vKXN/zHID
         s+GDKD5rbVnsXuW+VQdOh+GZpkd4bQNkLLStqWFzp3bweSuDKkMB1MZIacU99uwHaN
         p7/NZUeFrcJgw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id F292960A50;
        Tue, 30 Nov 2021 12:20:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/1] ice: xsk: clear status_error0 for each allocated desc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163827480898.28928.8800569496106543318.git-patchwork-notify@kernel.org>
Date:   Tue, 30 Nov 2021 12:20:08 +0000
References: <20211129231746.2767739-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211129231746.2767739-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, maciej.fijalkowski@intel.com,
        netdev@vger.kernel.org, magnus.karlsson@intel.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        bpf@vger.kernel.org, alexandr.lobakin@intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 29 Nov 2021 15:17:46 -0800 you wrote:
> From: Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> 
> Fix a bug in which the receiving of packets can stop in the zero-copy
> driver. Ice HW ignores 3 lower bits from QRX_TAIL register, which means
> that tail is bumped only on intervals of 8. Currently with XSK RX
> batching in place, ice_alloc_rx_bufs_zc() clears the status_error0 only
> of the last descriptor that has been allocated/taken from the XSK buffer
> pool. status_error0 includes DD bit that is looked upon by the
> ice_clean_rx_irq_zc() to tell if a descriptor can be processed.
> 
> [...]

Here is the summary with links:
  - [net,1/1] ice: xsk: clear status_error0 for each allocated desc
    https://git.kernel.org/netdev/net/c/d1ec975f9fa6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


