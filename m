Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 70A80535897
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 06:49:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242424AbiE0Esm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 00:48:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43412 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237156AbiE0Esh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 00:48:37 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D7C641322;
        Thu, 26 May 2022 21:48:36 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0BF92B82291;
        Fri, 27 May 2022 04:48:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9E54AC34113;
        Fri, 27 May 2022 04:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653626913;
        bh=JHfdVwsS662QWfc0dE9d7zEZI/6vvpAZgwZrMugOF2w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fdoClE1IdFwRSz/JMyVs/4gY+h0olJBx0YLAYHcSlaM+ikRdBe5KFi/dvafBkvCLR
         /VANgaxnGzBNLa+b15kSZXQ5yJgJRVNjdA7XNt8iY7ouXVx6zdsmDCUVLcNIY6M6VC
         qL4ItD1jJo0duapg2zIf6RrSR1c3taPG06UEcS/JM91f6bSMe5e65twhSjgUNEFVJJ
         QulhIYueJ1Toqcsyx5cIc9F+isff02UonrkfbsIYuaYyJf1l2zM4uLU5/LiX9lUahP
         hEitcnIVmi+eB30gGhlNCOGgnxLlojgSomDwy9MYTnAeG4w8nE+LoGE8hf7SLe0GfT
         Njp1Z+BnJU8Gw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7ADA7F03947;
        Fri, 27 May 2022 04:48:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: lan966x: check devm_of_phy_get() for -EDEFER_PROBE
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165362691349.5864.17166538440351301920.git-patchwork-notify@kernel.org>
Date:   Fri, 27 May 2022 04:48:33 +0000
References: <20220525231239.1307298-1-michael@walle.cc>
In-Reply-To: <20220525231239.1307298-1-michael@walle.cc>
To:     Michael Walle <michael@walle.cc>
Cc:     horatiu.vultur@microchip.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        UNGLinuxDriver@microchip.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 26 May 2022 01:12:39 +0200 you wrote:
> At the moment, if devm_of_phy_get() returns an error the serdes
> simply isn't set. While it is bad to ignore an error in general, there
> is a particular bug that network isn't working if the serdes driver is
> compiled as a module. In that case, devm_of_phy_get() returns
> -EDEFER_PROBE and the error is silently ignored.
> 
> The serdes is optional, it is not there if the port is using RGMII, in
> which case devm_of_phy_get() returns -ENODEV. Rearrange the error
> handling so that -ENODEV will be handled but other error codes will
> abort the probing.
> 
> [...]

Here is the summary with links:
  - [net] net: lan966x: check devm_of_phy_get() for -EDEFER_PROBE
    https://git.kernel.org/bpf/bpf/c/b58cdd4388b1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


