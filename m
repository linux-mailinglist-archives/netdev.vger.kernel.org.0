Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EE6E25B034A
	for <lists+netdev@lfdr.de>; Wed,  7 Sep 2022 13:40:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230007AbiIGLkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Sep 2022 07:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55416 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229480AbiIGLkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Sep 2022 07:40:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 52FD157200
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 04:40:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E78A261892
        for <netdev@vger.kernel.org>; Wed,  7 Sep 2022 11:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4B136C433C1;
        Wed,  7 Sep 2022 11:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662550816;
        bh=9mRTUoKp+NVPypgQL24MYgpnNtfGNqX1pcz+njbyRAM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ii0zZlPbVpnPV7c+71mgc0JLueg2pvy7ALoaDnE/xPrI4cXRyOiEaaPs5NC3w/Sg2
         501QqaglpBGRM6Po6naAMqUQRL/rS4ihZORpS1u0k6pWNjuyu6dHpAz61IDrFEP4o4
         HUjMqA6537UtH7DtyWRaIRPz/lB4ZVzIGmvrzYmLisSuD3e9LPB8HiWVVoNhD5ZpX1
         aK7pRCRsYLItcIzzz/UelOYw80Y+X2jJDcKkPLvdJuV2ex76rTyqCqbtl3WifFOdwQ
         MJ5dQrlNdwoPsEatYpReunjx8Rg14oK1AIMwvEpLEcvALnK4TrDvyTiHjeioHV+PvR
         OKyf0NRfKkxkg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2A5CDC4166E;
        Wed,  7 Sep 2022 11:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v5 0/3] sfc: add support for PTP over IPv6 and 802.3
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166255081616.11275.11323422521794146301.git-patchwork-notify@kernel.org>
Date:   Wed, 07 Sep 2022 11:40:16 +0000
References: <20220905082323.11241-1-ihuguet@redhat.com>
In-Reply-To: <20220905082323.11241-1-ihuguet@redhat.com>
To:     =?utf-8?b?w43DsWlnbyBIdWd1ZXQgPGlodWd1ZXRAcmVkaGF0LmNvbT4=?=@ci.codeaurora.org
Cc:     ecree.xilinx@gmail.com, habetsm.xilinx@gmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Mon,  5 Sep 2022 10:23:20 +0200 you wrote:
> Most recent cards (8000 series and newer) had enough hardware support
> for this, but it was not enabled in the driver. The transmission of PTP
> packets over these protocols was already added in commit bd4a2697e5e2
> ("sfc: use hardware tx timestamps for more than PTP"), but receiving
> them was already unsupported so synchronization didn't happen.
> 
> These patches add support for timestamping received packets over
> IPv6/UPD and IEEE802.3.
> 
> [...]

Here is the summary with links:
  - [net-next,v5,1/3] sfc: allow more flexible way of adding filters for PTP
    https://git.kernel.org/netdev/net-next/c/313aa13a0717
  - [net-next,v5,2/3] sfc: support PTP over IPv6/UDP
    https://git.kernel.org/netdev/net-next/c/621918c45fdc
  - [net-next,v5,3/3] sfc: support PTP over Ethernet
    https://git.kernel.org/netdev/net-next/c/e4616f64726b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


