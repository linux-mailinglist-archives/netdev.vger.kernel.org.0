Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E0D546008DD
	for <lists+netdev@lfdr.de>; Mon, 17 Oct 2022 10:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbiJQIkZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Oct 2022 04:40:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60532 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229977AbiJQIkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Oct 2022 04:40:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FB302716F
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 01:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 460D360F81
        for <netdev@vger.kernel.org>; Mon, 17 Oct 2022 08:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9EB9AC433B5;
        Mon, 17 Oct 2022 08:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665996015;
        bh=9xMMH3+lO0XQOoKqae/qjCXd9ADc3aVGICNZhctZVi0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bAuKy70Laxd/4iEBGZFtgZY1sbSsWhEtJ7ZRb8C2OI+wwxgC2eDUoIhLhyCUla/iV
         3112gIbdDCsGhkLDbbJG2GBNpzLz+/TrPqmrT+mR5G/aVoP8ffWb8RRMrg/hAH2VcS
         CjEPv3NVu3kUc0C9NewEv3/v+8YAix7fMQ04w2bNo5O13vjzzQsAdyj5GHW1tJwzpg
         FbEdplJ4a8phF98SpecpvE0Xuf8D4rmhT8tuxfLys/Fu1jUXHKBbQb3BJ+vPf1C4fE
         qfZYCqa5bsXKsMaH8Km5Unq/nk3ndfCeDgcHGxgCsXI7IMuFUJMJqwRLxh/nQhxt9h
         ZHC8evbe2HiQA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7BC5AE270EB;
        Mon, 17 Oct 2022 08:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] net: ethernet: mtk_eth_wed: fixe some leaks
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166599601550.19223.16660356198196080947.git-patchwork-notify@kernel.org>
Date:   Mon, 17 Oct 2022 08:40:15 +0000
References: <20221017035156.2497448-1-yangyingliang@huawei.com>
In-Reply-To: <20221017035156.2497448-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-mediatek@lists.infradead.org, netdev@vger.kernel.org,
        nbd@nbd.name, davem@davemloft.net
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 17 Oct 2022 11:51:53 +0800 you wrote:
> I found some leaks in mtk_eth_soc.c/mtk_wed.c.
> 
>  patch#1 - I found mtk_wed_exit() is never called, I think mtk_wed_exit() need
>            be called in error path or module remove function to free the memory
>            allocated in mtk_wed_add_hw().
> 
>  patch#2 - The device is not put in error path in mtk_wed_add_hw().
> 
> [...]

Here is the summary with links:
  - [net,1/3] net: ethernet: mtk_eth_soc: fix possible memory leak in mtk_probe()
    https://git.kernel.org/netdev/net/c/b3d0d98179d6
  - [net,2/3] net: ethernet: mtk_eth_wed: add missing put_device() in mtk_wed_add_hw()
    https://git.kernel.org/netdev/net/c/9d4f20a476ca
  - [net,3/3] net: ethernet: mtk_eth_wed: add missing of_node_put()
    https://git.kernel.org/netdev/net/c/e0bb4659e235

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


