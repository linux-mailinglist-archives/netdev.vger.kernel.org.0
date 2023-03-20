Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 22D846C0E9B
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 11:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230087AbjCTKU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 06:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57992 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230095AbjCTKUX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 06:20:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 850FD12CC1;
        Mon, 20 Mar 2023 03:20:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1ED2BB80DE3;
        Mon, 20 Mar 2023 10:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C91C7C4339C;
        Mon, 20 Mar 2023 10:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679307617;
        bh=CJDEBGjmfCXyMHYKOQOzjrh6ZWjbwqVYaba0I0x1wsM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uLWCXkp4mKcylIHW+vbHFgezgHl8IYC6k03gowknPjRyocDqTpRhH48EbPAJeAaE9
         mkhA5cL10l2RZ2dKrtWUBhVmhTgJTRzuVJz8uPL54lCwSiO9kN0CLWT9vhOu5e+exr
         U7WmnKSqKc11bGMK2ksQg4+URkAIIEH2hwri/GFi4I5xZvZR4foDM9a26bOT23FNMT
         HuZdQib75/AoLRZFfPkLuvcXUtLBR+G1ix+TJfKroecbdaLyNJaZhBB4niV3x85OuI
         ozBAtD9Ut/sZz7jZzw8sZCGfO1QX4iBBIvHunVNgcw5c1QPoy+K1FWDR20M88V87LJ
         uQVLTjh7lbHlg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A9EACE2A047;
        Mon, 20 Mar 2023 10:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] usb: plusb: remove unused pl_clear_QuickLink_features
 function
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167930761769.15318.7226219185357457772.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Mar 2023 10:20:17 +0000
References: <20230318131342.1684103-1-trix@redhat.com>
In-Reply-To: <20230318131342.1684103-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nathan@kernel.org, ndesaulniers@google.com,
        stern@rowland.harvard.edu, studentxswpy@163.com,
        gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        llvm@lists.linux.dev
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by David S. Miller <davem@davemloft.net>:

On Sat, 18 Mar 2023 09:13:42 -0400 you wrote:
> clang with W=1 reports
> drivers/net/usb/plusb.c:65:1: error:
>   unused function 'pl_clear_QuickLink_features' [-Werror,-Wunused-function]
> pl_clear_QuickLink_features(struct usbnet *dev, int val)
> ^
> This static function is not used, so remove it.
> 
> [...]

Here is the summary with links:
  - usb: plusb: remove unused pl_clear_QuickLink_features function
    https://git.kernel.org/netdev/net/c/7d722c9802d4

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


