Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 424D73D4CFB
	for <lists+netdev@lfdr.de>; Sun, 25 Jul 2021 11:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231137AbhGYJJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 25 Jul 2021 05:09:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:54358 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230305AbhGYJJd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 25 Jul 2021 05:09:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 7AF846056B;
        Sun, 25 Jul 2021 09:50:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627206604;
        bh=u0KNHPNCAChL4lbcFdbbm4gLVhl2LpuQ1YuHCdNtJYk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CxBjppMqTCR7WO4m1xuiYi7ZFaUIFSSwh8z2MZguCEdUfopx+6rITDoIA8uuWprQS
         w8O22IeAb2qOakpo7JE8lBmatMl/nC7MZ86ASRhE+4dmYnRN+yB5JGxBDwDQCOm9ui
         FDNHHrlQsveLaQF0pJN99Sxq+6xiSeipRChWqHcSCHvoFSzoO30bcs8n5dMAF2/tqe
         wWbwK48cJkG1VHowiUZpgFBVS+CdHvALjEdZRI6vzdhmIvffoBGRkx+a6wYQ9u3hEE
         xtM1AfVy2MDPe2NRktTftA+MnugwFwbcXuRZl3Qe3K/qUSXO3IlTwCU8QucaG2EA5V
         rxDmukUoWhrgQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 6FDD660A39;
        Sun, 25 Jul 2021 09:50:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] devlink: Fix phys_port_name of virtual port and merge
 error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162720660445.12734.2954839653977502700.git-patchwork-notify@kernel.org>
Date:   Sun, 25 Jul 2021 09:50:04 +0000
References: <20210723145600.282258-1-parav@nvidia.com>
In-Reply-To: <20210723145600.282258-1-parav@nvidia.com>
To:     Parav Pandit <parav@nvidia.com>
Cc:     netdev@vger.kernel.org, jiri@nvidia.com, davem@davemloft.net,
        kuba@kernel.org, saeedm@nvidia.com, schnelle@linux.ibm.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Fri, 23 Jul 2021 17:56:00 +0300 you wrote:
> Merge commit cited in fixes tag was incorrect. Due to it phys_port_name
> of the virtual port resulted in incorrect name.
> 
> Also the phys_port_name of the physical port was written twice due to
> the merge error.
> 
> Fix it by removing the old code and inserting back the misplaced code.
> 
> [...]

Here is the summary with links:
  - [net] devlink: Fix phys_port_name of virtual port and merge error
    https://git.kernel.org/netdev/net/c/149ea30fdd5c

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


