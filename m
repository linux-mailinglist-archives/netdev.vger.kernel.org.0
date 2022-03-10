Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B01B64D403F
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 05:20:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239466AbiCJEVT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 23:21:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42086 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239452AbiCJEVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 23:21:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3CDB111863B
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 20:20:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DCBACB824B0
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 04:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6A7C1C340F3;
        Thu, 10 Mar 2022 04:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646886011;
        bh=ZOfTd+dafK0jxfIJvuZj+EfMXd+QT2DxZdDwMv9Rvng=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=W68Wv7n434LfHlbcijp2zKtE6m2dh6etDs5rz04/K9MuJu2xMgpKxePrOwQlUDZI0
         Gk6cTVHQiZgyD28+XsjRe8idEXZYv2RZXwyCv/AoEr/69dDOpnyJ+iAbJSSFhwsPWe
         YtjpnhfhPbpe9iUskVf8b3mNs8I+F0wcWOu6tFGmIvnzYXE9SPTjZxmUoE9sLjL06m
         H1CXSCWR9MYjGgqCyzALmeNLfHHQS2+SpJsTZnrY6+ZeOPUd/fURfu2YcvEBLOx4uc
         CVGLM/CrpanY94ZIdFhrBjWB9/P2HWOUmmRfUNFnp/yY9Ge+WJ8owpTVH8zf1/kPii
         Xnl0dOKDSwPAw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 538E6EAC095;
        Thu, 10 Mar 2022 04:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] tcp: autocork: take MSG_EOR hint into consideration
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164688601133.11305.8201229477488708260.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 04:20:11 +0000
References: <20220309054706.2857266-1-eric.dumazet@gmail.com>
In-Reply-To: <20220309054706.2857266-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, kafai@fb.com, soheil@google.com,
        willemb@google.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  8 Mar 2022 21:47:06 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> tcp_should_autocork() is evaluating if it makes senses
> to not immediately send current skb, hoping that
> user space will add more payload on it by the
> time TCP stack reacts to upcoming TX completions.
> 
> [...]

Here is the summary with links:
  - [net-next] tcp: autocork: take MSG_EOR hint into consideration
    https://git.kernel.org/netdev/net-next/c/b0de0cf4f57c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


