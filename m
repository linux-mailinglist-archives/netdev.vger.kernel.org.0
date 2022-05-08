Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 801BA51F1B1
	for <lists+netdev@lfdr.de>; Sun,  8 May 2022 22:50:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232809AbiEHUyI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 8 May 2022 16:54:08 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35794 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232844AbiEHUyG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 8 May 2022 16:54:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3FFD165B4
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 13:50:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1F28B80E8F
        for <netdev@vger.kernel.org>; Sun,  8 May 2022 20:50:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B40F5C385B3;
        Sun,  8 May 2022 20:50:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652043012;
        bh=kvHimcYV+nq5QxUCfS8EaXujOyCtkjXMrd0uGB19TOQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=iz/qsrrKUHu2W2E/hWWiFHulkVyNXhjkYMhLv25SQopd9qPhQdrGTVVONkbjMyG9I
         rO82AFgu0HpYbTcll5DpZkBH+Pq5NgyHNZjnGaeUVKNBxZQpvNalXHm4gaq8u5/AWA
         Pvmq06VRE2zaM0P40SSrlaMpZSA9Hk+yMFxmgiuReMNxDDRFwt9Gj7CV1HT/dmxf6T
         /lPQIemmGdcbxd87bkpEI+wSLsE8oHlYo+nd3fKB3QDVhUKl/V4voXUXjpdxcUxAi/
         gdk05/S0SAJ25Ztj6e9iX6M43a+LxybXQcNDT6YXRSx0Sgf0encLXF+YJ7Ha0GcwaK
         G6NcQ1IWMQAoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9E847F03876;
        Sun,  8 May 2022 20:50:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH ethtool-next v3 0/2] Add support to get/set tx push by ethtool
 -G/g
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165204301264.30767.10690359782009256931.git-patchwork-notify@kernel.org>
Date:   Sun, 08 May 2022 20:50:12 +0000
References: <20220429091704.21258-1-huangguangbin2@huawei.com>
In-Reply-To: <20220429091704.21258-1-huangguangbin2@huawei.com>
To:     huangguangbin (A) <huangguangbin2@huawei.com>
Cc:     mkubecek@suse.cz, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, lipeng321@huawei.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to ethtool/ethtool.git (next)
by Michal Kubecek <mkubecek@suse.cz>:

On Fri, 29 Apr 2022 17:17:02 +0800 you wrote:
> From: Jie Wang <wangjie125@huawei.com>
> 
> These two patches first update uapi headers by using the import shell, then
> add support to get/set tx push by ethtool -G/g.
> 
> Changelog:
> v2->v3
> 1.Revise the min_argc value of tx-push.
> link:https://lore.kernel.org/netdev/20220421084646.15458-1-huangguangbin2@huawei.com/
> 
> [...]

Here is the summary with links:
  - [ethtool-next,v3,1/2] update UAPI header copies
    https://git.kernel.org/pub/scm/network/ethtool/ethtool.git/commit/?id=bd138ee083c4
  - [ethtool-next,v3,2/2] ethtool: add support to get/set tx push by ethtool -G/g
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


