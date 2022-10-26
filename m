Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3E4D60D97D
	for <lists+netdev@lfdr.de>; Wed, 26 Oct 2022 05:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232846AbiJZDAa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Oct 2022 23:00:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50208 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232787AbiJZDAW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Oct 2022 23:00:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9DDDE37416
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 20:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D598FB82016
        for <netdev@vger.kernel.org>; Wed, 26 Oct 2022 03:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7B736C4347C;
        Wed, 26 Oct 2022 03:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666753216;
        bh=ejcP2ifLohn/OkDlba2fhexzB+x+33qRwoWn+ZtdM0s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EsDDk06FM3g2ovAvTME6iR1ZM9HsNNcWg/VREctxV3W6bwGT6ninqAsJO3nf/KnZw
         7L1fzvts5QYDS3UQ/ncBfJyrn69zbBLC799s8T3zMI5pizky1Ps6C7/pEG8nI+hhIG
         fiC8TYy18+QEWPkFvGLwk9OGa1h+E9TD1EtzdXCb0Abwmf7aVNafg+kUJha1o3d7io
         JouYVVkRbaCpJqo5IFG/AwfizYBocnbqPBFTH0BnRW7LK81mZ2chUKRMDwODdnvnBN
         aUr2uxq9lvhm0w6qQgN9RS0xfC3OM4BU3FL0OT/tkpTvbB/GEPe9KNSZu0Pf34hN63
         MlxGMC6+L8FVw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 60A4EE50D7A;
        Wed, 26 Oct 2022 03:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: ksz884x: fix missing pci_disable_device() on error
 in pcidev_init()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166675321638.7735.6557504831592301148.git-patchwork-notify@kernel.org>
Date:   Wed, 26 Oct 2022 03:00:16 +0000
References: <20221024131338.2848959-1-yangyingliang@huawei.com>
In-Reply-To: <20221024131338.2848959-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     netdev@vger.kernel.org, Tristram.Ha@micrel.com,
        davem@davemloft.net, kuba@kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 24 Oct 2022 21:13:38 +0800 you wrote:
> pci_disable_device() need be called while module exiting, switch to use
> pcim_enable(), pci_disable_device() will be called in pcim_release()
> while unbinding device.
> 
> Fixes: 8ca86fd83eae ("net: Micrel KSZ8841/2 PCI Ethernet driver")
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net] net: ksz884x: fix missing pci_disable_device() on error in pcidev_init()
    https://git.kernel.org/netdev/net/c/5da6d65590a0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


