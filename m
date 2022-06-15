Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E4CC54C35D
	for <lists+netdev@lfdr.de>; Wed, 15 Jun 2022 10:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243658AbiFOIUS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 04:20:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243575AbiFOIUQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 04:20:16 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E573827FFB;
        Wed, 15 Jun 2022 01:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7FC1D61976;
        Wed, 15 Jun 2022 08:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D5D81C3411C;
        Wed, 15 Jun 2022 08:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655281214;
        bh=NtvxRmKChUQzaDPQ+vbp67VHe21hfaLn7r6U2p/yrsQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QxOo2rPlD+A/46JmCLBJWDxljpwoisVRdZrmGn3bXtnc1uQulIaEkwSuQ6zlYv1lY
         ojeUI4Y2JCdtY2LyOEvRqvNQW1ptIhul3ItzasCTWSm3dwwC9CxMVGj4lfQeGktasw
         K0tO8/SvQ7EUsn2TeTzxTMkDXZtikQnbs/7BTbxar1UDhfYzb4eXBvcYNlj5Ky9oep
         11B1hQ6eTVm8tna01X4GTX+96UtMVhY0FomQQe8Shq+RQwUmAFV17sHz5w3sKRcABF
         SzncJ6XogQrDP7hJOvVOmkWC6s7MdOX3XqVkdOA7fb2M4CFWc5mhMlf8tQvqxZ6Eos
         H7ME+lHrJ9xkQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B8999E73854;
        Wed, 15 Jun 2022 08:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/6] net: ipa: simplify completion statistics
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165528121475.11773.6004153793854654666.git-patchwork-notify@kernel.org>
Date:   Wed, 15 Jun 2022 08:20:14 +0000
References: <20220613171759.578856-1-elder@linaro.org>
In-Reply-To: <20220613171759.578856-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mka@chromium.org, evgreen@chromium.org,
        bjorn.andersson@linaro.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 13 Jun 2022 12:17:53 -0500 you wrote:
> The first patch in this series makes the name used for variables
> representing a TRE ring be consistent everywhere.  The second
> renames two structure fields to better represent their purpose.
> 
> The last four rework a little code that manages some tranaction and
> byte transfer statistics maintained mainly for TX endpoints.  For
> the most part this series is refactoring.  The last one also
> includes the first step toward no longer assuming an event ring is
> dedicated to a single channel.
> 
> [...]

Here is the summary with links:
  - [net-next,1/6] net: ipa: use "tre_ring" for all TRE ring local variables
    https://git.kernel.org/netdev/net-next/c/2295947bdaa6
  - [net-next,2/6] net: ipa: rename two transaction fields
    https://git.kernel.org/netdev/net-next/c/3eeabea6c895
  - [net-next,3/6] net: ipa: introduce gsi_trans_tx_committed()
    https://git.kernel.org/netdev/net-next/c/4e0f28e9ee4b
  - [net-next,4/6] net: ipa: simplify TX completion statistics
    https://git.kernel.org/netdev/net-next/c/65d39497fab6
  - [net-next,5/6] net: ipa: stop counting total RX bytes and transactions
    https://git.kernel.org/netdev/net-next/c/dbad2fa71914
  - [net-next,6/6] net: ipa: rework gsi_channel_tx_update()
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


