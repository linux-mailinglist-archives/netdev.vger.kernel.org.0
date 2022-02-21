Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 232B94BE1E0
	for <lists+netdev@lfdr.de>; Mon, 21 Feb 2022 18:53:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234929AbiBUNKi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Feb 2022 08:10:38 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:41598 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238073AbiBUNKf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Feb 2022 08:10:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C1FF1EAFB;
        Mon, 21 Feb 2022 05:10:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3B6BAB81185;
        Mon, 21 Feb 2022 13:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E29D1C340F6;
        Mon, 21 Feb 2022 13:10:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645449009;
        bh=H/AAOV/KPpcqeTNpNQIxUs7cqf+Kkl2uYNPyOYOeorI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TBEwfzE6Oj60w3d/u4uCzdf2Oqkac8lonvJhZHWRPNdn0ydmjS+INIIE/0HHhy2lj
         68JrNsCiSp3+gUeYFA9TDYhjvhQh7MmZYVbysJUXEka17UIp8B+AMDt1joowlukmWX
         cR7jxVdtgweTq9z5ZrkqCKk/hiVwQmSyip1NqSmqptdqZrGi6yMIcCib/x+t0GF5Pf
         NJwykknNfSb3AWcDG/mc/9OCS6nblb99R5qnBEePoGECI1HDS5dATFxrq/qtls8/OU
         pE3Pa2ky6L1Q1DAXwLiOjz89nDGmni/5CFtfCkTrjEQsngruECmbPIF8+yTmUdhwK9
         TL5SiFDmM7NKA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D1330E6D3E8;
        Mon, 21 Feb 2022 13:10:09 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [net-next PATCH v2 0/2] RVU AF and NETDEV drivers' PTP updates.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164544900985.23760.15653354946520544563.git-patchwork-notify@kernel.org>
Date:   Mon, 21 Feb 2022 13:10:09 +0000
References: <20220221064508.19148-1-rsaladi2@marvell.com>
In-Reply-To: <20220221064508.19148-1-rsaladi2@marvell.com>
To:     Rakesh Babu Saladi <rsaladi2@marvell.com>
Cc:     sgoutham@marvell.com, gakula@marvell.com, sbhatta@marvell.com,
        hkelam@marvell.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        richardcochran@gmail.com
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

This series was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon, 21 Feb 2022 12:15:06 +0530 you wrote:
> Patch 1: Add suppot such that RVU drivers support new timestamp format.
> Patch 2: This patch adds workaround for PTP errata.
> 
> Changes made from  v1 to v2
> 1. CC'd Richard Cochran to review PTP related patches.
> 2. Removed a patch from the old patch series. Will submit the removed patch
> separately.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] octeontx2-pf: cn10k: add support for new ptp timestamp format
    https://git.kernel.org/netdev/net-next/c/74c1b2338e0e
  - [net-next,v2,2/2] octeontx2-af: cn10k: add workaround for ptp errata
    https://git.kernel.org/netdev/net-next/c/6426fc3abab9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


