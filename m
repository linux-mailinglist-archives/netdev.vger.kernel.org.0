Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D7D5852E15D
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 02:50:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344127AbiETAuR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 May 2022 20:50:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232937AbiETAuP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 May 2022 20:50:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55EE7131F1E
        for <netdev@vger.kernel.org>; Thu, 19 May 2022 17:50:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0B7ECB8293F
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 00:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BA522C385B8;
        Fri, 20 May 2022 00:50:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1653007811;
        bh=GGnxR5uXNoZXq5sM0U5uqYpxBDVHf/bkw0J43CfkQIY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dJAh84oj76SIyzAP/1ljQqmOakG4ilsJDYAkGwbToI7VnqoE+MnrOVGLh1S6RUYgq
         Elx88XwkC+JV/+b0+0wTdxJl7twAmPLI+/IsCUIMVZ0zl06ULg99Lw41RAe+YXtMUA
         rilWYNC7Q4cjJEG9T7GwgLn+4To+zbcgbHvpHoY7HB3WxITcA0POh6ddUA0PNbBgki
         T7PLXbfyMFC0bOBu1CORTIcfDYNZWa3r4+SLZBg9KKlg4mMVv7Waqj3m4csN2LGpSN
         1u/sqj7RX7iceseyxCXVQgMd2DZuobsdDO5Tl95grSpaMvCFWnD65pl6TyS9fANwJV
         cqUg8m0V50fuQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9B98DF03935;
        Fri, 20 May 2022 00:50:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv3 net] Documentation: add description for
 net.core.gro_normal_batch
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165300781163.9691.10540742307161386869.git-patchwork-notify@kernel.org>
Date:   Fri, 20 May 2022 00:50:11 +0000
References: <acf8a2c03b91bcde11f67ff89b6050089c0712a3.1652888963.git.lucien.xin@gmail.com>
In-Reply-To: <acf8a2c03b91bcde11f67ff89b6050089c0712a3.1652888963.git.lucien.xin@gmail.com>
To:     Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        ecree@solarflare.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed, 18 May 2022 12:09:15 -0400 you wrote:
> Describe it in admin-guide/sysctl/net.rst like other Network core options.
> Users need to know gro_normal_batch for performance tuning.
> 
> Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
> Reported-by: Prijesh Patel <prpatel@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>
> 
> [...]

Here is the summary with links:
  - [PATCHv3,net] Documentation: add description for net.core.gro_normal_batch
    https://git.kernel.org/netdev/net/c/582a2dbc72ac

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


