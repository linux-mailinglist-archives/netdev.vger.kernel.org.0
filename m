Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 75E7B565076
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 11:10:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232471AbiGDJKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 05:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231808AbiGDJKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 05:10:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E5E21D2
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 02:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 09A1BB80DE5
        for <netdev@vger.kernel.org>; Mon,  4 Jul 2022 09:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 982BAC341CA;
        Mon,  4 Jul 2022 09:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656925813;
        bh=Kz8dMTxhLgKrKAkkoZ/GlsdD6FwYY9TWKYJq+YJvJ2o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=eSYRcAx+TaLUkOJV/cxJLRw3Xf9+p4hgtGPytX/ekit4bB8C9bVfWJ79CweOpioBN
         yL2qh4jBTyAuxfVd/N0d/fJ5m2KHl27vI4o5PPZzeueHogmXsus5O5++96trid2+Kj
         VXVrwkTnwX7i9LE5iW7xIQZwsRM+wNx4KuACR8DwJGTkMJx+oqGHG0hFuaWpI0cmOv
         Ey8ZZyK2jXcYP3JMM6QAgIKP+yeRzJyZSkkRIwsmvGsf/+U6IVJ3lAGARw/qj6AbUW
         AJGm0muBhHbBn7jXKDVBlaR4T0GCZ8tXkzM4Sft5eTd2E2LNvYMzuIiAmoPOVOaRen
         hbz8wANP48Hxw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7E7B1E45BDE;
        Mon,  4 Jul 2022 09:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/3] docs: netdev: document more of our rules
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165692581351.32669.4129777489558084481.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Jul 2022 09:10:13 +0000
References: <20220702031209.790535-1-kuba@kernel.org>
In-Reply-To: <20220702031209.790535-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, andrew@lunn.ch
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

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  1 Jul 2022 20:12:06 -0700 you wrote:
> The patch series length limit and reverse xmas tree are not documented.
> Add those, and a tl;dr section summarizing how we differ.
> 
> v2: improve the series length blurb (Andrew)
> 
> Jakub Kicinski (3):
>   docs: netdev: document that patch series length limit
>   docs: netdev: document reverse xmas tree
>   docs: netdev: add a cheat sheet for the rules
> 
> [...]

Here is the summary with links:
  - [net,v2,1/3] docs: netdev: document that patch series length limit
    https://git.kernel.org/netdev/net/c/02514a067fad
  - [net,v2,2/3] docs: netdev: document reverse xmas tree
    https://git.kernel.org/netdev/net/c/a24875641143
  - [net,v2,3/3] docs: netdev: add a cheat sheet for the rules
    https://git.kernel.org/netdev/net/c/5d407ca73892

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


