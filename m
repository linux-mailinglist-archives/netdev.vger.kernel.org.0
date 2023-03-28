Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D43106CB43B
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 04:40:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbjC1CkU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Mar 2023 22:40:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229501AbjC1CkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Mar 2023 22:40:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A46B51706;
        Mon, 27 Mar 2023 19:40:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 4811B614AE;
        Tue, 28 Mar 2023 02:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 9A344C433D2;
        Tue, 28 Mar 2023 02:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679971217;
        bh=dRVjBQFh7ntZKy9FhOddEMHEAPoKh+2naKJO091LArc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=FyAbH5eAYBOJZoij7fBU7yXpmEhuLbYFxoPQgiRZzeIOXbHWnXqzNXzbb2YwpIvU1
         wdWrC9j1bSHB/3jKNhx3iY4KlriCaFxIebT8b5g8qnNhVNTu4xqGh2j4Nav353VC7w
         xkLORFJHF54iYWh2PRZB28jfeBY30wt3t2El++AZsq9XbTfYfeQIYQzk87SiSHpiNu
         9c1sQ4YrV1KZX7IGj6sY1nUFq/j1IeZl+03+drYqu2RfVg5L7Q7rXhJB9fnK7uN6h+
         idamboqTewRV2yW7KEZ8KiMHK4szYET6kO7HpIH/szska+NdwK9U1F04Ts5zaDR74B
         i6oabuFVKpyzQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7AA67E4D029;
        Tue, 28 Mar 2023 02:40:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: fman: Add myself as a reviewer
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167997121749.8778.804854183224496569.git-patchwork-notify@kernel.org>
Date:   Tue, 28 Mar 2023 02:40:17 +0000
References: <20230323145957.2999211-1-sean.anderson@seco.com>
In-Reply-To: <20230323145957.2999211-1-sean.anderson@seco.com>
To:     Sean Anderson <sean.anderson@seco.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, madalin.bucur@nxp.com,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 23 Mar 2023 10:59:57 -0400 you wrote:
> I've read through or reworked a good portion of this driver. Add myself
> as a reviewer.
> 
> Signed-off-by: Sean Anderson <sean.anderson@seco.com>
> ---
> 
>  MAINTAINERS | 1 +
>  1 file changed, 1 insertion(+)

Here is the summary with links:
  - net: fman: Add myself as a reviewer
    https://git.kernel.org/netdev/net/c/ac9bba3ff1ef

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


