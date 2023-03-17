Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A46476BE262
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 09:00:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231247AbjCQIAZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 04:00:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45426 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231246AbjCQIAX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 04:00:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 69BC03FBA9
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 01:00:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id EE87362200
        for <netdev@vger.kernel.org>; Fri, 17 Mar 2023 08:00:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5BFDBC433A8;
        Fri, 17 Mar 2023 08:00:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679040019;
        bh=5IfkrOPt6XkYUhKbtndj8nmhLbDhn83FWYTbnfu7Nk8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=in44UQRXzUr/St4866rfNsqaRX9EmLQKiGMtkeePXWf5UcIo2djJZLuogjj5Oufb4
         uQnDScmprCP1YcHI1szp6tmJKVpe+MtH1J89y2bEu96G3gEMDDLizm6bS7pB4o7m3w
         7Q4eTXCDvSUzcDhnkXPbqLS3CKafZpq7CcsR6hB1bGUNR5Tr1/9YZy9Mi0S09nkNQ8
         twbUNqyJosG4GVRXkS3d3tMM/uAVtYLcIjJ0lf3q21E6QwtCQjOslmQOASU3b+ARWJ
         AJFsvNZBbKqDQ0fV6kJCXd56OsANVGW4ifHuvS5OjTS2XUvECUyYCUWXtBUSfP9qsD
         +A5IFCn8elYcA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 43C7DE2A03B;
        Fri, 17 Mar 2023 08:00:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next v2] net: wangxun: Implement the ndo change mtu
 interface
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167904001927.28626.7154832800777638807.git-patchwork-notify@kernel.org>
Date:   Fri, 17 Mar 2023 08:00:19 +0000
References: <20230315074304.13178-1-mengyuanlou@net-swift.com>
In-Reply-To: <20230315074304.13178-1-mengyuanlou@net-swift.com>
To:     mengyuanlou <mengyuanlou@net-swift.com>
Cc:     netdev@vger.kernel.org, jiawenwu@trustnetic.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Wed, 15 Mar 2023 15:43:04 +0800 you wrote:
> From: Mengyuan Lou <mengyuanlou@net-swift.com>
> 
> Add ngbe and txgbe ndo_change_mtu support.
> 
> Signed-off-by: Mengyuan Lou <mengyuanlou@net-swift.com>
> ---
> v2:
> - Andrew Lunn: https://lore.kernel.org/netdev/Y+4rd1q58XzLlCOy@lunn.ch/
> - Alexander Lobakin:
> 	https://lore.kernel.org/netdev/fb59cc0a-d92b-ca16-4594-79d54d061bd7@intel.com/
> 
> [...]

Here is the summary with links:
  - [net-next,v2] net: wangxun: Implement the ndo change mtu interface
    https://git.kernel.org/netdev/net-next/c/81dc07417f0f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


