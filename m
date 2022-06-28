Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5995D55D220
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 15:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244595AbiF1FAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 01:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46896 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243903AbiF1FAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 01:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1548626125
        for <netdev@vger.kernel.org>; Mon, 27 Jun 2022 22:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 98332B81C38
        for <netdev@vger.kernel.org>; Tue, 28 Jun 2022 05:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22E3EC341CD;
        Tue, 28 Jun 2022 05:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656392415;
        bh=LfVs+v9pd3ZsJZFfPwpZydXR/P1xZI1bu2lRa810Ob8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=al5Cb2OZF474N9FFw3eYucYQIBOctCR9xfNutkNU574A1RYxxL8oj9YUTt3CNI2NX
         JUtlL2UaBc7OEprb5doBkVGm+PKNw2chX3n6DiyrVyCXE3hxWNgPC65zBNAipw1ID7
         ya/sHHCEzCkH04La7DoG15EVRQEUuLwv80c3iJslvtM9msp/9iLkg5eeXre247oE/W
         3oIK85mxOvdm3oRjR0tZ20gDLejk0JTYL1EptIqIDbzzA8bJhennHh1ukddN2QVnD+
         oi+MXDr4FraJwyHHA+aD6H6ZXtePY62L6OBvke5XH+QD2olMQYz7t3M2z64L+s3Vvw
         PVWowTSa/scpA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 07222E49FA1;
        Tue, 28 Jun 2022 05:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] Notify user space if any actions were flushed before
 error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165639241501.25506.17717185902977586634.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Jun 2022 05:00:15 +0000
References: <20220623140742.684043-1-victor@mojatatu.com>
In-Reply-To: <20220623140742.684043-1-victor@mojatatu.com>
To:     Victor Nogueira <victor@mojatatu.com>
Cc:     jhs@mojatatu.com, xiyou.wangcong@gmail.com, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, jiri@resnulli.us
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Jun 2022 11:07:40 -0300 you wrote:
> This patch series fixes the behaviour of actions flush so that the
> kernel always notifies user space whenever it deletes actions during a
> flush operation, even if it didn't flush all the actions. This series
> also introduces tdc tests to verify this new behaviour.
> 
> Victor Nogueira (2):
>   net/sched: act_api: Notify user space if any actions were flushed
>     before error
>   selftests: tc-testing: Add testcases to test new flush behaviour
> 
> [...]

Here is the summary with links:
  - [net,1/2] net/sched: act_api: Notify user space if any actions were flushed before error
    https://git.kernel.org/netdev/net/c/76b39b94382f
  - [net,2/2] selftests: tc-testing: Add testcases to test new flush behaviour
    https://git.kernel.org/netdev/net/c/88153e29c1e0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


