Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 068BA5BD97D
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 03:40:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229979AbiITBkb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 21:40:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229939AbiITBkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 21:40:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1627F4333E;
        Mon, 19 Sep 2022 18:40:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id BD19DB8235A;
        Tue, 20 Sep 2022 01:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4AD67C43142;
        Tue, 20 Sep 2022 01:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663638017;
        bh=wxW2VaB0RQw3crVBM5ii2aGabktBzIL2NWxewOBsPOY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TJ0uwLRqKE6pOb/2skjx4dYagfBYRcMZ4Vd9rePWYqP17eNMJgnQguKJukgyeSNuU
         xx4/R2DtWvSyGYarWJFhNUoemYUyvcZbUl+NGp7oFkTX2jEjS/tpe6NibOompzQwmk
         SbFnCT6kuRLHCezcMw8lyyHVzs79FD/9a8a9uNRIpSGw2thbosmlgZ8eBMHB2aJ7Kx
         CJ2489uvgaX4sOufAoFckTyTNdH9Jkk39gTdL3kMpoeKjcn1ZbFvoCOjlhGjNwyM+d
         QJKoYIKaAVs8hUlYMOAFb3Ow4wLYDODtk/UYTIfYTQy1U+FQ+/tslimxytCBxhQPLp
         dIFrOy1KSS70A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 31DDBE52538;
        Tue, 20 Sep 2022 01:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] openvswitch: Change the return type for vport_ops.send
 function hook to int
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166363801718.6857.9735991331516869091.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 01:40:17 +0000
References: <20220913230739.228313-1-nhuck@google.com>
In-Reply-To: <20220913230739.228313-1-nhuck@google.com>
To:     Nathan Huckleberry <nhuck@google.com>
Cc:     error27@gmail.com, llvm@lists.linux.dev, pshelar@ovn.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, nathan@kernel.org, ndesaulniers@google.com,
        trix@redhat.com, netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 13 Sep 2022 16:07:38 -0700 you wrote:
> All usages of the vport_ops struct have the .send field set to
> dev_queue_xmit or internal_dev_recv.  Since most usages are set to
> dev_queue_xmit, the function hook should match the signature of
> dev_queue_xmit.
> 
> The only call to vport_ops->send() is in net/openvswitch/vport.c and it
> throws away the return value.
> 
> [...]

Here is the summary with links:
  - openvswitch: Change the return type for vport_ops.send function hook to int
    https://git.kernel.org/netdev/net-next/c/8bb7c4f8c927

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


