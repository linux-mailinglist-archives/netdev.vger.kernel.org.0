Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A9CB34B25F
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:01:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230444AbhCZXAl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:00:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:35316 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230114AbhCZXAN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 19:00:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id A2A2A61A33;
        Fri, 26 Mar 2021 23:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616799612;
        bh=mOODSIec5PmYGkS4VV9SQ0gQ5mORs4fhmeIVnDXcN5E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=YZnP929c7qssyYKgCUO4/c3em3x3odfuSpOiWYR2PYdY/wLGXJ7qs7RQGxCY/hH0P
         lIBB5zsMLk9asoyPxDBmzrmlh6+loc1tCl+MH/tUx+DT9NMJkpKtrDtaV2nmOyPosl
         MPItGACVCMxIGnopRsLRrOtYqAA4S8dZUsFHJfX1ZSWXyebQtIr23jXTxUxZJJw6VD
         aOfcQxYhlMGfP4TsJLXUHfMWJBwMOmUylS4pwbuYiv8D6gh6vSyy/0hseV0wbXEyoB
         2N1QnPlfQJ/HHeepJLFEpbsso17BQkLZeEjSF1Z5H0/28Md8AaQjfLWetMU3Ia0RKo
         EbnGFTPFl9CAA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 89162609E6;
        Fri, 26 Mar 2021 23:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next 0/3] net: llc: Correct some function names in header
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161679961255.14639.10605106394738089122.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 23:00:12 +0000
References: <20210326101350.2519614-1-yangyingliang@huawei.com>
In-Reply-To: <20210326101350.2519614-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 26 Mar 2021 18:13:47 +0800 you wrote:
> Fix some make W=1 kernel build warnings in net/llc/
> 
> Yang Yingliang (3):
>   net: llc: Correct some function names in header
>   net: llc: Correct function name llc_sap_action_unitdata_ind() in
>     header
>   net: llc: Correct function name llc_pdu_set_pf_bit() in header
> 
> [...]

Here is the summary with links:
  - [-next,1/3] net: llc: Correct some function names in header
    https://git.kernel.org/netdev/net-next/c/26440a63a1ac
  - [-next,2/3] net: llc: Correct function name llc_sap_action_unitdata_ind() in header
    https://git.kernel.org/netdev/net-next/c/8114f099d937
  - [-next,3/3] net: llc: Correct function name llc_pdu_set_pf_bit() in header
    https://git.kernel.org/netdev/net-next/c/72e6afe6b4b3

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


