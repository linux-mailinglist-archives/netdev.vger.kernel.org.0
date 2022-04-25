Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0BD9550DEB1
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 13:20:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241717AbiDYLXT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 07:23:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39876 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240501AbiDYLXR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 07:23:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E644525E
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 04:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 94D69B815E5
        for <netdev@vger.kernel.org>; Mon, 25 Apr 2022 11:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4F632C385A4;
        Mon, 25 Apr 2022 11:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650885611;
        bh=nE6ck/ERk4U44s6xc9dNQFEnGwSfrdenefk7+0tMITk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dCxIKYNAs9jVfOFEM2ONQEDPXjdfaRk+JZ7EcH41I2CYE9glr/R/9H6YqOiTRGb5z
         lPirQvudOnITM9w6SZnFFmKzzr83rTFxBK1x6+YtN/XSZdWcF/LTbkoII7H8YYoPe8
         1RXZxFk+G9GhmlqPr+a8aqzy/BZIxXxYiolUCg0oRKS/7fE1ZlXnmejlYpIzl/2XGv
         eCp6fPEjcfn99DpBqopuwRIaUuDjhcrNKrFrxM7UX3Z2N4MTVrqzOnWf30CDzBziRS
         oIxjgmFiqhVWXzzwDPAxNFEGp3HhFHopWAk5QC1Lovj9csXCJAepEQXyVAKT5vBlbG
         ZB1Xs/VKeVuUA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3544DE85D90;
        Mon, 25 Apr 2022 11:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: make sure treq->af_specific is initialized
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165088561121.26271.15338368974535072718.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Apr 2022 11:20:11 +0000
References: <20220424203509.2801158-1-eric.dumazet@gmail.com>
In-Reply-To: <20220424203509.2801158-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, edumazet@google.com, fruggeri@arista.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Sun, 24 Apr 2022 13:35:09 -0700 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> syzbot complained about a recent change in TCP stack,
> hitting a NULL pointer [1]
> 
> tcp request sockets have an af_specific pointer, which
> was used before the blamed change only for SYNACK generation
> in non SYNCOOKIE mode.
> 
> [...]

Here is the summary with links:
  - [net] tcp: make sure treq->af_specific is initialized
    https://git.kernel.org/netdev/net/c/ba5a4fdd63ae

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


