Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 018244A7CF9
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 01:40:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348632AbiBCAkK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 19:40:10 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:53742 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348637AbiBCAkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 19:40:10 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C2D7360FA9
        for <netdev@vger.kernel.org>; Thu,  3 Feb 2022 00:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 31AA3C36AE5;
        Thu,  3 Feb 2022 00:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643848809;
        bh=AbZTleag249K3jwEdDt76ozYztnRsBnEKvBQ3YyojwM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=M3xKG/K3G8Y1WsoS81y3vxgwnv3jU8Qd1NW5xLRR6j2nZjlgCq/h7xnXmw6dGq0un
         NdXPTfXoNKGBcvFJ5fU57hF6JVuVECq2FDtxEH/rPs1hTRsVAYE+/bO1GBC2A/9n6n
         dtWSYODx8mwfBgy17l+9rD+NPqg6+ptH1nIt1PuwFvDGFgHCR1Q6/Si7NkGw5W8cHB
         JWD2pTICRSBgd645qmHxMU1zmPAyxaGL1e9VQjsEv0Y5MTAL3PA6Ps0R3yMRc50PrX
         ePo3cQCtiomG3aksvSbQkoJ8iQkAKKlOXhKl2+imX10ZMbjDeIYYAQX+0QGGSzy7RG
         JfVJoRtLlnvZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1E7E4E5D07E;
        Thu,  3 Feb 2022 00:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] tcp: add missing tcp_skb_can_collapse() test in
 tcp_shift_skb_data()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164384880912.13373.9875179366600746041.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Feb 2022 00:40:09 +0000
References: <20220201184640.756716-1-eric.dumazet@gmail.com>
In-Reply-To: <20220201184640.756716-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com, pabeni@redhat.com,
        mathew.j.martineau@linux.intel.com, talalahmad@google.com,
        arjunroy@google.com, soheil@google.com, willemb@google.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  1 Feb 2022 10:46:40 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> tcp_shift_skb_data() might collapse three packets into a larger one.
> 
> P_A, P_B, P_C  -> P_ABC
> 
> Historically, it used a single tcp_skb_can_collapse_to(P_A) call,
> because it was enough.
> 
> [...]

Here is the summary with links:
  - [net] tcp: add missing tcp_skb_can_collapse() test in tcp_shift_skb_data()
    https://git.kernel.org/netdev/net/c/b67985be4009

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


