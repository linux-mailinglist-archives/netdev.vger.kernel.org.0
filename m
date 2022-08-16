Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F8905953C1
	for <lists+netdev@lfdr.de>; Tue, 16 Aug 2022 09:28:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232059AbiHPH2O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Aug 2022 03:28:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54154 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231774AbiHPH1d (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Aug 2022 03:27:33 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFE017DA92
        for <netdev@vger.kernel.org>; Mon, 15 Aug 2022 21:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8506D61007
        for <netdev@vger.kernel.org>; Tue, 16 Aug 2022 04:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5812C433C1;
        Tue, 16 Aug 2022 04:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660622414;
        bh=EGMutGj+sCDCOgtLFTKlLQ/8GQMzHIdFbdQvevMwArU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QEjlyjHMx5isjF2NGQZHtDG9rVKHmFTLEsKxERzC9bZsXAv+AW/tWhUDJtesishQN
         iIaWg5ddTjoNuze7GpFrwCz5Vwc8B/1QR6/adwPB9zntnbBMGdlysAGzY8bJUbIWzq
         l1ORc47KFkJIUf18XGSm/6bvlJtxERe3xE1eUe6AR20ysj/qzSBNjoIGLnUpngfwzV
         SDk0iGTAkcsXQqBhlSSl9ple2vUL3IEjnTW5ZF3TLFdGbkpPUcWV05aoaFbgFfmP6j
         RLVVJVcFvC3IgFuYQnodDtMmj0hWyaE7MWcjwIebRFUvxsA4r6ygg798ZbBoubMqzo
         eHf86bi1Md/0w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B9BDDE2A051;
        Tue, 16 Aug 2022 04:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/4][pull request] Intel Wired LAN Driver Updates
 2022-08-12 (iavf)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166062241475.31291.980988249605556689.git-patchwork-notify@kernel.org>
Date:   Tue, 16 Aug 2022 04:00:14 +0000
References: <20220812172309.853230-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220812172309.853230-1-anthony.l.nguyen@intel.com>
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

On Fri, 12 Aug 2022 10:23:05 -0700 you wrote:
> This series contains updates to iavf driver only.
> 
> Przemyslaw frees memory for admin queues in initialization error paths,
> prevents freeing of vf_res which is causing null pointer dereference,
> and adjusts calls in error path of reset to avoid iavf_close() which
> could cause deadlock.
> 
> [...]

Here is the summary with links:
  - [net,1/4] iavf: Fix adminq error handling
    https://git.kernel.org/netdev/net/c/419831617ed3
  - [net,2/4] iavf: Fix NULL pointer dereference in iavf_get_link_ksettings
    https://git.kernel.org/netdev/net/c/541a1af451b0
  - [net,3/4] iavf: Fix reset error handling
    https://git.kernel.org/netdev/net/c/31071173771e
  - [net,4/4] iavf: Fix deadlock in initialization
    https://git.kernel.org/netdev/net/c/cbe9e5112630

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


