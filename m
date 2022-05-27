Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2FA7535894
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 06:48:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242398AbiE0Esg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 00:48:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43392 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237156AbiE0Esf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 00:48:35 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C977E41322;
        Thu, 26 May 2022 21:48:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 582CE60BD4;
        Fri, 27 May 2022 04:48:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8E4AAC385A9;
        Fri, 27 May 2022 04:48:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653626913;
        bh=OHORZuBkhGyIjfAgvAx1fjS7Wl/qrazwATxQRTfrV1w=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jfycG77haFoYN5yoSVAqqBHrmhEp2ZJ+3esfJ+n5IwVbwFHaV7CkRlfdN2y9O+2Oc
         4SgoCA4qHNutVXfQWHb8SjPciy8ntAG3F8DoBqAJR0TtJCUksSJvzshhmLz2o0JqOG
         2nU0kJyv3fuB2KS9WHVM1S6UbhCKupgLIEEm3arbgcl+UquNycxgm2KgeDRh+YZ4ni
         fUKc56UYwY1SHYv6rEJA6QRAXc9/Z9hocDEHmHgRlUaioaTmHUrJOR/oY487TrgXyF
         4H94PugM/UTRdnKvyJO2vPRldqxaIeqtSCZMazPJ2sRl7FAhi7eqxv/czbQCTEeUPV
         UPyDOj8lnzpDw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 712CAF03944;
        Fri, 27 May 2022 04:48:33 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] netfilter: nf_tables: disallow non-stateful
 expression in sets earlier
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165362691345.5864.18094210067248775753.git-patchwork-notify@kernel.org>
Date:   Fri, 27 May 2022 04:48:33 +0000
References: <20220526205411.315136-2-pablo@netfilter.org>
In-Reply-To: <20220526205411.315136-2-pablo@netfilter.org>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to bpf/bpf.git (master)
by Pablo Neira Ayuso <pablo@netfilter.org>:

On Thu, 26 May 2022 22:54:10 +0200 you wrote:
> Since 3e135cd499bf ("netfilter: nft_dynset: dynamic stateful expression
> instantiation"), it is possible to attach stateful expressions to set
> elements.
> 
> cd5125d8f518 ("netfilter: nf_tables: split set destruction in deactivate
> and destroy phase") introduces conditional destruction on the object to
> accomodate transaction semantics.
> 
> [...]

Here is the summary with links:
  - [net,1/2] netfilter: nf_tables: disallow non-stateful expression in sets earlier
    https://git.kernel.org/bpf/bpf/c/520778042ccc
  - [net,2/2] netfilter: nft_limit: Clone packet limits' cost value
    https://git.kernel.org/bpf/bpf/c/558254b0b602

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


