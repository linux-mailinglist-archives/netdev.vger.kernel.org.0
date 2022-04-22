Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4DC8150C449
	for <lists+netdev@lfdr.de>; Sat, 23 Apr 2022 01:12:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233182AbiDVW4l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Apr 2022 18:56:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233945AbiDVW40 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Apr 2022 18:56:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11E37272195
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 15:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9921F62153
        for <netdev@vger.kernel.org>; Fri, 22 Apr 2022 22:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 006A3C385B2;
        Fri, 22 Apr 2022 22:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650666013;
        bh=5aefpUtGU5rrGoXIWgxs6lipqvcyNEx5VmFl3K6WoiE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DCrtDyqxe54q0nP6OMPkxUSlu4qhaoI9yr8upDIL+OkP8necuoAojDnmcYWIQIm5f
         +Y+rzaidgqvQGyVT2q/IbSlTTOZ4OzLK9jv4EnURn6LkausR3CUwJwOXq9tpp2w8Xb
         j9sR0U8Ht5Lo2xK0ewnHG1GT2lPeCJ7GF0rlUVwO/l+uzBcReY9MlclmGit3VMJHr9
         uA4pT6J3pEa73gYy/5WhRvS+efITnfor4MZZHFLrS5UtO8miXS/Bi1rs+kqHXY2HRq
         Q62n1FFRaHDA0USK6a8XsPhoO3qMoZ8FB5/DhgSi9cdUntuS3SJK+GdYEzmypqqVNq
         bXdzvamwYoKuQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D9FD7E8DD61;
        Fri, 22 Apr 2022 22:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] qed: Remove IP services API.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165066601288.17746.5061213603060758540.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Apr 2022 22:20:12 +0000
References: <351ac8c847980e22850eb390553f8cc0e1ccd0ce.1650545051.git.gnault@redhat.com>
In-Reply-To: <351ac8c847980e22850eb390553f8cc0e1ccd0ce.1650545051.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, aelior@marvell.com, manishc@marvell.com,
        irusskikh@marvell.com, nassa@marvell.com, pkushwaha@marvell.com,
        okulkarni@marvell.com, mkalderon@marvell.com, smalin@marvell.com,
        hare@suse.de
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 21 Apr 2022 14:47:26 +0200 you wrote:
> qed_nvmetcp_ip_services.c and its corresponding header file were
> introduced in commit 806ee7f81a2b ("qed: Add IP services APIs support")
> but there's still no users for any of the functions they declare.
> Since these files are effectively unused, let's just drop them.
> 
> Found by code inspection. Compile-tested only.
> 
> [...]

Here is the summary with links:
  - [net-next] qed: Remove IP services API.
    https://git.kernel.org/netdev/net-next/c/5e7260712b9a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


