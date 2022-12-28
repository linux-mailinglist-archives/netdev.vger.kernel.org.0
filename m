Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DBCD1657540
	for <lists+netdev@lfdr.de>; Wed, 28 Dec 2022 11:20:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232758AbiL1KUZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 28 Dec 2022 05:20:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232658AbiL1KUW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 28 Dec 2022 05:20:22 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE667101CF;
        Wed, 28 Dec 2022 02:20:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4E7A1B81628;
        Wed, 28 Dec 2022 10:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 048F8C433D2;
        Wed, 28 Dec 2022 10:20:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672222816;
        bh=rnSkTkijHSD25HXVoeDuPkC+Os1HjJg5x2qSFd7fjKk=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ji3m7FqrJdXyRXQGyGxgOguXJApdrGPtDdRVVBD5TBWogMlaj/A2eAE4RhUfFaObm
         B66nsgDa9CW69Aky+KQeQcJqQEkllRbhMptiRdEtejh4RywV0Ncw2fYKnt7RPXRAgI
         ExTctdT0G2HBdUPZys+LUqm7+YYd81bqXjA7A7yPmga8Q2dqWD7IQshVY8BjE3i5ax
         RrKT486Ra6nzNPIK+z82v/Wra5JmNIyvDs0wg9/TyWIUc9023l6zIyB9/TPG89itPB
         Z0Ciy/haTOqypDq+OgALu9hsU4fXh/7s2qH27wwxDd/HGSSkk/tUiS8vN/XNv5JbI0
         2yJElDV56DyCA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D3A69E50D72;
        Wed, 28 Dec 2022 10:20:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/5] bnxt_en: Bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167222281586.11291.7480486130037156484.git-patchwork-notify@kernel.org>
Date:   Wed, 28 Dec 2022 10:20:15 +0000
References: <1672111180-19463-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1672111180-19463-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, bpf@vger.kernel.org,
        gospo@broadcom.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 26 Dec 2022 22:19:35 -0500 you wrote:
> This series fixes a devlink bug and several XDP related bugs.  The
> devlink bug causes a kernel crash on VF devices.  The XDP driver
> patches fix and clean up the RX XDP path and re-enable header-data
> split that was disabled by mistake when adding the XDP multi-buffer
> support.
> 
> Michael Chan (4):
>   bnxt_en: Simplify bnxt_xdp_buff_init()
>   bnxt_en: Fix XDP RX path
>   bnxt_en: Fix first buffer size calculations for XDP multi-buffer
>   bnxt_en: Fix HDS and jumbo thresholds for RX packets
> 
> [...]

Here is the summary with links:
  - [net,1/5] bnxt_en: fix devlink port registration to netdev
    https://git.kernel.org/netdev/net/c/0020ae2a4aa8
  - [net,2/5] bnxt_en: Simplify bnxt_xdp_buff_init()
    https://git.kernel.org/netdev/net/c/bbfc17e50ba2
  - [net,3/5] bnxt_en: Fix XDP RX path
    https://git.kernel.org/netdev/net/c/9b3e607871ea
  - [net,4/5] bnxt_en: Fix first buffer size calculations for XDP multi-buffer
    https://git.kernel.org/netdev/net/c/1abeacc1979f
  - [net,5/5] bnxt_en: Fix HDS and jumbo thresholds for RX packets
    https://git.kernel.org/netdev/net/c/a056ebcc30e2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


