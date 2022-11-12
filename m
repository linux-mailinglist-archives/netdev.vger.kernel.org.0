Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BED562670A
	for <lists+netdev@lfdr.de>; Sat, 12 Nov 2022 05:50:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233563AbiKLEuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Nov 2022 23:50:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52396 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232943AbiKLEuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Nov 2022 23:50:23 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C81B5DB8;
        Fri, 11 Nov 2022 20:50:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 610EF609FA;
        Sat, 12 Nov 2022 04:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB771C433D7;
        Sat, 12 Nov 2022 04:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668228621;
        bh=l4AT+oslbEXAcHs2cSywHoF/9T7DsjOJ2eU5FzrcU2U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=U4N0M6gd3S3O8i+hthTD/YEP5k53K2NJECNqmaU4Guv7yiy7Mq4RbfQ8k4ORbGx4m
         WI2CfBfV1583MLpRdaos6HtQWM1tqx9MdcXe9DMVnP5ApCDyA0cvaqXlGjx/oMHIob
         MQuidKqi8NvKR33hHV0mkyfxOpPfnTfK+Qk9w5S7J1Dw/AJT8+C/azbnAVcsmWfA2F
         MtzGLYJ5uW3XZ5sYwtAVetTQrwntG/JGZ5ylL9mYPyEWPhDY3y6ytC+g5P0QgqS/c/
         h7a6u/kXhg72uzs4DmpiESV27aiVvHeXQJ+sqRA9GFmNih7XQTnVBMdIbB2Hjc/bDI
         uFEZUFl7iWQZQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8E363E270EF;
        Sat, 12 Nov 2022 04:50:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: vlan: claim one bit from sk_buff
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166822862157.12539.11699913480152181206.git-patchwork-notify@kernel.org>
Date:   Sat, 12 Nov 2022 04:50:21 +0000
References: <20221109095759.1874969-1-edumazet@google.com>
In-Reply-To: <20221109095759.1874969-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        daniel@iogearbox.net, ast@kernel.org, andrii@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org, eric.dumazet@gmail.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  9 Nov 2022 09:57:57 +0000 you wrote:
> First patch claims skb->vlan_present.
> This means some bpf changes, eg for sparc32 that I could not test.
> 
> Second patch removes one conditional test in gro_list_prepare().
> 
> Eric Dumazet (2):
>   net: remove skb->vlan_present
>   net: gro: no longer use skb_vlan_tag_present()
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: remove skb->vlan_present
    https://git.kernel.org/netdev/net-next/c/354259fa73e2
  - [net-next,2/2] net: gro: no longer use skb_vlan_tag_present()
    https://git.kernel.org/netdev/net-next/c/be3ed48683f0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


