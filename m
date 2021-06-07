Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 96B3A39E90D
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 23:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231521AbhFGVWB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 17:22:01 -0400
Received: from mail.kernel.org ([198.145.29.99]:53754 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231253AbhFGVV4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 17:21:56 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 6697661246;
        Mon,  7 Jun 2021 21:20:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623100804;
        bh=NycoxI/gb/198hF0ezqd+5kHDn8jFw9p9Cko7vVxWSk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QQjr/hgSmJWjAGfoV3jFtWbnYSoPxCMExtbkfH1ZO2/b39I3hldffhDPeGjD4jJWh
         PiGXzH2jVQnhwDAEH1tQUrbf1dQdvqb3F3gROHS8U2r9+s7TgN3jvMKzXH73r0CagD
         ey7nyfe62rQr0HLQQDWZMRBSInQC3M5aCwjIlSIbAsCaSTUwfWWUOy5euJmBYE4Cfl
         fvf0A84tXL6nJUkmsPdTCz05OGBgOdIbISjDb1YseyU+ex8W6aRwDtohRsHSAU2qe6
         I2A3AOk/YRtuDzLRTs7rKib9VR8Qor0mKWJT/w7U0B/nE0WFtnTQGNY+SdfKgWbBvf
         IJlvm+3wpxoUA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 52FDB60CE0;
        Mon,  7 Jun 2021 21:20:04 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] l2tp: Fix spelling mistakes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162310080433.4243.1228423995846449576.git-patchwork-notify@kernel.org>
Date:   Mon, 07 Jun 2021 21:20:04 +0000
References: <20210607150137.2856585-1-zhengyongjun3@huawei.com>
In-Reply-To: <20210607150137.2856585-1-zhengyongjun3@huawei.com>
To:     Zheng Yongjun <zhengyongjun3@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, jchapman@katalix.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Mon, 7 Jun 2021 23:01:37 +0800 you wrote:
> Fix some spelling mistakes in comments:
> negociated  ==> negotiated
> dont  ==> don't
> 
> Signed-off-by: Zheng Yongjun <zhengyongjun3@huawei.com>
> ---
>  net/l2tp/l2tp_ip.c  | 2 +-
>  net/l2tp/l2tp_ppp.c | 2 +-
>  2 files changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [net-next] l2tp: Fix spelling mistakes
    https://git.kernel.org/netdev/net-next/c/7f553ff21410

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


