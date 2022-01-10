Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BFF4A488DAB
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 02:01:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237705AbiAJBAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Jan 2022 20:00:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48070 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234889AbiAJBAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Jan 2022 20:00:12 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99D9FC061751
        for <netdev@vger.kernel.org>; Sun,  9 Jan 2022 17:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5ACADB81072
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 01:00:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 29652C36AF4;
        Mon, 10 Jan 2022 01:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641776409;
        bh=O0NMvY1KGtRB+To3TMZCdpnoIYQdX4Ggvb1hEN4sxQ4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=VF11lBtuZI0JaIKFmo6ToAJPA3l3DXxntum6bRG0sSiswIpL00pEp5zmm07KJYiP4
         vuzHEO8u5znQL4/oeugWEZREiALWPM7UAqUeOKhaa3Pd/rJGwibOtjyIDQzWp8KmIm
         S1nyj96zw40/NlRvljjykYbReZv/D3nyZGSer+ZYOxRMyQ1oEcMfGGNyoplqBL8vjH
         IkFkIt3gqbRAWyU9PVxyxDJz2SeMaRXYCea7mzxNFJsPa2s/GpX6VSosDVBnBmMhHA
         saT626+CRzrVcWebYUzuRxE6wp/2hPmqumH+PCWWG64d9eiJhBTmrmUJsa4UKi6uyQ
         l8V3BmgQtt4Xw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 12001F60790;
        Mon, 10 Jan 2022 01:00:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] amt: fix wrong return type of
 amt_send_membership_update()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164177640906.18208.13604408119661863183.git-patchwork-notify@kernel.org>
Date:   Mon, 10 Jan 2022 01:00:09 +0000
References: <20220109163702.6331-1-ap420073@gmail.com>
In-Reply-To: <20220109163702.6331-1-ap420073@gmail.com>
To:     Taehee Yoo <ap420073@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Sun,  9 Jan 2022 16:37:02 +0000 you wrote:
> amt_send_membership_update() would return -1 but it's return type is bool.
> So, it should be used TRUE instead of -1.
> 
> Fixes: cbc21dc1cfe9 ("amt: add data plane of amt interface")
> Reported-by: kernel test robot <lkp@intel.com>
> Signed-off-by: Taehee Yoo <ap420073@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] amt: fix wrong return type of amt_send_membership_update()
    https://git.kernel.org/netdev/net/c/dd3ca4c5184e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


