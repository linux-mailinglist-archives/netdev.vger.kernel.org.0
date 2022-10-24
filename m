Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9A95C60B9D1
	for <lists+netdev@lfdr.de>; Mon, 24 Oct 2022 22:21:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234193AbiJXUVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 16:21:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41864 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232593AbiJXUVH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 16:21:07 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE7A238A2E;
        Mon, 24 Oct 2022 11:37:32 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 56B48B815A2;
        Mon, 24 Oct 2022 12:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 08845C433C1;
        Mon, 24 Oct 2022 12:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666613416;
        bh=9ESBzX52CjK6XxD8MdXK9r+A7vj8YD1Vc9itBxgSk54=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=d3wA6bjcf5xb7vFZ3l0+Hy9cmk+lm7cYwe0l7Q0kTgGmS88pf8w12D4Id0Q8tg8PU
         DA+iKviAIuco1CXwxvSNiJgSVKdQTbcHF/5Cl/HbU51aIq637Hr/fmWHFirOXXSR4I
         SEmU1ooIHuCKMmHEZmeNyhOvBHzQa3RgCBa6oRDzxO3+ZjgGwA4F6UC8zvQFR0wnLh
         kjBx+i3QBoXcYBdfXG5o8ZBGxl5I/OEP9jstPkByr9LIjgDW+D7hMWexXUmx1QLV7s
         98e6cOJTpLyfywpK4Az7dD2qBwJqTYLgwIfrBvUXP0yvpP7/iIwuC40L6zqViyTiG6
         HfgaFe4M2DWYw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D7515E270DE;
        Mon, 24 Oct 2022 12:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: lantiq_etop: don't free skb when returning
 NETDEV_TX_BUSY
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166661341587.16761.10357700348677404057.git-patchwork-notify@kernel.org>
Date:   Mon, 24 Oct 2022 12:10:15 +0000
References: <1666315944-30898-1-git-send-email-zhangchangzhong@huawei.com>
In-Reply-To: <1666315944-30898-1-git-send-email-zhangchangzhong@huawei.com>
To:     Zhang Changzhong <zhangchangzhong@huawei.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, blogic@openwrt.org, ralph.hempel@lantiq.com,
        ralf@linux-mips.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 21 Oct 2022 09:32:24 +0800 you wrote:
> The ndo_start_xmit() method must not free skb when returning
> NETDEV_TX_BUSY, since caller is going to requeue freed skb.
> 
> Fixes: 504d4721ee8e ("MIPS: Lantiq: Add ethernet driver")
> Signed-off-by: Zhang Changzhong <zhangchangzhong@huawei.com>
> ---
>  drivers/net/ethernet/lantiq_etop.c | 1 -
>  1 file changed, 1 deletion(-)

Here is the summary with links:
  - [net] net: lantiq_etop: don't free skb when returning NETDEV_TX_BUSY
    https://git.kernel.org/netdev/net/c/9c1eaa27ec59

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


