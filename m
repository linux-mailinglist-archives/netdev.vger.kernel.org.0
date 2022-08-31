Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 836695A7697
	for <lists+netdev@lfdr.de>; Wed, 31 Aug 2022 08:30:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229935AbiHaGa1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 31 Aug 2022 02:30:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48728 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230242AbiHaGaX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 31 Aug 2022 02:30:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D19435A2CB
        for <netdev@vger.kernel.org>; Tue, 30 Aug 2022 23:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 52C55B81F41
        for <netdev@vger.kernel.org>; Wed, 31 Aug 2022 06:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 08CADC4347C;
        Wed, 31 Aug 2022 06:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661927418;
        bh=s0UZY0H6RiF7jHCOpaVf2BouM7YaGuJEDvirZ9/CCow=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C4PPZh8CGjqtFkgD3DUDHCQimk1jernzgsjXsE9oNW+xEAukBt2wdWDg6sWC5OAiW
         JeccSMJV/nV69iGzDNme/vVkcBM13dpPJHXs7tl06DrW6Z9E1PqYzFIDcPQfQW2pWU
         bU6XtR8Yj2E/StMwpfHQaEtkp1f8uD1AHr0ts5wcZSuX/4S7Zx6xf41+wclF/YwBBj
         vxZ/rXmmSNwFz2f2mvU0uLkg+stJqIYj829n/to5GcNvCD9WQO+Xv/yFPqMZnte0H2
         eM25M+GWuQH5DjF1mJW4jmPywTQb9KUiOsonGoEhBd32s7RQ4XN/Jb+jkAKnW/7/MR
         got33PUnqkCNQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DDA57E924DC;
        Wed, 31 Aug 2022 06:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Revert "net: devlink: add RNLT lock assertion to
 devlink_compat_switch_id_get()"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166192741790.4297.12605146141371989165.git-patchwork-notify@kernel.org>
Date:   Wed, 31 Aug 2022 06:30:17 +0000
References: <20220829121324.3980376-1-vladbu@nvidia.com>
In-Reply-To: <20220829121324.3980376-1-vladbu@nvidia.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     davem@davemloft.net, jiri@resnulli.us, kuba@kernel.org,
        netdev@vger.kernel.org, maord@nvidia.com, saeedm@nvidia.com,
        leon@kernel.org, roid@nvidia.com, jiri@nvidia.com
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

On Mon, 29 Aug 2022 14:13:24 +0200 you wrote:
> This reverts commit 6005a8aecee8afeba826295321a612ab485c230e.
> 
> The assertion was intentionally removed in commit 043b8413e8c0 ("net:
> devlink: remove redundant rtnl lock assert") and, contrary what is
> described in the commit message, the comment reflects that: "Caller must
> hold RTNL mutex or reference to dev...".
> 
> [...]

Here is the summary with links:
  - [net-next] Revert "net: devlink: add RNLT lock assertion to devlink_compat_switch_id_get()"
    https://git.kernel.org/netdev/net-next/c/21cb860c7f31

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


