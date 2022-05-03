Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 01ED3518348
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 13:30:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234676AbiECLds (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 07:33:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40906 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232574AbiECLdr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 07:33:47 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EC8DAC2D
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 04:30:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8708B81D86
        for <netdev@vger.kernel.org>; Tue,  3 May 2022 11:30:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 66C3BC385B1;
        Tue,  3 May 2022 11:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1651577412;
        bh=m+wLQ2q51cHsLAg/b/lczYnficZ2clXvJsUyhNhhSAU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F1OGV4tJDWu58GVjZleCmb5mYvI0AGmRphk0Zw2Zu+rhpuF9teztQcto1KmK+ctdZ
         qzz2NXThnoC2MRvnYoYEhvaFF9vBZlJTIEgcss3wwF9SRQ43vkiQ++pt2fTeULL8QX
         0MTcASyy/pL7FyNlEZ5OHT6vESgIzsaq97h1/onrGvJMnhvXQJDhrtyCVt3t5D2B3A
         OjtB9K5ihkHxUE3NVo3CYS1kJkZ7oMD44gYHHYCuQuYZz2EspsLOYu2uM5zGye6Ao4
         f1pY9pFqFPfHoN/wbY4I662rNL59hg6QmwkbrWOktbBdVGs/OQs3E64B/iJOzaAJER
         Ce/sAOSggltlw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 48F0CE8DD77;
        Tue,  3 May 2022 11:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 1/2] selftests/net: so_txtime: fix parsing of start time
 stamp on 32 bit systems
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165157741229.13463.17815086401858574439.git-patchwork-notify@kernel.org>
Date:   Tue, 03 May 2022 11:30:12 +0000
References: <20220502094638.1921702-2-mkl@pengutronix.de>
In-Reply-To: <20220502094638.1921702-2-mkl@pengutronix.de>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     netdev@vger.kernel.org, kernel@pengutronix.de, kuba@kernel.org,
        cmllamas@google.com, willemb@google.com
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon,  2 May 2022 11:46:37 +0200 you wrote:
> This patch fixes the parsing of the cmd line supplied start time on 32
> bit systems. A "long" on 32 bit systems is only 32 bit wide and cannot
> hold a timestamp in nano second resolution.
> 
> Fixes: 040806343bb4 ("selftests/net: so_txtime multi-host support")
> Cc: Carlos Llamas <cmllamas@google.com>
> Cc: Willem de Bruijn <willemb@google.com>
> Signed-off-by: Marc Kleine-Budde <mkl@pengutronix.de>
> 
> [...]

Here is the summary with links:
  - [net,1/2] selftests/net: so_txtime: fix parsing of start time stamp on 32 bit systems
    https://git.kernel.org/netdev/net/c/97926d5a847c
  - [net,2/2] selftests/net: so_txtime: usage(): fix documentation of default clock
    https://git.kernel.org/netdev/net/c/f5c2174a3775

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


