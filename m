Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1D86D4AF116
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:12:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232437AbiBIMLx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:11:53 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233073AbiBIMLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:11:10 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27C0AE024633;
        Wed,  9 Feb 2022 04:00:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E6F33B82073;
        Wed,  9 Feb 2022 12:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AB161C340EF;
        Wed,  9 Feb 2022 12:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644408012;
        bh=W50OIA2qnvEJLm1zMiBVquRpXEdxaNVuRW3Edd8fiJI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uPwcJr6JYYAYGRWdQHy3tjB2x3ADqLPj6HpLuClhmSfzUvQncwDcTuCRlTFMkZFIt
         0uMxo++NUor0zm16Xkr/Gi1IeWuXIe1Z1PLyVc1ckc9e/Wk++jtJw5ZKFoJM8yACnj
         ICCzKGWUzIYMMTLYwtoPSLLoyFtI5OghLADCm0c/LzPGlgzZrFbYeu4B6YDa0gO3Ii
         EeahSgwBvVyRgzh0bO4uKlWTWYFSAYBkfHYXpR8fzl7EiP6PFnr2m+XiwcqR8TYZNy
         fAujoqcvg9vXXjjMHuZz00qzjNNxxsAT5ZZcjUld+neOeJS+V4/1BZ5hmNtCUzkmMH
         LVgK2s8rnknvA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 99DB5E6D45A;
        Wed,  9 Feb 2022 12:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/2][pull request] 1GbE Intel Wired LAN Driver
 Updates 2022-02-07
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164440801262.11178.4494190850958498766.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 12:00:12 +0000
References: <20220207233246.1172958-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220207233246.1172958-1-anthony.l.nguyen@intel.com>
To:     Nguyen@ci.codeaurora.org, Anthony L <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        vinschen@redhat.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com, ast@kernel.org, daniel@iogearbox.net,
        hawk@kernel.org, john.fastabend@gmail.com, bpf@vger.kernel.org
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

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Mon,  7 Feb 2022 15:32:44 -0800 you wrote:
> Corinna Vinschen says:
> 
> Fix the kernel warning "Missing unregister, handled but fix driver"
> when running, e.g.,
> 
>   $ ethtool -G eth0 rx 1024
> 
> [...]

Here is the summary with links:
  - [net-next,1/2] igc: avoid kernel warning when changing RX ring parameters
    https://git.kernel.org/netdev/net-next/c/453307b569a0
  - [net-next,2/2] igb: refactor XDP registration
    https://git.kernel.org/netdev/net-next/c/e62ad74aa534

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


