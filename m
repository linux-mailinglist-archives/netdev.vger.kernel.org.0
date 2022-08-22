Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 33CA959C139
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 16:01:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235531AbiHVOAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 10:00:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234803AbiHVOAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 10:00:21 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00E7B39B94;
        Mon, 22 Aug 2022 07:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 683FACE12B2;
        Mon, 22 Aug 2022 14:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B2336C43143;
        Mon, 22 Aug 2022 14:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661176816;
        bh=o1mTwFEtV6pXVr33Ti6bgAgVs4MqCeyJkctMEiUk4Y4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=e7L00i9T7NoD64qaLZQ33PlrPCbncrWfGyefn45hRJlI1WwzF9ORrYqK7UCU3bSgE
         LkAtO70oTaw3YpZ0mH3myL5Fqb/fMm4iwivrPYc/G8I6bw0ujRJ9VZyowWKR/AFP4/
         9SlulVcmg5LxFoc0WrNasTaOkbAoJUQdlIJ4TXv6kRBpRsl69/M+mjJuDtTF92ZNRi
         3FA2iZN2f41oClMN3rQ6w0O2L0huspAOGqc+CN2xj08aoyVPfwFsE9BZnnX4uz5Ocj
         I1ud3rGNuEcnE0+/wR3aKJg3MN37J458xXrwiZY6bRPeSfO0kmyhudI1C8jaqNYD6a
         7BEROrAKWHIWw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A0413E2A03D;
        Mon, 22 Aug 2022 14:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: prestera: cache port state for non-phylink
 ports too
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166117681665.22523.8363355515341094096.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Aug 2022 14:00:16 +0000
References: <20220818111821.415972-1-maksym.glubokiy@plvision.eu>
In-Reply-To: <20220818111821.415972-1-maksym.glubokiy@plvision.eu>
To:     Maksym Glubokiy <maksym.glubokiy@plvision.eu>
Cc:     tchornyi@marvell.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, linux@armlinux.org.uk,
        yevhen.orlov@plvision.eu, oleksandr.mazur@plvision.eu,
        taras.chornyi@plvision.eu, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 18 Aug 2022 14:18:21 +0300 you wrote:
> Port event data must stored to port-state cache regardless of whether
> the port uses phylink or not since this data is used by ethtool.
> 
> Fixes: 52323ef75414 ("net: marvell: prestera: add phylink support")
> Signed-off-by: Oleksandr Mazur <oleksandr.mazur@plvision.eu>
> Signed-off-by: Maksym Glubokiy <maksym.glubokiy@plvision.eu>
> 
> [...]

Here is the summary with links:
  - [net-next] net: prestera: cache port state for non-phylink ports too
    https://git.kernel.org/netdev/net-next/c/704438dd4f03

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


