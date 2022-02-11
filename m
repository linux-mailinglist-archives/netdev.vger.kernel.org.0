Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 162654B3101
	for <lists+netdev@lfdr.de>; Fri, 11 Feb 2022 23:50:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352022AbiBKWuQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Feb 2022 17:50:16 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41174 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344150AbiBKWuN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Feb 2022 17:50:13 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 29885BF7
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 14:50:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id D049FB82DAA
        for <netdev@vger.kernel.org>; Fri, 11 Feb 2022 22:50:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 6D1C8C340EB;
        Fri, 11 Feb 2022 22:50:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644619809;
        bh=VIMIskvAn+M/CciI7eKHFAnHdR/bcmhv+W5JOfzM18Y=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PRHsabB1CgLydidKlwhsep4ZOYuAanHk5QzuRKoBvDbxrI/03E5i+1GfFMuve19F+
         9NTIW1gecQCnwup+a4nVkO/yyPYbJ67lqSMLwmEnX4FhbgwS169dgHndHUSrKFH30V
         EKtKiy1D3D/juxq/3oFn6GQF27Kub/YFWKAsmeHKTE2s/B3OefFaHHQ1PU6gzPmOkB
         mJEwNJBkNDdkzNGLxGUnE7xZ8T66Sfchw52GMHVwO00DisIQH11m8jFIMAoYDrCQyk
         Wn52ZfM/EphaCJTPuE/iuhzL4xWlBlspntnDw2l8AiB2FBRECoRvPHDrhc022CmvBY
         8RWb/kEJu3DIA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 57E30E5CF96;
        Fri, 11 Feb 2022 22:50:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] mctp: serial: Cancel pending work from ndo_uninit handler
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164461980935.21006.7068640188485858438.git-patchwork-notify@kernel.org>
Date:   Fri, 11 Feb 2022 22:50:09 +0000
References: <20220211011552.1861886-1-jk@codeconstruct.com.au>
In-Reply-To: <20220211011552.1861886-1-jk@codeconstruct.com.au>
To:     Jeremy Kerr <jk@codeconstruct.com.au>
Cc:     netdev@vger.kernel.org, matt@codeconstruct.com.au,
        davem@davemloft.net, kuba@kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 11 Feb 2022 09:15:52 +0800 you wrote:
> We cannot do the cancel_work_sync from after the unregister_netdev, as
> the dev pointer is no longer valid, causing a uaf on ldisc unregister
> (or device close).
> 
> Instead, do the cancel_work_sync from the ndo_uninit op, where the dev
> still exists, but the queue has stopped.
> 
> [...]

Here is the summary with links:
  - [net] mctp: serial: Cancel pending work from ndo_uninit handler
    https://git.kernel.org/netdev/net/c/6c342ce2239c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


