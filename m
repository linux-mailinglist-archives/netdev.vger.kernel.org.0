Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7C74D57C33F
	for <lists+netdev@lfdr.de>; Thu, 21 Jul 2022 06:10:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231587AbiGUEKY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jul 2022 00:10:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230339AbiGUEKW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 21 Jul 2022 00:10:22 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C840410FE9
        for <netdev@vger.kernel.org>; Wed, 20 Jul 2022 21:10:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3878EB82298
        for <netdev@vger.kernel.org>; Thu, 21 Jul 2022 04:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A4DA2C341D5;
        Thu, 21 Jul 2022 04:10:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1658376617;
        bh=BTKEd4I8HdGAL2qyE0GARMnCPqalkrHSfglyqGbT10s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=O/8jRcx3MTFod5faWd9Yv2IbtmaNAyT+lEzKIx+YeoHU1ITQ7NXPhdNVbU5aRDrIp
         RYdmux8e7CMVK30nbyPtKPpt4IhfIMh7AeYxvcyAQDP/gWbsnhtPMX+dK/yKva7twf
         7WebrUv3wM07a/4Q/dkytrx2nMqEQjRXdBNY9kHbzz3JNcdLszp7rnMABZGciIGR80
         6sMOTR3l3LqxxqmVCz1/YJvWPsJliQL4ttCQBaTrqZW7AsnPSmM0L5RT/+X8iwqLMo
         hLlGcBMoqVY+j6Vg+nSBvuKcQrLVFy0MW7/bQrcL07CWeHGJCPV2X7aVPX8cMt+krj
         1GQ5E74dSf2TQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 82D55E45201;
        Thu, 21 Jul 2022 04:10:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: amd8111e: remove repeated dev->features
 assignement
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165837661753.25559.7757872631615708561.git-patchwork-notify@kernel.org>
Date:   Thu, 21 Jul 2022 04:10:17 +0000
References: <20220719142424.4528-1-shenjian15@huawei.com>
In-Reply-To: <20220719142424.4528-1-shenjian15@huawei.com>
To:     shenjian (K) <shenjian15@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linuxarm@openeuler.org
X-Spam-Status: No, score=-7.8 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 19 Jul 2022 22:24:24 +0800 you wrote:
> It's repeated with line 1793-1795, and there isn't any other
> handling for it. So remove it.
> 
> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> ---
>  drivers/net/ethernet/amd/amd8111e.c | 3 ---
>  1 file changed, 3 deletions(-)

Here is the summary with links:
  - [net-next] net: amd8111e: remove repeated dev->features assignement
    https://git.kernel.org/netdev/net-next/c/09765fcd3c71

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


