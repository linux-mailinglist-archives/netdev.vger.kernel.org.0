Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FEBC54C145
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 07:43:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242711AbiFOFkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 01:40:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiFOFkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 01:40:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6211248E67;
        Tue, 14 Jun 2022 22:40:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EEFF5616C4;
        Wed, 15 Jun 2022 05:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4E8CFC3411B;
        Wed, 15 Jun 2022 05:40:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655271612;
        bh=/VUFfwdAz5D+vWMY4vZrXF3RLilJ/K4ApW15+UIs4HE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WlKy8oSZXO2zwqWD6OEBcWAyp1wCCNJikwNkmNbCEcdAAU1Unp1M+mfd7HjBSg4g5
         JsQKlTnAbsiQqNbY5yHqbnsHxbabWnnFBsn32m96/2n/f+MWQs2pqTB2tK9rkNDDgA
         UCbhSKPL1PZL23DgozIUPrHGojfKoDMROHUQryTIT5KTTocVvJUlagYhvCYkYZHRgm
         XQeSZk7RDjx4BzPHKwgcTfiMJRCMb7kJzU0bRUdKMawdI4x0UoZay1gyPi/AtdZx1w
         JVjPXXEk0OUFtGdBkzyOGwonWjnidtTjscwFmGyNTD7SA28KyPALEZKsPakm1OUNfo
         w79FbQu0IENIg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 33594E73856;
        Wed, 15 Jun 2022 05:40:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] MAINTAINERS: add include/dt-bindings/net to NETWORKING
 DRIVERS
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165527161220.30672.4060128437193370686.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Jun 2022 05:40:12 +0000
References: <20220613121826.11484-1-lukas.bulwahn@gmail.com>
In-Reply-To: <20220613121826.11484-1-lukas.bulwahn@gmail.com>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 13 Jun 2022 14:18:26 +0200 you wrote:
> Maintainers of the directory Documentation/devicetree/bindings/net
> are also the maintainers of the corresponding directory
> include/dt-bindings/net.
> 
> Add the file entry for include/dt-bindings/net to the appropriate
> section in MAINTAINERS.
> 
> [...]

Here is the summary with links:
  - MAINTAINERS: add include/dt-bindings/net to NETWORKING DRIVERS
    https://git.kernel.org/netdev/net/c/b60377de7790

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


