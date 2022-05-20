Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E0A752E25E
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 04:12:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243688AbiETCKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 22:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47384 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241014AbiETCKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 22:10:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1FB6E11991D
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 19:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CD503B829D6
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 02:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9C635C34114;
        Fri, 20 May 2022 02:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653012612;
        bh=TR608NsmLw7o6ySHEbEu3W5Ypfk2UUrWYQn5DT5SzFA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qYkyj0nkYuExvv+fTLvZugYEq31igglMTVjDUSrXOoEv5LDX0ZPfhnTjQ5D0/CzKF
         ApuuJ4m9tG2yStUYxNNwLeO4w03tmfSq+cvWEQstpYYZ5r9INI0ZDd5NssKGQOOz6I
         lK6Uhl7qZqdVzEocbkGJNxcd/tHQWyMB0VWEYhCRV+MyH5S0A39O2XhnLV/hliVI1X
         2cBmwblbxvnV9t2FjOyzTeSbiSa8Kz7MO0RW4G1NBeG65tDM5lnYVay+nFciJwNaNo
         ulbeWXYEuQQDfd4Q/kTLyPZWWmSZI8uWMZar7QdXJ9ouEfWSAe11ABt5kDi65QnEdr
         pdh+rPtNfTf8A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7EAA3E8DBDA;
        Fri, 20 May 2022 02:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: improve PRR loss recovery
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165301261251.15462.1692873241460716101.git-patchwork-notify@kernel.org>
Date:   Fri, 20 May 2022 02:10:12 +0000
References: <20220519003410.2531936-1-ycheng@google.com>
In-Reply-To: <20220519003410.2531936-1-ycheng@google.com>
To:     Yuchung Cheng <ycheng@google.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        ncardwell@google.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 18 May 2022 17:34:10 -0700 you wrote:
> This patch improves TCP PRR loss recovery behavior for a corner
> case. Previously during PRR conservation-bound mode, it strictly
> sends the amount equals to the amount newly acked or s/acked.
> 
> The patch changes s.t. PRR may send additional amount that was banked
> previously (e.g. application-limited) in the conservation-bound
> mode, similar to the slow-start mode. This unifies and simplifies the
> algorithm further and may improve the recovery latency. This change
> still follow the general packet conservation design principle and
> always keep inflight/cwnd below the slow start threshold set
> by the congestion control module.
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: improve PRR loss recovery
    https://git.kernel.org/netdev/net-next/c/9ad084d66619

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


