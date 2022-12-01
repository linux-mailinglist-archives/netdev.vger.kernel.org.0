Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B057263ECE5
	for <lists+netdev@lfdr.de>; Thu,  1 Dec 2022 10:50:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229705AbiLAJuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Dec 2022 04:50:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229520AbiLAJuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 1 Dec 2022 04:50:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D65C2DFC6
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 01:50:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72B2860FA7
        for <netdev@vger.kernel.org>; Thu,  1 Dec 2022 09:50:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C9CD1C433D6;
        Thu,  1 Dec 2022 09:50:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669888216;
        bh=lHKNcWQXV8UgfiUW0OYmj10iiVpkaxW5a6HJ+Cx3A2I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tVuRiirWxKflKSDMA0sZWakI1YtMvVPbjmljI9fPF/gRlL/qR+e6lRm1dSvAxrHhT
         KJLbVmZe7tpO5L8iiOdtxV6MmZs15E5YdLT3A/+2NjY1f47G1eznCVfX2mtgBPL5Vt
         vDo21EnNcF4tUT2RXc94Waw5O9cKT0kHDhFV5LAB83TZEOtMAMPNv57muPx0WxDvjl
         DdW13xrzrjhJMGcD7u/WxQunnpsH2zHaZ+/HgUB+2sxfLW+TIsHRfmAo5RF1R2Qcyq
         vMUyToGfy5EgYFItKvQvK7jvpQF+bgWmUGXqMWn5a1VWwch7Qsd+G0KQxk+5PMFz+t
         wNjN1m4c8Mqzg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B14B7E21EF1;
        Thu,  1 Dec 2022 09:50:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net 0/2] af_unix: Fix a NULL deref in sk_diag_dump_uid().
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166988821672.23122.4391678060407477478.git-patchwork-notify@kernel.org>
Date:   Thu, 01 Dec 2022 09:50:16 +0000
References: <20221127012412.37969-1-kuniyu@amazon.com>
In-Reply-To: <20221127012412.37969-1-kuniyu@amazon.com>
To:     Kuniyuki Iwashima <kuniyu@amazon.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, felipe@felipegasper.com,
        harperchen1110@gmail.com, kuni1840@gmail.com,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Sun, 27 Nov 2022 10:24:10 +0900 you wrote:
> The first patch fixes a NULL deref when we dump a AF_UNIX socket's UID,
> and the second patch adds a repro/test for such a case.
> 
> 
> Changes:
>   v2:
>     * Get user_ns from NETLINK_CB(in_skb).sk.
>     * Add test.
> 
> [...]

Here is the summary with links:
  - [v2,net,1/2] af_unix: Get user_ns from in_skb in unix_diag_get_exact().
    https://git.kernel.org/netdev/net/c/b3abe42e9490
  - [v2,net,2/2] af_unix: Add test for sock_diag and UDIAG_SHOW_UID.
    https://git.kernel.org/netdev/net/c/ac011361bd4f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


