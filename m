Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDA194DBC14
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 02:10:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350803AbiCQBL1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 21:11:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242548AbiCQBL0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 21:11:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7D5661D301
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 18:10:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 151D361761
        for <netdev@vger.kernel.org>; Thu, 17 Mar 2022 01:10:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 77A90C340EF;
        Thu, 17 Mar 2022 01:10:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647479410;
        bh=ibuDjf4pnPyHzgh481xgZ3Wmi0Bk0+AWqr6sDCAP8Y4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ql6meQwCEJtvP9qkdkrJ7mY8Rf+8GLHUNGj6oZ/r/YrSLSLZR6UYaHMGtJ4TF8/or
         lD+SjkrYZ91DcTPIHFpBS94aOFNqXq+HSrnGB6IP759SfEJHGe+7Lwi+AW6eh2M6EJ
         0JsSlcfpgApDyNzADeOyuYaKjV4PENmJyLhCgPH2xIJ81RBinIvNsgaGOqOFf8IJhR
         LXVFCJruRC5wxAI5ln3FYQrstE+VUPtzpY/wKNhl3fp1VO75d63P6ctK04j+px/mwS
         KJRR8EAsmq9FQGW43KqVdy3A228Bl+L0wcf/T2ET4jHi29SqDDUc0uoD2hX/9bXkQH
         fPf7JmUKQ1T/g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4B724E8DD5B;
        Thu, 17 Mar 2022 01:10:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] vdpa: Update man page with added support to configure max vq
 pair
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164747941030.23040.1804187689944474995.git-patchwork-notify@kernel.org>
Date:   Thu, 17 Mar 2022 01:10:10 +0000
References: <20220315131358.7210-1-elic@nvidia.com>
In-Reply-To: <20220315131358.7210-1-elic@nvidia.com>
To:     Eli Cohen <elic@nvidia.com>
Cc:     dsahern@kernel.org, stephen@networkplumber.org,
        netdev@vger.kernel.org, virtualization@lists.linux-foundation.org,
        jasowang@redhat.com, si-wei.liu@oracle.com, mst@redhat.com,
        lulu@redhat.com, parav@nvidia.com
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Tue, 15 Mar 2022 15:13:58 +0200 you wrote:
> Update man page to include information how to configure the max
> virtqueue pairs for a vdpa device when creating one.
> 
> Signed-off-by: Eli Cohen <elic@nvidia.com>
> ---
>  man/man8/vdpa-dev.8 | 6 ++++++
>  1 file changed, 6 insertions(+)

Here is the summary with links:
  - vdpa: Update man page with added support to configure max vq pair
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=8130653dabe6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


