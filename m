Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BB97765A9EE
	for <lists+netdev@lfdr.de>; Sun,  1 Jan 2023 13:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230055AbjAAMKT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 1 Jan 2023 07:10:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39108 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229652AbjAAMKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 1 Jan 2023 07:10:17 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0FD9B2BCF;
        Sun,  1 Jan 2023 04:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A09E660DC5;
        Sun,  1 Jan 2023 12:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id F1D15C43392;
        Sun,  1 Jan 2023 12:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672575016;
        bh=HS6hQhzfJcGLiKObxkOMK8wJSzB6v+ql7r+nb/4JGps=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=qHRD861CPrVPlYUcGQM6HjPv1j9IS7yHQUVVBZhUXhvkd6Ak2HRCl4CULe+QnH/89
         BhkAMZQ60HDWv624GS2RsqUsw77OFZ6cQ7srratN2/Sdc3KW5pT1jhbYK0EGgJZgSe
         2vHj7veGBhJObTs9KDtk/6UxZ7GvflKj5GQQ+6lT1he1/oaVSTlrz3rRhWqTYZJrtM
         I8j1h0dA6S0uIEsghtd4kWDcxsclla6pMLVJBoQL7WLy8Dewe+dAV7YbRlcPKzdv1R
         4DhDAFfycgPYdZ2UanZH3Le+UJPNK33VvxgJdP7BV5EJnde2s9ZWky4prhJVxCP799
         SHBPXQYa9FUAg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D1FF3E5250A;
        Sun,  1 Jan 2023 12:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 0/2] selftests: net: fix for arp_ndisc_evict_nocarrier test
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167257501585.16085.18087813673437590807.git-patchwork-notify@kernel.org>
Date:   Sun, 01 Jan 2023 12:10:15 +0000
References: <20221230091829.217007-1-po-hsu.lin@canonical.com>
In-Reply-To: <20221230091829.217007-1-po-hsu.lin@canonical.com>
To:     Po-Hsu Lin <po-hsu.lin@canonical.com>
Cc:     linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org,
        netdev@vger.kernel.org, dsahern@kernel.org, prestwoj@gmail.com,
        shuah@kernel.org, pabeni@redhat.com, kuba@kernel.org,
        edumazet@google.com, davem@davemloft.net
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 30 Dec 2022 17:18:27 +0800 you wrote:
> This patchset will fix a false-positive issue caused by the command in
> cleanup_v6() of the arp_ndisc_evict_nocarrier test.
> 
> Also, it will make the test to return a non-zero value for any failure
> reported in the test for us to avoid false-negative results.
> 
> Po-Hsu Lin (2):
>   selftests: net: fix cleanup_v6() for arp_ndisc_evict_nocarrier
>   selftests: net: return non-zero for failures reported in
>     arp_ndisc_evict_nocarrier
> 
> [...]

Here is the summary with links:
  - [1/2] selftests: net: fix cleanup_v6() for arp_ndisc_evict_nocarrier
    https://git.kernel.org/netdev/net/c/9c4d7f45d607
  - [2/2] selftests: net: return non-zero for failures reported in arp_ndisc_evict_nocarrier
    https://git.kernel.org/netdev/net/c/1856628baa17

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


