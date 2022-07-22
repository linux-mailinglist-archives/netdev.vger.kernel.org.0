Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2EFF057E0E7
	for <lists+netdev@lfdr.de>; Fri, 22 Jul 2022 13:40:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233608AbiGVLkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Jul 2022 07:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39356 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231975AbiGVLkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Jul 2022 07:40:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E00FB12AE2;
        Fri, 22 Jul 2022 04:40:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 42887B82826;
        Fri, 22 Jul 2022 11:40:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B3B4DC341CB;
        Fri, 22 Jul 2022 11:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658490013;
        bh=FyaVIacDns7u0w7NfmF1dTQPf29rkwCwbbFsDaA2nFY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OpHaIM5/bnEf3cMl36I/luWlOd7kJnRGifnVXZYVZJgpv6oPeEu1mUDNm66uJEguT
         hDVSjaSbplba6BkhXrSh3PedL/UShRQLLZtivKPL9KCW4qnWIOaSJZK53Ru8e9rAbO
         mwIg//tdByxIU64QZrAaPevu73+dIYosg3v3tP+IcsUF9tcp03OsDE4Jm1OtlYIRJK
         pNTmyiv/okyhxuOZVv4lcVq9dZwq3FMhzYSVwnVPY3dXsMF8plebRvGdQp1GnRMjcN
         bKDt2ZVd83Jou1/gOwOKGdd8p3Nf5zXYorTweXUDfdoxgbV/Nhpw30ZflrjYOtb7c0
         t+slX849DZp9A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 98942E451BC;
        Fri, 22 Jul 2022 11:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] dt-bindings: net: ethernet-controller: Rework 'fixed-link'
 schema
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165849001362.931.15978104001255172124.git-patchwork-notify@kernel.org>
Date:   Fri, 22 Jul 2022 11:40:13 +0000
References: <20220719215100.1876577-1-robh@kernel.org>
In-Reply-To: <20220719215100.1876577-1-robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, krzysztof.kozlowski+dt@linaro.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Tue, 19 Jul 2022 15:50:59 -0600 you wrote:
> While the if/then schemas mostly work, there's a few issues. The 'allOf'
> schema will also be true if 'fixed-link' is not an array or object as a
> false 'if' schema (without an 'else') will be true. In the array case
> doesn't set the type (uint32-array) in the 'then' clause. In the node case,
> 'additionalProperties' is missing.
> 
> Rework the schema to use oneOf with each possible type.
> 
> [...]

Here is the summary with links:
  - dt-bindings: net: ethernet-controller: Rework 'fixed-link' schema
    https://git.kernel.org/netdev/net/c/17161c341de0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


