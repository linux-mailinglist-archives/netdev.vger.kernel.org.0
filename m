Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5CB2B50066D
	for <lists+netdev@lfdr.de>; Thu, 14 Apr 2022 08:50:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234153AbiDNGwh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Apr 2022 02:52:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60362 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233525AbiDNGwg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Apr 2022 02:52:36 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD9B640A0B
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 23:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 472CE61EEB
        for <netdev@vger.kernel.org>; Thu, 14 Apr 2022 06:50:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9538FC385A7;
        Thu, 14 Apr 2022 06:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649919011;
        bh=eYPFaMzm2tMi/zmdt7ETJuJ7Zi1C7+ynH4eRx97OY6o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lRqSC+Qx/tINAsjfHNMbaWB5zRaKoiXv24puB0cQErlih+zn530EcOgqboYjlklka
         N9MvrXSeeZS5m2o79xbyB2rEw0sxMYFXseRk99d1A7IMxtl/ZKR4buWCWj3wYtV1zY
         27vAHCJnqD1V7kLZEzkccakuUAp7r34z1y0YWuxZeS5k0NHWnVKSrOQhh4Tm/kg6ga
         oCj046k+SUuXdFhynw0OY0lsE2Q3RUK7j5kMbTQjkSatVZuiAgoXM2jYMPiwWBSrGT
         ZEYIKgOAR1ffWvVtwBt4lg46rb9SB8JgQccLjSkjrSo9VKEtMm4KS/iEXyV5JEzFKE
         1Ote5syHXhRYg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 799C2E85D15;
        Thu, 14 Apr 2022 06:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tun: annotate access to queue->trans_start
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164991901149.2774.5164833414025772461.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Apr 2022 06:50:11 +0000
References: <20220412135852.466386-1-atenart@kernel.org>
In-Reply-To: <20220412135852.466386-1-atenart@kernel.org>
To:     Antoine Tenart <atenart@kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 12 Apr 2022 15:58:52 +0200 you wrote:
> Commit 5337824f4dc4 ("net: annotate accesses to queue->trans_start")
> introduced a new helper, txq_trans_cond_update, to update
> queue->trans_start using WRITE_ONCE. One snippet in drivers/net/tun.c
> was missed, as it was introduced roughly at the same time.
> 
> Fixes: 5337824f4dc4 ("net: annotate accesses to queue->trans_start")
> Cc: Eric Dumazet <edumazet@google.com>
> Signed-off-by: Antoine Tenart <atenart@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net] tun: annotate access to queue->trans_start
    https://git.kernel.org/netdev/net/c/968a1a5d6541

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


