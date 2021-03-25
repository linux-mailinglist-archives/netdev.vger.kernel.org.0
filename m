Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D9A8C34862A
	for <lists+netdev@lfdr.de>; Thu, 25 Mar 2021 02:00:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239499AbhCYBA2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Mar 2021 21:00:28 -0400
Received: from mail.kernel.org ([198.145.29.99]:51052 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S239458AbhCYBAJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Mar 2021 21:00:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AB5DF619F8;
        Thu, 25 Mar 2021 01:00:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616634008;
        bh=WQS90v8cd/NZB6/cY/FZu1u1kCW9dDxmV2X0fFkJP+I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bZu3EWiw6wvQI2hgg+plg+My2+Gq/M84is+8jc9Z5iEhwtr2wdE57affJw/mJBmte
         q1KGfbgH6WM4XJs93MnMu+YBLDStwdvKL7uk1ECAJH3uqc6hrLcvwrBn7a4Zqdwugi
         JN1iObRlUvwYrZBLTFVw3jp6vJwPbRMiOOPzGooqv02/zv/1/S77ODW9ur2/z08cTi
         uB87tuBCeEt6JDWMlA73guSwjlmyVTHg3XY/HLpg2lvP/V7iiFbV9UOTheLSwixZdE
         Zcx2JraWqHPoWwcSg+shSiBrKDdk4EsMffmkXVOKLVvaeeL8UOkTEmjtNSCbQMzFTd
         i/cPiga6uaD1Q==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 984936096E;
        Thu, 25 Mar 2021 01:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/packet: Fix a typo in af_packet.c
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161663400861.21739.10283902101076452089.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Mar 2021 01:00:08 +0000
References: <20210324061931.11012-1-wanghai38@huawei.com>
In-Reply-To: <20210324061931.11012-1-wanghai38@huawei.com>
To:     Wang Hai <wanghai38@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, willemb@google.com,
        xie.he.0141@gmail.com, john.ogness@linutronix.de,
        yonatanlinik@gmail.com, gustavoars@kernel.org,
        tannerlove@google.com, eyal.birger@gmail.com,
        orcohen@paloaltonetworks.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Wed, 24 Mar 2021 14:19:31 +0800 you wrote:
> s/sequencially/sequentially/
> 
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Wang Hai <wanghai38@huawei.com>
> ---
>  net/packet/af_packet.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net/packet: Fix a typo in af_packet.c
    https://git.kernel.org/netdev/net-next/c/0e4161d0eda5

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


