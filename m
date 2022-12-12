Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DC12564AB2F
	for <lists+netdev@lfdr.de>; Tue, 13 Dec 2022 00:10:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233864AbiLLXKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Dec 2022 18:10:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229629AbiLLXKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 12 Dec 2022 18:10:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B34B564C5;
        Mon, 12 Dec 2022 15:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 5213661277;
        Mon, 12 Dec 2022 23:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AFF59C433D2;
        Mon, 12 Dec 2022 23:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670886616;
        bh=JTmV4BJmDr5X2BZwXGxXkRkPMHFMdlAW64qclUWgrSs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=u5/2rOti4RrGVqMGc1DqVSeBNIq2YhRC4MMNbPxUomIDsWgGeA3QYNQB3U4tP3RNU
         XbDaHHvjspg8qfwbzYpdBKyZsfDpIya6csj9+1BSsbwLbf2GKwu8WIO6xSVzqZTzn6
         R5QDG9rILrsvu1BjeU6QKNwAe3pvi7aQ+/7kfE7K/jW3V2/nErNrk5aHQFZf+UrSCi
         Dtf+iqIOtDbKAmLzqkORxxQrnp6SPRI7sbG8Q36X8tkZlPZAsZfq91b7KKAHi0cARv
         CgEIQQRgpXkdaxabScmUK3aU0xI9OhSqmOfaGCe/1yxNDiUcM9MGR+Lr/sTtTsZijV
         aJjFF1OSPAoNw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9078EE270C9;
        Mon, 12 Dec 2022 23:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: tso: inline tso_count_descs()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167088661658.21170.1188842453816081698.git-patchwork-notify@kernel.org>
Date:   Mon, 12 Dec 2022 23:10:16 +0000
References: <20221212032426.16050-1-linyunsheng@huawei.com>
In-Reply-To: <20221212032426.16050-1-linyunsheng@huawei.com>
To:     Yunsheng Lin <linyunsheng@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linuxarm@openeuler.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 12 Dec 2022 11:24:26 +0800 you wrote:
> tso_count_descs() is a small function doing simple calculation,
> and tso_count_descs() is used in fast path, so inline it to
> reduce the overhead of calls.
> 
> Signed-off-by: Yunsheng Lin <linyunsheng@huawei.com>
> ---
> V2: include skbuff.h explicitly and refactor comment as jakub's
>     suggestion.
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: tso: inline tso_count_descs()
    https://git.kernel.org/netdev/net-next/c/d7b061b80ee6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


