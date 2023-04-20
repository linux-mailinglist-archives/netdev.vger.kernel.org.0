Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DB4C16E87C3
	for <lists+netdev@lfdr.de>; Thu, 20 Apr 2023 04:01:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230406AbjDTCBJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Apr 2023 22:01:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55570 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232589AbjDTCAp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 19 Apr 2023 22:00:45 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F6B34682
        for <netdev@vger.kernel.org>; Wed, 19 Apr 2023 19:00:21 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC5D264472
        for <netdev@vger.kernel.org>; Thu, 20 Apr 2023 02:00:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 20384C4339B;
        Thu, 20 Apr 2023 02:00:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681956020;
        bh=9+70ARHh/xC6N7/oBFVw/s5NinD2OW9TB14eNlHqBuE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LHXh7VXmsH2vNyuRpWRwlkA3DZ26wsuUUvncNg6xs6wdJS/qXHKcXylsbFQ3Jsdmh
         xhGi3LkJt1Gke0gymRYEosF3Bb3QGSH9uLaMSjnk8pYnlU9stDgHrBvdR6xYuuW6Vm
         vQ75LlyWKOKqGRfgwQzqVR+UKEz3SwCQmEJNt3wzXjvSZwUu2MPCBUJzo5sbxl3Jrq
         ej8FeEkiZTeCkcdMBJVlgJBrG9sgDvr/HCjW/Of3GFIVmboWJKA52r7jeeLG6LEf3J
         dYxbjCcHmNabWxYkyEAtZuRQ2A1LnwSmaOkqrea8oFaV52FwOSdBV7pyiKWlXgkv7D
         QGu0QKl/CRLMg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 050D4C561EE;
        Thu, 20 Apr 2023 02:00:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] Revert "net/mlx5: Enable management PF initialization"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168195602001.17998.1803027075582992398.git-patchwork-notify@kernel.org>
Date:   Thu, 20 Apr 2023 02:00:20 +0000
References: <20230413222547.56901-1-kuba@kernel.org>
In-Reply-To: <20230413222547.56901-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, paul@paul-moore.com, saeedm@nvidia.com,
        leon@kernel.org, eranbe@nvidia.com, shayd@nvidia.com,
        moshe@nvidia.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 13 Apr 2023 15:25:47 -0700 you wrote:
> This reverts commit fe998a3c77b9f989a30a2a01fb00d3729a6d53a4.
> 
> Paul reports that it causes a regression with IB on CX4
> and FW 12.18.1000. In addition I think that the concept
> of "management PF" is not fully accepted and requires
> a discussion.
> 
> [...]

Here is the summary with links:
  - [net] Revert "net/mlx5: Enable management PF initialization"
    https://git.kernel.org/netdev/net/c/f52cc627b832

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


