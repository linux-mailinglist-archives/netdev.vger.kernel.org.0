Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A1BE3CF948
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 14:00:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236462AbhGTLTa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 07:19:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:54514 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235368AbhGTLT0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 07:19:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 8E51A6113C;
        Tue, 20 Jul 2021 12:00:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626782404;
        bh=177TBvvTLIbMygxfVWvZDKrus3TB4epZp0+5eZEJm6Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LE9MPu8wGlk5ydq4SszzV4cKTKwHPvleJzE8Zk/dWHxl9R+Dqs/kccr7sb4gQcpIR
         2U+p7y7uYkUxchexIbNB2PGqLI1oZoAlBECCWHU8nZLRJ8W2cB2PdJmi2zVztIF+PS
         EVbxD4stRBPZGeJaKO1nqJHNM4NDjUEeQwmpSgvKNVRlaXFfLZXRMOTqlDg0iiYvpO
         qpyMIzaEDc1i5jZffWMrxAMl5dBNtDQl97Gu4Z6prN8oa9yhZKpk8XN0cM2KqB/tpi
         ZIFYkbBtuTS2wl78FZmF4x3cj7Dkc1kLej0gmZaYbmLIQ9xqAsBA2HYfP9FeVP/MsS
         xwQoXv7CFbSSQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8143060A0B;
        Tue, 20 Jul 2021 12:00:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Revert "igc: Export LEDs"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162678240452.9139.8338036876262586329.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 12:00:04 +0000
References: <20210719101640.16047-1-kurt@linutronix.de>
In-Reply-To: <20210719101640.16047-1-kurt@linutronix.de>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     davem@davemloft.net, kuba@kernel.org, andrew@lunn.ch,
        hkallweit1@gmail.com, anthony.l.nguyen@intel.com,
        netdev@vger.kernel.org, vinicius.gomes@intel.com,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        dvorax.fuxbrumer@linux.intel.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 19 Jul 2021 12:16:40 +0200 you wrote:
> This reverts commit cf8331825a8d10e46fa574fdf015a65cb5a6db86.
> 
> There are better Linux interfaces to export the different LED modes
> and blinking reasons.
> 
> Revert this patch for now and come up with better solution later.
> 
> [...]

Here is the summary with links:
  - [net-next] Revert "igc: Export LEDs"
    https://git.kernel.org/netdev/net-next/c/edd2e9d58646

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


