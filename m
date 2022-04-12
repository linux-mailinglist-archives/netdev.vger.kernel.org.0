Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 187C64FDBB8
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 12:59:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353706AbiDLKGe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 06:06:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1389070AbiDLJXW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 05:23:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FC69527D3
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 01:30:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0EC56B81B66
        for <netdev@vger.kernel.org>; Tue, 12 Apr 2022 08:30:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA06DC385A1;
        Tue, 12 Apr 2022 08:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649752212;
        bh=m+1PpGjcwzHYLO+3cx1OqvO/hhTh8rff68hcJcnjGQA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bFSn3y8tt33D6MUcoPmxOFx49qQePeyXNBYioOxS3rObIZuOnq3c5WAwcuTkjL7vY
         JtFd2DOOqld136OWdCzBvJCeZ20Fe2pKgAHSTNjlmE/9p/xNq6X5N2HdWdGh4xuMkq
         flJasIEY3MLhZoPkv3R89EQ/aN+JIZPTJCM0YNH45K4rdwfAtXcr3jSux1ZTHEUbHj
         m8wKITzMS/2dLZRaXhUBIbPOwGrcZRRNSnHcgZRf49aIrW95j+nfzpp8+BU691dxiw
         iyhGsNLLGbMoe7Mu0QySYrA+MiH8BF4P8izivP30NfI2QOdAY7zg+thCFehpt3CSyn
         uS/ljFgukr4Xw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8D584E8DBD1;
        Tue, 12 Apr 2022 08:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 net-next 0/2] net: bridge: add support for host l2 mdb
 entries
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164975221257.23162.6047417037650246223.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Apr 2022 08:30:12 +0000
References: <20220411084054.298807-1-troglobit@gmail.com>
In-Reply-To: <20220411084054.298807-1-troglobit@gmail.com>
To:     Joachim Wiberg <troglobit@gmail.com>
Cc:     kuba@kernel.org, razor@blackwall.org, roopa@nvidia.com,
        netdev@vger.kernel.org, bridge@lists.linux-foundation.org,
        davem@davemloft.net
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 11 Apr 2022 10:40:52 +0200 you wrote:
> Fix to an obvious omissions for layer-2 host mdb entries, this v2 adds
> the missing selftest and some minor style fixes.
> 
> Note: this patch revealed some worrying problems in how the bridge
>       forwards unknown BUM traffic and also how unknown multicast is
>       forwarded when a IP multicast router is known, which a another
>       (RFC) patch series intend to address.  That series will build
>       on this selftest, hence the name of the test.
> 
> [...]

Here is the summary with links:
  - [v2,net-next,1/2] net: bridge: add support for host l2 mdb entries
    https://git.kernel.org/netdev/net-next/c/e65693b0179e
  - [v2,net-next,2/2] selftests: forwarding: new test, verify host mdb entries
    https://git.kernel.org/netdev/net-next/c/50fe062c806e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


