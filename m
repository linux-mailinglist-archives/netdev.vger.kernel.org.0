Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CD479557105
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 04:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1377818AbiFWCUU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jun 2022 22:20:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233738AbiFWCUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 22:20:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59E893DA6B;
        Wed, 22 Jun 2022 19:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0AB54B821BB;
        Thu, 23 Jun 2022 02:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B010CC341C7;
        Thu, 23 Jun 2022 02:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655950814;
        bh=graNdvIVNbS9kjQowBYW99En6tckj5cxzfmKORFNfBc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HsvEVnz2K4SCEfNT+0xPTBS+rp2JuqfwSp72bZvA7uTXPhnp382oVrNuDkrFU4NuT
         Vl8USdd8PUJNTV0ROkWxgki9bErBSgdUPsXp0Ke/3i4whE/gL5j5M5SVpQxCFKHecT
         fpbcMmkMJbx+cxnMLFVxi9zfmjbEojCKSuzfeVFBn04KMhCZRaBPKpl1449o2QLbT9
         3APOr9+z8lZoNPoDyppDmP83/Wi/rL/bo+oC7lS0DBwEHAFGpqnuA5vB3pqBNMUaZn
         V9W/Z5pfgCg2ZE1t8/zZv+c1A2aSrrVRVGu2A7Lyu1h3j74clS0WwmfG0edtk5UIMF
         ZK0l7CbWxa4eA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 95CBFE7BB90;
        Thu, 23 Jun 2022 02:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] virtio_net: fix xdp_rxq_info bug after suspend/resume
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165595081461.12810.3709900678857017030.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Jun 2022 02:20:14 +0000
References: <20220621114845.3650258-1-stephan.gerhold@kernkonzept.com>
In-Reply-To: <20220621114845.3650258-1-stephan.gerhold@kernkonzept.com>
To:     Stephan Gerhold <stephan.gerhold@kernkonzept.com>
Cc:     mst@redhat.com, jasowang@redhat.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        ast@kernel.org, daniel@iogearbox.net, hawk@kernel.org,
        john.fastabend@gmail.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Jun 2022 13:48:44 +0200 you wrote:
> The following sequence currently causes a driver bug warning
> when using virtio_net:
> 
>   # ip link set eth0 up
>   # echo mem > /sys/power/state (or e.g. # rtcwake -s 10 -m mem)
>   <resume>
>   # ip link set eth0 down
> 
> [...]

Here is the summary with links:
  - [net] virtio_net: fix xdp_rxq_info bug after suspend/resume
    https://git.kernel.org/netdev/net/c/8af52fe9fd3b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


