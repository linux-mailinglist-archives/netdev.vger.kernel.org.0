Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C599C661FDD
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 09:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236369AbjAIIUY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 03:20:24 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234347AbjAIIUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 03:20:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C289D129;
        Mon,  9 Jan 2023 00:20:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1928760F4D;
        Mon,  9 Jan 2023 08:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 78B22C433F0;
        Mon,  9 Jan 2023 08:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673252415;
        bh=WjM5c5Qkz5PNPCw90hvWIsXac1KXRmB80m7zwOTNdL0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kz3p/n4R52Slfv7u9GyKqJ4ymtt2m4zMzjovAagpt+nfoiDGkz+jII5Q0f3A4T4Rv
         OACMg8/p6QwSveeQTk7WUyB/lKC7sS+weHcLy3aE6JpNos9cOyqdH0o7JNsRDzvM7t
         B+3ptBqfFBGQXnyOCvbt510GWfHI2ENAQVS+DQCXqlSwsdff310ihGGv5jffC/2ciM
         HTlAVqJtIaeryZC/utgdmBHdHp4HRtXNoHCZaEmCHSmHuiGgyeZTny0MmMvLeq5SfK
         Z756ThDXsG08E7NequMtYMVfy2ytWG7wLoHfkemRGvKyeRt1yk3NHu0Texbr2ozl1g
         xzaJ9P44rohlg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5BB35C395DF;
        Mon,  9 Jan 2023 08:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: lan966x: Allow to add rules in TCAM even if not enabled
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167325241537.15932.6248175238662011957.git-patchwork-notify@kernel.org>
Date:   Mon, 09 Jan 2023 08:20:15 +0000
References: <20230106201507.2206113-1-horatiu.vultur@microchip.com>
In-Reply-To: <20230106201507.2206113-1-horatiu.vultur@microchip.com>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, UNGLinuxDriver@microchip.com, michael@walle.cc,
        steen.hegelund@microchip.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 6 Jan 2023 21:15:07 +0100 you wrote:
> The blamed commit implemented the vcap_operations to allow to add an
> entry in the TCAM. One of the callbacks is to validate the supported
> keysets. If the TCAM lookup was not enabled, then this will return
> failure so no entries could be added.
> This doesn't make much sense, as you can enable at a later point the
> TCAM. Therefore change it such to allow entries in TCAM even it is not
> enabled.
> 
> [...]

Here is the summary with links:
  - net: lan966x: Allow to add rules in TCAM even if not enabled
    https://git.kernel.org/netdev/net/c/76761babaa98

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


