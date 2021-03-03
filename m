Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F6A432C487
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:54:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1392548AbhCDAO4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:14:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:46092 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1445786AbhCCQus (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 3 Mar 2021 11:50:48 -0500
Received: by mail.kernel.org (Postfix) with ESMTPS id C97E664ED0;
        Wed,  3 Mar 2021 16:50:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1614790206;
        bh=vyWmKUOBbS6lHY2tc7qFSUiBwJxzrV0lRzpRy7/2YDE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hQpDBi9K/5eCdpWyWrMeGXSpuGA2uKWpCzJxN7hUXCk6Wvuwxfn9MeGdgf0zgwDWd
         FsqZdGrbOBIc9UVVYE8oewGHr01XKcXbH4qES0rmzyZkk7toEDOOt1JHoHz+EAwfio
         jLOv65KS7Q18aCe3w03b1E8MWyEAbNahG1z8j+KAwbrsAdoBQ0Z9Rypd/fuIahW03A
         sXQT0kyir+CsWGG8R1G2/I/uutKiJmVdt8FjUw6I5OW1qw7Gxw6l7LJkTiph7nDJ/8
         rbdo7/Vn0273TrkyhR2gULoZCn0OS6PiK1tIPFpMlc2Oqanji0frhu9EurdQW8+Wcp
         RV81KGNJGcxUw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id BC71F600DF;
        Wed,  3 Mar 2021 16:50:06 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] ibmvnic: Fix possibly uninitialized old_num_tx_queues
 variable warning.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161479020676.31057.2292593478574354971.git-patchwork-notify@kernel.org>
Date:   Wed, 03 Mar 2021 16:50:06 +0000
References: <20210302194747.21704-1-msuchanek@suse.de>
In-Reply-To: <20210302194747.21704-1-msuchanek@suse.de>
To:     Michal Suchanek <msuchanek@suse.de>
Cc:     netdev@vger.kernel.org, mpe@ellerman.id.au,
        benh@kernel.crashing.org, paulus@samba.org, drt@linux.ibm.com,
        ljp@linux.ibm.com, sukadev@linux.ibm.com, davem@davemloft.net,
        kuba@kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Tue,  2 Mar 2021 20:47:47 +0100 you wrote:
> GCC 7.5 reports:
> ../drivers/net/ethernet/ibm/ibmvnic.c: In function 'ibmvnic_reset_init':
> ../drivers/net/ethernet/ibm/ibmvnic.c:5373:51: warning: 'old_num_tx_queues' may be used uninitialized in this function [-Wmaybe-uninitialized]
> ../drivers/net/ethernet/ibm/ibmvnic.c:5373:6: warning: 'old_num_rx_queues' may be used uninitialized in this function [-Wmaybe-uninitialized]
> 
> The variable is initialized only if(reset) and used only if(reset &&
> something) so this is a false positive. However, there is no reason to
> not initialize the variables unconditionally avoiding the warning.
> 
> [...]

Here is the summary with links:
  - ibmvnic: Fix possibly uninitialized old_num_tx_queues variable warning.
    https://git.kernel.org/netdev/net/c/6881b07fdd24

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


