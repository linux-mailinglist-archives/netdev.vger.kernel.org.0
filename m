Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1963350FA5A
	for <lists+netdev@lfdr.de>; Tue, 26 Apr 2022 12:25:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345411AbiDZK2B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Apr 2022 06:28:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240759AbiDZK1R (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Apr 2022 06:27:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DDF755BE49
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 03:00:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9464F6142A
        for <netdev@vger.kernel.org>; Tue, 26 Apr 2022 10:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id ED3E9C385A0;
        Tue, 26 Apr 2022 10:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650967212;
        bh=lBo7FKZFyKjQKW5LnJrcKrxcEr1yJTi0fF8n3iAypvI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=laG7XVEo4EMunp95W+O1Jm9VWabDSfrB4FbfjJJBLyl8+w7WP2DaF72fCvli9fwTB
         5Xwq/lnBaCx6I7AM7eMhfh4BOR8Xl0ryO5fCbWFXRCNv1+8j2n6b3KrzdTdfHaPvvo
         WW5KzJHTyUUoMd4zWfsHmwQZdYGLqQoMt3mj3mMoX5+sDZYLc6/ILcCuRBmJ+CpEUx
         935xRlCWiIGZUTVd+Nd+TWwwlLuciazMCoVdVa1EHchMYauu8+qlkFFRYhQbIUveRh
         42ebbmVmnkbb1TWjVQVLiz8EA8kJuK5u4VmwUHkS0E/h2ll5ODbnKETvAYkGQm4g/7
         zBxo84i0ZaFcw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CFAF3E8DD67;
        Tue, 26 Apr 2022 10:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: phy: marvell10g: fix return value on error
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165096721184.19503.728438356781759868.git-patchwork-notify@kernel.org>
Date:   Tue, 26 Apr 2022 10:00:11 +0000
References: <f47cb031aeae873bb008ba35001607304a171a20.1650868058.git.baruch@tkos.co.il>
In-Reply-To: <f47cb031aeae873bb008ba35001607304a171a20.1650868058.git.baruch@tkos.co.il>
To:     Baruch Siach <baruch@tkos.co.il>
Cc:     linux@armlinux.org.uk, kabel@kernel.org, netdev@vger.kernel.org,
        baruch.siach@siklu.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 25 Apr 2022 09:27:38 +0300 you wrote:
> From: Baruch Siach <baruch.siach@siklu.com>
> 
> Return back the error value that we get from phy_read_mmd().
> 
> Fixes: c84786fa8f91 ("net: phy: marvell10g: read copper results from CSSR1")
> Signed-off-by: Baruch Siach <baruch.siach@siklu.com>
> 
> [...]

Here is the summary with links:
  - net: phy: marvell10g: fix return value on error
    https://git.kernel.org/netdev/net/c/0ed9704b660b

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


