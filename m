Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8BA2558A09C
	for <lists+netdev@lfdr.de>; Thu,  4 Aug 2022 20:40:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237266AbiHDSkQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Aug 2022 14:40:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37496 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236308AbiHDSkP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 4 Aug 2022 14:40:15 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7918911150
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 11:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 086E861568
        for <netdev@vger.kernel.org>; Thu,  4 Aug 2022 18:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 56D2CC433D7;
        Thu,  4 Aug 2022 18:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659638413;
        bh=HhHjywBRtK1s3vIH4rBVX6jQnAqLm7d+OMfzhW6VY88=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pAXlQsUy6C6243BhOVTWPeKqUiE9K4W+jrsgAoT3oKQX0Nv4fqiJ78i5VK56FCHRG
         8NCwQ8xLymwpoXxSOAa5M3uMYntYZg+32mIej/x80PmEkxfYE6bYbyBydfgdewmbZp
         68Xagqud3Cmd25bIaznT06Tv1e8U5AkFF0XMC+FHrHLk6YcSqIr8dZqaeiQ00KvNnf
         SKPukYLGRu30tVH3wLZFeaWJ5y8YmSn8848NrsatKzQpcAhSOrZkBUL8OqVEV2Kp1F
         qcyc0An910Sx6J8MkQrj0+9kaMUHVHXaPjgdwv4GUjW6sL8esKQTfOcUfHfN+pHAti
         0rMzki44co5TQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 408D5C43143;
        Thu,  4 Aug 2022 18:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next v6 0/1] devlink: add support to run selftest
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165963841326.12091.8816370869435845326.git-patchwork-notify@kernel.org>
Date:   Thu, 04 Aug 2022 18:40:13 +0000
References: <20220804091802.36136-1-vikas.gupta@broadcom.com>
In-Reply-To: <20220804091802.36136-1-vikas.gupta@broadcom.com>
To:     Vikas Gupta <vikas.gupta@broadcom.com>
Cc:     jiri@nvidia.com, dsahern@kernel.org, stephen@networkplumber.org,
        kuba@kernel.org, netdev@vger.kernel.org, edumazet@google.com,
        michael.chan@broadcom.com, andrew.gospodarek@broadcom.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to iproute2/iproute2-next.git (main)
by David Ahern <dsahern@kernel.org>:

On Thu,  4 Aug 2022 14:48:01 +0530 you wrote:
> Hi,
>   This patchset adds support in devlink to run selftests.
>   A related patchset for kernel has been merged.
> 
>  Below are the few examples for the commands implemented in the
>  patchset.
> 
> [...]

Here is the summary with links:
  - [iproute2-next,v6,1/1] devlink: add support for running selftests
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=06cb288d63f5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


