Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 722385753DE
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 19:20:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234785AbiGNRUQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 14 Jul 2022 13:20:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47354 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232584AbiGNRUP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 14 Jul 2022 13:20:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3AB0B4E857
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 10:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CB53C620D1
        for <netdev@vger.kernel.org>; Thu, 14 Jul 2022 17:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1FBC0C341C8;
        Thu, 14 Jul 2022 17:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657819214;
        bh=OUGlAsovOO3M+Ao/aXz2Go2IFc57mIF14vR5N/S1kzU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=l6NgTT4Fe7H41Spq3rQu/WjuvFqOdPYHojoeA+A3OJW5hsKHVk6L8HeFw3zC/Ufzj
         rvFFS47lBkX6/JptcIrToS4xU8WRfAEbry9ACJCDFLOXfpkSJMxQNdEXSXAuOA3Lnx
         crkBC9zcaMpcS1WkKQ/zlPixKl+Z09ThZf/O+b+OHwVgymCipyAg7hp+b+MemXLsoD
         ArwJ7EUpba431RTxd95gWmKbajA/onzCFRb+YZHoDljx8xbQcMBRibHouRdHIGEK24
         69b/0AXZnM8guq1XJld8tidN70icQkNd98TfcKw6zGXm2uOxS1pkLcCx2QL10n0lwS
         OmpxvCHaInRMA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 058E4E45230;
        Thu, 14 Jul 2022 17:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net/tls: Check for errors in tls_device_init
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165781921401.9202.6661795064449718975.git-patchwork-notify@kernel.org>
Date:   Thu, 14 Jul 2022 17:20:14 +0000
References: <20220714070754.1428-1-tariqt@nvidia.com>
In-Reply-To: <20220714070754.1428-1-tariqt@nvidia.com>
To:     Tariq Toukan <tariqt@nvidia.com>
Cc:     borisp@nvidia.com, john.fastabend@gmail.com, kuba@kernel.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, saeedm@nvidia.com, gal@nvidia.com,
        maximmi@nvidia.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu, 14 Jul 2022 10:07:54 +0300 you wrote:
> Add missing error checks in tls_device_init.
> 
> Fixes: e8f69799810c ("net/tls: Add generic NIC offload infrastructure")
> Reported-by: Jakub Kicinski <kuba@kernel.org>
> Reviewed-by: Maxim Mikityanskiy <maximmi@nvidia.com>
> Signed-off-by: Tariq Toukan <tariqt@nvidia.com>
> 
> [...]

Here is the summary with links:
  - [net] net/tls: Check for errors in tls_device_init
    https://git.kernel.org/netdev/net/c/3d8c51b25a23

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


