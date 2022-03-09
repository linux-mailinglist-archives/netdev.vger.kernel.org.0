Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 301774D2DA8
	for <lists+netdev@lfdr.de>; Wed,  9 Mar 2022 12:10:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231588AbiCILLN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 06:11:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60180 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229593AbiCILLM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 06:11:12 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [145.40.73.55])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 77A0116F940
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 03:10:14 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id DC3CECE1DF8
        for <netdev@vger.kernel.org>; Wed,  9 Mar 2022 11:10:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 54435C340F4;
        Wed,  9 Mar 2022 11:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646824211;
        bh=IIWYutN7Jb1GwEEjkgK9aMqmJsOUAlIMpCwQsCxbE4s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=t0N2T0tNVBxWWni39oaGrd+2k8YVcVrqhgiqWBkyV925jZdQUjHUKjy8FXPRcIrpz
         LOzX/AQM8n6rxoetAhrUpdx6DE4II2MS8nkebm5IDGmoiWtnicNgAXVHpDkjwWqWBZ
         NC5GdeecLmy/lz8qf3GqkbMyOnQ5UR2lHGsonSFFuMOBOgkvS8SVwKyP4UQU1OsN/N
         pXmZEx/hknG+oLcyuQwBnhzFp4ex1rrAkVDXXYA22JqvvQHrPPoN2EP28N6C8Bc5WU
         LljVvQsGzox5Lrf6KpvLWPnTpNyHFk1VGgSBJcY7OXybXY2f0f8MPL3QrpxM5GOS/A
         ioukAvUvTN44A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 31F60E8DD5B;
        Wed,  9 Mar 2022 11:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/2] ptp: ocp: update devlink information
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164682421119.10972.15834919116382444719.git-patchwork-notify@kernel.org>
Date:   Wed, 09 Mar 2022 11:10:11 +0000
References: <20220308000536.2278-1-jonathan.lemon@gmail.com>
In-Reply-To: <20220308000536.2278-1-jonathan.lemon@gmail.com>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        richardcochran@gmail.com, kernel-team@fb.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon,  7 Mar 2022 16:05:33 -0800 you wrote:
> Both of these patches update the information displayed via devlink.
> 
> v1 -> v2: remove board.manufacture information
> 
> Jonathan Lemon (2):
>   ptp: ocp: add nvmem interface for accessing eeprom
>   ptp: ocp: Update devlink firmware display path.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] ptp: ocp: add nvmem interface for accessing eeprom
    (no matching commit)
  - [net-next,v2,2/2] ptp: ocp: Update devlink firmware display path.
    https://git.kernel.org/netdev/net-next/c/b0ca789ade4e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


