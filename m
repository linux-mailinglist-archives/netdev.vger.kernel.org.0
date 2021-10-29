Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1862A43FB61
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 13:30:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231897AbhJ2Lck (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Oct 2021 07:32:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:49016 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230492AbhJ2Lcj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 29 Oct 2021 07:32:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 915E96115C;
        Fri, 29 Oct 2021 11:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635507011;
        bh=uAy1SJJyb9DsycKmcyU47MAQYOHNYV/B6vcBdMw5P40=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=n6Jk8zIHm6NU95juCvVYka/hBJxeL471AZPValH4j4TxVqbMMUzg2Fw+0rFN8m3JQ
         0OLyWuILQ+2/0TQn2bpqoF4FLaMdM9l6eje70B6t1L+qmf03pxXUPMxvWvu9V3WiNx
         t0AYHQ7rz+76/R6o3+B9Si2tufVcE8JG4vEEm34alrXLpIUT5LVueNWUFEFjYHB98w
         k0mym6NgXORU5t/4mMifvw1qAk7o19MogbOVO5ls+10lEvDqcXmeRyQ8UsaqVMZNvH
         u8M0rDZJw1/U6X+6LLXPVNTydKrhIC+t90geSoa8+/AbLj3PX0KW0Y0HNhzUQFryAL
         /4Km1icbq9bCw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8939860A5A;
        Fri, 29 Oct 2021 11:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 00/19] bnxt_en: devlink enhancements
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163550701155.27301.5778131497581586761.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Oct 2021 11:30:11 +0000
References: <1635493676-10767-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1635493676-10767-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edwin.peer@broadcom.com, gospo@broadcom.com, jiri@nvidia.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 29 Oct 2021 03:47:37 -0400 you wrote:
> This patch series implements some devlink enhancements for bnxt_en.
> They include:
> 
> 1. devlink reload to reinitialize driver or to activate new firmware.
> 2. Support enable_remote_dev_reset to enable/disable other functions
> resetting the device.
> 3. Consolidate and improve the health reporters.
> 4. Support live firmware patch.
> 5. Provide devlink dev info "fw" version on older firmware.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,01/19] bnxt_en: refactor printing of device info
    https://git.kernel.org/netdev/net-next/c/c7dd4a5b0a15
  - [net-next,v2,02/19] bnxt_en: refactor cancellation of resource reservations
    https://git.kernel.org/netdev/net-next/c/d900aadd86b0
  - [net-next,v2,03/19] bnxt_en: implement devlink dev reload driver_reinit
    https://git.kernel.org/netdev/net-next/c/228ea8c187d8
  - [net-next,v2,04/19] bnxt_en: implement devlink dev reload fw_activate
    https://git.kernel.org/netdev/net-next/c/8f6c5e4d1470
  - [net-next,v2,05/19] bnxt_en: add enable_remote_dev_reset devlink parameter
    https://git.kernel.org/netdev/net-next/c/892a662f0473
  - [net-next,v2,06/19] bnxt_en: improve error recovery information messages
    https://git.kernel.org/netdev/net-next/c/1596847d0f7b
  - [net-next,v2,07/19] bnxt_en: remove fw_reset devlink health reporter
    https://git.kernel.org/netdev/net-next/c/aadb0b1a0b36
  - [net-next,v2,08/19] bnxt_en: consolidate fw devlink health reporters
    https://git.kernel.org/netdev/net-next/c/2bb21b8db5c0
  - [net-next,v2,09/19] bnxt_en: improve fw diagnose devlink health messages
    https://git.kernel.org/netdev/net-next/c/8cc95ceb7087
  - [net-next,v2,10/19] bnxt_en: Refactor coredump functions
    https://git.kernel.org/netdev/net-next/c/9a575c8c25ae
  - [net-next,v2,11/19] bnxt_en: move coredump functions into dedicated file
    https://git.kernel.org/netdev/net-next/c/b032228e58ea
  - [net-next,v2,12/19] bnxt_en: Add compression flags information in coredump segment header
    https://git.kernel.org/netdev/net-next/c/80f62ba9d53d
  - [net-next,v2,13/19] bnxt_en: Retrieve coredump and crashdump size via FW command
    https://git.kernel.org/netdev/net-next/c/80194db9f53b
  - [net-next,v2,14/19] bnxt_en: extract coredump command line from current task
    https://git.kernel.org/netdev/net-next/c/4e59f0600790
  - [net-next,v2,15/19] bnxt_en: implement dump callback for fw health reporter
    https://git.kernel.org/netdev/net-next/c/188876db04a3
  - [net-next,v2,16/19] bnxt_en: Update firmware interface to 1.10.2.63
    https://git.kernel.org/netdev/net-next/c/21e70778d0d4
  - [net-next,v2,17/19] bnxt_en: implement firmware live patching
    https://git.kernel.org/netdev/net-next/c/3c4153394e2c
  - [net-next,v2,18/19] bnxt_en: Provide stored devlink "fw" version on older firmware
    https://git.kernel.org/netdev/net-next/c/63185eb3aa26
  - [net-next,v2,19/19] bnxt_en: Update bnxt.rst devlink documentation
    https://git.kernel.org/netdev/net-next/c/eff441f3b597

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


