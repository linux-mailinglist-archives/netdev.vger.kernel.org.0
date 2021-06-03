Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7505239ACA4
	for <lists+netdev@lfdr.de>; Thu,  3 Jun 2021 23:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230129AbhFCVVv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Jun 2021 17:21:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:49070 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229640AbhFCVVu (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Jun 2021 17:21:50 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 0806961403;
        Thu,  3 Jun 2021 21:20:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622755205;
        bh=IfSq5Dd/Ab+O41ImRrQMvqTshXVTzVLzZsL1xJq/qtc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Phkd9DSV5zUozHMjfHwSYbWlmzgXhvipmhq7/6sTIzCAWB/mtuB+NKf1wu1bFoEwX
         femnmpCD+UE/u/FolMoWY6TCZibHXTVBkgE4qn+AZuA8FsvtjuxeLO1ZExr+GfgLmN
         vFfctzskAr5OEswYjH2KtfB06kRQQQ/MeENM+sylYZ+NB4ZDm4rmKUWZcgyEGLX2qd
         2Aqyx7xCyX82EWnjt14slPTs62RuVu3uNLX4kzZ4RCEMjKRcW64jVheJzUsmuqufh9
         RDRSDCxaWf9tqV1rz+ZPd1HFlf0tBWbv124ZrSazrppryEaYPwZkc1GR+fssBzDktv
         4uQuapRvq6r9Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 014BA60ACA;
        Thu,  3 Jun 2021 21:20:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/8] NVMeTCP Offload ULP
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162275520500.10237.9696423451786528380.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Jun 2021 21:20:05 +0000
References: <20210602184246.14184-1-smalin@marvell.com>
In-Reply-To: <20210602184246.14184-1-smalin@marvell.com>
To:     Shai Malin <smalin@marvell.com>
Cc:     linux-nvme@lists.infradead.org, sagi@grimberg.me, hch@lst.de,
        axboe@fb.com, kbusch@kernel.org, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, aelior@marvell.com,
        mkalderon@marvell.com, okulkarni@marvell.com,
        pkushwaha@marvell.com, prabhakar.pkin@gmail.com,
        malin1024@gmail.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Wed, 2 Jun 2021 21:42:38 +0300 you wrote:
> With the goal of enabling a generic infrastructure that allows NVMe/TCP
> offload devices like NICs to seamlessly plug into the NVMe-oF stack, this
> patch series introduces the nvme-tcp-offload ULP host layer, which will
> be a new transport type called "tcp-offload" and will serve as an
> abstraction layer to work with vendor specific nvme-tcp offload drivers.
> 
> NVMeTCP offload is a full offload of the NVMeTCP protocol, this includes
> both the TCP level and the NVMeTCP level.
> 
> [...]

Here is the summary with links:
  - [1/8] nvme-tcp-offload: Add nvme-tcp-offload - NVMeTCP HW offload ULP
    https://git.kernel.org/netdev/net-next/c/f0e8cb6106da
  - [2/8] nvme-fabrics: Move NVMF_ALLOWED_OPTS and NVMF_REQUIRED_OPTS definitions
    https://git.kernel.org/netdev/net-next/c/98a5097d1e08
  - [3/8] nvme-fabrics: Expose nvmf_check_required_opts() globally
    https://git.kernel.org/netdev/net-next/c/af527935bd5a
  - [4/8] nvme-tcp-offload: Add device scan implementation
    https://git.kernel.org/netdev/net-next/c/4b8178ec5794
  - [5/8] nvme-tcp-offload: Add controller level implementation
    https://git.kernel.org/netdev/net-next/c/5aadd5f9311e
  - [6/8] nvme-tcp-offload: Add controller level error recovery implementation
    https://git.kernel.org/netdev/net-next/c/5faf6d685548
  - [7/8] nvme-tcp-offload: Add queue level implementation
    https://git.kernel.org/netdev/net-next/c/e4ba452ded39
  - [8/8] nvme-tcp-offload: Add IO level implementation
    https://git.kernel.org/netdev/net-next/c/35155e2626dc

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


