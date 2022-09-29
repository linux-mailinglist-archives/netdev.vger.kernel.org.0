Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DD50E5EF5E6
	for <lists+netdev@lfdr.de>; Thu, 29 Sep 2022 15:00:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235475AbiI2NAU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Sep 2022 09:00:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54474 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235017AbiI2NAT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Sep 2022 09:00:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B8F87B56C0;
        Thu, 29 Sep 2022 06:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25003B8247A;
        Thu, 29 Sep 2022 13:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id B9D18C433B5;
        Thu, 29 Sep 2022 13:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664456415;
        bh=CMT4l4mGvdWkpIe3DAEkmsfuSzuenMOtygbEam+01/k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O5Q/vF+mXwLC4FYb5Mo8e640s2ItQ2j6c85ikBVKuRktS8ZdS/4F1Lk9vRa26tMwI
         B6LtRBSgfw97LfDNqNj1jmpnxvNLg36SH1nIZ0ew4J19PUH0YLnnwGcomCwSORxvyG
         7p14w8ghgkX+CFMpWae7lRXOHC2TPnap2P0CdFmGVC/HohiRVC9t9Ul6Pa+UikiqiU
         amw8MhByWZN4yR0zmT7+6Gay2gsFfbiGNudC9GrPyEWJKETU7UPqzzv29Ab+nZRfUT
         fUGz0YM1FcokPQFLA3CXQm8g3i94uLxEUx6EUvCTcDOx8VYs0IgAYGNcL8HvlxzOSD
         nhkjbGJzc0cRg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 9EC4BE4D018;
        Thu, 29 Sep 2022 13:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: cpmac: Add __init/__exit annotations to module
 init/exit funcs
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166445641564.18480.13411097809800185710.git-patchwork-notify@kernel.org>
Date:   Thu, 29 Sep 2022 13:00:15 +0000
References: <20220928031708.89120-1-ruanjinjie@huawei.com>
In-Reply-To: <20220928031708.89120-1-ruanjinjie@huawei.com>
To:     ruanjinjie <ruanjinjie@huawei.com>
Cc:     f.fainelli@gmail.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Paolo Abeni <pabeni@redhat.com>:

On Wed, 28 Sep 2022 11:17:08 +0800 you wrote:
> Add __init/__exit annotations to module init/exit funcs
> 
> Signed-off-by: ruanjinjie <ruanjinjie@huawei.com>
> ---
>  drivers/net/ethernet/ti/cpmac.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)

Here is the summary with links:
  - [-next] net: cpmac: Add __init/__exit annotations to module init/exit funcs
    https://git.kernel.org/netdev/net-next/c/510bbf82f8dc

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


