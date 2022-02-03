Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A662D4A85D7
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 15:10:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351020AbiBCOKN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Feb 2022 09:10:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1350989AbiBCOKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Feb 2022 09:10:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7A0DFC061714
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 06:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 710E4618F6
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 14:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CE921C340EF;
        Thu,  3 Feb 2022 14:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643897410;
        bh=x2pqfSpR/RFDWvWNxGuUbKFBLNA90DrjZ67DORkbZwI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KnPyawqWuQXHZLwNLIbO0fx/D7vcHQf7zTij7X9USX42nmRTHaTDQqriAH7/KDibI
         fvlfrEWtoUNDEZL5hk8kXnAtzhX800wNrHpGzpZMhv4dsQGLt15ba11cBOH5ftUptb
         8EY9t9JMQiFhvg4892bd8TMbL4ZYKwv8jx/LzSmdmY+PcWZO4Le+LLSerBTG+dhkkK
         lh0VLpHBHAbGJa86LJYbglCZ/+3NMa94xS48TQlAxUluUx4TAr/1gGeVfMkCVW5p4O
         Ude8Mfpk+Dbq8XiGJOd6+Yhs1+ibW35uUNjMVVJ/yU/QCsnkuQb0drYeMctTSMGRO+
         eVrsF4H4xlOKg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BA2EBE5D08C;
        Thu,  3 Feb 2022 14:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 net-next 0/4] Virtual PTP clock improvements and fix
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164389741075.16432.16408317798392465843.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Feb 2022 14:10:10 +0000
References: <20220202093358.1341391-1-mlichvar@redhat.com>
In-Reply-To: <20220202093358.1341391-1-mlichvar@redhat.com>
To:     Miroslav Lichvar <mlichvar@redhat.com>
Cc:     netdev@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  2 Feb 2022 10:33:54 +0100 you wrote:
> v2:
> - dropped patch changing initial time of virtual clocks
> 
> The first patch fixes an oops when unloading a driver with PTP clock and
> enabled virtual clocks.
> 
> The other patches add missing features to make synchronization with
> virtual clocks work as well as with the physical clock.
> 
> [...]

Here is the summary with links:
  - [PATCHv2,net-next,1/4] ptp: unregister virtual clocks when unregistering physical clock.
    https://git.kernel.org/netdev/net-next/c/bfcbb76b0f59
  - [PATCHv2,net-next,2/4] ptp: increase maximum adjustment of virtual clocks.
    https://git.kernel.org/netdev/net-next/c/f77222d693cc
  - [PATCHv2,net-next,3/4] ptp: add gettimex64() to virtual clocks.
    https://git.kernel.org/netdev/net-next/c/f0067ebfc42b
  - [PATCHv2,net-next,4/4] ptp: add getcrosststamp() to virtual clocks.
    https://git.kernel.org/netdev/net-next/c/21fad63084c2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


