Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0CE6B685F41
	for <lists+netdev@lfdr.de>; Wed,  1 Feb 2023 06:51:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231491AbjBAFu7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Feb 2023 00:50:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230091AbjBAFu5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Feb 2023 00:50:57 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AEB095C0F1;
        Tue, 31 Jan 2023 21:50:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B78061166;
        Wed,  1 Feb 2023 05:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CCAB3C433EF;
        Wed,  1 Feb 2023 05:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675230619;
        bh=Tb4W3pCcjNAi7UolnOrEcolSUc5iHIeJzmJZTcUvLHY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=CvFSEhgHs1trFjGMDlHTPXZoe2vBskPAH5zfy0cMkTutBPId8TyM/WseynKu5gjR9
         rfD8RGHdzelJXyQqxCHKGY8DLbBuBUI3Q8zPkerUN5wxKP+Gokd8TcFbVqKoZRygRQ
         aGBHkZwORoMRfCzdwak8n0YWUSLD8g9s6OosSEFMNO8vb29O8WxX4LfoiABdI6AyJ4
         QPI7PAlupDq1sNb2Up7wpYMPjvRfxx3Dse/34uHAgGX3NjLi+X/fHhAzCnHsFQYRWs
         kIv0jRdAB30Cgpu3HFIwZMWu6k6+XRrRzKbB4zx5Sp9emMYVN8qPVu+UffLfMR7dVg
         1OXR7IsocIvDg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A9B46E21EEC;
        Wed,  1 Feb 2023 05:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] net: ipa: remaining IPA v5.0 support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167523061968.13377.15290570490808834749.git-patchwork-notify@kernel.org>
Date:   Wed, 01 Feb 2023 05:50:19 +0000
References: <20230130210158.4126129-1-elder@linaro.org>
In-Reply-To: <20230130210158.4126129-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, caleb.connolly@linaro.org, mka@chromium.org,
        evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 30 Jan 2023 15:01:50 -0600 you wrote:
> This series includes almost all remaining IPA code changes required
> to support IPA v5.0.  IPA register definitions and configuration
> data for IPA v5.0 will be sent later (soon).  Note that the GSI
> register definitions still require work.  GSI for IPA v5.0 supports
> up to 256 (rather than 32) channels, and this changes the way GSI
> register offsets are calculated.  A few GSI register fields also
> change.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] net: ipa: support more endpoints
    https://git.kernel.org/netdev/net-next/c/07abde549bc1
  - [net-next,2/8] net: ipa: extend endpoints in packet init command
    https://git.kernel.org/netdev/net-next/c/c84ddc119704
  - [net-next,3/8] net: ipa: define IPA v5.0+ registers
    https://git.kernel.org/netdev/net-next/c/8ba59716d16a
  - [net-next,4/8] net: ipa: update table cache flushing
    https://git.kernel.org/netdev/net-next/c/8e7c89d84a2b
  - [net-next,5/8] net: ipa: support zeroing new cache tables
    (no matching commit)
  - [net-next,6/8] net: ipa: greater timer granularity options
    https://git.kernel.org/netdev/net-next/c/32079a4ab106
  - [net-next,7/8] net: ipa: support a third pulse register
    (no matching commit)
  - [net-next,8/8] net: ipa: define two new memory regions
    https://git.kernel.org/netdev/net-next/c/5157d6bfcad3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


