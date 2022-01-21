Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7555A495DDA
	for <lists+netdev@lfdr.de>; Fri, 21 Jan 2022 11:40:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1380039AbiAUKkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 05:40:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48824 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1380044AbiAUKkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 05:40:12 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C6B6C06173F
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 02:40:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 29D8261A3E
        for <netdev@vger.kernel.org>; Fri, 21 Jan 2022 10:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 810FDC340E1;
        Fri, 21 Jan 2022 10:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642761611;
        bh=A9yW3egq8szZJbVtwND2dU2aaY4zP6oBbCSMqE31PlI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=MEEmnMLT5yjAPT+7dARcp2ua1uwZYiy4nqRSnIAUiiGkEkz4DWvIdSOfJwh1PweUf
         /HbmbhFhRb55LXRXNe66IdY8J0yuW/NTMS7ivbHEcw5ncHvbPnyJK9T5Mzh4+10zf5
         jI9MCIRJXyJLF0IJQxSwmjzX+oi8bv3aCxxX7Uzf5iNxufouv0sascqfkcTC29hAUX
         NwmJSuL3p0s3Lhn9oLiz1+F9wQUWCqBwSQfF1Ds85GrtVF10HnK84fV1g38WhG7qaG
         Q6nw1PwLzGhq43F5wQGIz8GzukQgRcKXjxWPhAjTOyjJIlUUw5B/rlq55evdwWUwb/
         fzKrmngryo9GA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 5BF3EF6079C;
        Fri, 21 Jan 2022 10:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/5][pull request] Intel Wired LAN Driver Updates
 2022-01-20
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164276161137.32094.12700534189273034073.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Jan 2022 10:40:11 +0000
References: <20220121000305.1423587-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220121000305.1423587-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Thu, 20 Jan 2022 16:03:00 -0800 you wrote:
> This series contains updates to i40e driver only.
> 
> Jedrzej increases delay for EMP reset and adds checks to ensure a VF
> request to change queues can be met.
> 
> Sylwester moves the placement of the Flow Director queue as to not
> fragment the queue pile which would cause later re-allocation issues.
> 
> [...]

Here is the summary with links:
  - [net,1/5] i40e: Increase delay to 1 s after global EMP reset
    https://git.kernel.org/netdev/net/c/9b13bd53134c
  - [net,2/5] i40e: Fix issue when maximum queues is exceeded
    https://git.kernel.org/netdev/net/c/d701658a50a4
  - [net,3/5] i40e: Fix queues reservation for XDP
    https://git.kernel.org/netdev/net/c/92947844b8be
  - [net,4/5] i40e: Fix for failed to init adminq while VF reset
    https://git.kernel.org/netdev/net/c/0f344c8129a5
  - [net,5/5] i40e: fix unsigned stat widths
    https://git.kernel.org/netdev/net/c/3b8428b84539

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


