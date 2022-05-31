Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E1AA2538D95
	for <lists+netdev@lfdr.de>; Tue, 31 May 2022 11:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240074AbiEaJU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 May 2022 05:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245141AbiEaJUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 May 2022 05:20:17 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E2FC462A12
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 02:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 5351BCE1300
        for <netdev@vger.kernel.org>; Tue, 31 May 2022 09:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8A7A5C34119;
        Tue, 31 May 2022 09:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653988812;
        bh=j+0A8U+99IRQDrJJhpHVse+Mcy2wHa+hRkOS7SWaf74=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=anR6lXiXBcKnLnCqb0nNgtWrgjxnPVwfu7aBKR5Jl6EzvQ1gh/2NVs8bJZMt6Bp2A
         sc6eARdG09JkBOkgSCxApqHvf955gAgv2LhzyKu+Ndc1KCTQX1anMiOims5svIpO+f
         IQQFgnWYzoKFMDPfhIw4uV2tNBb3sVkT1VJETpm1TQoNaU3g1Y5j5w2kfkUR5UlQHi
         m1eBVFLT+ymNVESEdvDim157H+kSFcLQMHyVLfIUjT45lL20fxTWm6ClCZjszRivoH
         bv0r/wYzsDhwjCOKrofdqnrYpQZ5k1NgaYozQN1WQp8GnsyzH1uzgDmeeA+LYLi4iV
         SIKW6e+nPH5Xg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 691EBF0394E;
        Tue, 31 May 2022 09:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 net] bonding: show NS IPv6 targets in proc master info
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165398881242.16269.6286099453685787139.git-patchwork-notify@kernel.org>
Date:   Tue, 31 May 2022 09:20:12 +0000
References: <20220530062639.37179-1-liuhangbin@gmail.com>
In-Reply-To: <20220530062639.37179-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, davem@davemloft.net, kuba@kernel.org,
        jtoppins@redhat.com, eric.dumazet@gmail.com, pabeni@redhat.com,
        liali@redhat.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 30 May 2022 14:26:39 +0800 you wrote:
> When adding bond new parameter ns_targets. I forgot to print this
> in bond master proc info. After updating, the bond master info will look
> like:
> 
> ARP IP target/s (n.n.n.n form): 192.168.1.254
> NS IPv6 target/s (XX::XX form): 2022::1, 2022::2
> 
> [...]

Here is the summary with links:
  - [PATCHv3,net] bonding: show NS IPv6 targets in proc master info
    https://git.kernel.org/netdev/net/c/4a1f14df55d1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


