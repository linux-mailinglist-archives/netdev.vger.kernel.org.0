Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD5A4C6E35
	for <lists+netdev@lfdr.de>; Mon, 28 Feb 2022 14:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236178AbiB1Nbo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Feb 2022 08:31:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236132AbiB1Nbl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Feb 2022 08:31:41 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B92F67B553;
        Mon, 28 Feb 2022 05:31:02 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 28FE1CE13C2;
        Mon, 28 Feb 2022 13:31:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8DE28C340F3;
        Mon, 28 Feb 2022 13:30:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646055059;
        bh=FS2fahhwxUCRx6vjuf1wsaHU8lukXCmh8jxyU76/vow=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=nDL4giEQc9D+3gWINfM9YXq22jXK6HnVdixBQ+D4odr5fa01cchQ5Sfimz5pt/cua
         nZ+kbycEcz+is6eZeVA75bfuG4kHQ2igIN5DGU2vTZ1J9hlUXJy2XhBCSpZy47OHSE
         u+KsLfv069f6KN30mazOUgKcklpf37YGAWfoRxSLYUFawRdOsL8y9tYxeMiDhP+7Ns
         IoG6dG5tSm/9fOE5uWojrskvUeFwZy/D1xLKGRjMORtwGjAq9Duw8LwcnrJNjrsCQB
         YhOGnOnlMbAqXc3D991w3+zi2j6gj2pHey2Nf7EMftminAbOT3aF8YeN7HRrQS3Lq2
         /fyIFjuz/fJTg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 76948E6D4BB;
        Mon, 28 Feb 2022 13:30:59 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: use time_is_before_eq_jiffies() instead of
 open coding it
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164605505947.13902.13998090836198697814.git-patchwork-notify@kernel.org>
Date:   Mon, 28 Feb 2022 13:30:59 +0000
References: <1646017944-60946-1-git-send-email-wangqing@vivo.com>
In-Reply-To: <1646017944-60946-1-git-send-email-wangqing@vivo.com>
To:     Qing Wang <wangqing@vivo.com>
Cc:     cooldavid@cooldavid.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 27 Feb 2022 19:12:22 -0800 you wrote:
> From: Wang Qing <wangqing@vivo.com>
> 
> Use the helper function time_is_{before,after}_jiffies() to improve
> code readability.
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>
> 
> [...]

Here is the summary with links:
  - net: ethernet: use time_is_before_eq_jiffies() instead of open coding it
    https://git.kernel.org/netdev/net-next/c/882edc062168

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


