Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 745356D2E2E
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 06:41:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233342AbjDAEkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 00:40:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53326 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjDAEkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 00:40:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E72A1C669
        for <netdev@vger.kernel.org>; Fri, 31 Mar 2023 21:40:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A1E71B83360
        for <netdev@vger.kernel.org>; Sat,  1 Apr 2023 04:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 51EE5C4339B;
        Sat,  1 Apr 2023 04:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680324017;
        bh=OK4VeE5mCiT7lYTTMWBQp8uc0RXbXR4/J8OqtaYw7Yw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZFJusxcE3JMUUCDA/ylzrEUnsWaxQ3iVSDd8vlVhB/fLY7SqiCDjGFdN9fY/tsjHq
         bRkBPdlHgmqZ+8sdwU2WWWI8Xh1K9Q/pVVCbgBQ515c7uaQptpLnW6X9kEcO38kdJ0
         p1dRCBzoAF3cWXEivFW0yiO1v8pLFFmxkhxboQfNIXzVqrW3AHITXJsZK4SevjwYy+
         UT54XyCI+4ccIFGD/utIngdnyXzfydXRnpT6TYcN9Ia4QQVxfrmdyz5jCSL1iTfiXf
         TcqYAnPx3FN7nt25wShnNtXzxcM/Po05a5ZsZc2CNg4pjZfvRDmpgaoRxAmi15aQAn
         eqEcYJPQJqw6w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 38D22E21EE4;
        Sat,  1 Apr 2023 04:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] icmp: guard against too small mtu
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168032401722.15847.13805989572906204547.git-patchwork-notify@kernel.org>
Date:   Sat, 01 Apr 2023 04:40:17 +0000
References: <20230330174502.1915328-1-edumazet@google.com>
In-Reply-To: <20230330174502.1915328-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        dsahern@kernel.org, netdev@vger.kernel.org, eric.dumazet@gmail.com,
        syzbot+d373d60fddbdc915e666@syzkaller.appspotmail.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 30 Mar 2023 17:45:02 +0000 you wrote:
> syzbot was able to trigger a panic [1] in icmp_glue_bits(), or
> more exactly in skb_copy_and_csum_bits()
> 
> There is no repro yet, but I think the issue is that syzbot
> manages to lower device mtu to a small value, fooling __icmp_send()
> 
> __icmp_send() must make sure there is enough room for the
> packet to include at least the headers.
> 
> [...]

Here is the summary with links:
  - [net] icmp: guard against too small mtu
    https://git.kernel.org/netdev/net/c/7d63b6712538

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


