Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 13C434CB71B
	for <lists+netdev@lfdr.de>; Thu,  3 Mar 2022 07:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229810AbiCCGk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Mar 2022 01:40:59 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47114 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229620AbiCCGk6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 3 Mar 2022 01:40:58 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7E8D71688FF;
        Wed,  2 Mar 2022 22:40:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3238AB82400;
        Thu,  3 Mar 2022 06:40:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DC284C004E1;
        Thu,  3 Mar 2022 06:40:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646289610;
        bh=8K7jB4I3jW3hbwpFkd8rOjNLPze/3EMTo6q7jWT5VOQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kb5Rko2Sc3qd8i0dw2tMQTewTGyMHwJOxJaZ1nUY/ngx21r+EQ4myjaTyr9SMa9vO
         vLppCtI6pnb50OIr0tlf/HgDGL2fSP+RhAxTLZ+KlluikBfafaNhPIRYMQMGbvOy3T
         PQEKMncvAgPrsopLFgFYxKf9yHJYnC8vQh+61WjlPg2Bauq9xVIHPgLdwyKqTEycrB
         s2LXEIImo/OZ/TajM/5cVw1GbZoMMpikqZSiWGYrKkAzRpIEUB8qMErWbA7G3NnNVD
         Tqku1pnuATpLb2NEHuVLTo9ATbdyISbY9zxxo/LvhI9nqIH18CXoEZhHAKszr6dVPJ
         9pvIvPqJQohoA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BBEF2EAC096;
        Thu,  3 Mar 2022 06:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH -next] net: openvswitch: remove unneeded semicolon
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164628961076.13615.16852026380052114967.git-patchwork-notify@kernel.org>
Date:   Thu, 03 Mar 2022 06:40:10 +0000
References: <20220227132208.24658-1-yang.lee@linux.alibaba.com>
In-Reply-To: <20220227132208.24658-1-yang.lee@linux.alibaba.com>
To:     Yang Li <yang.lee@linux.alibaba.com>
Cc:     pshelar@ovn.org, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, dev@openvswitch.org,
        linux-kernel@vger.kernel.org, abaci@linux.alibaba.com
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

On Sun, 27 Feb 2022 21:22:08 +0800 you wrote:
> Eliminate the following coccicheck warning:
> ./net/openvswitch/flow.c:379:2-3: Unneeded semicolon
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Yang Li <yang.lee@linux.alibaba.com>
> ---
>  net/openvswitch/flow.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - [-next] net: openvswitch: remove unneeded semicolon
    https://git.kernel.org/netdev/net-next/c/cb1d8fba91f2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


