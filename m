Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3F2B2575AD9
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 07:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229546AbiGOFUT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 01:20:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229457AbiGOFUS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 01:20:18 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9CE1796A3
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 22:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7263962265
        for <netdev@vger.kernel.org>; Fri, 15 Jul 2022 05:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C8A3EC385A5;
        Fri, 15 Jul 2022 05:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657862416;
        bh=jR0FdDcT1TWw8/YCthlOAM36FXfdbUwlrQSGQf2PxP4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=s3QUVcfyXNw2+jbcBHN+5kb7NpsIACDxkR/n1/XIw9qLb6EP6r7LwPI4bQrCICI9J
         vSua6QLf0DizUmpZX5mVjFbhWns1u0IjMe7xQhcG+BG3bCTOpla0L9lRRlY++cWXFZ
         1jscveLkwwYs5ZaLAHHuPumycO+VK7/0cjBWlZ8WPVDp23cSCRj/j81rdQ7nPUb4BE
         RtWKVW4Y2B3LmYP/G5mFuSvK3CrJKOmxo79HrHL1xCNHYfBYptrPjVd2IbdJyFz1TH
         ujYF7XuW3FyWEB0IxZWmkq4F7ViFywUfSGPtbLda5uvEMVlD/5Ra+W2iQ3rtIWCbjU
         jawYRetml7hUw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AF6A9E4521F;
        Fri, 15 Jul 2022 05:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [patch net-next repost 0/3] net: devlink: couple of trivial fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165786241671.22424.3665824739941899371.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Jul 2022 05:20:16 +0000
References: <20220713141853.2992014-1-jiri@resnulli.us>
In-Reply-To: <20220713141853.2992014-1-jiri@resnulli.us>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, mlxsw@nvidia.com,
        saeedm@nvidia.com, moshe@nvidia.com
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 13 Jul 2022 16:18:50 +0200 you wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Just a couple of trivial fixes I found on the way.
> 
> Jiri Pirko (3):
>   net: devlink: make devlink_dpipe_headers_register() return void
>   net: devlink: fix a typo in function name devlink_port_new_notifiy()
>   net: devlink: fix return statement in devlink_port_new_notify()
> 
> [...]

Here is the summary with links:
  - [net-next,repost,1/3] net: devlink: make devlink_dpipe_headers_register() return void
    https://git.kernel.org/netdev/net-next/c/9a7923668bc7
  - [net-next,repost,2/3] net: devlink: fix a typo in function name devlink_port_new_notifiy()
    https://git.kernel.org/netdev/net-next/c/ced92571af24
  - [net-next,repost,3/3] net: devlink: fix return statement in devlink_port_new_notify()
    https://git.kernel.org/netdev/net-next/c/a44c4511ffb2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


