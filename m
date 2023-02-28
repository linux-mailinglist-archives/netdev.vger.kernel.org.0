Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B0B46A6267
	for <lists+netdev@lfdr.de>; Tue, 28 Feb 2023 23:30:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229769AbjB1WaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Feb 2023 17:30:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbjB1WaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Feb 2023 17:30:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7360212A6
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 14:30:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 60AF3611FD
        for <netdev@vger.kernel.org>; Tue, 28 Feb 2023 22:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B96D0C4339E;
        Tue, 28 Feb 2023 22:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677623417;
        bh=5NyYgtDTMmkWgPgQyV4ZGv2D6kY28aeQXkuOqbe+foc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=R9yLZsU443j5DceFRprgiF3AHgQp+WaIbcC5pCTgFs3BG2+Nx16Gfin3j7z+vPjwm
         MnjRmNhbDq1nPxh5CWKjBWp1SfLODN3MggEuUOrsWjbzcwTnn0dApL/H2PM5KrPohj
         jpUOT7YPu+5ElSIv1siXt6g3K45/CETSk+0hcAZvCHQ+RZ+r+bzyfZOvVqiAYvvsUv
         VYBaEVuHI1ZMgnzuMWgiSe6MYpA3OSRJ2yjo/6dH2MouXLJFbPZ/J4bUdVU6LlOKSf
         32YLKnxHJgrr8H8Nmbby6a/M44kNbLiI1NfIEL4+8EDe4mlCx7orlbSXmU5o1dRcYY
         WhQFb3Fwx76dg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9E6A0C691DE;
        Tue, 28 Feb 2023 22:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tls: rx: fix return value for async crypto
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167762341764.5992.13064409836086814051.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Feb 2023 22:30:17 +0000
References: <20230227181201.1793772-1-kuba@kernel.org>
In-Reply-To: <20230227181201.1793772-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, gaurav.jain@nxp.com, borisp@nvidia.com,
        john.fastabend@gmail.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 27 Feb 2023 10:12:01 -0800 you wrote:
> Gaurav reports that TLS Rx is broken with async crypto
> accelerators. The commit under fixes missed updating
> the retval byte counting logic when updating how records
> are stored. Even tho both before and after the change
> 'decrypted' was updated inside the main loop, it was
> completely overwritten when processing the async
> completions. Now that the rx_list only holds
> non-zero-copy records we need to add, not overwrite.
> 
> [...]

Here is the summary with links:
  - [net] tls: rx: fix return value for async crypto
    https://git.kernel.org/netdev/net/c/4d42cd6bc2ac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


