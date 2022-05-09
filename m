Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 607BF51FE89
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 15:46:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236162AbiEINoP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 09:44:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50562 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236114AbiEINoJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 09:44:09 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 88A24262702;
        Mon,  9 May 2022 06:40:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0231061564;
        Mon,  9 May 2022 13:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 44B0FC385A8;
        Mon,  9 May 2022 13:40:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652103614;
        bh=VbUiUV4JNvYGLPeFk35MonaYtBG9dxRlYsJUUAeelM0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WIgGUNBxQLp+obLesgugAGHPPK9yYkxSUQBOZqjYqxqbNWujAG8+o4Advjdv8pA2t
         rho15uzL96KTVWFVP3PDINkfj2h4TdpbxyTiZOsnzt6LacKz51oR/Soyfrv6MNOZ5n
         vUFvxu7u5GDyf+JaOehFIAtOkU+H3NKtqyH7x6ls0QpmY7auNamtJWpPmneRz8Ij3F
         P3tMsBKGeZWLuCwLd1PUq3h8nEKiBq/jm66MN7FEwl4zYpHd0+Vnxv2Y/JCnpbBHJN
         kU3X85XmTLbDv/iQGkmtUQfU9xhq8UauM/GFgN1DXFnymdZ0ft0nfNJZCo8NFcqOq9
         CFknttJyBqnSw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2EBB3F0392A;
        Mon,  9 May 2022 13:40:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next 0/6] net: hns3: updates for -next
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165210361417.30657.1832076685595767481.git-patchwork-notify@kernel.org>
Date:   Mon, 09 May 2022 13:40:14 +0000
References: <20220509075532.32166-1-huangguangbin2@huawei.com>
In-Reply-To: <20220509075532.32166-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        chenhao288@hisilicon.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 9 May 2022 15:55:26 +0800 you wrote:
> This series includes some updates for the HNS3 ethernet driver.
> 
> Change logs:
> V1 -> V2:
>  - Fix some sparse warnings of patch 3# and 4#.
>  - Add patch #6 to fix sparse warnings of incorrect type of argument.
> 
> [...]

Here is the summary with links:
  - [V2,net-next,1/6] net: hns3: fix access null pointer issue when set tx-buf-size as 0
    https://git.kernel.org/netdev/net-next/c/a4fe9b6db6f9
  - [V2,net-next,2/6] net: hns3: remove the affinity settings of vector0
    https://git.kernel.org/netdev/net-next/c/bbed70241204
  - [V2,net-next,3/6] net: hns3: add byte order conversion for PF to VF mailbox message
    https://git.kernel.org/netdev/net-next/c/767975e582c5
  - [V2,net-next,4/6] net: hns3: add byte order conversion for VF to PF mailbox message
    https://git.kernel.org/netdev/net-next/c/416eedb60361
  - [V2,net-next,5/6] net: hns3: add query vf ring and vector map relation
    https://git.kernel.org/netdev/net-next/c/a1aed456e326
  - [V2,net-next,6/6] net: hns3: fix incorrect type of argument in declaration of function hclge_comm_get_rss_indir_tbl
    https://git.kernel.org/netdev/net-next/c/443edfd6d43d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


