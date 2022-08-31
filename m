Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CC835A7E94
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 15:20:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230341AbiHaNUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 09:20:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230213AbiHaNUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 09:20:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2EFE4CA0D;
        Wed, 31 Aug 2022 06:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 332A161AB9;
        Wed, 31 Aug 2022 13:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8672DC433B5;
        Wed, 31 Aug 2022 13:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661952016;
        bh=HEX19Msue3ia1rUZ9HgmgaphrORghYpXMdcYG7HxG5U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=N56X7E936bII32lwSkViwaOtgiyImAwBwAhUW10zv/WB/1DorJO91Fj2cfF3/mG0m
         /1F6ZoUPL2f+QRvfKl5CHJCc3cbMXPscoeAmL6vH6WoFOM5AFh32Dq7EKEviDAFey8
         8399WoIrYHcThilBHnmHDCWMf5BsxwtD1kaG+pc+uzN8OFZWoK05cNjEai4d0XNn4a
         NfEAGTpHCfKcApuWmbFdDBAKR1AQL+FJDmdjxN6AYUx4oosrtsvl7N/AVVcumdi2Fv
         i7bl7a0ncYbBMHQ+AQA3qdQy4TlzPHtXol6KqSHapbFVVf8El53ipC7YWHn9PD0aRy
         zzbo3oyfTHMQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6FF44E924DA;
        Wed, 31 Aug 2022 13:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net: hns3: updates for -next
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166195201645.2919.18238731043037132359.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Aug 2022 13:20:16 +0000
References: <20220830111117.47865-1-huangguangbin2@huawei.com>
In-Reply-To: <20220830111117.47865-1-huangguangbin2@huawei.com>
To:     Guangbin Huang <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        lanhao@huawei.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 30 Aug 2022 19:11:13 +0800 you wrote:
> This series includes some updates for the HNS3 ethernet driver.
> 
> Guangbin Huang (3):
>   net: hns3: add getting capabilities of gro offload and fd from
>     firmware
>   net: hns3: add querying fec ability from firmware
>   net: hns3: net: hns3: add querying and setting fec off mode from
>     firmware
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net: hns3: add getting capabilities of gro offload and fd from firmware
    https://git.kernel.org/netdev/net-next/c/507e46ae26ea
  - [net-next,2/4] net: hns3: add querying fec ability from firmware
    https://git.kernel.org/netdev/net-next/c/eaf83ae59e18
  - [net-next,3/4] net: hns3: add querying and setting fec llrs mode from firmware
    https://git.kernel.org/netdev/net-next/c/5c4f72842d1d
  - [net-next,4/4] net: hns3: net: hns3: add querying and setting fec off mode from firmware
    https://git.kernel.org/netdev/net-next/c/08aa17a0c185

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


