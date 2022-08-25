Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 120865A19F2
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 22:01:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233925AbiHYUBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 16:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36080 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243539AbiHYUA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 16:00:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 99B587E000
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 13:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 169B0B82B10
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 20:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5603C433B5;
        Thu, 25 Aug 2022 20:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661457617;
        bh=mFvs+Y0OjxuOJ6lzQj+CcvWGuLPhNqXNoJ7zp+0flCE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=DW73A9WYPyifwgjsbGWDVM3iRHs+N5m1JxUt8KaZ+jgGQa/0uyhtEwYpLchnBsU50
         1t8CQGHcITtYgiBxgODtuIhMBAFjg7ouB9oul/wrjkcKt1xJ884teALkTPagO+EFq6
         MMo7k5bLd+Fgk8aHgP+XsNpw8HPVlZKLWVOdrdkWPtu0CK6f6jBgYowDWTPo+PaqO9
         JpqTxQQQTxcCzTgPr/iBzqOBr5nHt99DUeSniJDBrethwneHU2Z3Npa+rpW7Eah6rv
         Gvd3bf4ObPHsRZ+xZw/69hfuWf8id6gh1zim/YIiXzBFb4fN2DHTFadxof5qKQ414T
         yf7dz3zEKG0Jw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id AC4A6E2A03C;
        Thu, 25 Aug 2022 20:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2022-08-24 (ixgbe, i40e)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166145761770.4210.6714197614601546636.git-patchwork-notify@kernel.org>
Date:   Thu, 25 Aug 2022 20:00:17 +0000
References: <20220824193748.874343-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220824193748.874343-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org
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

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Wed, 24 Aug 2022 12:37:45 -0700 you wrote:
> This series contains updates to ixgbe and i40e drivers.
> 
> Jake stops incorrect resetting of SYSTIME registers when starting
> cyclecounter for ixgbe.
> 
> Sylwester corrects a check on source IP address when validating destination
> for i40e.
> 
> [...]

Here is the summary with links:
  - [net,1/2] ixgbe: stop resetting SYSTIME in ixgbe_ptp_start_cyclecounter
    https://git.kernel.org/netdev/net/c/25d7a5f5a6bb
  - [net,2/2] i40e: Fix incorrect address type for IPv6 flow rules
    https://git.kernel.org/netdev/net/c/bcf3a1564293

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


