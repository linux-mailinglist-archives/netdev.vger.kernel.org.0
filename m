Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E2D5565E4D0
	for <lists+netdev@lfdr.de>; Thu,  5 Jan 2023 05:44:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230426AbjAEEou (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Jan 2023 23:44:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230297AbjAEEo1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Jan 2023 23:44:27 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 47D3451316
        for <netdev@vger.kernel.org>; Wed,  4 Jan 2023 20:44:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA835B819C8
        for <netdev@vger.kernel.org>; Thu,  5 Jan 2023 04:44:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 93B2BC433EF;
        Thu,  5 Jan 2023 04:44:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672893851;
        bh=ph0DXgEha+fN20SDpryxOe9fOzeXsKKPdSTq3sbKxr4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HyVcUALQaedL0IHfiysPcPzXw/TWrm40+HUOv+pi/5uEUFIopo/dOpOh07Q7tWST3
         M7ieKIJoIjXKINp4NhcftVB44TN8L5/78MAIgeGEDjssyLr6Im9FR7IL5UrPhA/2VN
         SluEoI1PBL83UMK38g1QVD00Uid5PXLMzixHqIFLJXqSmJH9GKLzpO7lnmEOgPQCxE
         +AKop5ggq44DE7iAyd2Ko/T3z751H942r/oSCZ6p3pEkWd9oSASffx9h5doNNvrZeH
         jyiYp/PyBGOmpvDWHYmcis0ZIicc6QHxmn2sn18+VPYtv+1+sfzGnunCD7yptdVpXn
         1raAzReD4Rjww==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 74EE2E57254;
        Thu,  5 Jan 2023 04:44:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/ulp: prevent ULP without clone op from entering the
 LISTEN status
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167289385147.19861.7104633829687203944.git-patchwork-notify@kernel.org>
Date:   Thu, 05 Jan 2023 04:44:11 +0000
References: <4b80c3d1dbe3d0ab072f80450c202d9bc88b4b03.1672740602.git.pabeni@redhat.com>
In-Reply-To: <4b80c3d1dbe3d0ab072f80450c202d9bc88b4b03.1672740602.git.pabeni@redhat.com>
To:     Paolo Abeni <pabeni@redhat.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        yoshfuji@linux-ipv6.org, dsahern@kernel.org, edumazet@google.com,
        kuba@kernel.org, davejwatson@fb.com, borisp@mellanox.com,
        slipper.alive@gmail.com
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  3 Jan 2023 12:19:17 +0100 you wrote:
> When an ULP-enabled socket enters the LISTEN status, the listener ULP data
> pointer is copied inside the child/accepted sockets by sk_clone_lock().
> 
> The relevant ULP can take care of de-duplicating the context pointer via
> the clone() operation, but only MPTCP and SMC implement such op.
> 
> Other ULPs may end-up with a double-free at socket disposal time.
> 
> [...]

Here is the summary with links:
  - [net] net/ulp: prevent ULP without clone op from entering the LISTEN status
    https://git.kernel.org/netdev/net/c/2c02d41d71f9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


