Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BF5B16C842E
	for <lists+netdev@lfdr.de>; Fri, 24 Mar 2023 19:02:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231272AbjCXSCL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Mar 2023 14:02:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232045AbjCXSB5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Mar 2023 14:01:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 057841B2DF
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 11:01:26 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id CC9C3CE277E
        for <netdev@vger.kernel.org>; Fri, 24 Mar 2023 18:00:24 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 06E9CC433EF;
        Fri, 24 Mar 2023 18:00:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679680823;
        bh=a6s+A4YciT4lelTzKm6mucfrAMrC4h2RLcHqYGkz+/g=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RB9aiWSb6evEnzG7OjKyOh5RA9pprK6auP4pDPmQ+eps/SGsyNYzG8Jz1YH5vkgW4
         RFAE9jct+W/c2qUawNPYU2KMh8qZaahxhqCLQyz9ekw+OSpsTGY8aTAbKYE/LNU/YF
         l3BfL4O3xsazIDLZY2PX454nHJqb2601dlrMa/EH3o6avDjORQr59JFRqAo2tiCfFc
         NhAJqbfKM1hUww4MsD/tdknk1OUyTS4JNljlfcWb2byYfMhUmGc/V9TLogfc6umjsG
         nJEDNvcstJg0HcqBw2CEeDXH4OugOtKlpxbU4mLKOWF00GMMHoE+zO5BCaJ9xZdZWj
         l1HBZjbqCHxlQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E5D1CE4D021;
        Fri, 24 Mar 2023 18:00:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: wangxun: Fix vector length of interrupt cause
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167968082293.24696.12490562231523661207.git-patchwork-notify@kernel.org>
Date:   Fri, 24 Mar 2023 18:00:22 +0000
References: <20230322103632.132011-1-jiawenwu@trustnetic.com>
In-Reply-To: <20230322103632.132011-1-jiawenwu@trustnetic.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 22 Mar 2023 18:36:32 +0800 you wrote:
> There is 64-bit interrupt cause register for txgbe. Fix to clear upper
> 32 bits.
> 
> Fixes: 3f703186113f ("net: libwx: Add irq flow functions")
> Signed-off-by: Jiawen Wu <jiawenwu@trustnetic.com>
> ---
>  drivers/net/ethernet/wangxun/libwx/wx_type.h    | 2 +-
>  drivers/net/ethernet/wangxun/ngbe/ngbe_main.c   | 2 +-
>  drivers/net/ethernet/wangxun/txgbe/txgbe_main.c | 3 ++-
>  3 files changed, 4 insertions(+), 3 deletions(-)

Here is the summary with links:
  - [net] net: wangxun: Fix vector length of interrupt cause
    https://git.kernel.org/netdev/net/c/59513714f665

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


