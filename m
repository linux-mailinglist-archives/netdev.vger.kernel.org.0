Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 566B26823A3
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 06:10:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229962AbjAaFK1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 00:10:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56106 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229930AbjAaFKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 00:10:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C0AFC30B09;
        Mon, 30 Jan 2023 21:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 79D01B819A5;
        Tue, 31 Jan 2023 05:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11173C433AE;
        Tue, 31 Jan 2023 05:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675141817;
        bh=DQ5RF1MS4vtaaJGGCy0zMvZ6Y471iESY5zZMmC496Ik=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SNoDqOfNs5v0OmfRfAhVCHV6/KoZB+t/lGOo7MaqbstiKQsOgxD3mns4vboo+v/LV
         2LfG8/b/gcMN9nFLgmmv2mMECGgPiqopmtZif/zv09aIKSCmzw6ssvkfTy4YZWkvB7
         TCacCv+eEtxmdbfWMmXLQ5tBLWrpvx/NLxBKAxXhbv5lLT0KG66DE0oVTXvKopkP3i
         FOKlN9BQFEjjcsTNq0dXOBFEw0zqf3I/wtv/53IOCv2dxlUOsgS3oE+5BdnHzZHjJC
         3FElxH/AgQNFc6PWJmUxJkHhNTs9ICyegwyE7nuDJ2u3gqxf4OoS8wKe0t28eUFZS8
         vdCndUuK7Q9LQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E7A79E50D6B;
        Tue, 31 Jan 2023 05:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: b44: Remove the unused function __b44_cam_read()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167514181694.11863.11779733080664866743.git-patchwork-notify@kernel.org>
Date:   Tue, 31 Jan 2023 05:10:16 +0000
References: <20230128090413.79824-1-jiapeng.chong@linux.alibaba.com>
In-Reply-To: <20230128090413.79824-1-jiapeng.chong@linux.alibaba.com>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     michael.chan@broadcom.com, davem@davemloft.net,
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

On Sat, 28 Jan 2023 17:04:13 +0800 you wrote:
> The function __b44_cam_read() is defined in the b44.c file, but not called
> elsewhere, so remove this unused function.
> 
> drivers/net/ethernet/broadcom/b44.c:199:20: warning: unused function '__b44_cam_read'.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Link: https://bugzilla.openanolis.cn/show_bug.cgi?id=3858
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
> 
> [...]

Here is the summary with links:
  - net: b44: Remove the unused function __b44_cam_read()
    https://git.kernel.org/netdev/net-next/c/1586f31e30ed

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


