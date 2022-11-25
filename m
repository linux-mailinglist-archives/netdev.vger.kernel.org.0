Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AFF2463851F
	for <lists+netdev@lfdr.de>; Fri, 25 Nov 2022 09:20:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229892AbiKYIUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Nov 2022 03:20:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229852AbiKYIUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Nov 2022 03:20:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0610022BD7;
        Fri, 25 Nov 2022 00:20:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AEA23B8298F;
        Fri, 25 Nov 2022 08:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6C121C433C1;
        Fri, 25 Nov 2022 08:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669364416;
        bh=otnltdyCW7H4vOjjm1lW8fbHg4CbEhEltMNq6AyjR0Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZSH+/lOrF7AdSPcmd9HM+wzpEE8fFnNRzU5QQiqyxKS7IiPnMoTLorpYS8PuV6xyO
         ojl6HNHtpwBMv9O1mw5xuvjfUrXFScoILvhI2PVKIcv2KwtoYvYybvyuoCs4Ar9XiH
         ouzGzwP+rFxlyhQLUzuwJsczKgD4lQoO2vOjrqn6OlvWl0fimsVBDy525NUB04dk8V
         uNPwh/q652g8Q0pw+hNb8OyrK0xAohbOJpKFvfIB4ovSRk7objZUsW+B5e3xxHI9me
         EBnsUUS/xwqsZYWO9J8VxtgO/Z1SvxppJJAy7x5FtTYDdUV1VDBivx0eGK9luIB46l
         kcahXvYL6yCDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4C335E270C7;
        Fri, 25 Nov 2022 08:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] qlcnic: fix sleep-in-atomic-context bugs caused by msleep
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166936441630.8812.9211554741894781474.git-patchwork-notify@kernel.org>
Date:   Fri, 25 Nov 2022 08:20:16 +0000
References: <20221123100642.6922-1-duoming@zju.edu.cn>
In-Reply-To: <20221123100642.6922-1-duoming@zju.edu.cn>
To:     Duoming Zhou <duoming@zju.edu.cn>
Cc:     linux-kernel@vger.kernel.org, shshaikh@marvell.com,
        manishc@marvell.com, GR-Linux-NIC-Dev@marvell.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
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

On Wed, 23 Nov 2022 18:06:42 +0800 you wrote:
> The watchdog timer is used to monitor whether the process
> of transmitting data is timeout. If we use qlcnic driver,
> the dev_watchdog() that is the timer handler of watchdog
> timer will call qlcnic_tx_timeout() to process the timeout.
> But the qlcnic_tx_timeout() calls msleep(), as a result,
> the sleep-in-atomic-context bugs will happen. The processes
> are shown below:
> 
> [...]

Here is the summary with links:
  - [net] qlcnic: fix sleep-in-atomic-context bugs caused by msleep
    https://git.kernel.org/netdev/net/c/8dbd6e4ce1b9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


