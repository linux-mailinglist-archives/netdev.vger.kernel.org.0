Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B95EF648CF7
	for <lists+netdev@lfdr.de>; Sat, 10 Dec 2022 04:50:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229734AbiLJDu1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Dec 2022 22:50:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229678AbiLJDuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Dec 2022 22:50:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 58E6E511D4;
        Fri,  9 Dec 2022 19:50:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E9443B82A66;
        Sat, 10 Dec 2022 03:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7930BC433F2;
        Sat, 10 Dec 2022 03:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670644221;
        bh=kifhm1yjQEnRS+L1KFP6bW7n+GVKqd2tN/WIPc5BikQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=vLmG/1prA4SRMSiKu/Z970rz7jV5w5nJn8IWM9nsRgoc0QfK5KpXXXFwpNbOocUGa
         v7Kcj/d17zYrJ9GobXJyhYY82DrWWxK+NzmTvmElPcy7ERo1j2QWf7aGaMvMHYWojt
         mtVo1DNuMsDDkzbWFdY7PVwOJeLbXaZgee8Z1NaLTMRsvPai09uK5wP4UYLneedCMa
         Wi5vdcJYkpBJiTtJwTIF+ZPhG5u87XfpyHJJkPaVD/0Y32zbT6D/ZmlHX26r4Lk90G
         v1TTXcHHRxSiScLitWqYclxmJvIyfIxtCpLSiWPL1EcAoTP5BHGZPaaWqWUkDaP3l9
         nCyvyZ4MGK6mQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 554CCC00448;
        Sat, 10 Dec 2022 03:50:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: bcmgenet: Remove the unused function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167064422134.8448.7660230410907496366.git-patchwork-notify@kernel.org>
Date:   Sat, 10 Dec 2022 03:50:21 +0000
References: <20221209033723.32452-1-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <20221209033723.32452-1-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     opendmb@gmail.com, f.fainelli@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, davem@davemloft.net,
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

On Fri,  9 Dec 2022 11:37:23 +0800 you wrote:
> The function dmadesc_get_addr() is defined in the bcmgenet.c file, but
> not called elsewhere, so remove this unused function.
> 
> drivers/net/ethernet/broadcom/genet/bcmgenet.c:120:26: warning: unused function 'dmadesc_get_addr'.
> 
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3401
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - net: bcmgenet: Remove the unused function
    https://git.kernel.org/netdev/net-next/c/28d39503e4e0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


