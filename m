Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9970858E8C8
	for <lists+netdev@lfdr.de>; Wed, 10 Aug 2022 10:30:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231186AbiHJIas (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Aug 2022 04:30:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51752 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231417AbiHJIaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 10 Aug 2022 04:30:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 458A11A8;
        Wed, 10 Aug 2022 01:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA66FB81B11;
        Wed, 10 Aug 2022 08:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7C185C433C1;
        Wed, 10 Aug 2022 08:30:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660120215;
        bh=5MyKZGu54z+B2Bggh4Iqs/zOi00lCYIgWA3QaHn9uTA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hb9R6jljzlgmxRMgdPa9BULAA9Nmo+CbhCWVAs1qkCYxtoi3zS1mdSM3AR7w9NndW
         MfQqohicq+QJTm71pGleUXQDxZP+enaJnBFXu/M5R4/hExCrSCqHm27azmMLZjXgV+
         9933hxAPXDJ/7oAuxIPrHY00qjx0BBmNaLwXbQkaLvymOEsldNaOhc3Fc+pYjw0dGz
         fU0rrixc/3izXAUF/iwrNuv8vYNS+D9CtMB6C7QN650ENktgzFzgQK/KC7B1aeHfN0
         tTsunnBRj/qTaqCI1qF+ASgIAmyx/XRMOxMGI86UdrA6qvp/4E4aEPVtgAonzK+xlG
         qKrg0MlGNcaYQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 613EDC43143;
        Wed, 10 Aug 2022 08:30:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/4] can: j1939: j1939_sk_queue_activate_next_locked():
 replace WARN_ON_ONCE with netdev_warn_once()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166012021539.17355.18233144959835378708.git-patchwork-notify@kernel.org>
Date:   Wed, 10 Aug 2022 08:30:15 +0000
References: <20220810071448.1627857-2-mkl@pengutronix.de>
In-Reply-To: <20220810071448.1627857-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        pchelkin@ispras.ru, khoroshilov@ispras.ru, o.rempel@pengutronix.de
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

This series was applied to netdev/net.git (master)
by Marc Kleine-Budde <mkl@pengutronix.de>:

On Wed, 10 Aug 2022 09:14:45 +0200 you wrote:
> From: Fedor Pchelkin <pchelkin@ispras.ru>
> 
> We should warn user-space that it is doing something wrong when trying
> to activate sessions with identical parameters but WARN_ON_ONCE macro
> can not be used here as it serves a different purpose.
> 
> So it would be good to replace it with netdev_warn_once() message.
> 
> [...]

Here is the summary with links:
  - [net,1/4] can: j1939: j1939_sk_queue_activate_next_locked(): replace WARN_ON_ONCE with netdev_warn_once()
    https://git.kernel.org/netdev/net/c/8ef49f7f8244
  - [net,2/4] can: j1939: j1939_session_destroy(): fix memory leak of skbs
    https://git.kernel.org/netdev/net/c/8c21c54a53ab
  - [net,3/4] can: ems_usb: fix clang's -Wunaligned-access warning
    https://git.kernel.org/netdev/net/c/a4cb6e62ea4d
  - [net,4/4] can: mcp251x: Fix race condition on receive interrupt
    https://git.kernel.org/netdev/net/c/d80d60b0db6f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


