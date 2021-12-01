Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 157BB46506B
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 15:50:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234074AbhLAOxe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Dec 2021 09:53:34 -0500
Received: from sin.source.kernel.org ([145.40.73.55]:48452 "EHLO
        sin.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229714AbhLAOxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Dec 2021 09:53:34 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 896F0CE1F4C;
        Wed,  1 Dec 2021 14:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B37EDC53FAD;
        Wed,  1 Dec 2021 14:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638370209;
        bh=EB6+uYnC16iug6UPBRdczP3wfnV6IClAeHhmLYpQVHM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OvDkUC3CRUX/Hwgzc9ejbnpj9k5j4QrvxHb8ExPnLrqLjqyIzhXpsowfFORR7TER8
         0CF4AkdZVTXJZ/xSsgejFoZfSlZw6XwUrT7PekIEw+xFUMhgbbntfTd8nGzwbD+Y+t
         wwThf2g23ZouEo8vbelOjgh23K2Q9XWL+I80inFUZMXl0vzmu/bRzoavmz+pbkQVHU
         g1ugXh1oAHAWrN2lgVgjltejBzCUR1tWyNRgGAaAn0VhPuXQDl6XZ/hNana4OcAN/8
         H5DD+0UTKw6ef2fEjRQ5JrxP4dwd403QHHMP6tokT818vaKLuU2Csw+Acgdh6YlMQI
         9tyEyIb33DWIw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 984F260BE3;
        Wed,  1 Dec 2021 14:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2][pull request] 1GbE Intel Wired LAN Driver
 Updates 2021-11-30
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163837020961.10998.3553685550782713867.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Dec 2021 14:50:09 +0000
References: <20211130175918.3705966-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20211130175918.3705966-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sasha.neftin@intel.com, vitaly.lifshits@intel.com,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com, bpf@vger.kernel.org, andrii@kernel.org,
        kpsingh@kernel.org, kafai@fb.com, yhs@fb.com, songliubraving@fb.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Tue, 30 Nov 2021 09:59:16 -0800 you wrote:
> Jesper Dangaard Brouer says:
> 
> Changes to fix and enable XDP metadata to a specific Intel driver igc.
> Tested with hardware i225 that uses driver igc, while testing AF_XDP
> access to metadata area.
> 
> The following are changes since commit 196073f9c44be0b4758ead11e51bc2875f98df29:
>   net: ixp4xx_hss: drop kfree for memory allocated with devm_kzalloc
> and are available in the git repository at:
>   git://git.kernel.org/pub/scm/linux/kernel/git/tnguy/next-queue 1GbE
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] igc: AF_XDP zero-copy metadata adjust breaks SKBs on XDP_PASS
    https://git.kernel.org/netdev/net-next/c/4fa8fcd34401
  - [net-next,2/2] igc: enable XDP metadata in driver
    https://git.kernel.org/netdev/net-next/c/f51b5e2b5943

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


