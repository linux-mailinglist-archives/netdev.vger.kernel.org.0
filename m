Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9EE754F586C
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 11:15:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbiDFJBe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 05:01:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55566 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1444625AbiDFIz7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 04:55:59 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C71AFE41E;
        Tue,  5 Apr 2022 18:20:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B684D619C0;
        Wed,  6 Apr 2022 01:20:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 1A1CBC385A1;
        Wed,  6 Apr 2022 01:20:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649208012;
        bh=z5ikIrvAWbdvVSUz6n5Lk27siJp+TxbgZHkbrdoS3fM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=tUegwQeMRwlnbqI2AbE2yLSNxRObKDNMvKQJWUqvVtGOCZ2oclfWJkAa07LbpYgUs
         kAHHhbbRqvGIsu3Wl3QohNc7qwSFALBXdDhkAXaTWLfILmshtgbNqwuHE2HmYzNyyx
         NA3n1vUzUpE8gQi9HeB9CYmrMhuipVQowyWlYhz+hdgbazbKsowloY1SjXNYsFdZra
         STzXynB07/yEYg77eLtT0RGcy9Ikh/P5ne/rI+NDhqvlxeOghvp++Tty+8/lc6lBsZ
         5xrq3xqBDFsCVTvbRI5+WOWwbVqAyhTyvCBwiABD+SJ4uhEC4mzE6iC3ySSer3IG+6
         6rNJiETOLuMrg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id F342CE85D53;
        Wed,  6 Apr 2022 01:20:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] net: openvswitch: don't send internal clone attribute to
 the userspace.
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164920801199.3942.3063131772130924818.git-patchwork-notify@kernel.org>
Date:   Wed, 06 Apr 2022 01:20:11 +0000
References: <20220404104150.2865736-1-i.maximets@ovn.org>
In-Reply-To: <20220404104150.2865736-1-i.maximets@ovn.org>
To:     Ilya Maximets <i.maximets@ovn.org>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, davem@davemloft.net,
        dev@openvswitch.org, linux-kernel@vger.kernel.org,
        pabeni@redhat.com, pshelar@ovn.org, azhou@ovn.org,
        pkusunyifeng@gmail.com
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  4 Apr 2022 12:41:50 +0200 you wrote:
> 'OVS_CLONE_ATTR_EXEC' is an internal attribute that is used for
> performance optimization inside the kernel.  It's added by the kernel
> while parsing user-provided actions and should not be sent during the
> flow dump as it's not part of the uAPI.
> 
> The issue doesn't cause any significant problems to the ovs-vswitchd
> process, because reported actions are not really used in the
> application lifecycle and only supposed to be shown to a human via
> ovs-dpctl flow dump.  However, the action list is still incorrect
> and causes the following error if the user wants to look at the
> datapath flows:
> 
> [...]

Here is the summary with links:
  - [net] net: openvswitch: don't send internal clone attribute to the userspace.
    https://git.kernel.org/netdev/net/c/3f2a3050b4a3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


