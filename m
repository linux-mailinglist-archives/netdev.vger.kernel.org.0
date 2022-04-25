Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5889650DDA4
	for <lists+netdev@lfdr.de>; Mon, 25 Apr 2022 12:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233313AbiDYKNt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Apr 2022 06:13:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33982 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241566AbiDYKNS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 25 Apr 2022 06:13:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9912AB27;
        Mon, 25 Apr 2022 03:10:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 48D4BB8118F;
        Mon, 25 Apr 2022 10:10:13 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C616BC385AD;
        Mon, 25 Apr 2022 10:10:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650881411;
        bh=lNgBXGaoCT/k5X92nztIeiOL/3Lu7e/xi5PEh/eGvQQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QSQRRIDIDQKI+X8ArKiJNXB3e+39OhfCvMdmHYh42J4p0r+ShN9S8tP1KP70JX40V
         2XrPJNJCKlVNrV473t5/grSgMADrGN16rwqNukum3aae9rBMhKS7V0ytRFA/aCzR2B
         yKHsEf5Z9vqrp2OSyClmvdk+gFlQx1O5AUXR4qxJGVTzLhg/kizeHeIyWvePqGGIsn
         DNxeRIV7XmM9OI/fEFGh1/xkXJ6bnNOyEgNL9vsv8qbB7INvRZRnoRIpvdF3RSVmcZ
         AQk6l3A394iK5Qpn6XNNFbJNRuj7wnJlR8/+2lr1kyZVNfcX8IN2x3WCInkXKgboGs
         M2SNy1DFnkliw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B0452E85D90;
        Mon, 25 Apr 2022 10:10:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] net: hns: Add missing fwnode_handle_put in hns_mac_init
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165088141171.23385.7839668644054334902.git-patchwork-notify@kernel.org>
Date:   Mon, 25 Apr 2022 10:10:11 +0000
References: <20220421055344.8102-1-wupeng58@huawei.com>
In-Reply-To: <20220421055344.8102-1-wupeng58@huawei.com>
To:     Peng Wu <wupeng58@huawei.com>
Cc:     yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        huangguangbin2@huawei.com, shenyang39@huawei.com,
        lipeng321@huawei.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, liwei391@huawei.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 21 Apr 2022 05:53:44 +0000 you wrote:
> In one of the error paths of the device_for_each_child_node() loop
> in hns_mac_init, add missing call to fwnode_handle_put.
> 
> Signed-off-by: Peng Wu <wupeng58@huawei.com>
> ---
>  drivers/net/ethernet/hisilicon/hns/hns_dsaf_mac.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)

Here is the summary with links:
  - net: hns: Add missing fwnode_handle_put in hns_mac_init
    https://git.kernel.org/netdev/net/c/e85f8a9f1625

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


