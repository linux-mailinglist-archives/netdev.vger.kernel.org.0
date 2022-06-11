Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 493B254723C
	for <lists+netdev@lfdr.de>; Sat, 11 Jun 2022 07:30:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1345447AbiFKFa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 11 Jun 2022 01:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49524 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229643AbiFKFaZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 11 Jun 2022 01:30:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1368A29A
        for <netdev@vger.kernel.org>; Fri, 10 Jun 2022 22:30:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 51A60B8389F
        for <netdev@vger.kernel.org>; Sat, 11 Jun 2022 05:30:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DFE32C34116;
        Sat, 11 Jun 2022 05:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654925414;
        bh=Ak/niIvp9K90rkmgnQe3ORJQw5Hceu6RCl0gLsHXtlI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ND7+e9id/MQxGHrog9dqatpT0rmc3nMfXLmtaG6/alYSzlhVKDjUiXRrOwUg1rfzk
         Bqdk2ZSlfC+89aem8QGdxUVKv341Yvk5vG2QsmYN+okl37x9L6jiC70D4/pvj1dslj
         zOkb3YRL60IwkuYFG7Tqm0Pfh10ivzaJo3G4rNF9Gufs9eNFwF5FPzwaP7SYgGLlKF
         DYn577YmF8h3BEbk48QKMpj3ClrJotZeUHRcXwFykzXdThf0K/SXlWPt7FmaXHKxnj
         4N2pjIjRi7fEAma/KQfRBL9RRyxsiK3jBnc5f/4GrbVIstYo/sFHnRmm3OCyLHDZQN
         AKhM4XuQFJG+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C553FE737E8;
        Sat, 11 Jun 2022 05:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ethernet: Remove vf rate limit check for drivers
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165492541280.21310.3317091740668140358.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Jun 2022 05:30:12 +0000
References: <20220609084717.155154-1-simon.horman@corigine.com>
In-Reply-To: <20220609084717.155154-1-simon.horman@corigine.com>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        michael.chan@broadcom.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, shshaikh@marvell.com,
        manishc@marvell.com, bin.chen@corigine.com,
        GR-Linux-NIC-Dev@marvell.com, netdev@vger.kernel.org,
        oss-drivers@corigine.com
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu,  9 Jun 2022 10:47:17 +0200 you wrote:
> From: Bin Chen <bin.chen@corigine.com>
> 
> The commit a14857c27a50 ("rtnetlink: verify rate parameters for calls to
> ndo_set_vf_rate") has been merged to master, so we can to remove the
> now-duplicate checks in drivers.
> 
> Signed-off-by: Bin Chen <bin.chen@corigine.com>
> Signed-off-by: Baowen Zheng <baowen.zheng@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>
> 
> [...]

Here is the summary with links:
  - [net-next] ethernet: Remove vf rate limit check for drivers
    https://git.kernel.org/netdev/net-next/c/10e11aa241b6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


