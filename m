Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4D0834D5990
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 05:31:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346288AbiCKEbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 23:31:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55608 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1346275AbiCKEbR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 23:31:17 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EAB001A58F6
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 20:30:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A88C5B82A74
        for <netdev@vger.kernel.org>; Fri, 11 Mar 2022 04:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 47316C340F4;
        Fri, 11 Mar 2022 04:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646973013;
        bh=GgwXEfWFHW1903LfqimrzaGI/cogjqdqjaPQDfYjdpo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pfnmUxkh78dmKMwdn/28z11LXz+MIe06MyX8YgpPFvAZhdVl/QCrOowOFnjzeD0xG
         eY8gHG3j+znGpOi0QsAVr81t3Xi5q2en04hko5C2gjD4lA8JWyyqryKcFU3hiKXJyl
         1Hk28HngJV/ZmAyZ/mbVwrDESdfsvnMhs+M6hIWzKFePI2nSyN4JalQ9f9fYkoLYKL
         6gdUKxrvG0HFBG9nnjEvj3J8cdQREloXog0gzWM0tXdbOfLM9qpyCov1bap+oeahKB
         Dez3idbChk2kU9vR+hJm2xTrWCrx5b1nlUncizSn5XeYufc0NNsMT3PauAf/Mm84Sw
         vCwVeMkNkpmGQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2A4F1F03843;
        Fri, 11 Mar 2022 04:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2] net: control the length of the altname list
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164697301316.12732.15946977817982589075.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Mar 2022 04:30:13 +0000
References: <20220309182914.423834-1-kuba@kernel.org>
In-Reply-To: <20220309182914.423834-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, dsahern@gmail.com,
        jiri@resnulli.us
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

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  9 Mar 2022 10:29:12 -0800 you wrote:
> Count the memory used for altnames and don't let user
> overflow the property nlattr. This was reported by George:
> https://lore.kernel.org/all/3e564baf-a1dd-122e-2882-ff143f7eb578@gmail.com/
> 
> Targeting net-next because I think we generally don't consider
> tightening "root controlled" memory accounting to be a fix.
> There's also some risk of breakage.
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] net: account alternate interface name memory
    https://git.kernel.org/netdev/net-next/c/5d26cff5bdbe
  - [net-next,2/2] net: limit altnames to 64k total
    https://git.kernel.org/netdev/net-next/c/155fb43b70b5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


