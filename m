Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 88BAA4AF11C
	for <lists+netdev@lfdr.de>; Wed,  9 Feb 2022 13:12:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbiBIMLu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 07:11:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57862 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233065AbiBIMLK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 07:11:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC05CE02462C
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 04:00:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5A314616B1
        for <netdev@vger.kernel.org>; Wed,  9 Feb 2022 12:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BCA5BC36AE3;
        Wed,  9 Feb 2022 12:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644408012;
        bh=YyUiHTMhN1qp9X7Oq8hmTcSdzhvkSTazG5hO6/ghqGY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sS03t/osJBqUOxdIKSaqeYiyiMQD4i1KaTQnT4PKZ5a7pylCl8HZ0UEEHupnpMKHb
         HobFE9HtfLePsU83ZWEvTR7i4sVRTH//05xhyYK+sro8XUTsaY3IfFaTOpk+zIXM8O
         p8HYzKjbLoz3T6UkTjaZLCALPfoxmrTOEJeY8z9qBHBLeVMb4B9YdDDkPSRQvjmwvZ
         XCIK/mtcwlQDZcjYj0NGutoDaBceRoDkvbdxfXEUq8hVw5MUCUzTf4n2CXyd89glOo
         9R+vTD2JauZlKasTlAIMAIre6qf7VzXiU9iggmaEdA1URk9g2pUmEXQ/5BsLsKVODF
         yJ++K8grkRZBg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A2568E6D458;
        Wed,  9 Feb 2022 12:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/5][pull request] 40GbE Intel Wired LAN Driver
 Updates 2022-02-08
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164440801266.11178.13088796827382294168.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Feb 2022 12:00:12 +0000
References: <20220208215117.1733822-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220208215117.1733822-1-anthony.l.nguyen@intel.com>
To:     Nguyen@ci.codeaurora.org, Anthony L <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
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

On Tue,  8 Feb 2022 13:51:12 -0800 you wrote:
> Joe Damato says:
> 
> This patch set makes several updates to the i40e driver stats collection
> and reporting code to help users of i40e get a better sense of how the
> driver is performing and interacting with the rest of the kernel.
> 
> These patches include some new stats (like waived and busy) which were
> inspired by other drivers that track stats using the same nomenclature.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] i40e: Remove rx page reuse double count
    https://git.kernel.org/netdev/net-next/c/89bb09837b97
  - [net-next,2/5] i40e: Aggregate and export RX page reuse stat
    https://git.kernel.org/netdev/net-next/c/b3936d27673c
  - [net-next,3/5] i40e: Add a stat tracking new RX page allocations
    https://git.kernel.org/netdev/net-next/c/453f83054838
  - [net-next,4/5] i40e: Add a stat for tracking pages waived
    https://git.kernel.org/netdev/net-next/c/cb963b989755
  - [net-next,5/5] i40e: Add a stat for tracking busy rx pages
    https://git.kernel.org/netdev/net-next/c/b76bc129839d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


