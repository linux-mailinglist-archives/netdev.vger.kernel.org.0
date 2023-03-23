Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C6F416C5D8A
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 04:51:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230401AbjCWDvP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 23:51:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230249AbjCWDue (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 23:50:34 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5CB1F305DF
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 20:50:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 33CD0B81EE1
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 03:50:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF116C4339B;
        Thu, 23 Mar 2023 03:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679543419;
        bh=WVodnDYGjp9nbCxDxekZyS+RNbV7Ye/faCmUeQDT79A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=efGoTXFfJPiJxidCsHM5+bp8VaO0v4vC6taISHNGnegc7n5tDo4ugZG1SzffP6mgz
         HgmTcVJooAmVvsiLMU8RS9AMNF6zmbdBVaeeA9MPy0mMBRPub495ut6nErKkZtzuCi
         ByzA43l3A1FwXrMbcJnr9WXa0Lz29bPAXaj3Eo7wqz7gZ9wlKwCE15lszKxCuhA+qt
         98DK1IhB6lgZewwWNXycYyPweuYAcbfSSk8iulL7DvHK3TrioBeS/0ooLcvzfo63qD
         TlC5kGxnEl9f+BQlk2X1dO5QsHtKl2/fyISqPnhzm5wQUqR9il/2wYh+yFQe6+AI2n
         16iwDfZjYoDTA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C7A26E61B86;
        Thu, 23 Mar 2023 03:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 0/3] bnxt PTP optimizations
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167954341981.25225.10727159112223409387.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 03:50:19 +0000
References: <20230321144449.15289-1-pavan.chebbi@broadcom.com>
In-Reply-To: <20230321144449.15289-1-pavan.chebbi@broadcom.com>
To:     Pavan Chebbi <pavan.chebbi@broadcom.com>
Cc:     michael.chan@broadcom.com, kuba@kernel.org, davem@davemloft.net,
        edumazet@google.com, gospo@broadcom.com, netdev@vger.kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Mar 2023 07:44:46 -0700 you wrote:
> Patches to
> 1. Enforce software based freq adjustments only on shared PHC NIC
> 
> 2. A prerequisite change to expand capability storage field to
> accommodate more Firmware reported capabilities
> 
> v1-->v2:
>   Addressed comments by vadim.fedorenko@linux.dev
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/3] bnxt: Change fw_cap to u64 to accommodate more capability bits
    https://git.kernel.org/netdev/net-next/c/a3a4e300439b
  - [net-next,v2,2/3] bnxt: Defer PTP initialization to after querying function caps
    https://git.kernel.org/netdev/net-next/c/edc528731548
  - [net-next,v2,3/3] bnxt: Enforce PTP software freq adjustments only when in non-RTC mode
    https://git.kernel.org/netdev/net-next/c/a02c33130709

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


