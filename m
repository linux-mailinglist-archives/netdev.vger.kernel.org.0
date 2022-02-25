Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 89A5E4C3BBF
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 03:30:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236573AbiBYCap (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 21:30:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38498 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231263AbiBYCao (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 21:30:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87AC320B15F;
        Thu, 24 Feb 2022 18:30:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3A521B82A96;
        Fri, 25 Feb 2022 02:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CF11AC340F4;
        Fri, 25 Feb 2022 02:30:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645756210;
        bh=tCgwYpUmEoWAO6jH1XEO78hSgFEOcyy/j9gcQGDjwjY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=I8hth6jNdjYlCr5yzFUCmo6tcoRx37sLrsc7Mesnj9R+s0s6zjV/XmUy4QqlM7ePM
         3DzWSvQKCYnE8YBdVTtUlqa8cq4XMFBDeufuMoMticjMI0q3TspUTWMeCu/dxdKCt0
         t6tsx4djxoGXofbecy1sJamdXFkmX07eClsHk5erHAHKEbCyIqOFN/vADy6NU6+jxK
         ncX2rutY8dxUwU3jipYWCLkmACMVN7twlG7RGahBkzhvaD7p0ozRdPvtsPYRO5EdBG
         mSKgUhUxb5s6K68H3ck2Lfdmrf+TVR4dZFYVmMjlPUKpJW2TM03pY+ioiBJHijxzjH
         e6hlZyjLCLaew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B3DC4E6D3DE;
        Fri, 25 Feb 2022 02:30:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request: bluetooth 2021-06-14
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164575621073.25534.8884614257765630962.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Feb 2022 02:30:10 +0000
References: <20220224210838.197787-1-luiz.dentz@gmail.com>
In-Reply-To: <20220224210838.197787-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
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

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 24 Feb 2022 13:08:38 -0800 you wrote:
> The following changes since commit 42404d8f1c01861b22ccfa1d70f950242720ae57:
> 
>   net: mv643xx_eth: process retval from of_get_mac_address (2022-02-24 10:05:08 -0800)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-02-24
> 
> [...]

Here is the summary with links:
  - pull request: bluetooth 2021-06-14
    https://git.kernel.org/netdev/net/c/8a7271000b91

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


