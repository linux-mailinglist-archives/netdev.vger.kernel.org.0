Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 408585EB16F
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 21:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229585AbiIZTkT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 15:40:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:32848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbiIZTkR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 15:40:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 36FDF2A723
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 12:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C882B6123E
        for <netdev@vger.kernel.org>; Mon, 26 Sep 2022 19:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24619C433D7;
        Mon, 26 Sep 2022 19:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664221216;
        bh=YRBe84gx+i/EggIGJrZcogWJ/iDeeHr3EvlDWKr715E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IEBLfv/n/T3VAVDMNwxg5xxqcL3m7sR25e7An2G5XWmRlBXHWDesOsmBvJr9xrCKp
         3sEw1LwU6/bdtyr2veaxCVIOYMqW0DqmyPHPNctkgMXHRikH996Pg4oiM1l4gLfFjP
         0LgLCLIBSOsIxJX84S6/jhMbYK19+dwuJspcbIzAQ7pQUI2zIHkjLHcjaA0Y+E0SgY
         9TUaF57C5vhKD/YEhO5iuqBnaJPV9ySJ7upED94NY6QjSrH3IUWJW+B/9uYw9BYiBI
         vQbc9+3RSQ51joaIOU9pq6mfAidliGbyGI6AQH5JDx48pxil4WURSuXpQrxWnBiuvL
         gEdVQBncliJvw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 064D3C04E59;
        Mon, 26 Sep 2022 19:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next,v2 0/4] Remove useless inline functions from net
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166422121600.19913.16367476485620472713.git-patchwork-notify@kernel.org>
Date:   Mon, 26 Sep 2022 19:40:16 +0000
References: <20220922083857.1430811-1-cuigaosheng1@huawei.com>
In-Reply-To: <20220922083857.1430811-1-cuigaosheng1@huawei.com>
To:     Gaosheng Cui <cuigaosheng1@huawei.com>
Cc:     idosch@nvidia.com, petrm@nvidia.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 22 Sep 2022 16:38:53 +0800 you wrote:
> v2:
>   1. Take the wireless patch("mlxsw: reg: Remove unused inline function
>   mlxsw_reg_sftr2_pack()")out of the series.
>   2. Remove the entire SFTR-V2 register in the patch("mlxsw: reg: Remove
>   deprecated code about SFTR-V2 Register").
>   3. Change Subject prefix to "PATCH net-next".
>   Thanks for taking time to review the patch.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/4] mlxsw: reg: Remove deprecated code about SFTR-V2 Register
    https://git.kernel.org/netdev/net-next/c/a9c3abf4e576
  - [net-next,v2,2/4] neighbour: Remove unused inline function neigh_key_eq16()
    https://git.kernel.org/netdev/net-next/c/c8f01a4a5447
  - [net-next,v2,3/4] net: Remove unused inline function sk_nulls_node_init()
    https://git.kernel.org/netdev/net-next/c/d6755f37abfd
  - [net-next,v2,4/4] net: Remove unused inline function dst_hold_and_use()
    https://git.kernel.org/netdev/net-next/c/0b81882ddf8a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


