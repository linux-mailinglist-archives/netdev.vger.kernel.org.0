Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EF25659F039
	for <lists+netdev@lfdr.de>; Wed, 24 Aug 2022 02:30:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229923AbiHXAaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Aug 2022 20:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34380 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229775AbiHXAaS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Aug 2022 20:30:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D58F04A83A
        for <netdev@vger.kernel.org>; Tue, 23 Aug 2022 17:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0A48F6176B
        for <netdev@vger.kernel.org>; Wed, 24 Aug 2022 00:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5BF28C433D6;
        Wed, 24 Aug 2022 00:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661301015;
        bh=zZ0Y7Q0wMklrepPUnl+Ta8JB5Gm0f4WTXRN4Sx1C2us=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qW/HmY9c5/jRNSFtLstgigfDR+ALxOgqFGO8TUs8yQpU5vd4qLExnLXs8wGsjJt4c
         N2L2tLc0tBFOb5Hf6uZx8M0NxYWU60yiXKna2W4TWEq4prJT5beE77CMmaqfxc3SEa
         GTcxLqLsXeKqIp4mTofl3Mefuf85SSp1vepk1ckRE2IMmZkpDPFmymPHBKbhrAjM43
         RDVTanBG1hAEN1OqgWJ0txS7y4iRzqUH47HRLKxl9lrWNaVzAEI0P7k+nuxFhTN/Ut
         PMfJBuYCFSz0Fkke3HSBq0Hurp3UNvAtFotXAefIHWIW47+dEKRKMUkkqfyQ6z7oZf
         6rWpDX/QQRxTA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4130BE2A03B;
        Wed, 24 Aug 2022 00:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/2] net: improve and fix netlink kdoc
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166130101526.10626.11004140775322754493.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Aug 2022 00:30:15 +0000
References: <20220819200221.422801-1-kuba@kernel.org>
In-Reply-To: <20220819200221.422801-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 19 Aug 2022 13:02:20 -0700 you wrote:
> Subsequent patch will render the kdoc from
> include/uapi/linux/netlink.h into Documentation.
> We need to fix the warnings. While at it move
> the comments on struct nlmsghdr to a proper
> kdoc comment.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> 
> [...]

Here is the summary with links:
  - [v2,1/2] net: improve and fix netlink kdoc
    https://git.kernel.org/netdev/net-next/c/30b6055428a9
  - [v2,2/2] docs: netlink: basic introduction to Netlink
    https://git.kernel.org/netdev/net-next/c/510156a7f0cb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


