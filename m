Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C774D4C9AD3
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 03:00:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238983AbiCBCAy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 21:00:54 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230314AbiCBCAx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 21:00:53 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 92993A2F27;
        Tue,  1 Mar 2022 18:00:11 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 17AE461663;
        Wed,  2 Mar 2022 02:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 68321C340F2;
        Wed,  2 Mar 2022 02:00:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646186410;
        bh=j0DmT/8JQKqd2/kERN7c7YHZoCRGMYatz/NsNvnNPBg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=WW97Z9CaMxzeruDTYZktudKbzxvUjSx3sjUBxmE2kgzVtCjmCXoDWNybBKFxaeMvQ
         AqF4c2+GtO+unctB+DVMfNUcCJyNsOLPMF6men3qJHzIz4i7LMiONzkEmmki+zkMae
         unc6DfyXCfD0wZguUYC4xkblZGyg43QOHfWr/kmSvMDMFKb2hNwKJyTGxH8Q4WK1cw
         V2feyQ/CbHtDdfz9/faucSa3B1AOoHc4ag/DNjk6DKND2O8OmhF7O9Rb7SjibTZGXv
         f4kQyly0MJCxm/e4duxAvqaEIAjpuHgZkOs0ejgYPngzuRM7P6YzwQzRbqURxddcB4
         4MztxbnvRKuhA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 465BBEAC096;
        Wed,  2 Mar 2022 02:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] nfp: avoid newline at end of message in NL_SET_ERR_MSG_MOD
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164618641028.32282.3941297685068677511.git-patchwork-notify@kernel.org>
Date:   Wed, 02 Mar 2022 02:00:10 +0000
References: <20220301112356.1820985-1-wanjiabing@vivo.com>
In-Reply-To: <20220301112356.1820985-1-wanjiabing@vivo.com>
To:     Wan Jiabing <wanjiabing@vivo.com>
Cc:     simon.horman@corigine.com, kuba@kernel.org, davem@davemloft.net,
        baowen.zheng@corigine.com, louis.peens@corigine.com,
        jianbol@nvidia.com, peng.zhang@corigine.com,
        oss-drivers@corigine.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kael_w@qq.com
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

On Tue,  1 Mar 2022 19:23:54 +0800 you wrote:
> Fix the following coccicheck warning:
> ./drivers/net/ethernet/netronome/nfp/flower/qos_conf.c:750:7-55: WARNING
> avoid newline at end of message in NL_SET_ERR_MSG_MOD
> 
> Signed-off-by: Wan Jiabing <wanjiabing@vivo.com>
> ---
>  drivers/net/ethernet/netronome/nfp/flower/qos_conf.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)

Here is the summary with links:
  - nfp: avoid newline at end of message in NL_SET_ERR_MSG_MOD
    https://git.kernel.org/netdev/net-next/c/323d51cac6a1

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


