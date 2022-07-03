Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 237BE56473E
	for <lists+netdev@lfdr.de>; Sun,  3 Jul 2022 14:10:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232327AbiGCMKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Jul 2022 08:10:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34776 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229739AbiGCMKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Jul 2022 08:10:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 624F165AA;
        Sun,  3 Jul 2022 05:10:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0D0C3B80AD5;
        Sun,  3 Jul 2022 12:10:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A3587C341CA;
        Sun,  3 Jul 2022 12:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1656850213;
        bh=T5TjPufyRMY/w85lSgYtYwPLXAWDFgCoKRyts+Vgwn4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=jbZE1Fpqc9AsfXY/+PIyPcAlMlWB/EAUNySOyNOYRCVr2CphsURygYZM7gMzxHl1s
         +oWZ77OxNf5Pw1gFcNpfzuefgOmpRqrLChDC09bCghLolIN7LEBjUGiFQ39aWPesfn
         1VvSo0SCBzOeODZsfg+4ZSZRiH0c4FJ0rsbVoTXAfNOMasVO1yYUqwDacIg+eZyeEb
         GGNkggONxVNZjk6GGHNXFUM0tySzlH7azG2Q0zMqsUrL4qp02wPyoydiOnhijy+DQH
         pTcia7ZJ0oPcT001fjwMRmQa/LLhcvkTeptACAkGIS0wv3ciYFFf34o8tKxNZsN09Q
         rjqHalB1XE5Sw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 84152E49BB8;
        Sun,  3 Jul 2022 12:10:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: usb: Remove unnecessary '0' values from hasdata
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165685021352.15364.967699856420828004.git-patchwork-notify@kernel.org>
Date:   Sun, 03 Jul 2022 12:10:13 +0000
References: <20220701071802.3388-1-kunyu@nfschina.com>
In-Reply-To: <20220701071802.3388-1-kunyu@nfschina.com>
To:     Li kunyu <kunyu@nfschina.com>
Cc:     davem@davemloft.net, edumazet@google.com,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri,  1 Jul 2022 15:18:02 +0800 you wrote:
> hasdata does not need to be initialized to zero. It will be assigned a
> value in the following judgment conditions.
> 
> Signed-off-by: Li kunyu <kunyu@nfschina.com>
> ---
>  drivers/net/usb/catc.c | 2 +-
>  1 file changed, 1 insertions(+), 1 deletions(-)

Here is the summary with links:
  - net: usb: Remove unnecessary '0' values from hasdata
    https://git.kernel.org/netdev/net-next/c/d0bf1fe6454e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


