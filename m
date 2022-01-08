Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AC9B7488103
	for <lists+netdev@lfdr.de>; Sat,  8 Jan 2022 04:00:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233403AbiAHDAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jan 2022 22:00:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44248 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbiAHDAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jan 2022 22:00:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E7229C061574
        for <netdev@vger.kernel.org>; Fri,  7 Jan 2022 19:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 813AD6200F
        for <netdev@vger.kernel.org>; Sat,  8 Jan 2022 03:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D7AD8C36AED;
        Sat,  8 Jan 2022 03:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641610817;
        bh=pcUTVzfOm5adlij8IAWzeS3FWJPIZwcG0KDD2MBEbOI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PacvqLjHmgOGQMGkYqAL+NGJrTJCRN4Hb6P95rSHGDoJGhckyUlJzFhP6X2KH19Sr
         hFJVxPlNBJjxhr6DLx6J0ZvBsbeGzd5/ffNI+wglx7TtB3Wp4eEcf4NuBdpkTu4Gqx
         vZ6VVxFqJ0EV51msNP66q6qrRE9wYTke32OJ7GjItr5h31kUktwinWIj295uKx9TXi
         oTO5gDji5SGXkqOvaLJ8Cphv0kN0E5Utvdtu6sxK5TK+TUka1ro9L8wOuixk3tEDDP
         OtYMN2lmFqdRmSN/SXjWOT6xxG7KixDYeevg/0U5AYQVxRTlnCzLi968yd5rTTBC25
         Lr35sW0ZGP3Rw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B2F8BF79404;
        Sat,  8 Jan 2022 03:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/6][pull request] 40GbE Intel Wired LAN Driver
 Updates 2022-01-07
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164161081772.25151.10259821848143113985.git-patchwork-notify@kernel.org>
Date:   Sat, 08 Jan 2022 03:00:17 +0000
References: <20220107175704.438387-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220107175704.438387-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Fri,  7 Jan 2022 09:56:58 -0800 you wrote:
> This series contains updates to i40e and iavf drivers.
> 
> Karen limits per VF MAC filters so that one VF does not consume all
> filters for i40e.
> 
> Jedrzej reduces busy wait time for admin queue calls for i40e.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/6] i40e: Add ensurance of MacVlan resources for every trusted VF
    https://git.kernel.org/netdev/net-next/c/cfb1d572c986
  - [net-next,v2,2/6] i40e: Minimize amount of busy-waiting during AQ send
    https://git.kernel.org/netdev/net-next/c/ef39584ddb15
  - [net-next,v2,3/6] i40e: Update FW API version
    https://git.kernel.org/netdev/net-next/c/9c83ca8a638d
  - [net-next,v2,4/6] i40e: Remove non-inclusive language
    https://git.kernel.org/netdev/net-next/c/17b33d431960
  - [net-next,v2,5/6] i40e: remove variables set but not used
    https://git.kernel.org/netdev/net-next/c/a127adf2fc83
  - [net-next,v2,6/6] iavf: remove an unneeded variable
    https://git.kernel.org/netdev/net-next/c/5322c68e588d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


