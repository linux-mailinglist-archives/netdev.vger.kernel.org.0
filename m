Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9F24A613247
	for <lists+netdev@lfdr.de>; Mon, 31 Oct 2022 10:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230157AbiJaJKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 05:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230144AbiJaJKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 05:10:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C2401DE99
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 02:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0B3296104E
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 09:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66014C43143;
        Mon, 31 Oct 2022 09:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667207417;
        bh=yZdg+oIV67ryx6EyCMns1Pg6vaV24zvD1ubqztKoubk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MSMnMfnHOf/91SmmblAuieUfNElU8Ymq/wJJxdkbKM74twDQ6qrypZHQ0gfe9agxm
         SskHbhcygOBOPn/Por+MLIyCn+5r6Lewm+bMliZ1xUGZUWArz/pCXbNG/jBG/ut8Mm
         u6bszBZb9t73U/d6uXeunLVDxTmBAs5yM66MdXGz/bmik+ABomqYDkeCPF5IOsoOqa
         2UqqiR9kg6YZj2T+5ltLMG3tFok/mM27x/lgcDq6kxQ2q/VdHWsemN2Bm6E853IptN
         0DfdSaIODt0Cz3EiW0RQ7pZewmhBjIrZo4QMSYgQIXJGVPUJfR7jicl3dY3MoP7Zs6
         423vGk25d/KAA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4BD56E5250E;
        Mon, 31 Oct 2022 09:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net: remove unusged netdev_unregistering()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166720741730.7426.13684154383447575553.git-patchwork-notify@kernel.org>
Date:   Mon, 31 Oct 2022 09:10:17 +0000
References: <20221027160424.3489-1-claudiajkang@gmail.com>
In-Reply-To: <20221027160424.3489-1-claudiajkang@gmail.com>
To:     Juhee Kang <claudiajkang@gmail.com>
Cc:     netdev@vger.kernel.org, simon.horman@corigine.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        pablo@netfilter.org, skhan@linuxfoundation.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 28 Oct 2022 01:04:24 +0900 you wrote:
> Currently, use dev->reg_state == NETREG_UNREGISTERING to check the status
> which is NETREG_UNREGISTERING, rather than using netdev_unregistering.
> Also, A helper function which is netdev_unregistering on nedevice.h is no
> longer used. Thus, netdev_unregistering removes from netdevice.h.
> 
> Signed-off-by: Juhee Kang <claudiajkang@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: remove unusged netdev_unregistering()
    https://git.kernel.org/netdev/net-next/c/f3fb589aeb88

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


