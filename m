Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A0FB56B86A2
	for <lists+netdev@lfdr.de>; Tue, 14 Mar 2023 01:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbjCNAKW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 20:10:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229664AbjCNAKU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 20:10:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67A6A5FA51;
        Mon, 13 Mar 2023 17:10:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EA55061572;
        Tue, 14 Mar 2023 00:10:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 48C11C4339B;
        Tue, 14 Mar 2023 00:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678752618;
        bh=M641l2gDbCVmX3wa9BEJ4ORnVbPvhgTsIZ5XjJlUPIk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=PHBEU0vI7AtWnoBFwJ5LBflxoD6Yp0KnjTk4LLkEzpvsS0EVz2nyTqAeF4t0PbdeV
         nf2FQJAWbDwBxSmLefFKrdHlEGY2AL5uIRWP89OD4S/L86uJ55nKR5ynzEnNt97GMT
         kovfzXpaB/xEOtFFNmhNpFVJX8TDTfY8Kj8/oASJ5OF85MTLDe0wk9IWl0q12r8X0V
         L77AGFNg2FZTIk3lV7WYkqnlVYiCo+1LhCwZmUYn2RZcUaz1UAptaluaSXNKeipZYw
         2DS4NKcjxqCMl3CpPKJa80Tv1XVMDJ5zr+pKO9XOcRlsM86bKyG3wrOFl04d6pznEI
         4DrW5Y1OTz4mw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 26624E66CB9;
        Tue, 14 Mar 2023 00:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] qed/qed_dev: guard against a possible division by zero
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167875261815.15210.17693965732885071826.git-patchwork-notify@kernel.org>
Date:   Tue, 14 Mar 2023 00:10:18 +0000
References: <20230309201556.191392-1-d-tatianin@yandex-team.ru>
In-Reply-To: <20230309201556.191392-1-d-tatianin@yandex-team.ru>
To:     Daniil Tatianin <d-tatianin@yandex-team.ru>
Cc:     aelior@marvell.com, manishc@marvell.com, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        Yuval.Mintz@qlogic.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, simon.horman@corigine.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  9 Mar 2023 23:15:56 +0300 you wrote:
> Previously we would divide total_left_rate by zero if num_vports
> happened to be 1 because non_requested_count is calculated as
> num_vports - req_count. Guard against this by validating num_vports at
> the beginning and returning an error otherwise.
> 
> Found by Linux Verification Center (linuxtesting.org) with the SVACE
> static analysis tool.
> 
> [...]

Here is the summary with links:
  - [v2] qed/qed_dev: guard against a possible division by zero
    https://git.kernel.org/netdev/net/c/1a9dc5610ef8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


