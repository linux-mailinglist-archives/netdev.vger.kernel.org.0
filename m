Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 96309660C4E
	for <lists+netdev@lfdr.de>; Sat,  7 Jan 2023 04:50:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230285AbjAGDuX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 22:50:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45558 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbjAGDuW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 22:50:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3C41547336
        for <netdev@vger.kernel.org>; Fri,  6 Jan 2023 19:50:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E1C12B81627
        for <netdev@vger.kernel.org>; Sat,  7 Jan 2023 03:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8DDB0C433D2;
        Sat,  7 Jan 2023 03:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673063418;
        bh=55o9jwdqwI8+6WZ82FzJLYPlLf5lMAINtt6k/nXmpxE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=j6yK6FUVfRJKmTg3D+tGw8YCUxpzaYbFcNCSTv4cJrsmu3eq68WlIfSv0yLML9kcn
         6GPo5XZHX5ePePkeUQ8baHse6LyiknAmJlegBhARqCON9qDTLCQwaw4jHGfoCTVOBu
         Cs+6YUkx4fc6OtlZRMltA1ymv8ciS8tKsyWDkA0rGDsOq2BhqMCtQhMw+GRKCZCy+0
         tUGpmHu2ypoSpPQk2AL4eL7fzSBThDEp2WvWl6ulHfP90+TaoM22zPmr82j7SqRoF6
         XxaAfdpytkEo+b7dOgsKL7zxjGlUlJ6uLdlx720yiG059Yy2Wy52JFRc80xrH3wROd
         AVKNUTlZo4kvg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 75366C395DF;
        Sat,  7 Jan 2023 03:50:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/8] net: wangxun: Adjust code structure
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167306341847.8196.961375733566282048.git-patchwork-notify@kernel.org>
Date:   Sat, 07 Jan 2023 03:50:18 +0000
References: <20230106033853.2806007-1-jiawenwu@trustnetic.com>
In-Reply-To: <20230106033853.2806007-1-jiawenwu@trustnetic.com>
To:     Jiawen Wu <jiawenwu@trustnetic.com>
Cc:     netdev@vger.kernel.org, mengyuanlou@net-swift.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  6 Jan 2023 11:38:45 +0800 you wrote:
> Remove useless structs 'txgbe_hw' and 'ngbe_hw' make the codes clear.
> And move the same codes which sets MAC address between txgbe and ngbe
> to libwx. Further more, rename struct 'wx_hw' to 'wx' and move total
> adapter members to wx.
> 
> Jiawen Wu (7):
>   net: txgbe: Remove structure txgbe_hw
>   net: ngbe: Remove structure ngbe_hw
>   net: txgbe: Move defines into unified file
>   net: ngbe: Move defines into unified file
>   net: wangxun: Move MAC address handling to libwx
>   net: wangxun: Rename private structure in libwx
>   net: txgbe: Remove structure txgbe_adapter
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/8] net: txgbe: Remove structure txgbe_hw
    https://git.kernel.org/netdev/net-next/c/ce2b4ad5d1b5
  - [net-next,v3,2/8] net: ngbe: Remove structure ngbe_hw
    https://git.kernel.org/netdev/net-next/c/8f727eeca397
  - [net-next,v3,3/8] net: txgbe: Move defines into unified file
    https://git.kernel.org/netdev/net-next/c/524f6b29fb86
  - [net-next,v3,4/8] net: ngbe: Move defines into unified file
    https://git.kernel.org/netdev/net-next/c/92710fe60515
  - [net-next,v3,5/8] net: wangxun: Move MAC address handling to libwx
    https://git.kernel.org/netdev/net-next/c/79625f45ca73
  - [net-next,v3,6/8] net: wangxun: Rename private structure in libwx
    https://git.kernel.org/netdev/net-next/c/9607a3e62645
  - [net-next,v3,7/8] net: txgbe: Remove structure txgbe_adapter
    https://git.kernel.org/netdev/net-next/c/270a71e64012
  - [net-next,v3,8/8] net: ngbe: Remove structure ngbe_adapter
    https://git.kernel.org/netdev/net-next/c/803df55d32ea

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


