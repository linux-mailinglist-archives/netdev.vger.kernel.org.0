Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1F5584DE605
	for <lists+netdev@lfdr.de>; Sat, 19 Mar 2022 05:50:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242140AbiCSEvg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Mar 2022 00:51:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242105AbiCSEve (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 19 Mar 2022 00:51:34 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 42EEB3B3FA;
        Fri, 18 Mar 2022 21:50:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9A52060BAA;
        Sat, 19 Mar 2022 04:50:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E7396C340F4;
        Sat, 19 Mar 2022 04:50:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647665411;
        bh=YL4W3lAmQSDP790yVzNoQ2deihGUAoSaEvgUDwfEUHU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=TansEaSlNRhBNiktfiizPPn5/OzNB+03eWy8Up7MjHlL1Eq1L58JveVD6CZkrzWw9
         OHwS254/URkvAKrC0liDjMaCY6w9WOI/C8mrfU8hw69Sofw+wadE31pABYAf0rxMmj
         hZI0LXFR6dp0138D0pYZwl8Is1DjwgG4nLJ4IlcYtj2jKPr23cAKdQr8DXujjRYZQp
         xb0qPdqVaaZzFhJZjK2Pe4QoHCQwNW8wfufcMJhp6VLEjUGSWlBWBuojsDZSKCGVHY
         LZGVMQ87GKhAjCPy5vfkgO11yYJct9kFVX+cGwv0k5UJW0Mrtw2QpvXKTeIjs5e6jO
         h8nFaA1ijGGmA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id CE2F5F0383F;
        Sat, 19 Mar 2022 04:50:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] nfc: st21nfca: remove unnecessary skb check before
 kfree_skb()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164766541084.28065.2012315502960743033.git-patchwork-notify@kernel.org>
Date:   Sat, 19 Mar 2022 04:50:10 +0000
References: <20220318072728.2659578-1-yangyingliang@huawei.com>
In-Reply-To: <20220318072728.2659578-1-yangyingliang@huawei.com>
To:     Yang Yingliang <yangyingliang@huawei.com>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        colin.king@intel.com, kuba@kernel.org, davem@davemloft.net,
        krzk@kernel.org
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri, 18 Mar 2022 15:27:28 +0800 you wrote:
> The skb will be checked in kfree_skb(), so remove the outside check.
> 
> Signed-off-by: Yang Yingliang <yangyingliang@huawei.com>
> ---
>  drivers/nfc/st21nfca/i2c.c | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)

Here is the summary with links:
  - [-next] nfc: st21nfca: remove unnecessary skb check before kfree_skb()
    https://git.kernel.org/netdev/net-next/c/800c326bfa9c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


