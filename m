Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9C1875247C2
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 10:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351360AbiELIUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 May 2022 04:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235236AbiELIUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 12 May 2022 04:20:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B96836B78;
        Thu, 12 May 2022 01:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C887DB8212E;
        Thu, 12 May 2022 08:20:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 7F7D8C34113;
        Thu, 12 May 2022 08:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652343612;
        bh=/sepvWsWEAY29BZ3lNddMM3axrtRpJ8y+YN2sx3tIs8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=HaEQUcRYZvCIL8tkkKAb2tDKDSzUIPXgHYkQMumAR7bgQKMuNyfCTsD5Y150qQ4cG
         rVqTYfRbFPmj7r/Ask8KpBQadaXpVj7cuHTG3NhGsfjIzaDIfplZz/5KVXrL/+Wt9u
         NuW3ho+9vPiA1FQvT1XlpNsITk1wbSge7pGjCE8VIl5jlBkaRXgYnRDZklgUO1ry60
         PSvfQq42i4cFhdTZNKOS83cygTFutCVCASg6wLsEhAv3YQ0WfTg6zpwqaWlQ68zLCl
         b5KRnX9DD9EVseYbdXPsBrQ7RqfBkuS6E/lEOTI16WMA8/u41BsSqL+WWNu0ds+DXD
         AXNktX2+d7/oQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 62AFEF0392C;
        Thu, 12 May 2022 08:20:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: bcmgenet: Check for Wake-on-LAN interrupt probe
 deferral
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165234361240.1558.11947576074618789897.git-patchwork-notify@kernel.org>
Date:   Thu, 12 May 2022 08:20:12 +0000
References: <20220511031752.2245566-1-f.fainelli@gmail.com>
In-Reply-To: <20220511031752.2245566-1-f.fainelli@gmail.com>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, opendmb@gmail.com,
        bcm-kernel-feedback-list@broadcom.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        s.shtylyov@omp.ru, wahrenst@gmx.net, linux-kernel@vger.kernel.org
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
by Paolo Abeni <pabeni@redhat.com>:

On Tue, 10 May 2022 20:17:51 -0700 you wrote:
> The interrupt controller supplying the Wake-on-LAN interrupt line maybe
> modular on some platforms (irq-bcm7038-l1.c) and might be probed at a
> later time than the GENET driver. We need to specifically check for
> -EPROBE_DEFER and propagate that error to ensure that we eventually
> fetch the interrupt descriptor.
> 
> Fixes: 9deb48b53e7f ("bcmgenet: add WOL IRQ check")
> Fixes: 5b1f0e62941b ("net: bcmgenet: Avoid touching non-existent interrupt")
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net] net: bcmgenet: Check for Wake-on-LAN interrupt probe deferral
    https://git.kernel.org/netdev/net/c/6b77c06655b8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


