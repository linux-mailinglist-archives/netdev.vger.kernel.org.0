Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C55334DC591
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 13:10:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233450AbiCQML2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 17 Mar 2022 08:11:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33056 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233380AbiCQML2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 17 Mar 2022 08:11:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0D5DB1A7763
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 05:10:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6489160BD4
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 12:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BF4CEC340ED;
        Thu, 17 Mar 2022 12:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647519010;
        bh=9GS0ROgyZQs8bT/fKKu6vWOiKYEGqgynNHgUBQg60aY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HKIxuyzMOdEz9TqbzGrwdkJIykib/oUaRG3LQ400Bsbl6+19su6jfdSRHWNLdSG9y
         wzFvXhJVMNQIwSlxYBZoy4veHSSMcFgyfUEuoJIjqL55sIRWJAibxVMJW0yG3at60z
         qaIQJSE/l9iMNNIx/s4HMflWXzzZGDktnOQCP94tlZQvbI3CslRTWvJw8kvXBpfmN8
         6zQzcb5P9x/5oILscHO/owcrUwBHqN+3Wa/mzO1Up54FBd9oU7d+GOKKfDRomRFFmh
         WVjQN9/wLRDW0fLnnH+IiCoOvhYe/Nxn/03l8h0RhEXZbHHvTIPwVFnEWK0woCrckj
         yt4owk+cTmp9g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A6761E6D3DD;
        Thu, 17 Mar 2022 12:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next,v3] net: geneve: support IPv4/IPv6 as inner protocol
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164751901067.7780.6193168284529969363.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 12:10:10 +0000
References: <20220316061557.431872-1-eyal.birger@gmail.com>
In-Reply-To: <20220316061557.431872-1-eyal.birger@gmail.com>
To:     Eyal Birger <eyal.birger@gmail.com>
Cc:     roopa@nvidia.com, davem@davemloft.net, kuba@kernel.org,
        shmulik.ladkani@gmail.com, netdev@vger.kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 16 Mar 2022 08:15:57 +0200 you wrote:
> This patch adds support for encapsulating IPv4/IPv6 within GENEVE.
> 
> In order to use this, a new IFLA_GENEVE_INNER_PROTO_INHERIT flag needs
> to be provided at device creation. This property cannot be changed for
> the time being.
> 
> In case IP traffic is received on a non-tun device the drop count is
> increased.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: geneve: support IPv4/IPv6 as inner protocol
    https://git.kernel.org/netdev/net-next/c/435fe1c0c1f7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


