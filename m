Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DCAA48C9F6
	for <lists+netdev@lfdr.de>; Wed, 12 Jan 2022 18:40:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241269AbiALRkL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jan 2022 12:40:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35350 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238188AbiALRkK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jan 2022 12:40:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D95BC06173F;
        Wed, 12 Jan 2022 09:40:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EF59A618BC;
        Wed, 12 Jan 2022 17:40:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5D0C4C36AEB;
        Wed, 12 Jan 2022 17:40:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642009209;
        bh=dH3Rgfg0dmfN/ANUSizcRBkaWwQy95/1radkCDdUdYw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TgN6Qva+8OTqQcmmNsbCTGrHGONgFAUPqC10S2ozE5nyfouOeCeRCoICSBddxQhyF
         LnFMoUkg3U6Anwqfh9x0/zNmeCJg0a5ZbM5kEpnSGLEzpHUNPix7Ga0XC/X+JkkBKD
         IImI2H/p8i2zXtv+ai/gb+vcOi4AYxb/xREwJ3/ELk81N+DWx9ny5SGCV495AxMggC
         YbGm3x61e6QahSi1Apaz+IB0oY8i+xaoAWOBuAtReeahMXu3STVGTmymXwA9Z2aqcq
         VHA2uTHyRnUPCS6yd/eMRXbVUpWyNHRPigvZGR0MFpPMhgC80Kqin9rsbHU0fvUHqg
         q3Nvgbl+jhVAg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 43128F60792;
        Wed, 12 Jan 2022 17:40:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next v4] iplink_can: add ctrlmode_{supported,_static}
 to the "--details --json" output
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164200920926.13100.6359567854126946569.git-patchwork-notify@kernel.org>
Date:   Wed, 12 Jan 2022 17:40:09 +0000
References: <20220109153040.521632-1-mailhol.vincent@wanadoo.fr>
In-Reply-To: <20220109153040.521632-1-mailhol.vincent@wanadoo.fr>
To:     Vincent Mailhol <mailhol.vincent@wanadoo.fr>
Cc:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org, linux-can@vger.kernel.org,
        linux-kernel@vger.kernel.org, mkl@pengutronix.de
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Mon, 10 Jan 2022 00:30:40 +0900 you wrote:
> This patch is the userland counterpart of [1]. Indeed, [1] enables the
> can netlink interface to report the CAN controller capabilities.
> 
> Previously, only the options which were switched on were reported
> (i.e. can_priv::ctrlmode). Here, we add two additional pieces of
> information to the json report:
> 
> [...]

Here is the summary with links:
  - [iproute2-next,v4] iplink_can: add ctrlmode_{supported,_static} to the "--details --json" output
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=db5305290c2f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


