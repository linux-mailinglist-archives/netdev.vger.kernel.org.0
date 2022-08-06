Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 859D458B35C
	for <lists+netdev@lfdr.de>; Sat,  6 Aug 2022 04:10:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241669AbiHFCKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 5 Aug 2022 22:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37932 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241654AbiHFCKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 5 Aug 2022 22:10:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3705C2AF6;
        Fri,  5 Aug 2022 19:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE142B82AC3;
        Sat,  6 Aug 2022 02:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6EEE7C433D7;
        Sat,  6 Aug 2022 02:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659751813;
        bh=hRJejyyiZsTASW6C3ZfgHZTv63Mj+O+arUxw/aioS2M=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oSmAfM3yrhEI+Ga75Ac+S4t1WdoP7zkUqVf8XXHjD9MWUmh6Ar2JAXiTJTKCci6E/
         6c6oD1PyoniYRyy75hoswrklu6fBo+uAG0iC9MDn7+a+cKZGQcZhbAhtQJFlXop6ll
         hPvBLeKkJsk5Awj5t/ABBYglhxZVqRnBR6lgqj7PwfDXbfbh06s01ff88+gB3h425T
         oeRpNWvTwEZKu+l6kTMpfq9mFQwFA3vCvIY7jgIKm6kjHp5Qg7+9VlPPyCTANx+80v
         Vb5zcau2Rv/djJzhy+kFN5o4Dr61GloizlSl36ic+S06GIdvZmP7VgeNieaJ+8lMlU
         HC2IKADR2zzOQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 54BEEC43142;
        Sat,  6 Aug 2022 02:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v1 net 1/1] net: avoid overflow when rose /proc displays
 timer information.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165975181334.26957.10972886418767588216.git-patchwork-notify@kernel.org>
Date:   Sat, 06 Aug 2022 02:10:13 +0000
References: <Yuk9vq7t7VhmnOXu@electric-eye.fr.zoreil.com>
In-Reply-To: <Yuk9vq7t7VhmnOXu@electric-eye.fr.zoreil.com>
To:     Francois Romieu <romieu@fr.zoreil.com>
Cc:     netdev@vger.kernel.org, edumazet@google.com, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, f6bvp@free.fr,
        thomas@osterried.de, thomas@x-berg.in-berlin.de,
        linux-hams@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 2 Aug 2022 17:07:42 +0200 you wrote:
> rose /proc code does not serialize timer accesses.
> 
> Initial report by Bernard F6BVP Pidoux exhibits overflow amounting
> to 116 ticks on its HZ=250 system.
> 
> Full timer access serialization would imho be overkill as rose /proc
> does not enforce consistency between displayed ROSE_STATE_XYZ and
> timer values during changes of state.
> 
> [...]

Here is the summary with links:
  - [v1,net,1/1] net: avoid overflow when rose /proc displays timer information.
    https://git.kernel.org/netdev/net/c/df1c941468fc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


