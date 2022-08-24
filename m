Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 529F45A040E
	for <lists+netdev@lfdr.de>; Thu, 25 Aug 2022 00:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229914AbiHXWbT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Aug 2022 18:31:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46948 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229833AbiHXWaW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Aug 2022 18:30:22 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 15EC6B844;
        Wed, 24 Aug 2022 15:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 01A5CCE2409;
        Wed, 24 Aug 2022 22:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3C05BC43144;
        Wed, 24 Aug 2022 22:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661380217;
        bh=jBOu2Pdw+e9odRrH52ZpnLAEMnqwvnH7KG8eLHtqhYs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pDsEgDV88uxzGXCGj23B3i8OfGcHf/LxeJxFbRw+aH6BjXrXS+G20Yj3B8uMerHJh
         bi9hbFHYgskAAVg9j5K4WXuaxUAy1iiziurShb0ZbZsRqyT1GMbficRAylwpYxehcQ
         lhOWWUKHjftfmj3wCeG1XwM87wFqqQ395V+/d0gIAlJHTEhVkhdhBA6al7CEB45qpZ
         ofmVfImxwp/o3cqSvbBSS6K8RTQJwfcRAyIfv8l6y2qPi1CSsUaD+Q/t02DOCPDB+7
         La3v6iDERJ40V2nmjOpZoDl0xDjgHZAzmcDop3sVhrj4UAL8YkkXMLx+H/AelvWfvc
         JMAnJqVtbdhEA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1C2B8E2A03B;
        Wed, 24 Aug 2022 22:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Bluetooth: hci_event: Fix checking conn for
 le_conn_complete_evt
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <166138021710.13438.1447339099365572725.git-patchwork-notify@kernel.org>
Date:   Wed, 24 Aug 2022 22:30:17 +0000
References: <20220823123850.1.I0cb00facc6a47efc8cee54d5d4a02fadb388e5a5@changeid>
In-Reply-To: <20220823123850.1.I0cb00facc6a47efc8cee54d5d4a02fadb388e5a5@changeid>
To:     Archie Pusaka <apusaka@google.com>
Cc:     linux-bluetooth@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, chromeos-bluetooth-upstreaming@chromium.org,
        apusaka@chromium.org, sonnysasaka@chromium.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        johan.hedberg@gmail.com, pabeni@redhat.com,
        soenke.huster@eknoes.de, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
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

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Tue, 23 Aug 2022 12:39:22 +0800 you wrote:
> From: Archie Pusaka <apusaka@chromium.org>
> 
> To prevent multiple conn complete events, we shouldn't look up the
> conn with hci_lookup_le_connect, since it requires the state to be
> BT_CONNECT. By the time the duplicate event is processed, the state
> might have changed, so we end up processing the new event anyway.
> 
> [...]

Here is the summary with links:
  - Bluetooth: hci_event: Fix checking conn for le_conn_complete_evt
    https://git.kernel.org/bluetooth/bluetooth-next/c/045f23cf75a8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


