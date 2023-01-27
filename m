Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F189667E347
	for <lists+netdev@lfdr.de>; Fri, 27 Jan 2023 12:29:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233412AbjA0L3r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Jan 2023 06:29:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233269AbjA0L3Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Jan 2023 06:29:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BD19A17164;
        Fri, 27 Jan 2023 03:28:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 06865B820C0;
        Fri, 27 Jan 2023 11:20:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9D598C433EF;
        Fri, 27 Jan 2023 11:20:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674818417;
        bh=W2XhhASGy1cEC/6c7RehtbhYyYemTgLU8PM5TW7nsaU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ILpfE/p18AFWOMZjK4/hUBUwX2ogKG8wFODYTLcee34SyaoHtlNse5u0STWaE7iK3
         rKyDhG0iDZQBBCpxC/O7lf5Cu165snMxTxy3rjtOQf4xZ9Uig0is4LblhPgJOIPEHd
         GmyDOtV51avf4yh77+GdQNjOwhthXpHTm+8qB3x693GbSVmcGj4aC5mQM2menLO29J
         6sZio7Dkc28O+X6DZJodw+mmVv9nTjcxXGs7uoDE0NXxjaD9fYJqHSz1UgsNuehKFp
         GytSVc6/UDOJbEao25yIgecUZ6yhGrvVCrlXDrbuHAK5RJWOL0JPo7XGHz1JxGta3Q
         17wcvzSthWLtw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7FC76C39564;
        Fri, 27 Jan 2023 11:20:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/8] net: ipa: abstract status parsing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167481841750.1603.1626079611671298658.git-patchwork-notify@kernel.org>
Date:   Fri, 27 Jan 2023 11:20:17 +0000
References: <20230125204545.3788155-1-elder@linaro.org>
In-Reply-To: <20230125204545.3788155-1-elder@linaro.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, caleb.connolly@linaro.org, mka@chromium.org,
        evgreen@chromium.org, andersson@kernel.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 25 Jan 2023 14:45:37 -0600 you wrote:
> Under some circumstances, IPA generates a "packet status" structure
> that describes information about a packet.  This is used, for
> example, when offload hardware detects an error in a packet, or
> otherwise discovers a packet needs special handling.  In this case,
> the status is delivered (along with the packet it describes) to a
> "default" endpoint so that it can be handled by the AP.
> 
> [...]

Here is the summary with links:
  - [net-next,1/8] net: ipa: refactor status buffer parsing
    https://git.kernel.org/netdev/net-next/c/63a560b5289a
  - [net-next,2/8] net: ipa: stop using sizeof(status)
    https://git.kernel.org/netdev/net-next/c/b8dc7d0eea5a
  - [net-next,3/8] net: ipa: define all IPA status mask bits
    https://git.kernel.org/netdev/net-next/c/8e71708bb25e
  - [net-next,4/8] net: ipa: rename the NAT enumerated type
    https://git.kernel.org/netdev/net-next/c/cbea4761173d
  - [net-next,5/8] net: ipa: define remaining IPA status field values
    https://git.kernel.org/netdev/net-next/c/ec4c24f6a511
  - [net-next,6/8] net: ipa: IPA status preparatory cleanups
    https://git.kernel.org/netdev/net-next/c/02c5077439fc
  - [net-next,7/8] net: ipa: introduce generalized status decoder
    https://git.kernel.org/netdev/net-next/c/ebd2a82ecea8
  - [net-next,8/8] net: ipa: add IPA v5.0 packet status support
    https://git.kernel.org/netdev/net-next/c/55c6eae70ff1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


