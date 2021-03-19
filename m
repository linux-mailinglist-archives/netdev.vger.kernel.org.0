Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 588233412C7
	for <lists+netdev@lfdr.de>; Fri, 19 Mar 2021 03:21:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233276AbhCSCUh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Mar 2021 22:20:37 -0400
Received: from mail.kernel.org ([198.145.29.99]:54108 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230389AbhCSCUQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 18 Mar 2021 22:20:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id 3828B64DE2;
        Fri, 19 Mar 2021 02:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1616120412;
        bh=mNbzQUv5TcsFqOYgQ8XdgeryHw1NmPLO3Coa8dhthRs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hOBhrR/E5ehUdjEYT3F5bkici03uRZ+HTzVbyG98PX4wtfNhsVi0akRueSX5tA/Q9
         mRFK7G73EkezsurSfzEDn8eH/cp956dMd29Oib90iH3raBzLXSADm2n9RFz78XXLXT
         ov9sxOVDAQBQWuNwEFdyfVpbmO2CeuiQ+SYiqpojLaVncZ2J6DxpRWjRCom3A68ygh
         axrAJa0e3K6tzmzuHC+w9gvzewhGFRMIU/3fy9sJrraFs+9wHAGzh1EVVpOVW3KHia
         TEnSvKKwdGSoYee6Jjr7YuFulwYsTR52JdX1VKbLjjapuA9EYVTd4bW3NquQlM48EM
         nM909zPpk+ahw==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 274C860191;
        Fri, 19 Mar 2021 02:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] /net/core/: fix misspellings using codespell tool
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <161612041215.22955.9527590233602069118.git-patchwork-notify@kernel.org>
Date:   Fri, 19 Mar 2021 02:20:12 +0000
References: <20210318115213.474322-1-xiong.zhenwu@zte.com.cn>
In-Reply-To: <20210318115213.474322-1-xiong.zhenwu@zte.com.cn>
To:     Menglong Dong <menglong8.dong@gmail.com>
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        xiong.zhenwu@zte.com.cn
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (refs/heads/master):

On Thu, 18 Mar 2021 04:52:13 -0700 you wrote:
> From: Xiong Zhenwu <xiong.zhenwu@zte.com.cn>
> 
> A typo is found out by codespell tool in 1734th line of drop_monitor.c:
> 
> $ codespell ./net/core/
> ./net/core/drop_monitor.c:1734: guarnateed  ==> guaranteed
> 
> [...]

Here is the summary with links:
  - [net-next] /net/core/: fix misspellings using codespell tool
    https://git.kernel.org/netdev/net-next/c/a835f9034efb

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


