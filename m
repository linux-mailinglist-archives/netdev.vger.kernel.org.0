Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E65D86D1795
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 08:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230124AbjCaGks (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 31 Mar 2023 02:40:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229925AbjCaGkr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 31 Mar 2023 02:40:47 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60DB1191E2
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 23:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2D96623AF
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 06:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5E857C433D2;
        Fri, 31 Mar 2023 06:40:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680244819;
        bh=nhIE0opza93RN19T71/bfQYKInHoe+JovfAPFBcxwXg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d13JnbEy3w/swc13MkriuIVFKhmZFG2vdBcYq+lnOHI9x4tDwekuIwlECow3IEK66
         KyOUVMarWMrByxVOmR/L6KT6/ouJ59yQ8E2tIbyuilKfgBO+UWnXxogWzEIW8IR7T3
         guS4NVWeL7BmLu8KwP3l/Fc6HF9u6fjD7faizaLe88HuqdPCYDA1DpJirHTK/HwWOc
         V0aRXtVju6i9PqwC3bFg1teN6jOL4VExeHzKv0qrfp5loG3sEsZSdMOu5EMHDaUwBH
         N/i33qIcKTveaywqz7IxEJPCuEhF08JfM0Kpliv/oIVxPt0r6kFbsLvBEIQd1QUWXT
         KlkfZICGRaZKA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 472F4C395C3;
        Fri, 31 Mar 2023 06:40:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/4] tools: ynl: fill in some gaps of ethtool spec
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168024481928.5026.14285386257176451722.git-patchwork-notify@kernel.org>
Date:   Fri, 31 Mar 2023 06:40:19 +0000
References: <20230329221655.708489-1-sdf@google.com>
In-Reply-To: <20230329221655.708489-1-sdf@google.com>
To:     Stanislav Fomichev <sdf@google.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Mar 2023 15:16:51 -0700 you wrote:
> I was trying to fill in the spec while exploring ethtool API for some
> related work. I don't think I'll have the patience to fill in the rest,
> so decided to share whatever I currently have.
> 
> Patches 1-2 add the be16 + spec.
> Patches 3-4 implement an ethtool-like python tool to test the spec.
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/4] tools: ynl: support byte-order in cli
    https://git.kernel.org/netdev/net-next/c/9f7cc57fe550
  - [net-next,v3,2/4] tools: ynl: populate most of the ethtool spec
    https://git.kernel.org/netdev/net-next/c/a353318ebf24
  - [net-next,v3,3/4] tools: ynl: replace print with NlError
    https://git.kernel.org/netdev/net-next/c/48993e22d23a
  - [net-next,v3,4/4] tools: ynl: ethtool testing tool
    https://git.kernel.org/netdev/net-next/c/f3d07b02b2b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


