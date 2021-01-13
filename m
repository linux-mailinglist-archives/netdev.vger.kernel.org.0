Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 386FB2F4322
	for <lists+netdev@lfdr.de>; Wed, 13 Jan 2021 05:31:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725854AbhAMEat (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jan 2021 23:30:49 -0500
Received: from mail.kernel.org ([198.145.29.99]:54962 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725372AbhAMEat (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 12 Jan 2021 23:30:49 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id D83092312E;
        Wed, 13 Jan 2021 04:30:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610512208;
        bh=JDELMkeE1VzXHGuVA+uSEDO+LE6CH2XlgfiEGacHxCw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=c1rGz1Rr6fvixGwqLnIA7TQoe/HePVRe2K1TB7MoRUT9vJciD7M7iWqA3yMV+dQ60
         wlfamwacxdhyxpuy/dHM23/CxmIxIReokZiy8XxtUN/HGwHlSMS99ai2vbcH48uJfY
         BHnPBjOhRfxp/w8PU16mqxEUSxFuMEttWuhQGUZl8uAez47weGY3u5fcg9IT5D3fsG
         jZ9MqJRPGNKqy0IOFiTkFKB1s6f0T+cYJ1qaaRLulvPU1rKs20hvCyfgnZ1ABmx9Er
         aVXVSJZcig3NTEiCSPcHO7rtT6Xlyz+K+VWJe18jBcz/8BpKxFnN7n3rECwCQwABgq
         Tq95lXE8r0QHQ==
Received: from pdx-korg-docbuild-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-1.ci.codeaurora.org (Postfix) with ESMTP id C8E42604E9;
        Wed, 13 Jan 2021 04:30:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] net/smc: fix out of bound access in netlink interface
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161051220881.5581.17205976954559864201.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Jan 2021 04:30:08 +0000
References: <20210112162122.26832-1-kgraul@linux.ibm.com>
In-Reply-To: <20210112162122.26832-1-kgraul@linux.ibm.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, hca@linux.ibm.com,
        raspl@linux.ibm.com, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Tue, 12 Jan 2021 17:21:20 +0100 you wrote:
> Please apply the following patch for smc to netdev's net tree.
> 
> Both patches fix possible out-of-bounds reads. The original code expected
> that snprintf() reads len-1 bytes from source and appends the terminating
> null, but actually snprintf() first copies len bytes and finally overwrites
> the last byte with a null.
> Fix this by using memcpy() and terminating the string afterwards.
> 
> [...]

Here is the summary with links:
  - [net,1/2] smc: fix out of bound access in smc_nl_get_sys_info()
    https://git.kernel.org/netdev/net/c/25fe2c9c4cd2
  - [net,2/2] net/smc: use memcpy instead of snprintf to avoid out of bounds read
    https://git.kernel.org/netdev/net/c/8a4465368964

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


