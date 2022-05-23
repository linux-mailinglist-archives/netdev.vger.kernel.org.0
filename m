Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E01531F23
	for <lists+netdev@lfdr.de>; Tue, 24 May 2022 01:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229571AbiEWXKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 19:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60850 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229441AbiEWXKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 19:10:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F14370901;
        Mon, 23 May 2022 16:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 39A63B81696;
        Mon, 23 May 2022 23:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id CCC7BC34100;
        Mon, 23 May 2022 23:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653347412;
        bh=r8xL3eb2Iu7WpxuLDd0t8cmqbsoeobvUBpNroD7v/z4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C3+WteiVvgoUNpGLVjT6qMaxNVct9vMUD869wiAAJfK+qBLP7xvNzLO4E/N8dDwXO
         WlLnZeVg/KUNhEXab7X7Gq5kaYJ8HceiZ3UsbLXNS5Qjg/wEMONrhSM0OSk/1lxrMV
         57SdxTbhTaWfj1bx4jwEQbaSUngMQ3uYKdVn9RLCBohz0231AMYIcr+vi33dclHt5U
         8fxU7PVhXDn7ilUDaIhjtxsg/5rRVoez1FsxKPu6KSi7rQJyoV00ePeuUZF3jgior8
         81t12q6f5EbjSZslNEnX4Oq0QRm30kw/dnRlDY0cyK7eHMgMBHRiYrLzYXyLbxvFLR
         tloN9pMMseYjg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A9B7FEAC081;
        Mon, 23 May 2022 23:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/3] can: peak_usb: fix typo in comment
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165334741269.398.15174446878045253185.git-patchwork-notify@kernel.org>
Date:   Mon, 23 May 2022 23:10:12 +0000
References: <20220523201045.1708855-2-mkl@pengutronix.de>
In-Reply-To: <20220523201045.1708855-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        linux-can@vger.kernel.org, kernel@pengutronix.de,
        Julia.Lawall@inria.fr
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Mon, 23 May 2022 22:10:43 +0200 you wrote:
> From: Julia Lawall <Julia.Lawall@inria.fr>
> 
> Spelling mistake (triple letters) in comment.
> Detected with the help of Coccinelle.
> 
> Link: https://lore.kernel.org/all/20220521111145.81697-24-Julia.Lawall@inria.fr
> Signed-off-by: Julia Lawall <Julia.Lawall@inria.fr>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] can: peak_usb: fix typo in comment
    https://git.kernel.org/netdev/net-next/c/a682d1843300
  - [net-next,2/3] can: kvaser_usb: silence a GCC 12 -Warray-bounds warning
    https://git.kernel.org/netdev/net-next/c/3e88445a3a5a
  - [net-next,3/3] can: ctucanfd: platform: add missing dependency to HAS_IOMEM
    https://git.kernel.org/netdev/net-next/c/8f445a3ec3fd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


