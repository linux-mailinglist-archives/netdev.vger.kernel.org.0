Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F232D661FDA
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 09:20:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234243AbjAIIUW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 03:20:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236276AbjAIIUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 03:20:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3A94F017
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 00:20:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5018860F51
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 08:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ACEB6C4339E;
        Mon,  9 Jan 2023 08:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673252415;
        bh=Ur/SZRDNkT+YQLLfzQ1G7vuXhTpkXGpY2uV5JJi4oIE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=BeWISOmO7rZvzTADlnyF0n3Igw1x2noHmZxqWf9EYlozsyhopGsDucu34rcz3aMN8
         5aSA1i5jV6E8veCKothmSTT/xXDY7RnV3qYUZuBDWmbmwP+MOix0ALXkzgsj45tIZP
         dpvINWe4udBmNiukvbwUh8dl0Es7A1ZfuK3/zPnw5GH08uyZMXW2Xgobz9zQ3Ms2J0
         WDssfG2lsI2umG6FfjsStuhqA3+Wp1EUhRnMdqz2ePY52wNrgshC1r/nTMVDNB9KxP
         6l0+/V0QZkqmGndsUCP5miBkVTmkTrbF/ocGc0adnwkIaLIdgoxusbAecH5s6AV/FA
         V/oPJwhyOVwgA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9640DC395DF;
        Mon,  9 Jan 2023 08:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: skb: remove old comments about frag_size for
 build_skb()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167325241561.15932.2850934896731586682.git-patchwork-notify@kernel.org>
Date:   Mon, 09 Jan 2023 08:20:15 +0000
References: <20230107022904.582051-1-kuba@kernel.org>
In-Reply-To: <20230107022904.582051-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  6 Jan 2023 18:29:04 -0800 you wrote:
> Since commit ce098da1497c ("skbuff: Introduce slab_build_skb()")
> drivers trying to build skb around slab-backed buffers should
> go via slab_build_skb() rather than passing frag_size = 0 to
> the main build_skb().
> 
> Remove the copy'n'pasted comments about 0 meaning slab.
> 
> [...]

Here is the summary with links:
  - [net-next] net: skb: remove old comments about frag_size for build_skb()
    https://git.kernel.org/netdev/net-next/c/12c1604ae1a3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


