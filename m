Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3E65FF999
	for <lists+netdev@lfdr.de>; Sat, 15 Oct 2022 12:10:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229662AbiJOKKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Oct 2022 06:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229633AbiJOKKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Oct 2022 06:10:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47E3F30F75;
        Sat, 15 Oct 2022 03:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E7F0EB8074E;
        Sat, 15 Oct 2022 10:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8A87CC433D7;
        Sat, 15 Oct 2022 10:10:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665828614;
        bh=lrKxT4JiUp21pgfPdi39R2O/1sHsVyppp27pKoo4IhQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eIYvypOqkcPlYftoYQXflX/Q0IYln7viBajH7Oa94blkjwAywCq+ponbAClvrOgc+
         HIDXX79rMvS4AJOWs+NYrOelaiAwF6UTjJm/2RKsAckQkXlvBWbqk3g5VRczJn4oNn
         IufQCprMPKSI6KGYfAY/BzoC1wIxCV2nTDqlLFRTrEwuQFmSpbxkXO1rOYKb/hv8Q9
         /mhISrq7OqKbfQK2wCAY5DnbVmYQE96FW6AIvdM8aMAO4gq1WGsvbdSjDY/7L7QaZX
         pmsrhlIhNdp8D95kohiX90LV4Q1/WnR1y8nUeM1+QJmgetMKvmLD6Eu2W4gXydDJny
         LZ23uWP2Pl1jA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 714EBE4D00C;
        Sat, 15 Oct 2022 10:10:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net/atm: fix proc_mpc_write incorrect return value
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166582861446.27777.4839698545728092807.git-patchwork-notify@kernel.org>
Date:   Sat, 15 Oct 2022 10:10:14 +0000
References: <20221014020540.32114-1-cppcoffee@gmail.com>
In-Reply-To: <20221014020540.32114-1-cppcoffee@gmail.com>
To:     Xiaobo Liu <cppcoffee@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

On Fri, 14 Oct 2022 10:05:40 +0800 you wrote:
> Then the input contains '\0' or '\n', proc_mpc_write has read them,
> so the return value needs +1.
> 
> Fixes: 1da177e4c3f4 ("Linux-2.6.12-rc2")
> 
> Signed-off-by: Xiaobo Liu <cppcoffee@gmail.com>
> 
> [...]

Here is the summary with links:
  - net/atm: fix proc_mpc_write incorrect return value
    https://git.kernel.org/netdev/net/c/d8bde3bf7f82

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


