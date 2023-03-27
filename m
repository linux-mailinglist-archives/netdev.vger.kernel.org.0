Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEA006C9D11
	for <lists+netdev@lfdr.de>; Mon, 27 Mar 2023 10:00:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232913AbjC0IA0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 04:00:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232934AbjC0IAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 04:00:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 417E44693
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 01:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C0F0661052
        for <netdev@vger.kernel.org>; Mon, 27 Mar 2023 08:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0EE0BC433A4;
        Mon, 27 Mar 2023 08:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679904019;
        bh=uc5vOpc06rPCMFW+xrq9g/IO6bkO2KTY7TXgmSDxL7o=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aL2r7DG3us4syUGpoEH/7GCL6l9lZAhgpsUFtIA9jlcurxG4IKSjnrwq4bZ5UWUXb
         lAwy+kLPf/e2uRsSrWpQ/zvRkChVburBBzur8vqTtoBr/g5K02xg6Tex0bSvWy+2kr
         htHglOLOWs12BQe+xW+VwdNj0fm4Dmdid4yCnUdEAO14qy7gu7ttEO2TgQ6YKUcOLW
         FbM8Tv1bgNxt0qDXUvgLRMahwzncCsxGkd89xLBjkA4Y/meTADm+S7S2zc0tXik7Du
         XQPzBCDa8d1jRSTNbdHmRLOZblvzS6lxbc//gO0Idv2vLN0nPC9YnBVc7tih4bmKWd
         Fh7gOWCHeu3pQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DFDF3E4D029;
        Mon, 27 Mar 2023 08:00:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v4] tools: ynl: Add missing types to encode/decode
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167990401891.27318.17495811832218442091.git-patchwork-notify@kernel.org>
Date:   Mon, 27 Mar 2023 08:00:18 +0000
References: <20230324175258.25145-1-michal.michalik@intel.com>
In-Reply-To: <20230324175258.25145-1-michal.michalik@intel.com>
To:     Michal Michalik <michal.michalik@intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 24 Mar 2023 18:52:58 +0100 you wrote:
> While testing the tool I noticed we miss the u16 type on payload create.
> On the code inspection it turned out we miss also u64 - add them.
> 
> We also miss the decoding of u16 despite the fact `NlAttr` class
> supports it - add it.
> 
> Signed-off-by: Michal Michalik <michal.michalik@intel.com>
> --
> v4:
> - remove `Fixes:` tag since no code is using that now
> - rebased to latest tree
> v3: change tree `net` -> `net-next`
> v2: add a `Fixes:` tag to the commit message
> 
> [...]

Here is the summary with links:
  - [net-next,v4] tools: ynl: Add missing types to encode/decode
    https://git.kernel.org/netdev/net-next/c/dd3a7d58dcc2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


