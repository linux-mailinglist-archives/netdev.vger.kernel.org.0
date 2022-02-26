Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 729C44C5601
	for <lists+netdev@lfdr.de>; Sat, 26 Feb 2022 14:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231197AbiBZNAs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 26 Feb 2022 08:00:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiBZNAr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 26 Feb 2022 08:00:47 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1C21C266D99
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 05:00:12 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 3B3816092A
        for <netdev@vger.kernel.org>; Sat, 26 Feb 2022 13:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 95ECFC340F1;
        Sat, 26 Feb 2022 13:00:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1645880411;
        bh=EhnHpXOIli+jY8evit/zKNvbREnF875tl0gX2MNMO5U=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AIvza2kjZafbhZ19uztWwAqcZXskgIBhWWMjpSHAE4J77cnF0rariqgX1l45oRHOw
         L8URpJHxqFD1WvSWvw/wLgnPyqxtg6o0iVJmPiL+hXn8vCpLvJkhXl+yuxPsxPSUF8
         9nu7g8ECvwK2pKhBh4QbUILpgV6+wpSqhuxhrx/zWP8dHGzBqtnKY8W41Djm+dXafL
         D9YWBRhpbA0ShsXjMFArSWCukK9VDa30ZPVwFQQxG1kbdMIJNAoL55zyzZ3zYQVud5
         GoIY+WsRrTzwcDFw/z45xQKIQIy3kHTtBLC6zK3PpVcSLpvTp6eLCq9u6RnwyKbBRN
         OZFNzXHbjRNQQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 7356AEAC095;
        Sat, 26 Feb 2022 13:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/8][pull request] Intel Wired LAN Driver Updates
 2022-02-25
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164588041146.8718.9913656272536439293.git-patchwork-notify@kernel.org>
Date:   Sat, 26 Feb 2022 13:00:11 +0000
References: <20220225194614.136571-1-anthony.l.nguyen@intel.com>
In-Reply-To: <20220225194614.136571-1-anthony.l.nguyen@intel.com>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        sassmann@redhat.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by Tony Nguyen <anthony.l.nguyen@intel.com>:

On Fri, 25 Feb 2022 11:46:06 -0800 you wrote:
> This series contains updates to iavf driver only.
> 
> Slawomir fixes stability issues that can be seen when stressing the
> driver using a large number of VFs with a multitude of operations.
> Among the fixes are reworking mutexes to provide more effective locking,
> ensuring initialization is complete before teardown, preventing
> operations which could race while removing the driver, stopping certain
> tasks from being queued when the device is down, and adding a missing
> mutex unlock.
> 
> [...]

Here is the summary with links:
  - [net,1/8] iavf: Rework mutexes for better synchronisation
    https://git.kernel.org/netdev/net/c/fc2e6b3b132a
  - [net,2/8] iavf: Add waiting so the port is initialized in remove
    https://git.kernel.org/netdev/net/c/974578017fc1
  - [net,3/8] iavf: Fix init state closure on remove
    https://git.kernel.org/netdev/net/c/3ccd54ef44eb
  - [net,4/8] iavf: Fix locking for VIRTCHNL_OP_GET_OFFLOAD_VLAN_V2_CAPS
    https://git.kernel.org/netdev/net/c/0579fafd37fb
  - [net,5/8] iavf: Fix race in init state
    https://git.kernel.org/netdev/net/c/a472eb5cbaeb
  - [net,6/8] iavf: Fix deadlock in iavf_reset_task
    https://git.kernel.org/netdev/net/c/e85ff9c631e1
  - [net,7/8] iavf: Fix missing check for running netdev
    https://git.kernel.org/netdev/net/c/d2c0f45fcceb
  - [net,8/8] iavf: Fix __IAVF_RESETTING state usage
    https://git.kernel.org/netdev/net/c/14756b2ae265

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


