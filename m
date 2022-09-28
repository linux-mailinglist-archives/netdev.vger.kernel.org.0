Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 815AB5ED37E
	for <lists+netdev@lfdr.de>; Wed, 28 Sep 2022 05:30:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231428AbiI1DaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Sep 2022 23:30:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231268AbiI1DaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Sep 2022 23:30:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2806B13D78
        for <netdev@vger.kernel.org>; Tue, 27 Sep 2022 20:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7E26B61D07
        for <netdev@vger.kernel.org>; Wed, 28 Sep 2022 03:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CD388C433D7;
        Wed, 28 Sep 2022 03:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664335815;
        bh=/CoIpuyJiQ+TYnD2XBi4K/R3CzI0vwpXdRtH1fQUZ0A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f5nUYDWcw37D9Kng3kF3IgE2AEsGk4Pa/Ppxt9c7D+bjeOaKFPPxbH3vSDaE9/HlT
         VObICTEQ/UcKMmOl3QRWdvxSMqBdCYTrIFr1Io3XBR1a2Mu1k6g5qW3IvJ/SoCgG5u
         z9cAWoDaguk4exulNeZBAmPAn3+0SFIzbC/Tig+UHaSUE+oO2E/AmWhFJYwU/muyE/
         RwFmewUB3WC/s4AiYradvYEzK3sKG1tAsXp7eG+2aepZxvc8F9/+AddnPAsrmcjBFL
         eYjLzKP9sYcl1lglBxjyFilIupiqvv3ktAGPC81Ab+Hz7XTUS8eUYbtxlvp2q6zwqa
         1PfPsZWTBTYiQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B1A83C04E59;
        Wed, 28 Sep 2022 03:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 1/2] libnetlink: add offset for
 nl_dump_ext_ack_done
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166433581572.10603.5778674738651623494.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Sep 2022 03:30:15 +0000
References: <20220927102107.191852-1-liuhangbin@gmail.com>
In-Reply-To: <20220927102107.191852-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, dsahern@kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Tue, 27 Sep 2022 18:21:06 +0800 you wrote:
> There is no rule to have an error code after NLMSG_DONE msg. The only reason
> we has this offset is that kernel function netlink_dump_done() has an error
> code followed by the netlink message header.
> 
> Making nl_dump_ext_ack_done() has an offset parameter. So we can adjust
> this for NLMSG_DONE message without error code.
> 
> [...]

Here is the summary with links:
  - [iproute2-next,1/2] libnetlink: add offset for nl_dump_ext_ack_done
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=80059fa5c5ed

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


