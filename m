Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3815E4D403D
	for <lists+netdev@lfdr.de>; Thu, 10 Mar 2022 05:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239462AbiCJEVR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Mar 2022 23:21:17 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42082 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239450AbiCJEVO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Mar 2022 23:21:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F1B39D9966;
        Wed,  9 Mar 2022 20:20:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A60CCB824AB;
        Thu, 10 Mar 2022 04:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 58DCEC340EB;
        Thu, 10 Mar 2022 04:20:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646886011;
        bh=THbhfUoqsWdZGBNwJW0eh2TMwVtzZWvLtOJaCmFmRKw=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=df89b5rRoI2Ft15WtioChlduaYfGPMBNlwdN1bcAEXnE6qNy7AnChOkfjAWiIc563
         68z+c6iIpJTCSuNg/m+yDGvd++hUUW720aoiUr/mtGbE/VaLEYDsSooPQ9uhgZGM+B
         OH14OtLofCSMVfMhsltE6vqNl8l4ceCa0lbW9KEp8eUo7TLzN+tZGMTF2h2uz1s5HQ
         Zz4ACSneQGtjypyf8kQ5j7Rj30+PGfy54owv1Y6ltEGFSKlTjr4G+EuQYLOJCptEJC
         hXJ8NWPuoXAhbKBG8lMVWui6Et7oglOUQ1LVplEXoeT1cExiK8l7fJ+8vD4gzLB+rN
         ZdkQ9HvSG75Cg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 41294E8DD5B;
        Thu, 10 Mar 2022 04:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/smc: fix -Wmissing-prototypes warning when
 CONFIG_SYSCTL not set
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164688601126.11305.7343800301996391648.git-patchwork-notify@kernel.org>
Date:   Thu, 10 Mar 2022 04:20:11 +0000
References: <20220309033051.41893-1-dust.li@linux.alibaba.com>
In-Reply-To: <20220309033051.41893-1-dust.li@linux.alibaba.com>
To:     Dust Li <dust.li@linux.alibaba.com>
Cc:     kuba@kernel.org, kgraul@linux.ibm.com, tonylu@linux.alibaba.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-rdma@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Wed,  9 Mar 2022 11:30:51 +0800 you wrote:
> when CONFIG_SYSCTL not set, smc_sysctl_net_init/exit
> need to be static inline to avoid missing-prototypes
> if compile with W=1.
> 
> Since __net_exit has noinline annotation when CONFIG_NET_NS
> not set, it should not be used with static inline.
> So remove the __net_init/exit when CONFIG_SYSCTL not set.
> 
> [...]

Here is the summary with links:
  - [net-next] net/smc: fix -Wmissing-prototypes warning when CONFIG_SYSCTL not set
    https://git.kernel.org/netdev/net-next/c/d9f509915925

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


