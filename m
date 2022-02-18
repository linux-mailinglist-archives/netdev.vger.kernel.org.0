Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8075E4BB7D6
	for <lists+netdev@lfdr.de>; Fri, 18 Feb 2022 12:11:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234486AbiBRLKe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Feb 2022 06:10:34 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:36066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232621AbiBRLKd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Feb 2022 06:10:33 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BB2A2B4614
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 03:10:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3FFA9B825DC
        for <netdev@vger.kernel.org>; Fri, 18 Feb 2022 11:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E2BE3C340F9;
        Fri, 18 Feb 2022 11:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645182610;
        bh=cCbT1KlWYz7gRp2My9K9ANPkibXcS8wbI/HWM25cxOk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=poc6NJB8dDJ8HTMShg7YT2RlmPZyC1PWwxIONUrOAb1f7ev7uLOCnCWYobyWTFnhP
         7eAqFXiW8EOUllYpIzMUd18V+9xP8Tw7vEcJnswhsQNtc8xxu56CS0X3VeWAIVco4K
         WRpQMHhcCBnXEP56AEYxebvQLt3wUZTCWEs+LwlU/apeN/2eB/CzRWAHl0wV8mKb1B
         je2HmgcX7KrDaoVr2as2komG/k3KpZN/lDWceNEX+U3sKhLujd0lPpZRcik4bjLMKc
         abHzsLqSVfv12IQNuvGXt1kSoLVaZSr3oCrEdRCYJbii/3g5Ktk3Pnka5UwLjiMG9H
         9g7K5T18kyYuQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D1DE2E7BB07;
        Fri, 18 Feb 2022 11:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: gro: Fix a 'directive in macro's argument
 list' sparse warning
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164518261085.25032.15319527109605279762.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Feb 2022 11:10:10 +0000
References: <20220217080755.19195-1-gal@nvidia.com>
In-Reply-To: <20220217080755.19195-1-gal@nvidia.com>
To:     Gal Pressman <gal@nvidia.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        pabeni@redhat.com, maximmi@nvidia.com, alexandr.lobakin@intel.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 17 Feb 2022 10:07:55 +0200 you wrote:
> Following the cited commit, sparse started complaining about:
> ../include/net/gro.h:58:1: warning: directive in macro's argument list
> ../include/net/gro.h:59:1: warning: directive in macro's argument list
> 
> Fix that by moving the defines out of the struct_group() macro.
> 
> Fixes: de5a1f3ce4c8 ("net: gro: minor optimization for dev_gro_receive()")
> Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Signed-off-by: Gal Pressman <gal@nvidia.com>
> Acked-by: Alexander Lobakin <alexandr.lobakin@intel.com>
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: gro: Fix a 'directive in macro's argument list' sparse warning
    https://git.kernel.org/netdev/net-next/c/8467fadc115c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


