Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BAFD13ED450
	for <lists+netdev@lfdr.de>; Mon, 16 Aug 2021 14:50:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231373AbhHPMui (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Aug 2021 08:50:38 -0400
Received: from mail.kernel.org ([198.145.29.99]:51186 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229801AbhHPMuh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Aug 2021 08:50:37 -0400
Received: by mail.kernel.org (Postfix) with ESMTPS id AAAC463279;
        Mon, 16 Aug 2021 12:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629118205;
        bh=o5KcqrjwqYnd0274mRDrfq3oNbM/dge8CyT5+/0rwZo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=H8/Uf0iFcgkw6oLg8TIBASLE6/eg19rX3JlhinN4DdSdVzV+h5XxNbr5Xo/tw/piB
         K6k2PPXb82P8PBIATrRt/VzcfgUQTvCbuUOlLhEWJFyOePOUYTE4E5Dsxkk5hxo7Gf
         cOsCzH+WNrbHihFqfdsDc7li1jQkXNbO/bbxFfJ0O5YgCYAXfUYbVx3hrTqMiu4dm6
         d2LiXWzu7xyMID717+27FZHfRUrTOlsMzOKWvbHYnD5FBOXEMFP5Elloswdw4kdXGC
         0DZHMBIvuwqfR/m/Hix3q1JfvigZHTntOicQemwcGJ4AyWDqo/8NZxo3vkGhMTbRbn
         v7FtyrjTSRedA==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 9E02E609CF;
        Mon, 16 Aug 2021 12:50:05 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net] net: iosm: Prevent underflow in ipc_chnl_cfg_get()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <162911820564.2793.8545305757282146357.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Aug 2021 12:50:05 +0000
References: <20210816111333.GE7722@kadam>
In-Reply-To: <20210816111333.GE7722@kadam>
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     m.chetan.kumar@intel.com, solly.ucko@gmail.com,
        linuxwwan@intel.com, loic.poulain@linaro.org,
        ryazanov.s.a@gmail.com, johannes@sipsolutions.net,
        davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        security@kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (refs/heads/master):

On Mon, 16 Aug 2021 14:13:33 +0300 you wrote:
> The bounds check on "index" doesn't catch negative values.  Using
> ARRAY_SIZE() directly is more readable and more robust because it prevents
> negative values for "index".  Fortunately we only pass valid values to
> ipc_chnl_cfg_get() so this patch does not affect runtime.
> 
> 
> Reported-by: Solomon Ucko <solly.ucko@gmail.com>
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
> 
> [...]

Here is the summary with links:
  - [v2,net] net: iosm: Prevent underflow in ipc_chnl_cfg_get()
    https://git.kernel.org/netdev/net/c/4f3f2e3fa043

You are awesome, thank you!
--
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


