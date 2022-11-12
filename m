Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E479A626717
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 06:10:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233972AbiKLFKZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Nov 2022 00:10:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230344AbiKLFKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Nov 2022 00:10:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A97D391CE
        for <netdev@vger.kernel.org>; Fri, 11 Nov 2022 21:10:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C466C60B4C
        for <netdev@vger.kernel.org>; Sat, 12 Nov 2022 05:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B78A7C4314B;
        Sat, 12 Nov 2022 05:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668229817;
        bh=kxSAqBxrCRTrkI/o9fzxwmJPKEDIU8vEdg24TN96ZKw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=P1j/a22wQJTZOE1XW43JFt0c+NPy66BDsIJDOQ6pvgmLfOvSHUbsgS43rweXkFk2Y
         tNeoWi8kiU4QKPYDz4ZhHg7PRW6VTu0r7nK/ktbkEW757siFTOmVJcw/AJtTzT9XmA
         bdfzbtfMclWDGIVN4Q9HXCZgCCwttPNcvCyx07dJTEYlSuWcytWGhwTthTAEH1yAb8
         Lpbw0LlC/BD1ZUF472ZgaigM2Fd5K57taqeV/8mYlnfTjY2XxSiHxP5DZie2llH0bq
         SnelRVGdaiKFzOldzcp80CqzHdF6yUq79ssElvuqoY+FifdQlKmpPxzMe2Mp1BfMO2
         beXcqBO78fpHw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 759E7E524C5;
        Sat, 12 Nov 2022 05:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mctp i2c: don't count unused / invalid keys for flow
 release
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166822981747.20406.7853672671463304757.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Nov 2022 05:10:17 +0000
References: <20221110053135.329071-1-jk@codeconstruct.com.au>
In-Reply-To: <20221110053135.329071-1-jk@codeconstruct.com.au>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matt@codeconstruct.com.au, zhangjian.3032@bytedance.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 10 Nov 2022 13:31:35 +0800 you wrote:
> We're currently hitting the WARN_ON in mctp_i2c_flow_release:
> 
>     if (midev->release_count > midev->i2c_lock_count) {
>         WARN_ONCE(1, "release count overflow");
> 
> This may be hit if we expire a flow before sending the first packet it
> contains - as we will not be pairing the increment of release_count
> (performed on flow release) with the i2c lock operation (only
> performed on actual TX).
> 
> [...]

Here is the summary with links:
  - [net] mctp i2c: don't count unused / invalid keys for flow release
    https://git.kernel.org/netdev/net/c/9cbd48d5fa14

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


