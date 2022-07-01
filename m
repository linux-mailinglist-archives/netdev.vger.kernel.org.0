Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BA5C0562A33
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 06:12:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232342AbiGAEKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 00:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229549AbiGAEKQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 00:10:16 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C1AC7B18;
        Thu, 30 Jun 2022 21:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 72B25B82CEF;
        Fri,  1 Jul 2022 04:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0217CC341CD;
        Fri,  1 Jul 2022 04:10:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656648613;
        bh=XtSykGU46TcC6RlL0aLeHdoxcTeDGYZDCSOM4KQDvMA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=cTNIoU2ERew7yklgM4xrBgbioD/XGK6jIM2SdL4fR9nrFM5nxsdIXFW75chc+TBsR
         LA3RmbN+mXKpMYtupGiFDauNumiYZ9h+iD9FIhR1dgXFn7uSpjRFRzOn87kEVYDMkk
         HTXqD/XKTfiP+6jgkEY0blHpeXzgu4Y43LtSYifaIwnSqkiPbFgeio8VSSrcxgPPxc
         Er2vrDdIsrGek7BFugDlsSwXhq1dS+/7eae6vRsuPy/e4LjhHlNMn6nt0hf+3hqsMW
         ogJb1N02e6+WdhgN8HlzeNTPlnrvpWk+B/pz6aJNq48bmW7fer5HkZ/uplVudKLNQo
         WV29Ac+zI5BoQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DB460E49BBC;
        Fri,  1 Jul 2022 04:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next v2] net: dsa: rzn1-a5psw: add missing of_node_put() in
 a5psw_pcs_get()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165664861289.15670.11572643046096642820.git-patchwork-notify@kernel.org>
Date:   Fri, 01 Jul 2022 04:10:12 +0000
References: <20220630014153.1888811-1-yangyingliang@huawei.com>
In-Reply-To: <20220630014153.1888811-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org, clement.leger@bootlin.com,
        olteanv@gmail.com, f.fainelli@gmail.com, davem@davemloft.net
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 30 Jun 2022 09:41:53 +0800 you wrote:
> of_parse_phandle() will increase the refcount of 'pcs_node', so add
> of_node_put() before return from a5psw_pcs_get().
> 
> Fixes: 888cdb892b61 ("net: dsa: rzn1-a5psw: add Renesas RZ/N1 advanced 5 port switch driver")
> Reported-by: Hulk Robot <hulkci@huawei.com>
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> 
> [...]

Here is the summary with links:
  - [-next,v2] net: dsa: rzn1-a5psw: add missing of_node_put() in a5psw_pcs_get()
    https://git.kernel.org/netdev/net-next/c/5a24389457ba

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


