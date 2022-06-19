Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0279555096E
	for <lists+netdev@lfdr.de>; Sun, 19 Jun 2022 11:00:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232255AbiFSJAQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 19 Jun 2022 05:00:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229777AbiFSJAO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 19 Jun 2022 05:00:14 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A82F32611;
        Sun, 19 Jun 2022 02:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4104760F8A;
        Sun, 19 Jun 2022 09:00:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 97FCAC341C6;
        Sun, 19 Jun 2022 09:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655629212;
        bh=ZhYCdmPIkvBb4HiRdGew2hPBVtn9FRzBnCVE2BGxsRA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hYe2MYazvyublmt1ixzcq923LmVnDEdkkvnqgdvDIGqFWp42osp/nXF+UvgDXQFmG
         bDLJMaUN4pPhOBMPuhkKMj3/+HHun4fcmrhD6WGC5iMthMtwHs+ylPW+98zE2JEIWK
         elqxQXAyuz6ZwWRR9h/389RkXGsZ1XEoOGSNvz2lqb2zFRoQtt9OLs0qhsHwX3h0ss
         To9I+vnqI9YbfIAutQLa5hJ1cDLa/pEUV9hHXSReX8yr9P8UBEJ9+0v6mt8IVs2c/4
         LXHFSbEIYx5kwnit4oORiNbkhO+xZA/6wnCuLtPgZhzwlA9tJKqbaKXv8AMi9QFlIQ
         hot8l6tweGRvQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 80133E7387A;
        Sun, 19 Jun 2022 09:00:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH] net: ethernet: stmmac: remove select QCOM_SOCINFO
 and make it optional
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165562921252.21034.212967862593750465.git-patchwork-notify@kernel.org>
Date:   Sun, 19 Jun 2022 09:00:12 +0000
References: <20220616221554.22040-1-ansuelsmth@gmail.com>
In-Reply-To: <20220616221554.22040-1-ansuelsmth@gmail.com>
To:     Christian Marangi <ansuelsmth@gmail.com>
Cc:     peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, mcoquelin.stm32@gmail.com,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        lkp@intel.com
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

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 17 Jun 2022 00:15:54 +0200 you wrote:
> QCOM_SOCINFO depends on QCOM_SMEM but is not selected, this cause some
> problems with QCOM_SOCINFO getting selected with the dependency of
> QCOM_SMEM not met.
> To fix this remove the select in Kconfig and add additional info in the
> DWMAC_IPQ806X config description.
> 
> Reported-by: kernel test robot <lkp@intel.com>
> Fixes: 9ec092d2feb6 ("net: ethernet: stmmac: add missing sgmii configure for ipq806x")
> Signed-off-by: Christian Marangi <ansuelsmth@gmail.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: stmmac: remove select QCOM_SOCINFO and make it optional
    https://git.kernel.org/netdev/net-next/c/c205035e3adb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


