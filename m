Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B28146AB177
	for <lists+netdev@lfdr.de>; Sun,  5 Mar 2023 18:00:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229591AbjCERAW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 Mar 2023 12:00:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46594 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjCERAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 Mar 2023 12:00:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B739714EA9
        for <netdev@vger.kernel.org>; Sun,  5 Mar 2023 09:00:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5C0EC60B19
        for <netdev@vger.kernel.org>; Sun,  5 Mar 2023 17:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B4F11C433D2;
        Sun,  5 Mar 2023 17:00:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678035617;
        bh=HYBJ18ETZ77e4DFmD/B9PD/tsS4MwC4HER8x/kR+ijQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=KGAYCbqbKW151ALvgwJ43a8kyHnW2XGuBua4ynCHQjmmgr2uFHAtrN4B//PavlXUu
         bmpX6LfusmN7ZkXIkVJ7sq3DVmxT8vTkoRfagPfIe7YhaJEuHyzkLJ+xff//dpMSJZ
         6mOnFEc0wtOpNLEVb2+25nhDgocd7Rd4zeXhO9FaUI9Oy9rYHRyayRMp+vJSHnQe03
         P+e+CjIg3QfV6Sw0qFB26mWc7RYMoGnCmOTtBmNB/rifTKV6t51osRReqdKexpGuq0
         y3MDcA71y4Hy1CY3Bba3G6ufqvEz3X0jpEjH5hTgF4BXw/vfAfsys/OMDVOM30Jwv0
         KQuAB5fdGjSkA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9B0FCC395F6;
        Sun,  5 Mar 2023 17:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCHv2 iproute2] u32: fix TC_U32_TERMINAL printing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167803561763.1759.16309629205111358425.git-patchwork-notify@kernel.org>
Date:   Sun, 05 Mar 2023 17:00:17 +0000
References: <20230301142100.1533509-1-liuhangbin@gmail.com>
In-Reply-To: <20230301142100.1533509-1-liuhangbin@gmail.com>
To:     Hangbin Liu <liuhangbin@gmail.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org,
        stephen@networkplumber.org, jhs@mojatatu.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2.git (main)
by Stephen Hemminger <stephen@networkplumber.org>:

On Wed,  1 Mar 2023 22:21:00 +0800 you wrote:
> We previously printed an asterisk if there was no 'sel' or 'TC_U32_TERMINAL'
> flag. However, commit 1ff22754 ("u32: fix json formatting of flowid")
> changed the logic to print an asterisk only if there is a 'TC_U32_TERMINAL'
> flag. Therefore, we need to fix this regression.
> 
> Before the fix, the tdc u32 test failed:
> 
> [...]

Here is the summary with links:
  - [PATCHv2,iproute2] u32: fix TC_U32_TERMINAL printing
    https://git.kernel.org/pub/scm/network/iproute2/iproute2.git/commit/?id=2854d69a99f6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


