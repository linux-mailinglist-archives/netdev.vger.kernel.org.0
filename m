Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F029A6C00A3
	for <lists+netdev@lfdr.de>; Sun, 19 Mar 2023 12:00:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229913AbjCSLAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Mar 2023 07:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229635AbjCSLAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Mar 2023 07:00:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2FBF02313A
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 04:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A461D60FAA
        for <netdev@vger.kernel.org>; Sun, 19 Mar 2023 11:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 09CC1C433AE;
        Sun, 19 Mar 2023 11:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679223618;
        bh=HOj3O+dIsHBx51YYzQDigJIQsgB2Py4GMtIgBtnIIL4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=RFsS4dL6eR2+XPq9CrDb8z6lVxH6DMEBZVk+YI0H2AjUF3/UILQCmwpfPtqbYA6Ds
         FjNnVNQ/INfHiL+gRchDa+zsQ6k7n5IFygLspQldKw0pXLs24tYZtrw71XU3IcuIQr
         IKQYSRbIZoKbPm9r+3cMK4Qn7PhoHMopQou2rPWqXSuUEuufWZTpNCGnCljY4jdDMa
         Fu6ELko4HCw5OeRRQCg36zf7C7ONwCq90Q8Xnxx64u+wSVRI6blekTQZRCbzrrt5+y
         K8yiOw5Wr/2/GwAW65J/d3ucNWznD//LYY0AQix+yiHYvdvCBQTDyz/ysQhftiz3af
         oXRzgpVuFjJZg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DBEA5E2A03E;
        Sun, 19 Mar 2023 11:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/packet: remove po->xmit
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167922361789.26931.6377318288286209726.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Mar 2023 11:00:17 +0000
References: <20230317162002.2690357-1-edumazet@google.com>
In-Reply-To: <20230317162002.2690357-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com, willemb@google.com,
        daniel@iogearbox.net
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Mar 2023 16:20:02 +0000 you wrote:
> Use PACKET_SOCK_QDISC_BYPASS atomic bit instead of a pointer.
> 
> This removes one indirect call in fast path,
> and READ_ONCE()/WRITE_ONCE() annotations as well.
> 
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> Suggested-by: Willem de Bruijn <willemb@google.com>
> Cc: Daniel Borkmann <daniel@iogearbox.net>
> 
> [...]

Here is the summary with links:
  - [net-next] net/packet: remove po->xmit
    https://git.kernel.org/netdev/net-next/c/105a201ebf33

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


