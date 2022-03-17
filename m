Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D84174DBCC9
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 03:00:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348008AbiCQCBa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 22:01:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59168 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235690AbiCQCBa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 22:01:30 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15DD61CB29;
        Wed, 16 Mar 2022 19:00:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9DACDB81D77;
        Thu, 17 Mar 2022 02:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 39471C340EC;
        Thu, 17 Mar 2022 02:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647482412;
        bh=k1LFsQik3L/D6Ot2+FMgItOwalLWrW7mSdB7NYL9cWM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pMUVrfMgtw25ZvTUo3HYzq8w9e3n/qzbkUZoDs3Vr3lxegijW6l8sKPVCb3ZZ8baN
         uEA3vrwci9im0T60KcWvX1h+c5bvvQAt+jFucVqunrJajSZ7qhhomSr7GdP4oNwBi/
         VjFck9FW3vbpcJ4Y83k8BH6PM2VIZNOaAA58Q2J5Lc4tMOxuZrtH4P1DRhixQfxj2i
         6dfDFQoGieVV34r15sqrhylb4xLVdfaSYvbAaFZFM/x8bFV9s4FCZjgXk2uXrvIel3
         XQosSc3wDGnL3imkLQwMuD0KOjIAvbNeLqC2MLg5JzQUziginUITZN/OHp0RSLOmeK
         tSuUUnkn1D1Ow==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1F984E8DD5B;
        Thu, 17 Mar 2022 02:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/5] can: isotp: sanitize CAN ID checks in
 isotp_bind()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164748241212.13675.17237725080632762715.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 02:00:12 +0000
References: <20220316204710.716341-2-mkl@pengutronix.de>
In-Reply-To: <20220316204710.716341-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        socketcan@hartkopp.net,
        syzbot+2339c27f5c66c652843e@syzkaller.appspotmail.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Wed, 16 Mar 2022 21:47:06 +0100 you wrote:
> From: Oliver Hartkopp <socketcan@hartkopp.net>
> 
> Syzbot created an environment that lead to a state machine status that
> can not be reached with a compliant CAN ID address configuration.
> The provided address information consisted of CAN ID 0x6000001 and 0xC28001
> which both boil down to 11 bit CAN IDs 0x001 in sending and receiving.
> 
> [...]

Here is the summary with links:
  - [net-next,1/5] can: isotp: sanitize CAN ID checks in isotp_bind()
    https://git.kernel.org/netdev/net-next/c/3ea566422cbd
  - [net-next,2/5] can: isotp: return -EADDRNOTAVAIL when reading from unbound socket
    https://git.kernel.org/netdev/net-next/c/30ffd5332e06
  - [net-next,3/5] can: isotp: support MSG_TRUNC flag when reading from socket
    https://git.kernel.org/netdev/net-next/c/42bf50a1795a
  - [net-next,4/5] dt-bindings: can: xilinx_can: Convert Xilinx CAN binding to YAML
    https://git.kernel.org/netdev/net-next/c/7843d3c8e5e6
  - [net-next,5/5] can: ucan: fix typos in comments
    https://git.kernel.org/netdev/net-next/c/c34983c94166

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


