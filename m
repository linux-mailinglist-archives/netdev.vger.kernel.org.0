Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 630615E5856
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 04:00:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229918AbiIVCAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 22:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229901AbiIVCAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 22:00:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF17F6DAFC;
        Wed, 21 Sep 2022 19:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B6F1F630BB;
        Thu, 22 Sep 2022 02:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1E836C433D6;
        Thu, 22 Sep 2022 02:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663812018;
        bh=svAjlNUwQTeY/kE6fzHjE28pUyNdgYVlqUvMFYKW0C4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Cpzci1EGIb/wbbRJWMJd4sxYU5HBqFUemm4poRTuk0c2rOFe0v90optCze5+v7yf9
         lKO69YlHyFd0al22Jkl9XMbMLii2MDYXtKeltZ6QGzHDuhlfVsqpMDJI5OdRbx40ku
         HHj05R1OMznDt/UMSfOBdXF2R5BF4aDlKdsc1aw7RNU+TXw1VfhidoG+gJoDW9YaSu
         04PWRDde1z+bDE9BDEXEq7TiP1n35NaPrZE+0DZ6kunS2YPR0nIkbuyyN7SLdom3YT
         yTAg0QO4Flyg1zNy+IpWB5skiluPKQFSbx+5xWbUCzMsAKc4RlnocVy5I1EdiYmk8Q
         FqHlWwKu6ECnw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 04A17E4D03D;
        Thu, 22 Sep 2022 02:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/4] netfilter: conntrack: fix the gc rescheduling
 delay
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166381201701.16388.7500974359204134271.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 02:00:17 +0000
References: <20220921095000.29569-2-fw@strlen.de>
In-Reply-To: <20220921095000.29569-2-fw@strlen.de>
To:     Florian Westphal <fw@strlen.de>
Cc:     netdev@vger.kernel.org, netfilter-devel@vger.kernel.org,
        kuba@kernel.org, pabeni@redhat.com, davem@davemloft.net,
        edumazet@google.com, atenart@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Florian Westphal <fw@strlen.de>:

On Wed, 21 Sep 2022 11:49:57 +0200 you wrote:
> From: Antoine Tenart <atenart@kernel.org>
> 
> Commit 2cfadb761d3d ("netfilter: conntrack: revisit gc autotuning")
> changed the eviction rescheduling to the use average expiry of scanned
> entries (within 1-60s) by doing:
> 
>   for (...) {
>       expires = clamp(nf_ct_expires(tmp), ...);
>       next_run += expires;
>       next_run /= 2;
>   }
> 
> [...]

Here is the summary with links:
  - [net-next,1/4] netfilter: conntrack: fix the gc rescheduling delay
    https://git.kernel.org/netdev/net-next/c/95eabdd20702
  - [net-next,2/4] netfilter: conntrack: revisit the gc initial rescheduling bias
    https://git.kernel.org/netdev/net-next/c/2aa192757005
  - [net-next,3/4] headers: Remove some left-over license text in include/uapi/linux/netfilter/
    https://git.kernel.org/netdev/net-next/c/7b5541a932c2
  - [net-next,4/4] netfilter: rpfilter: Remove unused variable 'ret'.
    https://git.kernel.org/netdev/net-next/c/72f5c8980463

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


