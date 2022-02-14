Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 020554B5317
	for <lists+netdev@lfdr.de>; Mon, 14 Feb 2022 15:20:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355067AbiBNOUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Feb 2022 09:20:21 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:55426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233252AbiBNOUT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Feb 2022 09:20:19 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 87FAB4A3F8;
        Mon, 14 Feb 2022 06:20:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2F7236103D;
        Mon, 14 Feb 2022 14:20:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 8D43AC340EF;
        Mon, 14 Feb 2022 14:20:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644848410;
        bh=wmIB5Xx8YNnUp61IjytANTE6h4pdM98NwtQfxsN8ya8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pYBK/WpdPB+Adjglevy0jGVzBfuBMEdwXHH8BrZbH2MZqZgacGtuvZPO+ImU6k/XQ
         CfoVzmV+0LFsOBnPGKyZb6xXIlcmwAfzJPZFpyglbLOMtL1pJkXa0vpfyvbq5WqOjG
         tSo8sA6SGBvCay2POScyPZji8e96hukgYIptsaB3vXjdMuqAa10V5brRc4YNW0a5aD
         ZjSTkXV1aRZFuTYBu2Mi+jq1OVetpoIyTQ/Te8W2es2IbV+2CRO3vDyuf/KjMYhbhE
         NiT7Pskq1fzQCNE+GRS4lZpgA0WHmK2C96/cS46WNYVrKjcRITsTAYvUT4YJ2sIsLL
         1mH8YHiOjboVg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 76C41E74CC2;
        Mon, 14 Feb 2022 14:20:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH][next] selftests: net: cmsg_sender: Fix spelling mistake
 "MONOTINIC" -> "MONOTONIC"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164484841048.14634.689140204535571711.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Feb 2022 14:20:10 +0000
References: <20220214093810.44792-1-colin.i.king@gmail.com>
In-Reply-To: <20220214093810.44792-1-colin.i.king@gmail.com>
To:     Colin Ian King <colin.i.king@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kselftest@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Mon, 14 Feb 2022 09:38:10 +0000 you wrote:
> There is a spelling mistake in an error message. Fix it.
> 
> Signed-off-by: Colin Ian King <colin.i.king@gmail.com>
> ---
>  tools/testing/selftests/net/cmsg_sender.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [next] selftests: net: cmsg_sender: Fix spelling mistake "MONOTINIC" -> "MONOTONIC"
    https://git.kernel.org/netdev/net-next/c/12d8c11198af

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


