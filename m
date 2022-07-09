Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E13B256C931
	for <lists+netdev@lfdr.de>; Sat,  9 Jul 2022 13:30:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229485AbiGILaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jul 2022 07:30:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbiGILaP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 9 Jul 2022 07:30:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8705C4E87B
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 04:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2318A60B07
        for <netdev@vger.kernel.org>; Sat,  9 Jul 2022 11:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C5A0C3411E;
        Sat,  9 Jul 2022 11:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657366212;
        bh=dHMMAkI0hbeJvvhLCtnBpFuFhrUkPB39iNVUMWvap/U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=A1UN9XKeTUxl406rrRJzIQAeWGIdo4vG9JR62ni12viJezYFYrcSDKF2Tl9PiNhi9
         c61LZcoYjLbpDJ5c5B91P2TxI8lmrJoMBrhv89Wr5djVGHxCGnUBVQUvKTCOr2/Bqp
         zvXm2GEUGfheqX+8ZlQ0wbdsQs/QrzuNrGTMDIA2Rf3nTNt5iuDib/97QgodIWU7r4
         Q1yRxE+o5tYZSXcAxx36e18J7qK5mjKA3XLpgiuOk60fi783ZYiEivc13sCh01f4tK
         x+TakRgTKMZGUuBMYiaP5KZXOm0fHG4EdOIDvZNWGZUYJUE+GAvOgfo4piFPftSiSq
         Huzm2JYigP42g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 64EF3E45BD8;
        Sat,  9 Jul 2022 11:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] vlan: fix memory leak in vlan_newlink()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165736621241.28880.10154380034505524860.git-patchwork-notify@kernel.org>
Date:   Sat, 09 Jul 2022 11:30:12 +0000
References: <20220708151153.1813012-1-edumazet@google.com>
In-Reply-To: <20220708151153.1813012-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzkaller@googlegroups.com, lucien.xin@gmail.com
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri,  8 Jul 2022 15:11:53 +0000 you wrote:
> Blamed commit added back a bug I fixed in commit 9bbd917e0bec
> ("vlan: fix memory leak in vlan_dev_set_egress_priority")
> 
> If a memory allocation fails in vlan_changelink() after other allocations
> succeeded, we need to call vlan_dev_free_egress_priority()
> to free all allocated memory because after a failed ->newlink()
> we do not call any methods like ndo_uninit() or dev->priv_destructor().
> 
> [...]

Here is the summary with links:
  - [net] vlan: fix memory leak in vlan_newlink()
    https://git.kernel.org/netdev/net/c/72a0b329114b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


