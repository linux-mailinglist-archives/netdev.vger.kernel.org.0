Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 38A284F93A8
	for <lists+netdev@lfdr.de>; Fri,  8 Apr 2022 13:20:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233208AbiDHLWU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Apr 2022 07:22:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40320 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233157AbiDHLWS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 Apr 2022 07:22:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D5F27184B7F
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 04:20:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 72F1561FBC
        for <netdev@vger.kernel.org>; Fri,  8 Apr 2022 11:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 89A92C385B6;
        Fri,  8 Apr 2022 11:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649416813;
        bh=NssQF9oHwWSMjku55RYfPwu2JUacTPgnzmmZCk0ygAc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=gyglGrtieW+C0kL/pIcqpozqadzP7juK2YjAdbOr2bs1GlVYEI/qPUO715xW+splU
         2UcmhXDrmaC5Jx1+rIhbnO2F77dvpYqTWFJ0Ij9HZ66NTte5sJGmZ55RqyA+HN3ILJ
         auQbo6/XxcyFYLH/P16pMmWlRdB5HW3TcjSXzhdg0ZpD65aBypmOvuJtvpDI20rWIb
         r0YPUC5CcaZUEomOdRu+FGjmLkm7k59BpDvCt21hKjodLrmgQQehpOUPrmRBMZuGPS
         +Oq9sLRMgv7n2N8cCrxMn4tDlIQUYIjtzb05X5TVL9KfdFLLTdktLN4NWqPElvoJj8
         vsPnco5CKSJCQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5367EE8DD5D;
        Fri,  8 Apr 2022 11:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] veth: Ensure eth header is in skb's linear part
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164941681333.25766.15801905253850356223.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Apr 2022 11:20:13 +0000
References: <b09b089827f128f65e9974c1dccdbbd06591f59a.1649254421.git.gnault@redhat.com>
In-Reply-To: <b09b089827f128f65e9974c1dccdbbd06591f59a.1649254421.git.gnault@redhat.com>
To:     Guillaume Nault <gnault@redhat.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, xemul@openvz.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Wed, 6 Apr 2022 16:18:54 +0200 you wrote:
> After feeding a decapsulated packet to a veth device with act_mirred,
> skb_headlen() may be 0. But veth_xmit() calls __dev_forward_skb(),
> which expects at least ETH_HLEN byte of linear data (as
> __dev_forward_skb2() calls eth_type_trans(), which pulls ETH_HLEN bytes
> unconditionally).
> 
> Use pskb_may_pull() to ensure veth_xmit() respects this constraint.
> 
> [...]

Here is the summary with links:
  - [net] veth: Ensure eth header is in skb's linear part
    https://git.kernel.org/netdev/net/c/726e2c5929de

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


