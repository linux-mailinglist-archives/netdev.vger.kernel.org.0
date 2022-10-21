Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62A65606F3A
	for <lists+netdev@lfdr.de>; Fri, 21 Oct 2022 07:11:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229904AbiJUFLI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Oct 2022 01:11:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58292 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiJUFKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Oct 2022 01:10:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00EAE104D38;
        Thu, 20 Oct 2022 22:10:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 26D7D61DD8;
        Fri, 21 Oct 2022 05:10:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id EE02DC433D6;
        Fri, 21 Oct 2022 05:10:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666329022;
        bh=N+UXvmTu54QU+fcOVjstjS5OAlxfzhZVjzyf6YtQnUk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=S2irkDQT+p9LldjMthsgdrtKwzFApUjHBgEfHE4M4rTRk7LF+8GUj44z39r1ujoUL
         EHA3ihIOOVkqij2rnKjhYY3JI6Fw4fqZvjvBSs+7F/tI3GCNZVH7s0O+Hcgwqthqix
         m7UpAUjXYubY+gMvEz6O3PT0nLHgG7rXRkt7sFiDtcO/3oBfJtaI0I48klUwA8yyxI
         SQVMIyiTwrfrSJotfHIVUZ2CIOSVYu+O+Mmi5BDV6DXKLcpgk1YLo8mn9QlsTS/ysu
         4Q36jvyU1IbOg4BCW0UYgH5xUPh1my1l2MhEEYCz5RcP/16J6V5MfiX3HutL7l9xB2
         3UUhzWllz8O+g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DB53FE270E2;
        Fri, 21 Oct 2022 05:10:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: bcmgenet: add RX_CLS_LOC_ANY support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166632902189.25874.17301955253233692884.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Oct 2022 05:10:21 +0000
References: <20221019215123.316997-1-opendmb@gmail.com>
In-Reply-To: <20221019215123.316997-1-opendmb@gmail.com>
To:     Doug Berger <opendmb@gmail.com>
Cc:     davem@davemloft.net, f.fainelli@gmail.com, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com,
        bcm-kernel-feedback-list@broadcom.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 19 Oct 2022 14:51:23 -0700 you wrote:
> If a matching flow spec exists its current location is as good
> as ANY. If not add the new flow spec at the first available
> location.
> 
> Signed-off-by: Doug Berger <opendmb@gmail.com>
> ---
> changes since v1:
>  - removed __u32 tmp variable. Thanks Jakub!
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: bcmgenet: add RX_CLS_LOC_ANY support
    https://git.kernel.org/netdev/net-next/c/070f822d077f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


