Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 08D0569BB2F
	for <lists+netdev@lfdr.de>; Sat, 18 Feb 2023 18:12:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbjBRRMi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 Feb 2023 12:12:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229563AbjBRRMg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 Feb 2023 12:12:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3647417CD6
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 09:12:36 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D9F8DB8087F
        for <netdev@vger.kernel.org>; Sat, 18 Feb 2023 17:12:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 75C48C4339E;
        Sat, 18 Feb 2023 17:12:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676740353;
        bh=GA5H44jYcHkLPPWOhvgK8WEWBRLZ4P+RSxdvMp/f50I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Zjxk0NEQ2cLl5mcjf/FwV0XWpchbICWtYT3CJzVWiDdixFRUDQZg+++1mmxGaFwDY
         C6lh6PUJPgxb8M0/6BokCfQH6AkZ/tUsQ6qHgrxO7kjtr1bDbC2mIvmp40cHGFJqMY
         +OFkr5BNm0FZbDGWxDry4mnscmFJqoBtqy2lm0184iwLb62ik7B302TYDdZOYP3S6i
         4KClm4sCm7AQSUR5+nPAX8sZTStLHth4pFGdIaHrbidrrHNxWiPBRYXqrrixvhLkK0
         yyU6CInJIBKMabi3tu3IdFqyfBXEzRNGmg2NcK2ZGda7DqXYyiktSz0B7Gf/bOqy7d
         RxhuHaAccztSA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 55C3FE68D2F;
        Sat, 18 Feb 2023 17:12:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [iproute2-next] seg6: man: ip-link.8: add SRv6 End PSP flavor
 description
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167674035334.11220.14340369648292783140.git-patchwork-notify@kernel.org>
Date:   Sat, 18 Feb 2023 17:12:33 +0000
References: <20230215135318.8899-1-paolo.lungaroni@uniroma2.it>
In-Reply-To: <20230215135318.8899-1-paolo.lungaroni@uniroma2.it>
To:     Paolo Lungaroni <paolo.lungaroni@uniroma2.it>
Cc:     dsahern@kernel.org, netdev@vger.kernel.org, kuba@kernel.org,
        stephen@networkplumber.org, stefano.salsano@uniroma2.it,
        ahabdels.dev@gmail.com, andrea.mayer@uniroma2.it
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Wed, 15 Feb 2023 14:53:18 +0100 you wrote:
> This patch extends the manpage by providing a brief description of the PSP
> flavor for the SRv6 End behavior as defined in RFC 8986 [1].
> 
> The code/logic required to handle the "flavors" framework has already been
> merged into iproute2 by commit:
>     04a6b456bf74 ("seg6: add support for flavors in SRv6 End* behaviors").
> 
> [...]

Here is the summary with links:
  - [iproute2-next] seg6: man: ip-link.8: add SRv6 End PSP flavor description
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=33840bbbbe5b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


