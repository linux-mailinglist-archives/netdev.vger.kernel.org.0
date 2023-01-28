Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 240C667F853
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 15:00:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233575AbjA1OAX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 09:00:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48688 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230394AbjA1OAV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 09:00:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CFBCD51F;
        Sat, 28 Jan 2023 06:00:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1B823B80AF6;
        Sat, 28 Jan 2023 14:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B1A85C4339B;
        Sat, 28 Jan 2023 14:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674914417;
        bh=ZUt19BoZpX0xTtTw6MsV9dAVljunOHRmwbXmaJ7Ugtw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SPEgENsBuxvXLexOa5jYVcHsV/yYaYXZ9IB8B1ww+hk/oFgI9DVslRkuvOi+SWARL
         TdF4KjkbIlk2BUzRDy7O4G+B7AGW+BwJRJwD5jW6SYIezjE4xlIQrVk2WoRkuBhi28
         CHLqnvAQw5PhXWD9jX9MV/pNEWGdgodmu1mlWs8c+OO3pXXirY9A92bOXUPGPlfaBa
         sDkqyYE1NRUqTu/OfuCj9pVUICLq9LhPvsaAylK+7X2DRo5RzAYTNhA0qpjbSFWOec
         tF68OQpgazvkEMmlos8UsqYXps3rshP3+uRydpmwEKpTAZsBoec2ErpKJ/mwrn4P5d
         KPvdGlb2xT2zA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 99BDEF83ECF;
        Sat, 28 Jan 2023 14:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] selftest: net: Improve IPV6_TCLASS/IPV6_HOPLIMIT tests
 apparmor compatibility
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167491441762.1771.2123081381985522010.git-patchwork-notify@kernel.org>
Date:   Sat, 28 Jan 2023 14:00:17 +0000
References: <20230126165548.230453-1-andrei.gherzan@canonical.com>
In-Reply-To: <20230126165548.230453-1-andrei.gherzan@canonical.com>
To:     Andrei Gherzan <andrei.gherzan@canonical.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 26 Jan 2023 16:55:48 +0000 you wrote:
> "tcpdump" is used to capture traffic in these tests while using a random,
> temporary and not suffixed file for it. This can interfere with apparmor
> configuration where the tool is only allowed to read from files with
> 'known' extensions.
> 
> The MINE type application/vnd.tcpdump.pcap was registered with IANA for
> pcap files and .pcap is the extension that is both most common but also
> aligned with standard apparmor configurations. See TCPDUMP(8) for more
> details.
> 
> [...]

Here is the summary with links:
  - selftest: net: Improve IPV6_TCLASS/IPV6_HOPLIMIT tests apparmor compatibility
    https://git.kernel.org/netdev/net/c/a6efc42a86c0

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


