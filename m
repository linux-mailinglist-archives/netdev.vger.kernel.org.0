Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5449F5B35A5
	for <lists+netdev@lfdr.de>; Fri,  9 Sep 2022 12:52:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229614AbiIIKub (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Sep 2022 06:50:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53878 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229940AbiIIKuV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Sep 2022 06:50:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CDBBDA9261;
        Fri,  9 Sep 2022 03:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6BA87B824E3;
        Fri,  9 Sep 2022 10:50:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1318DC433D7;
        Fri,  9 Sep 2022 10:50:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662720618;
        bh=SzVD3gDm/PcgqvVSU9TB1uMOW+StfPdo0bxx9yNs3hk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ob/B9X6LgYEMFfdEMkKfABFQzqSp3oSocPnE+cvzEE042oCAg/spUHBor+7vrM4oi
         oSlv/ufQQ+R5WjWFa3QHwKpk6N68NhJlRsGatvDFpIGPOXNtwup79n6bn7sRXeCqr6
         S/n+4yhcbTE5iGCXDmFSqsw6kYotehRlSZyftib2sd+2QNdZ771LekFCypILjzPEyF
         SXPFg8oJdE7N/Yw+AAXFxAA/BxclZMUTQJCAWARTChy5F1LGYtY/huzJZiGuKlWI+z
         aAyLGPFoz6LVA/RBZONYZpod3446rpyUEDp0rHdRkWLoh3ZkIdbEJlOhivzkzuyoCC
         pbAs9N0T+xwkQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F3CE1E1CABD;
        Fri,  9 Sep 2022 10:50:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: openvswitch: fix repeated words in comments
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166272061799.26556.17392984606454277891.git-patchwork-notify@kernel.org>
Date:   Fri, 09 Sep 2022 10:50:17 +0000
References: <20220907040346.55169-1-yuanjilin@cdjrlc.com>
In-Reply-To: <20220907040346.55169-1-yuanjilin@cdjrlc.com>
To:     Jilin Yuan <yuanjilin@cdjrlc.com>
Cc:     pshelar@ovn.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed,  7 Sep 2022 12:03:46 +0800 you wrote:
> Delete the redundant word 'is'.
> 
> Signed-off-by: Jilin Yuan <yuanjilin@cdjrlc.com>
> ---
>  net/openvswitch/flow_netlink.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - net: openvswitch: fix repeated words in comments
    https://git.kernel.org/netdev/net-next/c/169ccf0e4082

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


