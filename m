Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B17D64ABA3
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 00:40:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233849AbiLLXkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 18:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46572 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233823AbiLLXkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 18:40:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5F331AA01;
        Mon, 12 Dec 2022 15:40:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 65D09B80F92;
        Mon, 12 Dec 2022 23:40:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1FE3CC433D2;
        Mon, 12 Dec 2022 23:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670888419;
        bh=+az1pXE7X6sfRT3o2N5a5UUUkfjaCTtYvta9EP3TWTE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=E8mPLvQaxQT2fZSJMTnMSJUy1sZ0d4XqNrdC37yGRCjiy1jPoGNIwm8G7cvutepUE
         cv88cQzeOC6PVtc/cyx7BnKdTGRI+acrMcBXnN/LDwneRS1SnBpdgfggqIJetYFUJI
         gBZziGMxRQMy7Oya3zAIlBpQZluXehKwNNp1i/u+ABAA2tyPydYQRpCCdGpZnOlEc/
         IiBFWeynYlqA1oTOHgG5vk/cDuTJnuR+RHkSPi7ci0F7swNuOvvBud4Rmzal4vLM59
         CvingVsUTdCuMrDbaXvSSI9yAPDKcWNpogqFeO2kggcNgip14zIA9jQvmRabSLambB
         QE7g2mh7qZe9w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 09129E21EF1;
        Mon, 12 Dec 2022 23:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] qlcnic: Clean up some inconsistent indenting
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167088841903.5876.7987292047640279085.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 23:40:19 +0000
References: <20221212055813.91154-1-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <20221212055813.91154-1-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     shshaikh@marvell.com, manishc@marvell.com,
        GR-Linux-NIC-Dev@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        abaci@linux.alibaba.com
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

On Mon, 12 Dec 2022 13:58:13 +0800 you wrote:
> No functional modification involved.
> 
> drivers/net/ethernet/qlogic/qlcnic/qlcnic_ethtool.c:714 qlcnic_validate_ring_count() warn: inconsistent indenting.
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3419
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - qlcnic: Clean up some inconsistent indenting
    https://git.kernel.org/netdev/net-next/c/02abf84aa52d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


