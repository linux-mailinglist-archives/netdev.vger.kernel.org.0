Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A981F6B1C4B
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 08:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229895AbjCIHaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 02:30:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbjCIHaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 02:30:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A457460D6C
        for <netdev@vger.kernel.org>; Wed,  8 Mar 2023 23:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0BABB61A36
        for <netdev@vger.kernel.org>; Thu,  9 Mar 2023 07:30:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6906FC433D2;
        Thu,  9 Mar 2023 07:30:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678347019;
        bh=PY/uLA/uD4tEmxehzZVdhshdCuFhE/0EYmNnMkbAalo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jYLwv5T1ZmXRh0hXvQdscL7jLQRCDD6KygKCCAZNOEx2vblJCZSjI2K0n2F0PgGwO
         foqwJj5CyGBjmws1xOz8Gvd+8g63x5OvaCL5SJd0LEPKYm/s1/hgx3/btVb2nA1Sbt
         KGT7slVcNny9EwFs0df8x64TvlZU01SL2pjSG8Pl29LAyJmQx10JJGuvqsuyLALpiy
         1BPfwrw8Cq0AY3VYLCb+1JXUmzlNZNbZJdiy5Axju0IdAXFKWQ6xV0LOt1IsgsMazm
         B5gJGsq81HtGaZbai4+txt3IPcwPQjmNrmRAi9N0RMuAqn1MM5Oey+ISG/E+t76KB4
         vMvfgYgq3Z14w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4B43EE61B60;
        Thu,  9 Mar 2023 07:30:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2] tools: ynl: fix enum-as-flags in the generic CLI
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167834701930.22182.11614438480026068450.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Mar 2023 07:30:19 +0000
References: <20230308003923.445268-1-kuba@kernel.org>
In-Reply-To: <20230308003923.445268-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, lorenzo@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  7 Mar 2023 16:39:21 -0800 you wrote:
> The CLI needs to use proper classes when looking at Enum definitions
> rather than interpreting the YAML spec ad-hoc, because we have more
> than on format of the definition supported.
> 
> Jakub Kicinski (2):
>   tools: ynl: move the enum classes to shared code
>   tools: ynl: fix enum-as-flags in the generic CLI
> 
> [...]

Here is the summary with links:
  - [net,1/2] tools: ynl: move the enum classes to shared code
    https://git.kernel.org/netdev/net/c/6517a60b0307
  - [net,2/2] tools: ynl: fix enum-as-flags in the generic CLI
    https://git.kernel.org/netdev/net/c/c311aaa74ca1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


