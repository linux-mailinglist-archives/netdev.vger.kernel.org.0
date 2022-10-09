Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A44405F8DA6
	for <lists+netdev@lfdr.de>; Sun,  9 Oct 2022 21:10:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230202AbiJITKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Oct 2022 15:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52820 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230262AbiJITKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Oct 2022 15:10:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 100BB1EC78
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 12:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C3097B80D83
        for <netdev@vger.kernel.org>; Sun,  9 Oct 2022 19:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6ABBDC433C1;
        Sun,  9 Oct 2022 19:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665342615;
        bh=wyhfpaPr4horUSLI0COY3B51W8oh5usil64Uz2uKsU0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=rpTO1RnYyt6LvLDAozTTlXvNo3G3WAhb7Xq/5xGPd0y7thhFKFjgx2U4hBhEhgsoB
         XVMsFOvf4V41mhYumv5Z7dlExWI/kLrk5+/TLbqyKhYi7udvoiG/T9aKrJTh51BfvM
         TKHTUfmla5gyL8SI/kwSOCEWveimLPKhqfoLn9/TtbDIVxFC9x+jSBd6pVA+xaOvuX
         HRmnV1Q7ToWJowSHXAQsyKjyCsgjHofxybOd5idTmPQwmj/NqBBez7zYJitsfJwR7S
         Qs22BmvtjxgoH13LfHjEZDXaHcB+sDiesKX6auTK+10X77I9/jCPVX7NdIhQ6hoLb0
         MofZmbb7CTnUg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4A19CC73FE7;
        Sun,  9 Oct 2022 19:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: dsa: fix wrong pointer passed to PTR_ERR() in
 dsa_port_phylink_create()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166534261530.10565.9245107224628879722.git-patchwork-notify@kernel.org>
Date:   Sun, 09 Oct 2022 19:10:15 +0000
References: <20221008083942.3244411-1-yangyingliang@huawei.com>
In-Reply-To: <20221008083942.3244411-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, vladimir.oltean@nxp.com, jiri@nvidia.com,
        kuba@kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Sat, 8 Oct 2022 16:39:42 +0800 you wrote:
> Fix wrong pointer passed to PTR_ERR() in dsa_port_phylink_create() to print
> error message.
> 
> Fixes: cf5ca4ddc37a ("net: dsa: don't leave dangling pointers in dp->pl when failing")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  net/dsa/port.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net] net: dsa: fix wrong pointer passed to PTR_ERR() in dsa_port_phylink_create()
    https://git.kernel.org/netdev/net/c/557f050166e5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


