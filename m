Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E34AF631C3B
	for <lists+netdev@lfdr.de>; Mon, 21 Nov 2022 10:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229973AbiKUJAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Nov 2022 04:00:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50512 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229968AbiKUJAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Nov 2022 04:00:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 048C019C05
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 01:00:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 91DBB60F6D
        for <netdev@vger.kernel.org>; Mon, 21 Nov 2022 09:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E6603C43470;
        Mon, 21 Nov 2022 09:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669021217;
        bh=1CeqnEykMfRulD+FH2fFJxcsoD356Avs8pwtKpBUaeU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TUFs+sWJ1a72X98FM/3slto2gXbCDk3Bc9CmC9uV98dlWcp3j+v/p7lW6cZ7pu3/E
         4t1AKRvaFzMHkRAmQ3yJORcG/JjBXqHT8Nvhcfe1BP1UMdb6wy5xNvwAUmX1QYOO/f
         /pU9mVsoWqEUtIHAKBhmvnEEvJjkfWq4NMLLBZoXOdwh5lJhgqSMh7CKif2o4NsvNL
         zJCSbLtzm9ISoxKruUw7l02jdgYS5vP2gPedkeBh6mBumvg7yWqLmlbbbNEf9HLeqP
         7nKc/r/1gyXYlp4RRpODgxsxtVsvVoyaJZzVEBkhjryxJkSpa05F86fYZVVMUpI2S0
         5VBpHKLTjP1hw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D2AA3C395FF;
        Mon, 21 Nov 2022 09:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4 0/3] nfp: IPsec offload support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166902121685.26857.7983343247206670415.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Nov 2022 09:00:16 +0000
References: <20221117132102.678708-1-simon.horman@corigine.com>
In-Reply-To: <20221117132102.678708-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        leon@kernel.org, chengtian.liu@corigine.com,
        huanhuan.wang@corigine.com, yinjun.zhang@corigine.com,
        louis.peens@corigine.com, netdev@vger.kernel.org,
        oss-drivers@corigine.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 17 Nov 2022 14:20:59 +0100 you wrote:
> Huanhuan Wang says:
> 
> this series adds support for IPsec offload to the NFP driver.
> 
> It covers three enhancements:
> 
> 1. Patches 1/3:
>    - Extend the capability word and control word to to support
>      new features.
> 
> [...]

Here is the summary with links:
  - [net-next,v4,1/3] nfp: extend capability and control words
    https://git.kernel.org/netdev/net-next/c/484963ce9f1e
  - [net-next,v4,2/3] nfp: add framework to support ipsec offloading
    https://git.kernel.org/netdev/net-next/c/57f273adbcd4
  - [net-next,v4,3/3] nfp: implement xfrm callbacks and expose ipsec offload feature to upper layer
    https://git.kernel.org/netdev/net-next/c/859a497fe80c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


