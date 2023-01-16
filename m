Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698DE66BFF8
	for <lists+netdev@lfdr.de>; Mon, 16 Jan 2023 14:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231236AbjAPNkV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Jan 2023 08:40:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55020 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231232AbjAPNkU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Jan 2023 08:40:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C94A472AC
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 05:40:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7679FB80EB6
        for <netdev@vger.kernel.org>; Mon, 16 Jan 2023 13:40:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0F0B6C433D2;
        Mon, 16 Jan 2023 13:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673876416;
        bh=zIR6Ii/d3jkfFhCRCjAU6mgFZvvHRgnTzeYlaujsMNA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=utlJLvx64dxEqYYzQpQX6lSxVPjuW+2qwFfO/QGSZc/1sKiNC4CbAZCqqOsL2dnDE
         XTb+QKK6lOXl81KTygZYA8oKapXi6f7DNSm3Z5QoCjaRYTod9yk6JE10epjqnm+Xko
         t9EotGCsTKwq2x+db7zC3+i7+iuCZwMG6n1WC6uq8hoxTYh5SrYrjOYAiIlGUqrvJO
         2ETvMamTu3RcGsuiyrqpTwKywKnyPE851kFd6uH7kD+m4reLX97LTdFsy1uhjKXct2
         dXNeoTtsKxs39gu/I56iow0cfRNjywR3YnJ2UgeiNgSB3bJF/DwxGwf+leugPJBuPL
         Qf0Wpi1asB7ng==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E48C6E54D27;
        Mon, 16 Jan 2023 13:40:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3] net: dsa: mv88e6xxx: Enable PTP receive for
 mv88e6390
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167387641593.9239.3261063599237233452.git-patchwork-notify@kernel.org>
Date:   Mon, 16 Jan 2023 13:40:15 +0000
References: <20230113151258.196828-1-kurt@linutronix.de>
In-Reply-To: <20230113151258.196828-1-kurt@linutronix.de>
To:     Kurt Kanzenbach <kurt@linutronix.de>
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, olteanv@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, netdev@vger.kernel.org
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

On Fri, 13 Jan 2023 16:12:58 +0100 you wrote:
> The switch receives management traffic such as STP and LLDP. However, PTP
> messages are not received, only transmitted.
> 
> Ideally, the switch would trap all PTP messages to the management CPU. This
> particular switch has a PTP block which identifies PTP messages and traps them
> to a dedicated port. There is a register to program this destination. This is
> not used at the moment.
> 
> [...]

Here is the summary with links:
  - [net-next,v3] net: dsa: mv88e6xxx: Enable PTP receive for mv88e6390
    https://git.kernel.org/netdev/net-next/c/9627c981ac82

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


