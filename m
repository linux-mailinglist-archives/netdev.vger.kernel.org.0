Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 595FB5E5807
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 03:30:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230368AbiIVBaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 21:30:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51770 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230333AbiIVBaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 21:30:19 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7464C9E8AB;
        Wed, 21 Sep 2022 18:30:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CEEA862811;
        Thu, 22 Sep 2022 01:30:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24E11C43144;
        Thu, 22 Sep 2022 01:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663810216;
        bh=hOvc2gZNAEv38GW8uk2HZh27Apz29r+IxZi6cEksSOs=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=NulLZrURhjAa5KApOrsTwVY+U6u+WGlpTLDdBAAylizmHSVya6oSc2MigdTWipoTd
         qn+2KlUNuD77RaApwL8Q5jVOGiLvWyrC0Lo0YCeJqIwOWW08b4S0MK6nP7oUPLn+k4
         chd/BdfpVeLVYzGBir9jIi9HkvCQ6yflB1W9c3WJZiymA+mpcBJKNdRctKN2552CQs
         UEXWMUcx4dhEo7owCcommKZSpbcTolWnpK3ngMfSRmuSiG/C359DkLhFIORE5A8KQd
         8qHr3c1gnxtQtBFDfRbuCfM+ef1XND6jDj76t53eEHNoCRmWBOSybazPQX+rXs531O
         hcWYWWY7nCcDQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 09302E50D6C;
        Thu, 22 Sep 2022 01:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH V2 net-next] net: ethernet: ti: am65-cpsw: remove unused
 parameter of am65_cpsw_nuss_common_open()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166381021603.720.14689963899974157679.git-patchwork-notify@kernel.org>
Date:   Thu, 22 Sep 2022 01:30:16 +0000
References: <20220917020451.63417-1-huangguangbin2@huawei.com>
In-Reply-To: <20220917020451.63417-1-huangguangbin2@huawei.com>
To:     huangguangbin (A) <huangguangbin2@huawei.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, lipeng321@huawei.com,
        lanhao@huawei.com, shenjian15@huawei.com, s-vadapalli@ti.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Sat, 17 Sep 2022 10:04:51 +0800 you wrote:
> From: Jian Shen <shenjian15@huawei.com>
> 
> The inptu parameter 'features' is unused now. so remove it.
> 
> Signed-off-by: Jian Shen <shenjian15@huawei.com>
> Signed-off-by: Guangbin Huang <huangguangbin2@huawei.com>
> 
> [...]

Here is the summary with links:
  - [V2,net-next] net: ethernet: ti: am65-cpsw: remove unused parameter of am65_cpsw_nuss_common_open()
    https://git.kernel.org/netdev/net-next/c/3342a10f5ad3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


