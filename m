Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1EF675FA9E8
	for <lists+netdev@lfdr.de>; Tue, 11 Oct 2022 03:20:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229531AbiJKBU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Oct 2022 21:20:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbiJKBUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Oct 2022 21:20:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5BD4982605
        for <netdev@vger.kernel.org>; Mon, 10 Oct 2022 18:20:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 1D49AB811C0
        for <netdev@vger.kernel.org>; Tue, 11 Oct 2022 01:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A2808C433B5;
        Tue, 11 Oct 2022 01:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1665451215;
        bh=gUOuj6nJd1mhc56D90B9Z/JvUt0dcCljSJz5HLapaLg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=g37UHJrGz+WfTr2nleoXtJfC7lLd7R++X6IMiEK9lS4whBscJcOYbeGCGVp1XTr+L
         QJQaGwlKYRCqICSlrscKW3dF1PKXCWX8vJb+8N+0LHc9MxMxg+uX1n1DlZWjHP70Fg
         SxWE2TY+jmQMU357yJDaIlxGt8GzeYxTjNO+1ClncU3CU5pAhc5ISAyTtL2cHGsIqw
         8VMtIWgkDclk0ysBZY/VLU/w8Spvoj2NO0/kWFEuBIindUk9v1wFxP79kALrqWzKUn
         FN+WNyKvk8MD8xnAk3NKBIYY9vb1HWrlYgzKR05qD6/I14/zpGXa1AwupSDpeLmzOH
         LpPHYJr9sW4wg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 85499E4D024;
        Tue, 11 Oct 2022 01:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: sfp: fill also 5gbase-r and 25gbase-r modes in
 sfp_parse_support()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166545121554.22576.12304234241074213225.git-patchwork-notify@kernel.org>
Date:   Tue, 11 Oct 2022 01:20:15 +0000
References: <20221007084844.20352-1-kabel@kernel.org>
In-Reply-To: <20221007084844.20352-1-kabel@kernel.org>
To:     =?utf-8?q?Marek_Beh=C3=BAn_=3Ckabel=40kernel=2Eorg=3E?=@ci.codeaurora.org
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        rmk+kernel@armlinux.org.uk, andrew@lunn.ch
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri,  7 Oct 2022 10:48:44 +0200 you wrote:
> Fill in also 5gbase-r and 25gbase-r PHY interface modes into the
> phy_interface_t bitmap in sfp_parse_support().
> 
> Fixes: fd580c983031 ("net: sfp: augment SFP parsing with phy_interface_t bitmap")
> Signed-off-by: Marek Behún <kabel@kernel.org>
> ---
>  drivers/net/phy/sfp-bus.c | 3 +++
>  1 file changed, 3 insertions(+)

Here is the summary with links:
  - [net-next] net: sfp: fill also 5gbase-r and 25gbase-r modes in sfp_parse_support()
    https://git.kernel.org/netdev/net/c/5b4c189d660a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


