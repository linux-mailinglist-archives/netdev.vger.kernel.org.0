Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CEE3950DDE5
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 12:31:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241448AbiDYKdy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 06:33:54 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235076AbiDYKdV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 06:33:21 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6129B6318;
        Mon, 25 Apr 2022 03:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 10401B8128F;
        Mon, 25 Apr 2022 10:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8B1CEC385AD;
        Mon, 25 Apr 2022 10:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650882612;
        bh=wvjdFamBQ4IGaLRRyZZ8Q0E9aHm34WZs4MnP+NDZNVk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cfFMwl9esLX+4WnngsAC6Vw+tdQrngAAIofRMS3dSmjKSCZQKNnztwuhEHaBWtuXH
         ZBaDTFPZdlOeoEz6wPUrfWb2gl/dNyFzDW1HdQaLOKRTkRJU9AkeR7dDllVOP+yM+v
         BMBP8MH/Il3YeiV1WC8n+0FxhY2lGa69pkJ+ZjLmu9EGqm4FQG7iehb7EVBUVus4q2
         5WMiF9qYFbyra3Kn0dS8+pf6B1Sm/PO3WWrWCEPw86eTLqF2d2BHqmBBR4L9NGaJIe
         SgJ5iTIefjf22CDL533fuUS0GSnQ1WY3suVaWA2WaLc1lBAW+rie0N6ZVhSVvDXu4H
         rhFovQe12Hgnw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 737A3E85D90;
        Mon, 25 Apr 2022 10:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2] net: mscc: ocelot: Remove useless code
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165088261246.604.9770330765327308123.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Apr 2022 10:30:12 +0000
References: <1650537281-15069-1-git-send-email-baihaowen@meizu.com>
In-Reply-To: <1650537281-15069-1-git-send-email-baihaowen@meizu.com>
To:     Haowen Bai <baihaowen@meizu.com>
Cc:     UNGLinuxDriver@microchip.com, alexandre.belloni@bootlin.com,
        claudiu.manoil@nxp.com, davem@davemloft.net, kuba@kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, vladimir.oltean@nxp.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 21 Apr 2022 18:34:41 +0800 you wrote:
> payload only memset but no use at all, so we drop them.
> 
> Signed-off-by: Haowen Bai <baihaowen@meizu.com>
> ---
> V1->V2: change correct title
> 
>  drivers/net/ethernet/mscc/ocelot_vcap.c | 4 ----
>  1 file changed, 4 deletions(-)

Here is the summary with links:
  - [V2] net: mscc: ocelot: Remove useless code
    https://git.kernel.org/netdev/net-next/c/985e254c738c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


