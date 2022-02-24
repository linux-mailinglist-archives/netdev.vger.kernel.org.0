Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46F734C333F
	for <lists+netdev@lfdr.de>; Thu, 24 Feb 2022 18:11:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229832AbiBXRKm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Feb 2022 12:10:42 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbiBXRKl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Feb 2022 12:10:41 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 395321F83FF;
        Thu, 24 Feb 2022 09:10:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB29761B80;
        Thu, 24 Feb 2022 17:10:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 2ACD8C340F0;
        Thu, 24 Feb 2022 17:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645722610;
        bh=rGTcIsyPfUg5jarnpPAC5c1oD8wbki17rcNUhK+rn+A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=q/k7zPwArBHqe8/t+oyHeDXRSwRligPTjz43URI2HteAX66Lhn8sn2Yflw7v+9GIw
         rd/KJNZWLi0Zwo9dH5sMGGo9QzxwssloFXHU7zL+lmW7ftHNEftNVIW2Ap1/xfcIq4
         Z4Mw8XH7VNSoCUDI43BrvCrFSLAu5U7F+VHs2GKBOK8+V8T2/VntTwrP8PBJffKP0M
         kF+Nj4f1quM4mfg9ewfVR1uVotEiX0R60OhpCmlCYoDskzM6CmfoAsobRutHr2Ol45
         6lDEHtu6dWkxhDemDOZVn9SPzYAGaeCJOPmqfI3i3erpXATf/u7cGY9gDWfIAaRMBg
         5eOoPUNZaMbqw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0F611EAC09B;
        Thu, 24 Feb 2022 17:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 1/2] Revert "xen-netback: remove 'hotplug-status' once it
 has served its purpose"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164572261005.890.15777493366001996059.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Feb 2022 17:10:10 +0000
References: <20220222001817.2264967-1-marmarek@invisiblethingslab.com>
In-Reply-To: <20220222001817.2264967-1-marmarek@invisiblethingslab.com>
To:     =?utf-8?q?Marek_Marczykowski-G=C3=B3recki_=3Cmarmarek=40invisiblethingslab?=@ci.codeaurora.org,
        =?utf-8?q?=2Ecom=3E?=@ci.codeaurora.org
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        mcb30@ipxe.org, wei.liu@kernel.org, paul@xen.org,
        davem@davemloft.net, kuba@kernel.org,
        xen-devel@lists.xenproject.org, netdev@vger.kernel.org
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 22 Feb 2022 01:18:16 +0100 you wrote:
> This reverts commit 1f2565780e9b7218cf92c7630130e82dcc0fe9c2.
> 
> The 'hotplug-status' node should not be removed as long as the vif
> device remains configured. Otherwise the xen-netback would wait for
> re-running the network script even if it was already called (in case of
> the frontent re-connecting). But also, it _should_ be removed when the
> vif device is destroyed (for example when unbinding the driver) -
> otherwise hotplug script would not configure the device whenever it
> re-appear.
> 
> [...]

Here is the summary with links:
  - [v2,1/2] Revert "xen-netback: remove 'hotplug-status' once it has served its purpose"
    https://git.kernel.org/netdev/net/c/0f4558ae9187
  - [v2,2/2] Revert "xen-netback: Check for hotplug-status existence before watching"
    https://git.kernel.org/netdev/net/c/e8240addd0a3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


