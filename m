Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FFD6617527
	for <lists+netdev@lfdr.de>; Thu,  3 Nov 2022 04:40:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230179AbiKCDkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Nov 2022 23:40:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38816 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229637AbiKCDkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Nov 2022 23:40:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 493A315811;
        Wed,  2 Nov 2022 20:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6180861D14;
        Thu,  3 Nov 2022 03:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BB284C433D7;
        Thu,  3 Nov 2022 03:40:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667446815;
        bh=0NKeaCYrU2jNni7HwYo04jq1StIICoq2UhkqZuEtBA0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X7H/+cP4OPogr+Iue5/ZCpii8yTuLDTMExyeBssRzT2Rjwr0qdLLIWaLuVKelyftI
         d0VdVTocJnMF3vHf+Lwf5bue94++mVWm8EfvlQbcda/2ASsmjxi0BzUv08WVYwO/yF
         OBRLWxKgR2Wk5Uoac10Zz7MhU76cHHnigYVIFSzEknnw/sXH/3T4wNRqyP4ddKj9m/
         o+mMjS2IbFj8n/emTPStY/pxIoGpa0ZF0p08ofrFLyUpOrp2hy1RNLuwRxM16oI/BH
         NwY3HuWuVF+l76vYNWx8HNskHdA4m4RXQaYhDn7LNZzwH2HZZwQFHxCjgVloLRaooW
         tZBRx8tFYWEvA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9D786C41621;
        Thu,  3 Nov 2022 03:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] stmmac: dwmac-loongson: fix invalid mdio_node
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166744681563.6035.13467517612411156605.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Nov 2022 03:40:15 +0000
References: <20221101060218.16453-1-liupeibao@loongson.cn>
In-Reply-To: <20221101060218.16453-1-liupeibao@loongson.cn>
To:     Liu Peibao <liupeibao@loongson.cn>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, jiaxun.yang@flygoat.com,
        chenhuacai@loongson.cn, lvjianmin@loongson.cn,
        zhuyinbo@loongson.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue,  1 Nov 2022 14:02:18 +0800 you wrote:
> In current code "plat->mdio_node" is always NULL, the mdio
> support is lost as there is no "mdio_bus_data". The original
> driver could work as the "mdio" variable is never set to
> false, which is described in commit <b0e03950dd71> ("stmmac:
> dwmac-loongson: fix uninitialized variable ......"). And
> after this commit merged, the "mdio" variable is always
> false, causing the mdio supoort logic lost.
> 
> [...]

Here is the summary with links:
  - stmmac: dwmac-loongson: fix invalid mdio_node
    https://git.kernel.org/netdev/net/c/2ae34111fe4e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


