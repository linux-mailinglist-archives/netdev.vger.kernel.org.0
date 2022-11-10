Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E31CD624275
	for <lists+netdev@lfdr.de>; Thu, 10 Nov 2022 13:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229736AbiKJMkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Nov 2022 07:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229588AbiKJMkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Nov 2022 07:40:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3264F27921
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 04:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 94DA7CE2268
        for <netdev@vger.kernel.org>; Thu, 10 Nov 2022 12:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 95DB1C433D7;
        Thu, 10 Nov 2022 12:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668084014;
        bh=l3VXZgXA+GYPwv/RWZdX49B5yYsSbwBsZXpl4HDF30g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=mrvF/XfdyyJrbfegSoVtBSy0W5z0ey4aZuhhoR9iy6EQRP7KguYVId1IkKG8q9LVG
         id6wo9QSnQdizfOYxhvGUltHSbMBlqPFwv5MjzGazQUOvkS0pdpV5jLJaIJT0XPfQm
         +HnspKhPddPND5UgSNcQCVval3a1YBXTCOSxCKw7BzQmAerU46OsB1QBDE/BM+6Wr1
         MRu6kPlHoK3nvL3itwCRmVeORCHp2XV3zmrHEB8m5Zc5hKU7kY/guEMalEcyl2F5JJ
         nspRPwGXz2ZZqBZWH7vXJftCu+aLoLmiSyVrVsM5kBB+DKjbnU8lXzHBoFMl5M9CG7
         w0J9kdj0o05/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 757BAE270C5;
        Thu, 10 Nov 2022 12:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: mv643xx_eth: disable napi when init rxq or txq
 failed in mv643xx_eth_open()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166808401447.11351.14977032167640156254.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Nov 2022 12:40:14 +0000
References: <20221109025432.80900-1-shaozhengchao@huawei.com>
In-Reply-To: <20221109025432.80900-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, sebastian.hesselbarth@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, jeffrey.t.kirsher@intel.com,
        weiyongjun1@huawei.com, yuehaibing@huawei.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 9 Nov 2022 10:54:32 +0800 you wrote:
> When failed to init rxq or txq in mv643xx_eth_open() for opening device,
> napi isn't disabled. When open mv643xx_eth device next time, it will
> trigger a BUG_ON() in napi_enable(). Compile tested only.
> 
> Fixes: 2257e05c1705 ("mv643xx_eth: get rid of receive-side locking")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net,v2] net: mv643xx_eth: disable napi when init rxq or txq failed in mv643xx_eth_open()
    https://git.kernel.org/netdev/net/c/f111606b63ff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


