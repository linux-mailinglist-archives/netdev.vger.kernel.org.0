Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AB7CD59BFFE
	for <lists+netdev@lfdr.de>; Mon, 22 Aug 2022 15:01:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234652AbiHVNBD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Aug 2022 09:01:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234728AbiHVNAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Aug 2022 09:00:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 43D27356C9;
        Mon, 22 Aug 2022 06:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D4EAC6115A;
        Mon, 22 Aug 2022 13:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3EE7CC433B5;
        Mon, 22 Aug 2022 13:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661173218;
        bh=xD2RSwwmSrB52FGIT+LkzLr1KYbQvQbYqQr5bTN1XAs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MJ7yeid1bv+sqZ694YQkCGxvDpTcp8emjn2xpDmf2bZ1w0zxcyePNJzynTtbxpiOl
         9XxYfDZXobZ/DryoTjcMJH9QC8nypFAeJGu53ZptVctoo88meq9IT1g9AHfYW3TExI
         Ee8tA7cQOv3OLoQnSzZMwgr1j6GQSbbDE2wMebI4nJAqTT+M4wzSJKmuBhr5/abure
         SNbIq/Xg31DsGlyl+WDa6Z+078aD+EI0NSp6WazL/0dkMVO0yub3GuXKXWKZ76W4Nk
         z7mdRKKj5tYMPLHeAsZzTnnn1sJcuGF8/0+LsToII8MK7WO94Funz1YQ3b+GcWXS2m
         WY2Srw0P4cZCg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2999EC4166E;
        Mon, 22 Aug 2022 13:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 1/2] openvswitch: Fix double reporting of drops in
 dropwatch
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166117321816.20649.7576548542360425486.git-patchwork-notify@kernel.org>
Date:   Mon, 22 Aug 2022 13:00:18 +0000
References: <20220817150635.1725530-1-mkp@redhat.com>
In-Reply-To: <20220817150635.1725530-1-mkp@redhat.com>
To:     Mike Pattrick <mkp@redhat.com>
Cc:     netdev@vger.kernel.org, pshelar@ovn.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 17 Aug 2022 11:06:34 -0400 you wrote:
> Frames sent to userspace can be reported as dropped in
> ovs_dp_process_packet, however, if they are dropped in the netlink code
> then netlink_attachskb will report the same frame as dropped.
> 
> This patch checks for error codes which indicate that the frame has
> already been freed.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] openvswitch: Fix double reporting of drops in dropwatch
    https://git.kernel.org/netdev/net-next/c/1100248a5c5c
  - [net-next,v2,2/2] openvswitch: Fix overreporting of drops in dropwatch
    https://git.kernel.org/netdev/net-next/c/c21ab2afa2c6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


