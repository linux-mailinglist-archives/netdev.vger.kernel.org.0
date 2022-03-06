Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE2E4CEAA7
	for <lists+netdev@lfdr.de>; Sun,  6 Mar 2022 12:00:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233223AbiCFLBE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Mar 2022 06:01:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230380AbiCFLBD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Mar 2022 06:01:03 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AC481AD98;
        Sun,  6 Mar 2022 03:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B433361207;
        Sun,  6 Mar 2022 11:00:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 050A3C340EE;
        Sun,  6 Mar 2022 11:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646564411;
        bh=gQgt51KfbhtelpDvXytR5KCXX7q2eFZ4r67iCAzuZVE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=F7M+q2M+/Bp1OqDCxXByYV+Bgglh/JEACPE59Ou2BAM6RIUM6YJNSKD7goQ5XHLSb
         Lt5WM9k2XhrcGC5iO3R2ZDALJNyXE77wLt2DYwPA43/ktVpr5i9E/jBmSu5alP/Xj4
         Hfze9aeqSEZ+p99Oq6UFnGX4FPywzX280C5s87/xlSnCfWfk0DFVWzfh4vWdhRL+qw
         4w6kdr+ljxlSCFGxFUCAhiqOJgh5L+D0Jvh8Ah/gQAWoZkigrPdUd+GjvfjqXkoyH7
         fZxSbZ9IWrtNKqPM3/G4MIWfDKwzRf+w33f2v2rAWMQyZa3quC7mSthgyGdk7I1u/z
         +XytWf75G6Guw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DDAF5F0383A;
        Sun,  6 Mar 2022 11:00:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] Revert "net/smc: don't req_notify until all CQEs
 drained"
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164656441090.1458.8729699275971748731.git-patchwork-notify@kernel.org>
Date:   Sun, 06 Mar 2022 11:00:10 +0000
References: <20220304091719.48340-1-dust.li@linux.alibaba.com>
In-Reply-To: <20220304091719.48340-1-dust.li@linux.alibaba.com>
To:     Dust Li <dust.li@linux.alibaba.com>
Cc:     kgraul@linux.ibm.com, davem@davemloft.net, kuba@kernel.org,
        guangguan.wang@linux.alibaba.com, leon@kernel.org,
        netdev@vger.kernel.org, linux-s390@vger.kernel.org,
        linux-rdma@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by David S. Miller <davem@davemloft.net>:

On Fri,  4 Mar 2022 17:17:19 +0800 you wrote:
> This reverts commit a505cce6f7cfaf2aa2385aab7286063c96444526.
> 
> Leon says:
>   We already discussed that. SMC should be changed to use
>   RDMA CQ pool API
>   drivers/infiniband/core/cq.c.
>   ib_poll_handler() has much better implementation (tracing,
>   IRQ rescheduling, proper error handling) than this SMC variant.
> 
> [...]

Here is the summary with links:
  - [net-next] Revert "net/smc: don't req_notify until all CQEs drained"
    https://git.kernel.org/netdev/net-next/c/925a24213b5c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


