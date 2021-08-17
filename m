Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E10D63EEA18
	for <lists+netdev@lfdr.de>; Tue, 17 Aug 2021 11:40:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236163AbhHQJku (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 Aug 2021 05:40:50 -0400
Received: from mail.kernel.org ([198.145.29.99]:33796 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236082AbhHQJko (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 17 Aug 2021 05:40:44 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6313560F11;
        Tue, 17 Aug 2021 09:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629193211;
        bh=g8TrUzvroWxlhghmyr7bpyjXsdTGLVOxYdHZl/HVCn0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QUhwcJq1VG2GtEkStBKjXkGx1NTOGcOgKFQgQb2l03F5hdWDQy96BKnezXzr2cxzM
         nN+o7bQIXQp/JpIxFtBCr7T7rX6C3AjFsE3Y2k2k+8gvuMW6qAV1SfZo5r6yoQO2dm
         k5Y8FpjWpnsiWHOLOGPkffMss3kssv1gzYODltZlUrdnprCKQcHG+0Ltn8q9Wzgd9r
         EQ8j49DWaLydXE8aiiOlqU/3kRRQ57HxZMeZz4tv5i74lbqpwfY7judFrkWbRnKV5W
         UHjKNqlOpgdbvGWj31J1eENlYPwUplTw4/2R72quHVYu7fgdeWNsOblaJR6d9Kh10G
         uGQuXnx0qFU4g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 58397609CF;
        Tue, 17 Aug 2021 09:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH 00/11] octeontx2: Rework MCAM flows management for
 VFs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162919321135.26227.5808597240956880952.git-patchwork-notify@kernel.org>
Date:   Tue, 17 Aug 2021 09:40:11 +0000
References: <1629175493-4895-1-git-send-email-sbhatta@marvell.com>
In-Reply-To: <1629175493-4895-1-git-send-email-sbhatta@marvell.com>
To:     Subbaraya Sundeep <sbhatta@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sgoutham@marvell.com, hkelam@marvell.com, gakula@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Tue, 17 Aug 2021 10:14:42 +0530 you wrote:
> From Octeontx2 hardware point of view there is no
> difference between PFs and VFs. Hence with refactoring
> in driver the packet classification features or offloads
> can be supported by VFs also. This patchset unifies the
> mcam flows management so that VFs can also support
> ntuple filters. Since there are MCAM allocations by
> all PFs and VFs in the system it is required to have
> the ability to modify number of mcam rules count
> for a PF/VF in runtime. This is achieved by using devlink.
> Below is the summary of patches:
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] octeontx2-af: Modify install flow error codes
    https://git.kernel.org/netdev/net-next/c/9cfc58095688
  - [net-next,02/11] octeontx2-af: add proper return codes for AF mailbox handlers
    https://git.kernel.org/netdev/net-next/c/7278c359e52c
  - [net-next,03/11] octeontx2-af: Add debug messages for failures
    https://git.kernel.org/netdev/net-next/c/a83bdada06bf
  - [net-next,04/11] octeontx2-pf: Enable NETIF_F_RXALL support for VF driver
    https://git.kernel.org/netdev/net-next/c/0b3834aeaf47
  - [net-next,05/11] octeontx2-pf: Ntuple filters support for VF netdev
    https://git.kernel.org/netdev/net-next/c/3cffaed2136c
  - [net-next,06/11] octeontx2-pf: Sort the allocated MCAM entry indices
    https://git.kernel.org/netdev/net-next/c/cc65fcab88be
  - [net-next,07/11] octeontx2-pf: Unify flow management variables
    https://git.kernel.org/netdev/net-next/c/2e2a8126ffac
  - [net-next,08/11] octeontx2-pf: devlink params support to set mcam entry count
    https://git.kernel.org/netdev/net-next/c/2da489432747
  - [net-next,09/11] octeontx2-af: Allocate low priority entries for PF
    https://git.kernel.org/netdev/net-next/c/7df5b4b260dd
  - [net-next,10/11] octeontx2-af: cn10K: Get NPC counters value
    https://git.kernel.org/netdev/net-next/c/99b8e5479d49
  - [net-next,11/11] octeontx2-af: configure npc for cn10k to allow packets from cpt
    https://git.kernel.org/netdev/net-next/c/aee512249190

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


