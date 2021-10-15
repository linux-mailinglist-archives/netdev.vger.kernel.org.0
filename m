Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 22F5442E711
	for <lists+netdev@lfdr.de>; Fri, 15 Oct 2021 05:10:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232068AbhJODMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Oct 2021 23:12:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:44064 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229526AbhJODMN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 14 Oct 2021 23:12:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 5992861152;
        Fri, 15 Oct 2021 03:10:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634267407;
        bh=P9nM+iawcJ/cq9zxzrLs3/0vOumzbm2xlBDwLs2lEC8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZLJGt8sCFWZnezJ1ABzCIB6rNztC/C6kKbilZKUbU+bJr8JIULmCLLEz8GXWkZhhT
         3g8xp3MUWrNFp+UQb9uEkuT3Gx1EQmCIYSGPfPPWtUMEhT2GU5H6+D6T5jE4twuGh9
         ldM1ShI/oepnSxPpgoCdqB+lX7Nue/sNnaYMD8HIirzxm31+w+vexxHQF9hJ5YqVR5
         qfXkJePBc+jpWsG7uDVXg14HaShdCvkKVIT6M8BqWiLsdyDGWk5voQqnbakJr2tZqj
         n00ZToDg816kCnZq85BlR8a22klfCFb0B2G4iECNle81TSgs24YX+lP/E1dCVBm4IW
         RQw6qz4+wdy3g==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 4C35960A6D;
        Fri, 15 Oct 2021 03:10:07 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/3] octeontx2-af: Miscellaneous changes for CPT
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163426740730.15884.10273341939652937551.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Oct 2021 03:10:07 +0000
References: <20211013055621.1812301-1-schalla@marvell.com>
In-Reply-To: <20211013055621.1812301-1-schalla@marvell.com>
To:     Srujana Challa <schalla@marvell.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sgoutham@marvell.com, lcherian@marvell.com, gakula@marvell.com,
        hkelam@marvell.com, jerinj@marvell.com, sbhatta@marvell.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Oct 2021 11:26:18 +0530 you wrote:
> This patchset consists of miscellaneous changes for CPT.
> First patch enables the CPT HW interrupts, second patch
> adds support for CPT LF teardown in non FLR path and
> final patch does CPT CTX flush in FLR handler.
> 
> v2:
> - Fixed a warning reported by kernel test robot.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/3] octeontx2-af: Enable CPT HW interrupts
    https://git.kernel.org/netdev/net-next/c/4826090719d4
  - [v2,net-next,2/3] octeontx2-af: Perform cpt lf teardown in non FLR path
    https://git.kernel.org/netdev/net-next/c/7054d39ccf7e
  - [v2,net-next,3/3] octeontx2-af: Add support to flush full CPT CTX cache
    https://git.kernel.org/netdev/net-next/c/149f3b73cb66

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


