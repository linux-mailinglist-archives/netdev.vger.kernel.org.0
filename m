Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A34996C5F30
	for <lists+netdev@lfdr.de>; Thu, 23 Mar 2023 06:50:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230414AbjCWFud (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Mar 2023 01:50:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230356AbjCWFuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Mar 2023 01:50:25 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AF97023A41
        for <netdev@vger.kernel.org>; Wed, 22 Mar 2023 22:50:24 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5CA8EB81F68
        for <netdev@vger.kernel.org>; Thu, 23 Mar 2023 05:50:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 141A2C4339C;
        Thu, 23 Mar 2023 05:50:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679550622;
        bh=x8Z4aOgTlibVGc1atNdSiJvkAO19JDt1AnxevM9Y4WI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=aYwgZYWbDfbnq/WmpghtGf/YojyrunAbUmLVnSu9+dlirMSG9Ca4/8EC1P4CMdTdX
         glenU/pZ5Mcqvqo1kt7hdnMXOo6ywod8s38CNuSHPPAeg4JTbZiaGe8G7sc6tPZxwL
         hrk6ymnIC8W/3ije/0RQNMQG9CXcgyx9P8vg0HP58Jt7cns/uyQy2MrVoSKkHgippH
         ZVHPlRANALiJ4gnRfyiMAYJ2ZX1FSIAvrS/Exi+SWfY1b9FfwCPKo3lu7De5uLv+uW
         S1D/JXnPe4Iugb9btGOjNrnF2UefNoPU4Qcdzochmzf1mCR6N3OFkJ6hGi/gtboZwF
         /p+uVH0w1YQ+A==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F166CE61B86;
        Thu, 23 Mar 2023 05:50:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2 1/2] net: Catch invalid index in XPS mapping
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167955062198.14332.10004881642462868350.git-patchwork-notify@kernel.org>
Date:   Thu, 23 Mar 2023 05:50:21 +0000
References: <20230321150725.127229-1-nnac123@linux.ibm.com>
In-Reply-To: <20230321150725.127229-1-nnac123@linux.ibm.com>
To:     Nick Child <nnac123@linux.ibm.com>
Cc:     netdev@vger.kernel.org, piotr.raczynski@intel.com
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue, 21 Mar 2023 10:07:24 -0500 you wrote:
> When setting the XPS value of a TX queue, warn the user once if the
> index of the queue is greater than the number of allocated TX queues.
> 
> Previously, this scenario went uncaught. In the best case, it resulted
> in unnecessary allocations. In the worst case, it resulted in
> out-of-bounds memory references through calls to `netdev_get_tx_queue(
> dev, index)`. Therefore, it is important to inform the user but not
> worth returning an error and risk downing the netdevice.
> 
> [...]

Here is the summary with links:
  - [net-next,v2,1/2] net: Catch invalid index in XPS mapping
    https://git.kernel.org/netdev/net-next/c/5dd0dfd55bae
  - [net-next,v2,2/2] netdev: Enforce index cap in netdev_get_tx_queue
    https://git.kernel.org/netdev/net-next/c/1cc6571f5627

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


