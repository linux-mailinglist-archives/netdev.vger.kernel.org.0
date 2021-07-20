Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 072CD3CF928
	for <lists+netdev@lfdr.de>; Tue, 20 Jul 2021 13:51:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238167AbhGTLKa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Jul 2021 07:10:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:50142 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237897AbhGTLJd (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 20 Jul 2021 07:09:33 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 94BC360230;
        Tue, 20 Jul 2021 11:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1626781805;
        bh=7jfywXOn2GZr77f8EbaJUEuiNiSlCKUWDIUqTIPm5DI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fBQnfNl9p48UtaxXAtfsPj95Vsy+g4pPRxuWUVo4dryPjxk5aKBkwK/CM8EXJ2yfw
         hfQEm77FBnJeVb6xMj9uhAogtLYYLT3KZ2+iN7n0caRAhIdpQbpjprtDAUNrBSXssP
         NRv7HPXwCnuCkO2TTk/ESnCSiSDNc1oOJa8Jr1rgTznarhPvqYNhmiDjQXik70/bb7
         ICCGCzyIN9NT6zqXl6rIwh3FdNG5kRebH8VVxNhQCd6Tmh41KCAlGQpH0aTzMHLZuP
         2bmf6vphl/6WViwDUY/e27pIvOvCeRmpdl752wkacRR13ud7uLXDFLexdkGCSCqNwE
         +d5y09fFXCDoA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 87E3660A0B;
        Tue, 20 Jul 2021 11:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4] net: hns3: fixes for -net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162678180555.3963.9739297260206457119.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Jul 2021 11:50:05 +0000
References: <1626685988-25869-1-git-send-email-huangguangbin2@huawei.com>
In-Reply-To: <1626685988-25869-1-git-send-email-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, fengchengwen@huawei.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        salil.mehta@huawei.com, lipeng321@huawei.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (refs/heads/master):

On Mon, 19 Jul 2021 17:13:04 +0800 you wrote:
> This series includes some bugfixes for the HNS3 ethernet driver.
> 
> Chengwen Feng (1):
>   net: hns3: fix possible mismatches resp of mailbox
> 
> Jian Shen (2):
>   net: hns3: disable port VLAN filter when support function level VLAN
>     filter control
>   net: hns3: fix rx VLAN offload state inconsistent issue
> 
> [...]

Here is the summary with links:
  - [net,1/4] net: hns3: fix possible mismatches resp of mailbox
    https://git.kernel.org/netdev/net/c/1b713d14dc3c
  - [net,2/4] net: hns3: add match_id to check mailbox response from PF to VF
    https://git.kernel.org/netdev/net/c/4671042f1ef0
  - [net,3/4] net: hns3: disable port VLAN filter when support function level VLAN filter control
    https://git.kernel.org/netdev/net/c/184cd221a863
  - [net,4/4] net: hns3: fix rx VLAN offload state inconsistent issue
    https://git.kernel.org/netdev/net/c/bbfd4506f962

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


