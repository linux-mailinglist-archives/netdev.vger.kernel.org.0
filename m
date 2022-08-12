Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8C11590F78
	for <lists+netdev@lfdr.de>; Fri, 12 Aug 2022 12:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238487AbiHLKa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Aug 2022 06:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60440 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S237891AbiHLKaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Aug 2022 06:30:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 267095FC5;
        Fri, 12 Aug 2022 03:30:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7873C61689;
        Fri, 12 Aug 2022 10:30:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B1229C433D7;
        Fri, 12 Aug 2022 10:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660300216;
        bh=zoMxktHDBNu8QE4ud535AwHCKvUVP9fcADl0Pb6Pss8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=IMbBvtmCBylTG+WyyvXfEyhWMPShYQC44Rt7qJZZT9Unbb6vz7bFM8rRLHoMxCsfs
         elmmlFYfFm5wLQmmEqH853Avqzf0+3hHWggGiKkZ8kOJlRXEpS6RPHdWXoBun9bedv
         xoAlecZ1+3R+hVXiyTTtqSmhn3FwME4HpD+KoFlpvj9XfNYSzY6es+iFNnVpt5zZnu
         uW3SN5QDKhW25XnAIqsdIzFqU18n1LbaLIRYWwTsV1EgVWpy9Nycgkqj/F5IAUB0Xh
         5GdSSOl8bRC//wRgY12wvFVbKr1CVYk4oTjIr/dcMs7Y4+Urzuu6bFdRUAnSDO+tAS
         8BYKMckq9OLoQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9597EC43143;
        Fri, 12 Aug 2022 10:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] skfp/h: fix repeated words in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166030021660.10916.17181010521478361071.git-patchwork-notify@kernel.org>
Date:   Fri, 12 Aug 2022 10:30:16 +0000
References: <20220810135901.17400-1-yuanjilin@cdjrlc.com>
In-Reply-To: <20220810135901.17400-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
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

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 10 Aug 2022 21:59:01 +0800 you wrote:
> Delete the redundant word 'the'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> ---
>  drivers/net/fddi/skfp/h/hwmtm.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - skfp/h: fix repeated words in comments
    https://git.kernel.org/netdev/net/c/86d2155e48f6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


