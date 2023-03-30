Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A1B8E6CFA5F
	for <lists+netdev@lfdr.de>; Thu, 30 Mar 2023 06:50:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbjC3EuZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 00:50:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46606 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229941AbjC3EuX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 00:50:23 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6230630EB
        for <netdev@vger.kernel.org>; Wed, 29 Mar 2023 21:50:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 24BDEB825CF
        for <netdev@vger.kernel.org>; Thu, 30 Mar 2023 04:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D1C56C433D2;
        Thu, 30 Mar 2023 04:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680151819;
        bh=RERdL205A3PNueDZZj5OQfL8SYVRdZH8kFdOJYWShTE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tj992kR8GFKBlb1D1heNNpKQu1m3cXbvWF2sEFnztOTSUmMcQWRev0Ijc3bHXWQvN
         tn8wT7Vx9aXLGTqBRdCkqZRNhcRx/xGfeqZLn75xSGrBTwFDz8VusJS3gcAsqnStM7
         2T/ZqRDRmAcv49+yZGy9CzSlhGWs6ilk2cEulgJh5pDPaOYDjGzAiyXfRoLCB24SlV
         APEi0fBXlukPMpPxsZDeAxqB7jKRGO5GAvFAD4zHdbx7zI/Dnni2qhHi0djzKui+rF
         PCo0u3YMcXOCR5Kc4rKT6IStKyccwvBirhOURbTaaYgFGc+zK+uLwJtjNg3eOglFnU
         MKjGgy1r/mEeg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B9543C41612;
        Thu, 30 Mar 2023 04:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] bnxt_en: 3 Bug fixes
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168015181975.11752.2723444571680412522.git-patchwork-notify@kernel.org>
Date:   Thu, 30 Mar 2023 04:50:19 +0000
References: <20230329013021.5205-1-michael.chan@broadcom.com>
In-Reply-To: <20230329013021.5205-1-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, gospo@broadcom.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 28 Mar 2023 18:30:18 -0700 you wrote:
> This series contains 3 small bug fixes covering ethtool self test, PCI
> ID string typos, and some missing 200G link speed ethtool reporting logic.
> 
> Kalesh AP (2):
>   bnxt_en: Fix reporting of test result in ethtool selftest
>   bnxt_en: Fix typo in PCI id to device description string mapping
> 
> [...]

Here is the summary with links:
  - [net,1/3] bnxt_en: Fix reporting of test result in ethtool selftest
    https://git.kernel.org/netdev/net/c/83714dc3db0e
  - [net,2/3] bnxt_en: Fix typo in PCI id to device description string mapping
    https://git.kernel.org/netdev/net/c/62aad36ed31a
  - [net,3/3] bnxt_en: Add missing 200G link speed reporting
    https://git.kernel.org/netdev/net/c/581bce7bcb7e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


