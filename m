Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 372454FEAD4
	for <lists+netdev@lfdr.de>; Wed, 13 Apr 2022 01:47:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229757AbiDLXX6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Apr 2022 19:23:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38890 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229851AbiDLXXj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Apr 2022 19:23:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB7BAC624E;
        Tue, 12 Apr 2022 15:10:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8623261BF7;
        Tue, 12 Apr 2022 22:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DDF8DC385A6;
        Tue, 12 Apr 2022 22:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649801411;
        bh=FVSj0lOGvvb3HXMxRnbZoXrT1E63ovpzxIrxbGjc/sw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=XEMhBF7EwUMWB17KuKpx9/gWtVyONWG7l6RfJzN8PkUXwg3qcPg7uOkZ5HdR7r26E
         85V4QU8+wz1I0cAKirHXsPvgGj2mkGc9PZnt6a318OM8Lwj78FxCZ6C0BrM5Bfiedd
         6jeAPvtr+as23GbDpDfR+vJTYFtBZ39Vb7y/xwuAidf6bzKezOltF89dct4M5WLJlt
         7C0wU4cHUxojB848j92xzVm+lY/L1AY7lqd7i8ojoRrxVRBQwAOwHnTWMY7hsmuIRs
         +vdWWdXdwt/B0UIO5YML+/cjnFudxVlGO9/J7LHluF//sOINaI5oyFYbg44ZxsB/Uo
         0txXiroN+99Yg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C28EEE8DD5E;
        Tue, 12 Apr 2022 22:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: ethernet: ti: cpsw: using pm_runtime_resume_and_get
 instead of pm_runtime_get_sync
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164980141178.23707.6487250151637734930.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Apr 2022 22:10:11 +0000
References: <20220412082847.2532584-1-chi.minghao@zte.com.cn>
In-Reply-To: <20220412082847.2532584-1-chi.minghao@zte.com.cn>
To:     CGEL <cgel.zte@gmail.com>
Cc:     grygorii.strashko@ti.com, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, linux-omap@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        chi.minghao@zte.com.cn, zealci@zte.com.cn
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

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 12 Apr 2022 08:28:47 +0000 you wrote:
> From: Minghao Chi <chi.minghao@zte.com.cn>
> 
> Using pm_runtime_resume_and_get() to replace pm_runtime_get_sync and
> pm_runtime_put_noidle. This change is just to simplify the code, no
> actual functional changes.
> 
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Minghao Chi <chi.minghao@zte.com.cn>
> 
> [...]

Here is the summary with links:
  - net: ethernet: ti: cpsw: using pm_runtime_resume_and_get instead of pm_runtime_get_sync
    https://git.kernel.org/netdev/net-next/c/2e5b3d4cb16e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


