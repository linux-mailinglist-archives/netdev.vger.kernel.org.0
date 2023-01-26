Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3E92367C4E9
	for <lists+netdev@lfdr.de>; Thu, 26 Jan 2023 08:31:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234415AbjAZHaz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Jan 2023 02:30:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52028 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229554AbjAZHam (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Jan 2023 02:30:42 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3E6065F1B;
        Wed, 25 Jan 2023 23:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6F1EBB819AE;
        Thu, 26 Jan 2023 07:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F193FC433A0;
        Thu, 26 Jan 2023 07:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674718217;
        bh=776WbdgvlSo/2M9QNlKZAn4tbX+UBjrD/DU9D2Ead1s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KeVtGagKIyDL2p8YHBgQnslbvPBRrtnl5KzT6dGOMTUQ1RsAPXh65i0ug1intyUKT
         n6BIh3W39qB62s8p6nfTBQjYkMQ1RD3oP+ZVTZL4z2hhlIUXipdkOLwMzwRGN25+Xq
         Qxq64SC5vyUBPySQY2EPEHcY4eQ5x8M8z5e8GMyUfWeCtkPbB7adFJIbZENb61yHxp
         7neJFFGfUOFwmLO99pWNwca7D6LXpS8kZBzauCZ590KS/ewfFLB7Mo7yKj0px2TP8C
         IYqxN2J2UI3WGpBQjKa/Sr3i2+ut/9Mf6JNZJH26q8SBice05E8EGe8khq5s0CC87m
         5gZqAWdabsOsw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C806CE52508;
        Thu, 26 Jan 2023 07:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] docs: networking: Fix bridge documentation URL
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167471821681.31738.8649419403734415514.git-patchwork-notify@kernel.org>
Date:   Thu, 26 Jan 2023 07:30:16 +0000
References: <20230124145127.189221-1-ivecera@redhat.com>
In-Reply-To: <20230124145127.189221-1-ivecera@redhat.com>
To:     Ivan Vecera <ivecera@redhat.com>
Cc:     linux-kernel@vger.kernel.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        corbet@lwn.net, netdev@vger.kernel.org, linux-doc@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 24 Jan 2023 15:51:26 +0100 you wrote:
> Current documentation URL [1] is no longer valid.
> 
> [1] https://www.linuxfoundation.org/collaborate/workgroups/networking/bridge
> 
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---
>  Documentation/networking/bridge.rst | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] docs: networking: Fix bridge documentation URL
    https://git.kernel.org/netdev/net/c/aee2770d199a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


