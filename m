Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 712434CE335
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 07:01:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229622AbiCEGBM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 01:01:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229456AbiCEGBL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 01:01:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884752261D9
        for <netdev@vger.kernel.org>; Fri,  4 Mar 2022 22:00:22 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E77AC60F03
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 06:00:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 44D61C340EE;
        Sat,  5 Mar 2022 06:00:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646460021;
        bh=hUIdtqRbJWm5CMHptbIB8uNOaz9K3+jQv9pi8BFDCVU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=f1ilnMOzYcjDHim9si1dc+JjvzjA1fvFpUuBFEdDX70Bau29ybvrAdFym4PmcVAU5
         gaSeruPLCHS4wN+utXBRO8GMMw2/ifFzp4CWg6ODv72Yb1YwTnx1OfRzsyE7O5hGi7
         keFRogqgwxQDjweisK/Q16NMsJu4RRDyCYzSAwOtzhfCt58DcclO1OlNAucp9XWZ3o
         9/0PcvgxgotDR5WOPw6uAsFnPr4wzxaE/nNQ2wSos2YF69dwAoDj8U2/gk6ZU3wxjE
         Yf9rhyMHfZc4zw5K8MCqNhDz818Yv1nRYbsrmKfZjXJl4NwQf2aw7QWgAJTo/NdGjP
         FCc4VpizjTAKA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 21EDFE7BB18;
        Sat,  5 Mar 2022 06:00:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 00/11] mptcp: Selftest refinements and a new test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164646002113.31837.15868652515983059293.git-patchwork-notify@kernel.org>
Date:   Sat, 05 Mar 2022 06:00:21 +0000
References: <20220304193636.219315-1-mathew.j.martineau@linux.intel.com>
In-Reply-To: <20220304193636.219315-1-mathew.j.martineau@linux.intel.com>
To:     Mat Martineau <mathew.j.martineau@linux.intel.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        matthieu.baerts@tessares.net, mptcp@lists.linux.dev
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  4 Mar 2022 11:36:25 -0800 you wrote:
> Patches 1 and 11 improve the printed output of the mptcp_join.sh
> selftest.
> 
> Patches 2-8 add a test for the MP_FASTCLOSE option, including
> prerequisite changes like additional MPTCP MIBs.
> 
> Patches 9-10 add some groundwork for upcoming tests.
> 
> [...]

Here is the summary with links:
  - [net-next,01/11] selftests: mptcp: adjust output alignment for more tests
    https://git.kernel.org/netdev/net-next/c/9a0a93672c14
  - [net-next,02/11] mptcp: add the mibs for MP_FASTCLOSE
    https://git.kernel.org/netdev/net-next/c/1e75629cb964
  - [net-next,03/11] selftests: mptcp: add the MP_FASTCLOSE mibs check
    https://git.kernel.org/netdev/net-next/c/e8e947ef50f6
  - [net-next,04/11] mptcp: add the mibs for MP_RST
    https://git.kernel.org/netdev/net-next/c/e40dd439d6da
  - [net-next,05/11] selftests: mptcp: add the MP_RST mibs check
    https://git.kernel.org/netdev/net-next/c/922fd2b39e5a
  - [net-next,06/11] selftests: mptcp: add extra_args in do_transfer
    https://git.kernel.org/netdev/net-next/c/cbfafac4cf8f
  - [net-next,07/11] selftests: mptcp: reuse linkfail to make given size files
    https://git.kernel.org/netdev/net-next/c/34b572b76fec
  - [net-next,08/11] selftests: mptcp: add fastclose testcase
    https://git.kernel.org/netdev/net-next/c/01542c9bf9ab
  - [net-next,09/11] selftests: mptcp: add invert check in check_transfer
    https://git.kernel.org/netdev/net-next/c/8117dac3e7c3
  - [net-next,10/11] selftests: mptcp: add more arguments for chk_join_nr
    https://git.kernel.org/netdev/net-next/c/26516e10c433
  - [net-next,11/11] selftests: mptcp: update output info of chk_rm_nr
    https://git.kernel.org/netdev/net-next/c/7d9bf018f907

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


