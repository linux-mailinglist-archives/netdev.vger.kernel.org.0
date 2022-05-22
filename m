Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 946C953066A
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 00:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348045AbiEVWKQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 18:10:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52986 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231986AbiEVWKO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 18:10:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B75C9381A4;
        Sun, 22 May 2022 15:10:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2921460F23;
        Sun, 22 May 2022 22:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 812D4C3411A;
        Sun, 22 May 2022 22:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653257412;
        bh=HVw9UNpsxtDAoeolW4s05T1gf/0xW8hy6jwdzWSCms0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BUpxrUhx4SjMKq8GWUiEcvowsW5NjobDBzLaT9mo02/9ywvnXWo1qi+kr4uozDeiY
         aS77geU9SieK0zfs9gS90Q9OYEKOVwk4/levlypmV1+nAKAqoQxDsLjve1CUwvqp9m
         Z2ApQzboiDyknADrBpZkG7UuEf+GVaY6xg+iaDJfCr48/ejIqwPQdodMETq8Tav4Cd
         kjeFNj+elgcJ7f7yT9M9SACnRh/A6GIO6Sk6zffW/RaMro3Pl3uk1zK2nJ8BobF9+k
         o9zXGMNC1HFNJMD0rFzqe5wEGmV+XZSs6vZneNVFqRmz4a22CYT48hXZc0fwhx7XqJ
         M2FlScMSJCwrA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6CA52F03938;
        Sun, 22 May 2022 22:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: fddi: skfp: smt: Remove extra parameters to vararg macro
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165325741244.24339.12922040378973252183.git-patchwork-notify@kernel.org>
Date:   Sun, 22 May 2022 22:10:12 +0000
References: <20220522133627.4085200-1-trix@redhat.com>
In-Reply-To: <20220522133627.4085200-1-trix@redhat.com>
To:     Tom Rix <trix@redhat.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, hanyihao@vivo.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 22 May 2022 09:36:27 -0400 you wrote:
> cppcheck reports
> [drivers/net/fddi/skfp/smt.c:750]: (warning) printf format string requires 0 parameters but 2 are given.
> 
> DB_SBAN is a vararg macro, like DB_ESSN.  Remove the extra args and the nl.
> 
> Signed-off-by: Tom Rix <trix@redhat.com>
> 
> [...]

Here is the summary with links:
  - net: fddi: skfp: smt: Remove extra parameters to vararg macro
    https://git.kernel.org/netdev/net-next/c/2a11fb1d1b85

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


