Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3AD175BE9FE
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:21:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231443AbiITPUk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:20:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231566AbiITPUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75BD5606B0;
        Tue, 20 Sep 2022 08:20:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3486FB82AA0;
        Tue, 20 Sep 2022 15:20:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D52E9C433D6;
        Tue, 20 Sep 2022 15:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663687214;
        bh=fX+wSiZy+n8JLCjfuIS2tthx3hDm7uGH6Lz+t8/r1G0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IHnwRa6fUf/CCSuIOqkIC5mB8NiZ8GMaRiQgx1IAIKa+cM19fp7n+d4HnKVIFql/B
         uUfRSu4itg4ElPvN20fRd06N8Voa2/jDge51n7KjgGKXvsMvd3s4mOYfrsz+QhqFyH
         ZPlIr2Xi3fO5UBXD3VToKUw6xjn1C0yA0kt0apIWS18jSFO9MgHKd2uqKvb3C3O2K8
         K8xR5AuW6qLHryW4nOj5Fski6Y4uQqHgrgbyieI+GVIZ9M/qE2LOjtEJ2usPBHL8l0
         D0jpOegnme8O2F6+ItwaJjcZcTyHwWCVj+1ySEQ/30qenOJT8NPGBQE7XdNFpZ9pQH
         HVORCI66bScYA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B509AC43141;
        Tue, 20 Sep 2022 15:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2] net: ipa: properly limit modem routing table use
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166368721473.32154.1711335581514313209.git-patchwork-notify@kernel.org>
Date:   Tue, 20 Sep 2022 15:20:14 +0000
References: <20220913204602.1803004-1-elder@linaro.org>
In-Reply-To: <20220913204602.1803004-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, mka@chromium.org, evgreen@chromium.org,
        bjorn.andersson@linaro.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
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
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 13 Sep 2022 15:46:02 -0500 you wrote:
> IPA can route packets between IPA-connected entities.  The AP and
> modem are currently the only such entities supported, and no routing
> is required to transfer packets between them.
> 
> The number of entries in each routing table is fixed, and defined at
> initialization time.  Some of these entries are designated for use
> by the modem, and the rest are available for the AP to use.  The AP
> sends a QMI message to the modem which describes (among other
> things) information about routing table memory available for the
> modem to use.
> 
> [...]

Here is the summary with links:
  - [net,v2] net: ipa: properly limit modem routing table use
    https://git.kernel.org/netdev/net/c/cf412ec33325

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


