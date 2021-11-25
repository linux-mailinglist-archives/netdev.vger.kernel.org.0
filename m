Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 55AA345D37A
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 04:12:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345356AbhKYDPU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 22:15:20 -0500
Received: from mail.kernel.org ([198.145.29.99]:36264 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343951AbhKYDNU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 22:13:20 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id 84600610A5;
        Thu, 25 Nov 2021 03:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637809809;
        bh=PDbhTLENeDKD4hCJRLwsOlkso22AHxV48kZ/niUuKEY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PlBjj++s2jA2u1fS5cWqXGEY+wwyPUlH9+0ZguSO3meSs20lwEHIgsRx6G6W6DL+X
         QkLGfPQTARqUmluyluqQW0w8UPIXu5Vnn3sUCG8SCoSTaJEveO62HREddJT6larLob
         t1mjFjbkVAU7JX/It5v5XdValKs9RMseJJcl4DdMgTIoHPPRbu+leCjMMPGFjRMdQA
         8uhste7iGmZH6zbtt+yLcKZ/yGeOu5oWbe6EmUD1UCW+zpUqSA6p/sDeDqy6Oz3IxF
         V8eNqig9AlALGByjP3sPzleS5C/XG5saqnYzNfylXNdjEUD9F6tgOnqzKfzEIBmfaD
         YXtSvzXLZW7oA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 71EF460A4E;
        Thu, 25 Nov 2021 03:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net/smc: fixes 2021-11-24
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163780980946.14115.16946791187551049177.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Nov 2021 03:10:09 +0000
References: <20211124123238.471429-1-kgraul@linux.ibm.com>
In-Reply-To: <20211124123238.471429-1-kgraul@linux.ibm.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com, jwi@linux.ibm.com,
        guodaxing@huawei.com, tonylu@linux.alibaba.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 24 Nov 2021 13:32:36 +0100 you wrote:
> Patch 1 from DaXing fixes a possible loop in smc_listen().
> Patch 2 prevents a NULL pointer dereferencing while iterating
> over the lower network devices.
> 
> Guo DaXing (1):
>   net/smc: Fix loop in smc_listen
> 
> [...]

Here is the summary with links:
  - [net,1/2] net/smc: Fix NULL pointer dereferencing in smc_vlan_by_tcpsk()
    https://git.kernel.org/netdev/net/c/587acad41f1b
  - [net,2/2] net/smc: Fix loop in smc_listen
    https://git.kernel.org/netdev/net/c/9ebb0c4b27a6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


