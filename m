Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EBC3960C241
	for <lists+netdev@lfdr.de>; Tue, 25 Oct 2022 05:30:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230218AbiJYDa0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Oct 2022 23:30:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229915AbiJYDaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Oct 2022 23:30:24 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3C601FCD9
        for <netdev@vger.kernel.org>; Mon, 24 Oct 2022 20:30:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8B349B819D8
        for <netdev@vger.kernel.org>; Tue, 25 Oct 2022 03:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 24D4BC43470;
        Tue, 25 Oct 2022 03:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1666668618;
        bh=ti1+BsJFm6bf9VDeFoBnqMfeN7w/WC6AEFhKssMwNAg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GOZMxJqYbDdNhF+YdSEs0PzxfGCV+c/92N6OSNLg+nGO4vh5JrYb1MJRfwCZCtSR0
         RMocU0iMDah1TDtPembJVHkZa6MTmuSpSrOkCYv2w6F0Dv0tmpHjCwsk+1Ncna3Bs3
         H5wIRMhFQ1tJrtAdptkjsA08rvARaYpayUVVtmLTzGde845l6KVDRrLFOXq1TnffPY
         /GX6689ImX+9GE6FkN+Uup1vfrc8C80C0uLVzhIeUPktC+Nc+vQY4Y/C4L5X0br0b0
         gQoLXP378b2OF/ztizvh7+740H3L8iLOxEtX/ckRl0ptca4GwdRabK8znaJxzrnuLm
         sd+5u8f35KyRQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0A60EE270E7;
        Tue, 25 Oct 2022 03:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v3 0/3] bnxt_en: Driver updates
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166666861703.16688.7421694669009155530.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Oct 2022 03:30:17 +0000
References: <1666334243-23866-1-git-send-email-michael.chan@broadcom.com>
In-Reply-To: <1666334243-23866-1-git-send-email-michael.chan@broadcom.com>
To:     Michael Chan <michael.chan@broadcom.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, kuba@kernel.org,
        edumazet@google.com, pabeni@redhat.com, gospo@broadcom.com,
        vikas.gupta@broadcom.com
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 21 Oct 2022 02:37:20 -0400 you wrote:
> This patchset adds .get_module_eeprom_by_page() support and adds
> an NVRAM resize step to allow larger firmware images to be flashed
> to older firmware.
> 
> v3: Return more specific extack error when .get_module_eeprom_by_page()
>     fails.
>     Return -EINVAL from bnxt_get_module_eeprom_by_page() when we
>     don't want to fallback to old method.
> v2: Simplify .get_module_eeprom_by_page() as suggested by Ido Schimmel
> 
> [...]

Here is the summary with links:
  - [net-next,v3,1/3] bnxt_en: Update firmware interface to 1.10.2.118
    https://git.kernel.org/netdev/net-next/c/84a911db8305
  - [net-next,v3,2/3] bnxt_en: add .get_module_eeprom_by_page() support
    https://git.kernel.org/netdev/net-next/c/7ef3d3901b99
  - [net-next,v3,3/3] bnxt_en: check and resize NVRAM UPDATE entry before flashing
    https://git.kernel.org/netdev/net-next/c/45034224623a

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


