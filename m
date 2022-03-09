Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B99D94D2DFC
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 12:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232182AbiCILbN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 06:31:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37910 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231970AbiCILbM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 06:31:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2ADEA14FBD9
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 03:30:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B65B261852
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1B6BEC340F4;
        Wed,  9 Mar 2022 11:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646825413;
        bh=PdOMBLWVqA0lLlyYG0NrboHs39ChnFyc3cQNB6pVJO4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hk9B4sGsLSznaUiTfzlwy7UzI0niTPusENWJOQBqNmM0RQedu+4+44DJQeUlzFy6i
         LIP6MDg53L5RiqdQ8d3g0cRSPjYARMqavyYjQxxRAeTGIBrMaeBYF/PC7b8+EkZPnt
         8cp6vuWtPWq5ZfPpTYbUvXq0640aGEjhNGNkmER83WC6ic1SYktVdzIRNp5Z5fy5Rp
         4uGvhIoJXR0+gp64kpdiX4QTZTxdIXk5sZHckQ/dGcq781XUL7buiThG3cCaKGg0I8
         O49KBQ7evCB3ksv8LqgdNbrGGYR1gva0MKqNH8o0zN29JD+23nXJeqiGiMuGdyZtKc
         iapew14voPTmg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EC096F0383C;
        Wed,  9 Mar 2022 11:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] skb: make drop reason booleanable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164682541296.22286.8618719351208779118.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Mar 2022 11:30:12 +0000
References: <20220308004421.237826-1-kuba@kernel.org>
In-Reply-To: <20220308004421.237826-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        dsahern@gmail.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon,  7 Mar 2022 16:44:21 -0800 you wrote:
> We have a number of cases where function returns drop/no drop
> decision as a boolean. Now that we want to report the reason
> code as well we have to pass extra output arguments.
> 
> We can make the reason code evaluate correctly as bool.
> 
> I believe we're good to reorder the reasons as they are
> reported to user space as strings.
> 
> [...]

Here is the summary with links:
  - [net-next] skb: make drop reason booleanable
    https://git.kernel.org/netdev/net-next/c/1330b6ef3313

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


