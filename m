Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55CFF62ECF3
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 05:50:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235048AbiKREuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Nov 2022 23:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40600 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230287AbiKREuS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Nov 2022 23:50:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D38A97AB1;
        Thu, 17 Nov 2022 20:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1DD6662323;
        Fri, 18 Nov 2022 04:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A8B6C433C1;
        Fri, 18 Nov 2022 04:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668747016;
        bh=tBhuVjI/PcP3f2i9VOpdRBwC44MerYrd7O5Cbeuy1kk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WkepjNANJUpVWTDfT+NseryUx4lLx4IsNCKZdZvVkYKnxU3Hlo4RGUyVXt00dVfDd
         5R1dd0be+GGqNnBNhCYuVAyvZ3N5n7bKfDP6tk3H/vMhDA+1AcON2bznaH4ZXVPKZM
         w6bLRArCgtIb/PlIN9bE65/5V1m2VS4uzayfHlTbGPxS/EVUlTSRXf6TaM9zyQbM8w
         FQCDYYQUNrWcBe5+BLe+dq6Eye7ENJHJTo9IlEFYtSmmRm4Jbd0O3vMjlyZJH5hjR3
         1/u79mE+51OEm1pralFCfWjmmVetx1QSM8Qpq7zKPDMF8o9f6TZ/eXk2OH3EnBPbzg
         ysS5a+eoinBEg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 47C31E29F45;
        Fri, 18 Nov 2022 04:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5] ethtool: doc: clarify what drivers can implement in their
 get_drvinfo()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166874701628.23195.4484319487930561442.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 04:50:16 +0000
References: <20221116171828.4093-1-mailhol.vincent@wanadoo.fr>
In-Reply-To: <20221116171828.4093-1-mailhol.vincent@wanadoo.fr>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, andrew@lunn.ch,
        linux@rempel-privat.de, dan.j.williams@intel.com, petrm@nvidia.com,
        chenhao288@hisilicon.com, amcohen@nvidia.com,
        gustavoars@kernel.org, sean.anderson@seco.com,
        linux-kernel@vger.kernel.org, leonro@nvidia.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 17 Nov 2022 02:18:28 +0900 you wrote:
> Many of the drivers which implement ethtool_ops::get_drvinfo() will
> prints the .driver, .version or .bus_info of struct ethtool_drvinfo.
> To have a glance of current state, do:
> 
>   $ git grep -W "get_drvinfo(struct"
> 
> Printing in those three fields is useless because:
> 
> [...]

Here is the summary with links:
  - [v5] ethtool: doc: clarify what drivers can implement in their get_drvinfo()
    https://git.kernel.org/netdev/net-next/c/f20a0a0519f3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


