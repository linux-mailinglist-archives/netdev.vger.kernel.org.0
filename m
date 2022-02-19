Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EEB1A4BC95A
	for <lists+netdev@lfdr.de>; Sat, 19 Feb 2022 17:41:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242651AbiBSQkg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Feb 2022 11:40:36 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:42640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242633AbiBSQkd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Feb 2022 11:40:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 750451D3ADC
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 08:40:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 284C2B80BED
        for <netdev@vger.kernel.org>; Sat, 19 Feb 2022 16:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A0E75C340F1;
        Sat, 19 Feb 2022 16:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645288811;
        bh=pzEo9nU7Dwcub0tPoiTz40TJ5Lhx43hKw3PT63Y5GUo=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=OK6pC84Nv2HLMltHzUyU6CEgSuC4GIXlYA7ZOHkqIzWf7pwaSi1WTTBcbOriNp3Bs
         yBICNRdJJeTAwKeHQc1ijvJjN8McZpdmkXt17V8Ts05wykvfVRZEqYu2TndFPkP0eN
         7fwWs11p4FnKoa4orsz9hmy3eK1HN1i93HEoSpJh9QlNDWkSXlAvJh9On8bRyNYsev
         +65Us0rej/juXmE8E2om0lUTEGciYLO7MN9efXg6wHy/gZPCvQjcr3NOi8IjzyiO6C
         hIBn7sn63NfExf70Bn7hXVLkTy6YSYVuZGqrjPsVC4sB2p1zXGqRdu0IX1erTSjIb9
         bjutTDzWFbBrA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 84627E7BB0C;
        Sat, 19 Feb 2022 16:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/2] Provide direct access to 1588 one step
 register
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164528881153.6364.8579876317661156965.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Feb 2022 16:40:11 +0000
References: <20220218202201.11111-1-radu-andrei.bulie@nxp.com>
In-Reply-To: <20220218202201.11111-1-radu-andrei.bulie@nxp.com>
To:     Radu Bulie <radu-andrei.bulie@nxp.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        ioana.ciornei@nxp.com, yangbo.lu@nxp.com, richardcochran@gmail.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 18 Feb 2022 22:21:59 +0200 you wrote:
> DPAA2 MAC supports 1588 one step timestamping.
> If this option is enabled then for each transmitted PTP event packet,
> the 1588 SINGLE_STEP register is accessed to modify the following fields:
> 
> -offset of the correction field inside the PTP packet
> -UDP checksum update bit,  in case the PTP event packet has
>  UDP encapsulation
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/2] dpaa2-eth: Update dpni_get_single_step_cfg command
    https://git.kernel.org/netdev/net-next/c/9572594ecf02
  - [net-next,v3,2/2] dpaa2-eth: Update SINGLE_STEP register access
    https://git.kernel.org/netdev/net-next/c/c4680c978567

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


