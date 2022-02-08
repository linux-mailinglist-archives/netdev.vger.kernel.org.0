Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A53674AD001
	for <lists+netdev@lfdr.de>; Tue,  8 Feb 2022 05:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238819AbiBHEAM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Feb 2022 23:00:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230298AbiBHEAL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Feb 2022 23:00:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D7185C0401DC
        for <netdev@vger.kernel.org>; Mon,  7 Feb 2022 20:00:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A257161542
        for <netdev@vger.kernel.org>; Tue,  8 Feb 2022 04:00:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11D4CC340E9;
        Tue,  8 Feb 2022 04:00:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644292809;
        bh=sPnAHgQAfr1ZqnNxZXZHAFkG+E4MAj1qk3iLGyTUowg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ueDgBe/mGpBaWBGBgCou26IkcD6BTF8TZJSg+D29TzEtJL/7v/+EavR3pTvMuUlj0
         ADZdkHbCNLpBuZUXtohYInGvtkkBmjxWMXtbN6U/qQkTApHm23CRLXCZ8e+O55Rgj7
         onsY6wdkBw5uXtz30y/meDHMwYPtQ8IbxHfDm3jR8xylzeyORMqsoO8QUhuPFo/aeP
         C2v0iSObPxSCONay1o+vnuVXu5rbbZVMbL0xh/m379UUMLODurBHPR4ePZGv+J82bl
         f3H3vXVYLgCtk8Lh0I+e95sQzEAM4aRWrtH7T7NAO93HVuWLiBD9acq4u7HMijw9Nb
         tZATrBdn66jMw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id EB6DAE6BB3D;
        Tue,  8 Feb 2022 04:00:08 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: typhoon: include <net/vxlan.h>
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164429280896.26406.10672367394832135312.git-patchwork-notify@kernel.org>
Date:   Tue, 08 Feb 2022 04:00:08 +0000
References: <20220208003502.1799728-1-eric.dumazet@gmail.com>
In-Reply-To: <20220208003502.1799728-1-eric.dumazet@gmail.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        edumazet@google.com
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

On Mon,  7 Feb 2022 16:35:02 -0800 you wrote:
> From: Eric Dumazet <edumazet@google.com>
> 
> We need this to get vxlan_features_check() definition.
> 
> Fixes: d2692eee05b8 ("net: typhoon: implement ndo_features_check method")
> Signed-off-by: Eric Dumazet <edumazet@google.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net: typhoon: include <net/vxlan.h>
    https://git.kernel.org/netdev/net-next/c/d1d5bd647c49

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


