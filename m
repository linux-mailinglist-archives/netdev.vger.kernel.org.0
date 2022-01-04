Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 63A674841BF
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 13:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233090AbiADMkP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 07:40:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56828 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233060AbiADMkO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 07:40:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9B62C061784;
        Tue,  4 Jan 2022 04:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 9F65EB8121F;
        Tue,  4 Jan 2022 12:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5843CC36AFC;
        Tue,  4 Jan 2022 12:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641300011;
        bh=DpqUB/vLHizCTNeIdtS8+PMqCOosmOKzrv0hvCCBznY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ilaHJALwF7QJcaIkeTJdOidggSeUjlE5NyswhYtZxjpa5Dro3cgbpayRpD8QhU9xC
         RBd6opxhSzHcFGYCBIhHUqk0elwyhxiEF6vocfvbOU6+nN/Ah/aLX1vR65cfE/HgBR
         t+6c7cTdI4+h0ICqMISeZ49Zouqx9M6gobLNcAROb0Ucea1KWUGSZ5nx385ku4ormG
         TsMPfiBoGrNtpPrhX9lTeCqwUVYdYFQN0nFwDyD0QQ9ZuSZl96dDYxIyrEvQJDf5ce
         piYPLSG0fPvjscwzwAkkelTeeBvXcT+J/abbGcfUaoPfsKJEsKc5gXpckhSRQ5egm5
         6vm9dcglJBRAQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 45B5AF79407;
        Tue,  4 Jan 2022 12:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: fixup build after bpf header changes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164130001127.24992.5502128028484482791.git-patchwork-notify@kernel.org>
Date:   Tue, 04 Jan 2022 12:40:11 +0000
References: <20220104034827.1564167-1-kuba@kernel.org>
In-Reply-To: <20220104034827.1564167-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        abdhalee@linux.vnet.ibm.com, jesse.brandeburg@intel.com,
        anthony.l.nguyen@intel.com, saeedm@nvidia.com, leon@kernel.org,
        intel-wired-lan@lists.osuosl.org, linux-rdma@vger.kernel.org,
        bpf@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Mon,  3 Jan 2022 19:48:27 -0800 you wrote:
> Recent bpf-next merge brought in header changes which uncovered
> includes missing in net-next which were not present in bpf-next.
> Build problems happen only on less-popular arches like hppa,
> sparc, alpha etc.
> 
> I could repro the build problem with ice but not the mlx5 problem
> Abdul was reporting. mlx5 does look like it should include filter.h,
> anyway.
> 
> [...]

Here is the summary with links:
  - [net-next] net: fixup build after bpf header changes
    https://git.kernel.org/netdev/net-next/c/7d714ff14d64

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


