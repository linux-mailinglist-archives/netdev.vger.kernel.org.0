Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE0494FF5E7
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 13:40:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233141AbiDMLmg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Apr 2022 07:42:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39382 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiDMLmf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Apr 2022 07:42:35 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EE7FA2DCD
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 04:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5C612CE22FD
        for <netdev@vger.kernel.org>; Wed, 13 Apr 2022 11:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 99AAEC385A4;
        Wed, 13 Apr 2022 11:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649850011;
        bh=8852dA7rkkPDyCaxlLGCxpC3nSGBIJCfJSH+j0TsN4w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TgzMt/bRdtVGypA7rcodxwwW7JlsjuttRHstPNpkesPo5iTGPcGFKWwIKmguEISuV
         jMnmSn8NJ+oiWQuy/0Du0Vp1rFt6Y1FZIY01k6wI49Vfe35u+7j72+fl1KWwdFfQLj
         MOYyzsqezCY6TrZnVOVSv1E8EKFqMC7rafnm3nUHhEJG/wvJILfeHZXRt/5YG2ddsd
         GjaUrZKE4rYse0Brc0nticJ2XFUx96DYKK3dsiU2HfIUOcH3lbUeeqllFYh1e45t5i
         YIyZhyY/dNbW0qHmuBnxwNsbd1KY++bILKvETxTykzJo/+LfLBp/6V2wRSQDQ2IzeY
         OYMq8rW8DQ+/w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 77E69E8DD5E;
        Wed, 13 Apr 2022 11:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "net: dsa: setup master before ports"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164985001148.18593.17484550428624509468.git-patchwork-notify@kernel.org>
Date:   Wed, 13 Apr 2022 11:40:11 +0000
References: <20220412094426.2342043-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220412094426.2342043-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, kuba@kernel.org,
        davem@davemloft.net, f.fainelli@gmail.com, andrew@lunn.ch,
        vivien.didelot@gmail.com, olteanv@gmail.com
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
by David S. Miller <davem@davemloft.net>:

On Tue, 12 Apr 2022 12:44:26 +0300 you wrote:
> This reverts commit 11fd667dac315ea3f2469961f6d2869271a46cae.
> 
> dsa_slave_change_mtu() updates the MTU of the DSA master and of the
> associated CPU port, but only if it detects a change to the master MTU.
> 
> The blamed commit in the Fixes: tag below addressed a regression where
> dsa_slave_change_mtu() would return early and not do anything due to
> ds->ops->port_change_mtu() not being implemented.
> 
> [...]

Here is the summary with links:
  - [net] Revert "net: dsa: setup master before ports"
    https://git.kernel.org/netdev/net/c/762c2998c962

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


