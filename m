Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id ACACA61439C
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 04:20:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229955AbiKADUt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 23:20:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60364 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229898AbiKADUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 23:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FC44DF25;
        Mon, 31 Oct 2022 20:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F0BEEB81B8F;
        Tue,  1 Nov 2022 03:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9AD78C43470;
        Tue,  1 Nov 2022 03:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667272816;
        bh=ZaCqXWdLyCYwzwFf3qFKT1X3USe85hzoy5zcqMZXZFs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I4yAXvrEuNf/aqDu1lCNNExAtYnmr8Hqkalw6OKehW7uYDTI94mLzyFGflMiwnTtr
         K3IT78kxXYYyuosH5CEJvwzjG9fXkwiaUTBgbNLZY2SmU46cdhkF+v1LSy22UGkOpX
         rWBGae/OCP+Cn6DEDbJYWXDWGVWShgFklmQvivkc8A2rvz+ufDBugOZB63IMpduAF7
         twUQPVyJNb2gKyelfkhgjt+yO9W7SUgu2hx5eMf0kySb9q6FNYs64sHfltBABaMQh4
         94l6uT3kHZ7Fwr07hFcg7CcfpBwDdziGtYpomSFZd8/D8PDHPAgRSEdJwIQahXqSEu
         +/fS+LSG7Nd2w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8031DC41621;
        Tue,  1 Nov 2022 03:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: systemport: Add support for RDMA overflow
 statistic counter
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166727281652.6120.10846675304729657013.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Nov 2022 03:20:16 +0000
References: <20221028222141.3208429-1-f.fainelli@gmail.com>
In-Reply-To: <20221028222141.3208429-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, bcm-kernel-feedback-list@broadcom.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 28 Oct 2022 15:21:40 -0700 you wrote:
> RDMA overflows can happen if the Ethernet controller does not have
> enough bandwidth allocated at the memory controller level, report RDMA
> overflows and deal with saturation, similar to the RBUF overflow
> counter.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: systemport: Add support for RDMA overflow statistic counter
    https://git.kernel.org/netdev/net-next/c/b98deb2f9803

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


