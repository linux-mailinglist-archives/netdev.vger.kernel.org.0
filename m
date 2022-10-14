Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 652B35FE9BF
	for <lists+netdev@lfdr.de>; Fri, 14 Oct 2022 09:40:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230038AbiJNHkc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Oct 2022 03:40:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33456 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230010AbiJNHkW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Oct 2022 03:40:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 052D167069
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 00:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 602C7B82269
        for <netdev@vger.kernel.org>; Fri, 14 Oct 2022 07:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9FF3CC43145;
        Fri, 14 Oct 2022 07:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665733216;
        bh=rvxS9EzEdG8Hx95SGNC347DBBu5e0RS5mD2D1ezUoUI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oaQCpxzvzYZqsfrAQNj9nTnCeO7R6cgXQLhMRFHJ0JbRdbGZQbyCSITJZ/TB0uqVI
         dSXVRdx++VVs6qiqJlWE1LZ9V4pMcsQe3ih25jvhZUVs7LlYDnxysjjSrv+aq7rVSM
         p3pvbtjlM+EAcbZq5eG6unbEwURJPCwhRnnPr8KaGewrnGoF26bYXKUZgdLlK7AFEr
         JNGDWPtIub/oeKStq/03JREviyi9/5ex49oYVoGne5RuJHraePoirROP3hkSmYzpke
         XC6chGBLlf2ztU0ItNWCuZBNRGt8ZxS+q1VP3h+IDRENX6r1nELxMiKirtEUq09yC4
         MPTn4j7bbfnYg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 87B98E52526;
        Fri, 14 Oct 2022 07:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tls: strp: make sure the TCP skbs do not have overlapping
 data
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166573321655.24049.13421324815397376895.git-patchwork-notify@kernel.org>
Date:   Fri, 14 Oct 2022 07:40:16 +0000
References: <20221012225520.303928-1-kuba@kernel.org>
In-Reply-To: <20221012225520.303928-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, borisp@nvidia.com, john.fastabend@gmail.com
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
by David S. Miller <davem@davemloft.net>:

On Wed, 12 Oct 2022 15:55:20 -0700 you wrote:
> TLS tries to get away with using the TCP input queue directly.
> This does not work if there is duplicated data (multiple skbs
> holding bytes for the same seq number range due to retransmits).
> Check for this condition and fall back to copy mode, it should
> be rare.
> 
> Fixes: 84c61fe1a75b ("tls: rx: do not use the standard strparser")
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [net] tls: strp: make sure the TCP skbs do not have overlapping data
    https://git.kernel.org/netdev/net/c/0d87bbd39d7f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


