Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CBFA54FBAEE
	for <lists+netdev@lfdr.de>; Mon, 11 Apr 2022 13:31:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343862AbiDKLcw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 07:32:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234457AbiDKLc0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 07:32:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 494FE3EF3D;
        Mon, 11 Apr 2022 04:30:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D8EBB6147F;
        Mon, 11 Apr 2022 11:30:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 40360C385B0;
        Mon, 11 Apr 2022 11:30:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649676612;
        bh=EQd/gpZRHBB2FF6AMzo7XeimtPs4JHZxYmOO8OfloI8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=hXClnj9jUFQRzKcZTQqr4El8cWkWLKOsmlamRkyCWPJrrvEHEH9MksH3OabDq7k95
         gB0aSFOC0ACV1ptSVL8V3Mdpqw6uguMNim7aNdtfDfdMP2iCe0YwvUIIH9gSFxoS/4
         yMbuSS9VoDAUk/5oFexjbSJGE1Pvh2ZGDu3M8eGjl54fEa6nSzq60YUj6GVrpHJW3n
         0Y39NKhTp1IcsT6MLLV79TthLDMTT2USAMVviKthK963HY0veEy3AAK7bR8PuqFpwW
         vOMYgrGj5HlWi5L1XfYa7Q9UzTwQlRpEXV36irUNzQYYJkHUYBdXK0EfV7Ea5F6ONJ
         He9D2fmA/NovA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 2A67BE85B76;
        Mon, 11 Apr 2022 11:30:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: ethernet: ti: cpsw: drop CPSW_HEADROOM define
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164967661217.4707.11061392109948944505.git-patchwork-notify@kernel.org>
Date:   Mon, 11 Apr 2022 11:30:12 +0000
References: <20220408134838.24761-1-grygorii.strashko@ti.com>
In-Reply-To: <20220408134838.24761-1-grygorii.strashko@ti.com>
To:     Grygorii Strashko <grygorii.strashko@ti.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        linux-kernel@vger.kernel.org, vigneshr@ti.com
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
by David S. Miller <davem@davemloft.net>:

On Fri, 8 Apr 2022 16:48:38 +0300 you wrote:
> Since commit 1771afd47430 ("net: cpsw: avoid alignment faults by taking
> NET_IP_ALIGN into account") the TI CPSW driver was switched to use correct
> define CPSW_HEADROOM_NA to avoid alignment faults, but there are two places
> left where CPSW_HEADROOM is still used (without causing issues).
> 
> Hence, completely drop CPSW_HEADROOM define and use CPSW_HEADROOM_NA
> everywhere to avoid further mistakes in code.
> 
> [...]

Here is the summary with links:
  - [net-next] net: ethernet: ti: cpsw: drop CPSW_HEADROOM define
    https://git.kernel.org/netdev/net-next/c/d072c88c28e1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


