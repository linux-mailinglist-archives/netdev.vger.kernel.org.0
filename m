Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 523CF622184
	for <lists+netdev@lfdr.de>; Wed,  9 Nov 2022 03:00:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiKICAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Nov 2022 21:00:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229470AbiKICAS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Nov 2022 21:00:18 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11EB424F19
        for <netdev@vger.kernel.org>; Tue,  8 Nov 2022 18:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C777EB81CEF
        for <netdev@vger.kernel.org>; Wed,  9 Nov 2022 02:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5F571C433D6;
        Wed,  9 Nov 2022 02:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667959215;
        bh=pR3ULdga+izg7fDRXlSohcv2cTjOR4J45aQd1olRBA8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qyRVB5DHY1UL7iPGjepEK2Cg/fC/jT/NAGxoKP64SJ8ByyUBCU6lFHmxSimJcIuHC
         yp/AMGXRsARI3JTJADekrG3+VsjsTTOOU3K7CTQk+MQz/lfkDPRA6LBF63+6R0NVxG
         cqhloLLYEZKe0Nj7V1bZO8xMTNog5wMHEal/KekJQD0RQMYS1n7LWEgtkLZBoeolyi
         Hn9Ajcx/qQxk8z+XTplZCID/FVIXrFzq7FM3ZxsQPt9L0rUDDX1eZHug9v1BRNMZ/L
         M1gBq3xPhYt8RvNkw0tT/k/+TZo7T5YcfVicS2mnwAdUJ9263ze/nqPjSmes1JxL36
         L7tMYbMyZLodw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3A57EE270F5;
        Wed,  9 Nov 2022 02:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3 net] ibmveth: Reduce default tx queues to 8
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166795921523.12027.10211175772240147435.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Nov 2022 02:00:15 +0000
References: <20221107203215.58206-1-nnac123@linux.ibm.com>
In-Reply-To: <20221107203215.58206-1-nnac123@linux.ibm.com>
To:     Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org, nick.child@ibm.com, bjking1@linux.ibm.com,
        ricklind@us.ibm.com, dave.taht@gmail.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  7 Nov 2022 14:32:15 -0600 you wrote:
> Previously, the default number of transmit queues was 16. Due to
> resource concerns, set to 8 queues instead. Still allow the user
> to set more queues (max 16) if they like.
> 
> Since the driver is virtualized away from the physical NIC, the purpose
> of multiple queues is purely to allow for parallel calls to the
> hypervisor. Therefore, there is no noticeable effect on performance by
> reducing queue count to 8.
> 
> [...]

Here is the summary with links:
  - [v3,net] ibmveth: Reduce default tx queues to 8
    https://git.kernel.org/netdev/net/c/742c60e1285c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


