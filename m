Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 59AA556B007
	for <lists+netdev@lfdr.de>; Fri,  8 Jul 2022 03:53:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236687AbiGHBKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Jul 2022 21:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229846AbiGHBKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Jul 2022 21:10:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AC9B371BD3;
        Thu,  7 Jul 2022 18:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 54726B824C2;
        Fri,  8 Jul 2022 01:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C06D2C341C0;
        Fri,  8 Jul 2022 01:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657242613;
        bh=2ugQijBkeHf/UAarAwaXkCJtfbCz/5FoYza6ZS+OKhw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Lb1mFGNlzNkH6ogaI+9Yu6uUvEW8aIkOur3ngnA6L+tpEd9SWgJxEe/eqwHJPppYD
         jx7nkrjacZSVO7vo4ovQWudXnGzP0BlZ7Ea42vd4FVnAmp8D1bNiEL9ZDQn2yfphuF
         ipc3Wtjwm7Lh4RaluAbIntcKcb8UISwK+VMgIz/e9YdLkn/68CdUMZrqgIdS08UF7f
         6ggZAat39EqSR+HfNAdyGo57smxMMo6LfmEZTAIJ5toCHY50PQR780R1I15JbkMvzb
         J74r8esNrDQDMzSVV5O3GzQa2MEhqSNQzHhSfAbWynJ5rx0ec20EaVBzPhkunerLyS
         9znfQOoC4e/kA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id A3D48E45BD9;
        Fri,  8 Jul 2022 01:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v4] net: ocelot: fix wrong time_after usage
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165724261366.30315.3026602159300701161.git-patchwork-notify@kernel.org>
Date:   Fri, 08 Jul 2022 01:10:13 +0000
References: <20220706132845.27968-1-paskripkin@gmail.com>
In-Reply-To: <20220706132845.27968-1-paskripkin@gmail.com>
To:     Pavel Skripkin <paskripkin@gmail.com>
Cc:     vladimir.oltean@nxp.com, claudiu.manoil@nxp.com,
        alexandre.belloni@bootlin.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        clement.leger@bootlin.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  6 Jul 2022 16:28:45 +0300 you wrote:
> Accidentally noticed, that this driver is the only user of
> while (time_after(jiffies...)).
> 
> It looks like typo, because likely this while loop will finish after 1st
> iteration, because time_after() returns true when 1st argument _is after_
> 2nd one.
> 
> [...]

Here is the summary with links:
  - [v4] net: ocelot: fix wrong time_after usage
    https://git.kernel.org/netdev/net/c/f46fd3d7c3bd

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


