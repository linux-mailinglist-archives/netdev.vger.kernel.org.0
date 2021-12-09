Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3555146E0F9
	for <lists+netdev@lfdr.de>; Thu,  9 Dec 2021 03:40:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230344AbhLICnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Dec 2021 21:43:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40332 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbhLICnp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Dec 2021 21:43:45 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A70E5C061746;
        Wed,  8 Dec 2021 18:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 917EBCE24BB;
        Thu,  9 Dec 2021 02:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B591CC00446;
        Thu,  9 Dec 2021 02:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639017608;
        bh=F5gwZkpKQ0e3/OpRF6BpfUQQwwIuQH/TApGn7kHWp3E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jxoHB653VwuEV4TUAb6PGXXlWbGj7BJJ0IFFAEhKJY1i9usNSgd8MRlF7S9Jjn825
         dA/LrO8p+a2OOD99jGzD4A/2qaHVmRG620BZb58xWphPzwpjpcGbemWg+1DYNNhkY0
         RT4NHJbAhheBxAnaCcVGw0nyczId/ITW1W5CEqSQBgXOLIehb/u59zlES6CqZj/ZHM
         gd2iDOvrh0nUMnxLevCVFb2BWwD/Mh56zjQ8df6nh1JqiX8Aq2/yXOUS5upDUMbxql
         kOQA+j0/5rEcaVDeIWvcXRQ4PzXX7vbd6T+TO1YVTQvjSLxFMfvE86cMR0PA/ZxQOY
         xcR1jb7LWrsFQ==
Received: from pdx-korg-docbuild-2.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by pdx-korg-docbuild-2.ci.codeaurora.org (Postfix) with ESMTP id 8F99660A39;
        Thu,  9 Dec 2021 02:40:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v5 net 1/1] net: mvpp2: fix XDP rx queues registering
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <163901760858.2130.12295890768510315552.git-patchwork-notify@kernel.org>
Date:   Thu, 09 Dec 2021 02:40:08 +0000
References: <20211207143423.916334-1-louis.amas@eho.link>
In-Reply-To: <20211207143423.916334-1-louis.amas@eho.link>
To:     Louis Amas <louis.amas@eho.link>
Cc:     mw@semihalf.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        kpsingh@kernel.org, mcroce@microsoft.com,
        emmanuel.deloget@eho.link, brouer@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  7 Dec 2021 15:34:22 +0100 you wrote:
> The registration of XDP queue information is incorrect because the
> RX queue id we use is invalid. When port->id == 0 it appears to works
> as expected yet it's no longer the case when port->id != 0.
> 
> The problem arised while using a recent kernel version on the
> MACCHIATOBin. This board has several ports:
>  * eth0 and eth1 are 10Gbps interfaces ; both ports has port->id == 0;
>  * eth2 is a 1Gbps interface with port->id != 0.
> 
> [...]

Here is the summary with links:
  - [v5,net,1/1] net: mvpp2: fix XDP rx queues registering
    https://git.kernel.org/netdev/net/c/a50e659b2a1b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


