Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4642B69417D
	for <lists+netdev@lfdr.de>; Mon, 13 Feb 2023 10:41:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230142AbjBMJk6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Feb 2023 04:40:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48258 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229768AbjBMJk4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Feb 2023 04:40:56 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C4716E88;
        Mon, 13 Feb 2023 01:40:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 449A5B80EF5;
        Mon, 13 Feb 2023 09:40:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E2218C433D2;
        Mon, 13 Feb 2023 09:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676281217;
        bh=A+9l9+481tvhhb7T3cOLIvFacCEKnI3xdlQwdevDYiY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fUNMS3UePQdMGIxkurubNSmhdvtdc0BJpwJfgHDeaLHraIDSzgF9dqj4TcGD1AB2q
         yGDTgLbNnueZhQkCShVy6ujjxndmfvIYG1x1KyIjl36VCUG7yvTbl2mZWcNhaPhR89
         vN3aRVAavFIgc7gkZhIvFbh6k0nn0FhRvSHaGpjJdK3xTkcuph2k2H6TCdWwU2pBUU
         YZ2Rjhgnel+PO2wFfhEqZwW3iCIKy1SQAIXmokZSoBwAqaM6uvdt6p6F+nSD3vO9eq
         whO+LQBj718wxJ032NHnot89nrFariMAaBk7qcIZI1OQuLP4U3Mb7WT7ytDL+VCl6k
         J/8JSKIZ2CgYw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BEFD0E68D2E;
        Mon, 13 Feb 2023 09:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v3] net: openvswitch: fix possible memory leak in
 ovs_meter_cmd_set()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167628121777.7814.15764238792586665267.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Feb 2023 09:40:17 +0000
References: <20230210020551.6682-1-hbh25y@gmail.com>
In-Reply-To: <20230210020551.6682-1-hbh25y@gmail.com>
To:     Hangyu Hua <hbh25y@gmail.com>
Cc:     pshelar@ovn.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, xiangxia.m.yue@gmail.com,
        simon.horman@corigine.com, echaudro@redhat.com,
        netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 10 Feb 2023 10:05:51 +0800 you wrote:
> old_meter needs to be free after it is detached regardless of whether
> the new meter is successfully attached.
> 
> Fixes: c7c4c44c9a95 ("net: openvswitch: expand the meters supported number")
> Signed-off-by: Hangyu Hua <hbh25y@gmail.com>
> ---
> 
> [...]

Here is the summary with links:
  - [v3] net: openvswitch: fix possible memory leak in ovs_meter_cmd_set()
    https://git.kernel.org/netdev/net/c/2fa28f5c6fcb

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


