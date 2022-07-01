Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 853D0562B24
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 08:00:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233256AbiGAGAT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 02:00:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35764 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233761AbiGAGAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 02:00:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5303B6B27F
        for <netdev@vger.kernel.org>; Thu, 30 Jun 2022 23:00:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 097B7B80D15
        for <netdev@vger.kernel.org>; Fri,  1 Jul 2022 06:00:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4683C341CB;
        Fri,  1 Jul 2022 06:00:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656655214;
        bh=6KoAi5sFEYGxxUM7NjvRzq+PIKoGC8fh/hGzl8GTtHE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ZiN0Y8zVlA5Ju1wyiVKI4IObAElZ5Qx2MdS8kY7Ary6Ho0gTxFtge5M6XBAnznKso
         2v50Gn7sCVwLUlbvkQwBzYbQOtK0JsOtzoP2wXf/q2kY3+b46WAdPlrvr5+OCaqUR9
         53haJ+U8MObR0aRRTkkV78szG83qTy4Ex3ROsyXbndYQl/5HgOUKk0b+KmDaJlkvEb
         2zhavwdHWCivRw5LYQMXKyHW5vUuZgXZtw1IIZhH5j8oYw4s5C/besD/efRPATAIyu
         vP8IGjjRqDlUgoDrUrSJmNV39dhEBWabT+rALz3qGxAoVtsZYfIkkuBBsXg62mIfwC
         KZxZ5+o5IbSUA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 96833E49BB8;
        Fri,  1 Jul 2022 06:00:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: gianfar: add support for software TX
 timestamping
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165665521461.30449.2734316829108600419.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Jul 2022 06:00:14 +0000
References: <20220629181335.3800821-1-vladimir.oltean@nxp.com>
In-Reply-To: <20220629181335.3800821-1-vladimir.oltean@nxp.com>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, claudiu.manoil@nxp.com,
        richardcochran@gmail.com
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 29 Jun 2022 21:13:35 +0300 you wrote:
> These are required by certain network profiling applications in order to
> measure delays.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  drivers/net/ethernet/freescale/gianfar.c         | 1 +
>  drivers/net/ethernet/freescale/gianfar_ethtool.c | 6 +++++-
>  2 files changed, 6 insertions(+), 1 deletion(-)

Here is the summary with links:
  - [net-next] net: gianfar: add support for software TX timestamping
    https://git.kernel.org/netdev/net-next/c/c7e5c423cb59

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


