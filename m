Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 62D3E529FA0
	for <lists+netdev@lfdr.de>; Tue, 17 May 2022 12:40:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236834AbiEQKkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 17 May 2022 06:40:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36010 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234568AbiEQKkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 17 May 2022 06:40:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 46D582AE31;
        Tue, 17 May 2022 03:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 0551AB81829;
        Tue, 17 May 2022 10:40:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 905FCC34100;
        Tue, 17 May 2022 10:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652784011;
        bh=lG+WzhlQu/F5FgYOMdxsU/i/OcTiws5bU6cJHnimqTI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=lfJI5YNlohnRV0I4JzS3kWuqM8L48KfcU30EtMWroiLL0o95z1drEWJEO6dH/5YcF
         b0fQqOFWYiG9NcS5zd4VBF4mMXWF2qQCpOeXOXQlwjKmPtCqNqd5T6riMGHGYbPv3y
         OkbN3m26VEvU0nOOzpI7snFcCKYnbbD5tFsWDtI0SVidOTTkgacfu+xeesPfUTZoXZ
         ZnYSUIiO5ai0LCJQG/PS6rdmJnnujYTpc1pR/2YTJu2lOPzX7ImMkq4FC6/k1vpKHf
         RqpXKr+jV/YVQj0XdIEzgKvs7IsQvsu57dQ0sGeKEbvz/W3QK3Fy2/Ky88u+ydDsY4
         6OW+puIfx7ETg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 72EEEF0389D;
        Tue, 17 May 2022 10:40:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] ax25: merge repeat codes in ax25_dev_device_down()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165278401146.26222.3962756403091826373.git-patchwork-notify@kernel.org>
Date:   Tue, 17 May 2022 10:40:11 +0000
References: <20220516062804.254742-1-luwei32@huawei.com>
In-Reply-To: <20220516062804.254742-1-luwei32@huawei.com>
To:     Lu Wei <luwei32@huawei.com>
Cc:     jreuter@yaina.de, ralf@linux-mips.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, pabeni@redhat.com,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org,
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
by Paolo Abeni <pabeni@redhat.com>:

On Mon, 16 May 2022 14:28:04 +0800 you wrote:
> Merge repeat codes to reduce the duplication.
> 
> Signed-off-by: Lu Wei <luwei32@huawei.com>
> ---
>  net/ax25/ax25_dev.c | 22 ++++++++++------------
>  1 file changed, 10 insertions(+), 12 deletions(-)

Here is the summary with links:
  - [net-next] ax25: merge repeat codes in ax25_dev_device_down()
    https://git.kernel.org/netdev/net-next/c/a968c799eb1d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


