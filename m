Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 959D14B11AE
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 16:30:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243627AbiBJPaQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Feb 2022 10:30:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:59796 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243625AbiBJPaO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Feb 2022 10:30:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0638AC5;
        Thu, 10 Feb 2022 07:30:15 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 065F4CE24DA;
        Thu, 10 Feb 2022 15:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 527E1C340EE;
        Thu, 10 Feb 2022 15:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644507011;
        bh=IhhKygO9E/1WKprcO/gYlkpi9CQuBTGGen7fWcqtqr4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=J3CcUKAtJKyVt8XEogUVsn5RVr4RK1N693GzMfPk4D1GrxW7txGwSCFz1vJeMBx61
         3kROsu215aoZcjfegKNiRn0FW0Fzfp03nLSX909FPsKQP2IgCXRsTQhEQv/lZGh35/
         MLNm1Gtc6eGgnGyEXmhi+3sD8TVw1uNDKM1G1qUpovnbLzL3RvN2+XdIalkJ1O2ZDY
         87waRloTKjGeMqZeibR+M1DowBCGgt7xKfrCKPkGvia7yHtuQzvl3wzCAe0I0373Mm
         rrKuzcMhV0HCVYpS1uoGWcE5Q+QzdQDaMaQZk9l1TM6c/QDRre+O+q50PsfJOJsB/N
         unjg0cx/a6qCw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 40C2CE6D3DE;
        Thu, 10 Feb 2022 15:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/11] net: ping6: support basic socket cmsgs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164450701125.11192.3528047051168402424.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Feb 2022 15:30:11 +0000
References: <20220210003649.3120861-1-kuba@kernel.org>
In-Reply-To: <20220210003649.3120861-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, willemb@google.com,
        lorenzo@google.com, maze@google.com, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Wed,  9 Feb 2022 16:36:38 -0800 you wrote:
> Add support for common SOL_SOCKET cmsgs in ICMPv6 sockets.
> Extend the cmsg tests to cover more cmsgs and socket types.
> 
> SOL_IPV6 cmsgs to follow.
> 
> Jakub Kicinski (11):
>   net: ping6: remove a pr_debug() statement
>   net: ping6: support packet timestamping
>   net: ping6: support setting socket options via cmsg
>   selftests: net: rename cmsg_so_mark
>   selftests: net: make cmsg_so_mark ready for more options
>   selftests: net: cmsg_sender: support icmp and raw sockets
>   selftests: net: cmsg_so_mark: test ICMP and RAW sockets
>   selftests: net: cmsg_so_mark: test with SO_MARK set by setsockopt
>   selftests: net: cmsg_sender: support setting SO_TXTIME
>   selftests: net: cmsg_sender: support Tx timestamping
>   selftests: net: test standard socket cmsgs across UDP and ICMP sockets
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] net: ping6: remove a pr_debug() statement
    https://git.kernel.org/netdev/net-next/c/426522394649
  - [net-next,02/11] net: ping6: support packet timestamping
    https://git.kernel.org/netdev/net-next/c/e7b060460f29
  - [net-next,03/11] net: ping6: support setting socket options via cmsg
    https://git.kernel.org/netdev/net-next/c/3ebb0b1032e5
  - [net-next,04/11] selftests: net: rename cmsg_so_mark
    https://git.kernel.org/netdev/net-next/c/a086ee24cce2
  - [net-next,05/11] selftests: net: make cmsg_so_mark ready for more options
    https://git.kernel.org/netdev/net-next/c/49b786130296
  - [net-next,06/11] selftests: net: cmsg_sender: support icmp and raw sockets
    https://git.kernel.org/netdev/net-next/c/de17e305a810
  - [net-next,07/11] selftests: net: cmsg_so_mark: test ICMP and RAW sockets
    https://git.kernel.org/netdev/net-next/c/0344488e11ca
  - [net-next,08/11] selftests: net: cmsg_so_mark: test with SO_MARK set by setsockopt
    https://git.kernel.org/netdev/net-next/c/9bbfbc92c64a
  - [net-next,09/11] selftests: net: cmsg_sender: support setting SO_TXTIME
    https://git.kernel.org/netdev/net-next/c/4d397424a5e0
  - [net-next,10/11] selftests: net: cmsg_sender: support Tx timestamping
    https://git.kernel.org/netdev/net-next/c/eb8f3116fb3f
  - [net-next,11/11] selftests: net: test standard socket cmsgs across UDP and ICMP sockets
    https://git.kernel.org/netdev/net-next/c/af6ca20591ef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


