Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 65A625BF195
	for <lists+netdev@lfdr.de>; Wed, 21 Sep 2022 02:00:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230221AbiIUAAV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 20:00:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57278 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229971AbiIUAAU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 20:00:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 079822F651
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 17:00:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7E455B81011
        for <netdev@vger.kernel.org>; Wed, 21 Sep 2022 00:00:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 23B22C433C1;
        Wed, 21 Sep 2022 00:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663718416;
        bh=pLOzzcadgBqzp+Dd/DBkVdvhkGefEm0UmiAEO8ngwY4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=oNKitQq/+WfgPpknNdjaL2iTfAi0DpLmE1rHDyUzhsxPwsmnAX8lQg6oSWLxsyiZ8
         1nl3k8zOpDybARCZcy47ja6pZ/gzhqmuzeBmeHSg6Nn+m7YXEmxdL3QMw/hegngmyG
         9ePitufmoUVRVm/B+PzvYYOLg4LGJuKlU3TXbI2DEAKXWvZd+3i6YXDRJhuxFdMlzx
         88R0cP2ZE/hkHU6ZXSLX0BiuPdYg/Lirvk47C6TkXdM9GWWJ1eh6fJ0ACsPmY8zSAj
         lTVBx08mqDzVrgFismkx6LB8StqmKMm/+0XKx8PIEMz0KRNddIjbJXi4NW1pHfJY+C
         k0ixZuQV6PVFQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 040CFE21EE2;
        Wed, 21 Sep 2022 00:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 1/1] ice: Add low latency Tx timestamp read
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166371841601.16905.11565731552834205871.git-patchwork-notify@kernel.org>
Date:   Wed, 21 Sep 2022 00:00:16 +0000
References: <20220916201728.241510-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220916201728.241510-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        edumazet@google.com, karol.kolacinski@intel.com,
        netdev@vger.kernel.org, richardcochran@gmail.com,
        gurucharanx.g@intel.com
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

On Fri, 16 Sep 2022 13:17:28 -0700 you wrote:
> From: Karol Kolacinski <karol.kolacinski@intel.com>
> 
> E810 products can support low latency Tx timestamp register read.
> This requires usage of threaded IRQ instead of kthread to reduce the
> kthread start latency (spikes up to 20 ms).
> Add a check for the device capability and use the new method if
> supported.
> 
> [...]

Here is the summary with links:
  - [net-next,1/1] ice: Add low latency Tx timestamp read
    https://git.kernel.org/netdev/net-next/c/1229b33973c7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


