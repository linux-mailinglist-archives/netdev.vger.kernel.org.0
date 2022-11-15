Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 81AC462990B
	for <lists+netdev@lfdr.de>; Tue, 15 Nov 2022 13:40:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232322AbiKOMkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Nov 2022 07:40:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53560 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232318AbiKOMkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Nov 2022 07:40:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3B9A3233A9
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 04:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B8EAA61728
        for <netdev@vger.kernel.org>; Tue, 15 Nov 2022 12:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0A603C433D6;
        Tue, 15 Nov 2022 12:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668516016;
        bh=5PETkSRFfQd+d+iP64YJos6hd+wgScggoBlBGO6L3M0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u0TmIlx5SsuiIkbTwk7A3WSLGuUKkzzb72cg7O0PPeuC9F3fywn5Pm7gq+/kHUEIb
         AkIp5Y5velLCiNpkt/OIKhHar1gxz8a6jjNLJiohNWVEBNstDOqyQgcV0dFHTeX5RH
         umQ7hBUHJsPVe56BJdi0jROpFwoeeKXqXWL/CtH4UPnBeBfvjzEDBfbqznW0IJ1dcm
         MIT168r5fpzdKiXIeLMu1TwFIZSZ+0eAIziBpVCscqih29VZkNCVIaNcKtd4KnNJK0
         uSOv9v2JXD1uF5UbXfJS1H07BXhWIIbh3TlMvzsmL4DBAEi2To61TsmjqtefAKCJL7
         Q1F8o2Krp9u2g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DF443C395F5;
        Tue, 15 Nov 2022 12:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net 0/3] net: hns3: This series bugfix for the HNS3
 ethernet driver.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166851601590.3148.3051543864016009000.git-patchwork-notify@kernel.org>
Date:   Tue, 15 Nov 2022 12:40:15 +0000
References: <20221114082048.49450-1-lanhao@huawei.com>
In-Reply-To: <20221114082048.49450-1-lanhao@huawei.com>
To:     Hao Lan <lanhao@huawei.com>
Cc:     lipeng321@huawei.com, shenjian15@huawei.com,
        linyunsheng@huawei.com, liuyonglong@huawei.com,
        chenhao418@huawei.com, wangjie125@huawei.com,
        huangguangbin2@huawei.com, yisen.zhuang@huawei.com,
        salil.mehta@huawei.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        xiaojiantao1@h-partners.com, dvyukov@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 14 Nov 2022 16:20:45 +0800 you wrote:
> This series includes some bugfix for the HNS3 ethernet driver.
> Patch 1# fix incorrect hw rss hash type of rx packet.
> Fixes: 796640778c26 ("net: hns3: support RXD advanced layout")
> Fixes: 232fc64b6e62 ("net: hns3: Add HW RSS hash information to RX skb")
> Fixes: ea4858670717 ("net: hns3: handle the BD info on the last BD of the packet")
> 
> Patch 2# fix return value check bug of rx copybreak.
> Fixes: e74a726da2c4 ("net: hns3: refactor hns3_nic_reuse_page()")
> Fixes: 99f6b5fb5f63 ("net: hns3: use bounce buffer when rx page can not be reused")
> 
> [...]

Here is the summary with links:
  - [V2,net,1/3] net: hns3: fix incorrect hw rss hash type of rx packet
    https://git.kernel.org/netdev/net/c/a56cad694767
  - [V2,net,2/3] net: hns3: fix return value check bug of rx copybreak
    https://git.kernel.org/netdev/net/c/29df7c695ed6
  - [V2,net,3/3] net: hns3: fix setting incorrect phy link ksettings for firmware in resetting process
    https://git.kernel.org/netdev/net/c/510d7b6ae842

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


