Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 71BC25868D8
	for <lists+netdev@lfdr.de>; Mon,  1 Aug 2022 13:54:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231926AbiHALxu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Aug 2022 07:53:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35038 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231564AbiHALxM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Aug 2022 07:53:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 290BB6326
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 04:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4E53A612EA
        for <netdev@vger.kernel.org>; Mon,  1 Aug 2022 11:50:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ACE91C433D7;
        Mon,  1 Aug 2022 11:50:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659354613;
        bh=A1Y1cyr7jtHiPgOgqBTPQ0yzBz7NKoFdjJOH9FDWlmc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ne8y6y4Rv9UYvNAh734FX0XN+LxNyVZVzZEdLYGdRNIvGwq7pvdAdB+A5kEyDm5+i
         1g3KxkUrBnZl9C5nM+HnIP8tbc8Qn1Hnl4n2y5YAcdOX5cAQPNAW4UmdR3TaTSH6a/
         9ZCC/cPO6otomoCX/ASw/f1fyBeCovAXnp31OGAgYwMydmFU/dLxV8+nxHZiMPuhdy
         rAUQGPIR61CcgyMoPnfil1neDFb9EVTReV+tlhFVpllHlj9A3+v4zUdbnNQvnETH2q
         NUhJN4TZISHOosmH96gXwcPXWf+e1Ad+umZTRAggfIE9hviwdmDhqkBcITMqjd9MAe
         w8GwF3rBHrjAA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9425BC43143;
        Mon,  1 Aug 2022 11:50:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/4] net/funeth: Tx support for XDP with frags
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165935461360.27629.16520429880209786838.git-patchwork-notify@kernel.org>
Date:   Mon, 01 Aug 2022 11:50:13 +0000
References: <20220729073257.2721-1-dmichail@fungible.com>
In-Reply-To: <20220729073257.2721-1-dmichail@fungible.com>
To:     Dimitris Michailidis <d.michailidis@fungible.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        lorenzo@kernel.org, hawk@kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 29 Jul 2022 00:32:53 -0700 you wrote:
> Support XDP with fragments for XDP_TX and ndo_xdp_xmit.
> 
> The first three patches rework existing code used by the skb path to
> make it suitable also for XDP. With these all the callees of the main
> Tx XDP function, fun_xdp_tx(), are fragment-capable. The last patch
> updates fun_xdp_tx() to handle fragments.
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] net/funeth: Unify skb/XDP Tx packet unmapping.
    https://git.kernel.org/netdev/net-next/c/16ead40812a0
  - [net-next,2/4] net/funeth: Unify skb/XDP gather list writing.
    https://git.kernel.org/netdev/net-next/c/a3b461bbd184
  - [net-next,3/4] net/funeth: Unify skb/XDP packet mapping.
    https://git.kernel.org/netdev/net-next/c/1c45b0cd6cf0
  - [net-next,4/4] net/funeth: Tx handling of XDP with fragments.
    https://git.kernel.org/netdev/net-next/c/8b684570eeaa

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


