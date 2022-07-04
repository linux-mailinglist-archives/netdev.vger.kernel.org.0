Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A2EC5650E1
	for <lists+netdev@lfdr.de>; Mon,  4 Jul 2022 11:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233894AbiGDJbL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Jul 2022 05:31:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233717AbiGDJab (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 4 Jul 2022 05:30:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 64895D126;
        Mon,  4 Jul 2022 02:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EB57361411;
        Mon,  4 Jul 2022 09:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5076FC36AE3;
        Mon,  4 Jul 2022 09:30:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656927013;
        bh=ESip6U0YDPnwxFmiJmdbhURWJPk6jK0EALSCTJQK/oc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=k6FawV2gFLh5kMOGqbm+U9jGdnZkMyusIJJolfkJHDGwreLktv31nPnz6wLzt4rf/
         O8LBN3arKqAK2vyF6bPWtvRhndr6zXD5xETbkx1LD41qkMYkEXl3KbFnlmGixOTlCT
         7HtCqu8KAbGpqgmdDDj9L0X3hLfyNZIdUUAoCWixAA/ADfQhp3JPNZkpqgieh9Wam3
         bSa3gjeXNOekOqrejNix/o6Js5Vv0JIYEoiShEJdIR44KMo9D5Qkm7tiWzDZn/QMK0
         YG/5uHnNkbTANeC38i+0h2QnANdu8/hw4yUyHVSJkz07A2hVeFw6suUfUkzu16cuQH
         sYW0FmgXFaFAw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 326EBE45BDB;
        Mon,  4 Jul 2022 09:30:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ipconfig: use strscpy to replace strlcpy
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165692701320.10611.9874439179208665797.git-patchwork-notify@kernel.org>
Date:   Mon, 04 Jul 2022 09:30:13 +0000
References: <6635dc9f.d16.181b966989f.Coremail.chenxuebing@jari.cn>
In-Reply-To: <6635dc9f.d16.181b966989f.Coremail.chenxuebing@jari.cn>
To:     XueBing Chen <chenxuebing@jari.cn>
Cc:     davem@davemloft.net, yoshfuji@linux-ipv6.org, dsahern@kernel.org,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 1 Jul 2022 18:55:17 +0800 (GMT+08:00) you wrote:
> The strlcpy should not be used because it doesn't limit the source
> length. Preferred is strscpy.
> 
> Signed-off-by: XueBing Chen <chenxuebing@jari.cn>
> ---
>  net/ipv4/ipconfig.c | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)

Here is the summary with links:
  - net: ipconfig: use strscpy to replace strlcpy
    https://git.kernel.org/netdev/net-next/c/634b215b7307

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


