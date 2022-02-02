Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2EA4A6AE6
	for <lists+netdev@lfdr.de>; Wed,  2 Feb 2022 05:30:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244365AbiBBEaN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Feb 2022 23:30:13 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:60090 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244155AbiBBEaM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Feb 2022 23:30:12 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 255A8616E9;
        Wed,  2 Feb 2022 04:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 81A37C340F2;
        Wed,  2 Feb 2022 04:30:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643776211;
        bh=v2mvwPosVusC+tleXQNEBb8lg+KCFnDh+6kynQsU9t8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uWS3XABb8W2Sqt5W0yPf+U8uicSfpd6lzc1Fx2cbKioVOEbNZlNi6grHonjLZqZ3L
         VE6hx3I8zz6/dEP7AmSQ9yOx2Wp1FLL6KhxGbu0m0nC33zPFmXZ7/PaMif/bCOwj9O
         jlgcckm7hjSf5HSHHBZXOKAX+A00G0WIpecuReO7fI0d/s5E+TJihGj1LkY/cNuhKs
         mnsWsijikdVSl3WJFYny32x0mScj1t1LpIiuVQe/Gb3NZv9gBOe+WER2Mww3dD9iel
         gyoG+lhdIn9SfRPSM8Gtolvb43BIhAd6Z5jHiveOlhCj76BlOJGiExwAJOT4KWaFTa
         jmzDkY1v9vZeg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 6A4DAE6BB76;
        Wed,  2 Feb 2022 04:30:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2 0/1] ipheth URB overflow fix
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164377621143.13473.6910787189636373903.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Feb 2022 04:30:11 +0000
References: <cover.1643699778.git.jan.kiszka@siemens.com>
In-Reply-To: <cover.1643699778.git.jan.kiszka@siemens.com>
To:     Jan Kiszka <jan.kiszka@siemens.com>
Cc:     kuba@kernel.org, davem@davemloft.net, gvalkov@abv.bg,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        corsac@corsac.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 1 Feb 2022 08:16:17 +0100 you wrote:
> Resent (v1 was mangled).
> 
> Note that the "Fixes:" tag is a strong assumption of mine. Speak up if
> you think that is wrong.
> 
> Jan
> 
> [...]

Here is the summary with links:
  - [v2,1/1] ipheth: fix EOVERFLOW in ipheth_rcvbulk_callback
    https://git.kernel.org/netdev/net/c/63e4b45c82ed

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


