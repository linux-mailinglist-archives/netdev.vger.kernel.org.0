Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E63425305B3
	for <lists+netdev@lfdr.de>; Sun, 22 May 2022 22:00:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232673AbiEVUAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 22 May 2022 16:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230015AbiEVUAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 22 May 2022 16:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35942167FB;
        Sun, 22 May 2022 13:00:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D2F27B80D7A;
        Sun, 22 May 2022 20:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 59E8CC34116;
        Sun, 22 May 2022 20:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653249616;
        bh=3++ZVRR12R7b7kn1s4as9qzzqk1hZRXbnbfbhjOAAAg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aBKpB80mTW1vDYt/pHje0EfVHPwgBVNwk8rkxWgVr7e+0QKiN3Bc1OxpWQYtCl/Vv
         f42XJP5Rsi/NYA4wp6+usas5DUtV/+4igrRdatnMRwISvPnP32m0mgQ40G4Q6AXouM
         Iwt163x8ANA4Ag3wZrT6n9nXwMN6JZUD1YkTSRmOtIOwlnv1Metd8a1TRX9/Db9PUL
         oD+1FLV37QPdsH7YFUec9VQtvId9iWeH55DJpQrPq80JS/PPg7/2qvn8nR/i8J6pbM
         c7C8kUJCLq78cq9DfNwuBbrk4DKFHU/Asvh1yXkpcqBF8scW/7vTSpChBKwuQOXSv/
         Uv/pDBu61UBmQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 289CB128071A;
        Sun, 22 May 2022 20:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/9] net: ipa: a few more small items
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165324961616.2622.11872941366931153343.git-patchwork-notify@kernel.org>
Date:   Sun, 22 May 2022 20:00:16 +0000
References: <20220522003223.1123705-1-elder@linaro.org>
In-Reply-To: <20220522003223.1123705-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mka@chromium.org, evgreen@chromium.org,
        bjorn.andersson@linaro.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 21 May 2022 19:32:14 -0500 you wrote:
> This series consists of three small sets of changes.  Version 2 adds
> a patch that avoids a warning that occurs when handling a modem
> crash (I unfortunately didn't notice it earlier).  All other patches
> are the same--just rebased.
> 
> The first three patches allow a few endpoint features to be
> specified.  At this time, currently-defined endpoints retain the
> same configuration, but when the monitor functionality is added in
> the next cycle these options will be required.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/9] net: ipa: make endpoint HOLB drop configurable
    https://git.kernel.org/netdev/net-next/c/153213f0554d
  - [net-next,v2,2/9] net: ipa: support hard aggregation limits
    (no matching commit)
  - [net-next,v2,3/9] net: ipa: specify RX aggregation time limit in config data
    https://git.kernel.org/netdev/net-next/c/beb90cba607f
  - [net-next,v2,4/9] net: ipa: kill gsi_trans_commit_wait_timeout()
    https://git.kernel.org/netdev/net-next/c/d15180b4eadb
  - [net-next,v2,5/9] net: ipa: count the number of modem TX endpoints
    https://git.kernel.org/netdev/net-next/c/2091c79ac4de
  - [net-next,v2,6/9] net: ipa: get rid of ipa_cmd_info->direction
    https://git.kernel.org/netdev/net-next/c/7ffba3bdf76a
  - [net-next,v2,7/9] net: ipa: remove command direction argument
    https://git.kernel.org/netdev/net-next/c/4de284b72e59
  - [net-next,v2,8/9] net: ipa: remove command info pool
    (no matching commit)
  - [net-next,v2,9/9] net: ipa: use data space for command opcodes
    https://git.kernel.org/netdev/net-next/c/a224bd4b88ca

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


