Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 00C7D34B266
	for <lists+netdev@lfdr.de>; Sat, 27 Mar 2021 00:01:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230487AbhCZXAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Mar 2021 19:00:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:35310 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230027AbhCZXAN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Mar 2021 19:00:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 9C49F61A32;
        Fri, 26 Mar 2021 23:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616799612;
        bh=4ef9G+rvdr8+rT6MRad44/ujrq6eQ8M0HFn9mQZheVE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=JmLc7bWy3G2yjTrmk6Vx49uW+tw7mTP1fQ7C7DPvdcPpx2p2cROGggEZptB6UZjVD
         uJMDKwU7XN8mpvnaLAyekKmaE05t4wSgQS3svUBQVECsi9UxGO65YfmkkoTCmItaUh
         Nr1XSfGo9PAhtMKtZV9PTF4E5D5aSHD5LgpExklC2TPzZEg4/yuyS4rkOSO22NW3y/
         zxi9SVAD02Im06OW+N47JBRb2BKh008Z7FNilZ+DWYbHeM+dlfOZr7WjaBMh5KJlrk
         Va+gBP3A62gnkKL6r9D1tvQX+7Db+UaqWnDsZwgeSX6eQqWFKZ2LT0AIU1bAlZ/hWk
         lON5HnBoobqiA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8054060970;
        Fri, 26 Mar 2021 23:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] ethtool: fec: ioctl kdoc touch ups
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161679961252.14639.9738109467037178288.git-patchwork-notify@kernel.org>
Date:   Fri, 26 Mar 2021 23:00:12 +0000
References: <20210326202223.302085-1-kuba@kernel.org>
In-Reply-To: <20210326202223.302085-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        mkubecek@suse.cz
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (refs/heads/master):

On Fri, 26 Mar 2021 13:22:20 -0700 you wrote:
> A few touch ups from v1 review.
> 
> Jakub Kicinski (3):
>   ethtool: fec: add note about reuse of reserved
>   ethtool: fec: fix FEC_NONE check
>   ethtool: document the enum values not defines
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] ethtool: fec: add note about reuse of reserved
    https://git.kernel.org/netdev/net-next/c/ad1cd7856d87
  - [net-next,2/3] ethtool: fec: fix FEC_NONE check
    https://git.kernel.org/netdev/net-next/c/cf2cc0bf4fde
  - [net-next,3/3] ethtool: document the enum values not defines
    https://git.kernel.org/netdev/net-next/c/d04feecaf154

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


