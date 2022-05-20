Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7EC5752E114
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 02:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244192AbiETAUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 20:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59022 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbiETAUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 20:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BFD4A980A5;
        Thu, 19 May 2022 17:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F8CD61A9C;
        Fri, 20 May 2022 00:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B4FEC34114;
        Fri, 20 May 2022 00:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653006012;
        bh=xN23XhVWg7Svo/4Flus8IM4qw8lkr4ZoO2wuqfbf4Vo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UJRK+YmEw/qvsuJHr1vSUE+3eeREXiS19Ok+bI40fXlPkr0cX7WWaBFomqemkWo6M
         OXfMN6d6wTZ4KtJJutzUhDLarFmPZgJ8jje/SNy3azbDK/+EO5CsHAytX+PehEnQO4
         q5CcTHkegSVh4pyWcumiDcy3PeJCOi5OcIvJSK0QD3KZnaS9zkBBeCkzjDd5EmBtzf
         FlvE0JaL7cCj4/wcOikB41dY58RG9DohuDMGY2aLPeFvGqsY2Wq/PX3ue4SBRHr7GM
         HwA6A7XiSl5z+YEwgkkLvcbtTbfkMi1MAbJMx9HEssrRcjS/dthRMBBnWkIra7L2vO
         T1NehjeifRWWw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6C3E5E8DBDA;
        Fri, 20 May 2022 00:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] net: macb: Fix PTP one step sync support
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165300601244.28143.16404681790790978508.git-patchwork-notify@kernel.org>
Date:   Fri, 20 May 2022 00:20:12 +0000
References: <20220518170756.7752-1-harini.katakam@xilinx.com>
In-Reply-To: <20220518170756.7752-1-harini.katakam@xilinx.com>
To:     Harini Katakam <harini.katakam@xilinx.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        richardcochran@gmail.com, claudiu.beznea@microchip.com,
        kuba@kernel.org, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        michal.simek@xilinx.com, harinikatakamlinux@gmail.com,
        radhey.shyam.pandey@xilinx.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 18 May 2022 22:37:56 +0530 you wrote:
> PTP one step sync packets cannot have CSUM padding and insertion in
> SW since time stamp is inserted on the fly by HW.
> In addition, ptp4l version 3.0 and above report an error when skb
> timestamps are reported for packets that not processed for TX TS
> after transmission.
> Add a helper to identify PTP one step sync and fix the above two
> errors. Add a common mask for PTP header flag field "twoStepflag".
> Also reset ptp OSS bit when one step is not selected.
> 
> [...]

Here is the summary with links:
  - [net,v3] net: macb: Fix PTP one step sync support
    https://git.kernel.org/netdev/net/c/5cebb40bc955

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


