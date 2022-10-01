Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 082AA5F17FC
	for <lists+netdev@lfdr.de>; Sat,  1 Oct 2022 03:13:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232997AbiJABNn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Sep 2022 21:13:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53804 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232456AbiJABNP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 30 Sep 2022 21:13:15 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E04B0C34D7
        for <netdev@vger.kernel.org>; Fri, 30 Sep 2022 18:10:17 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6EC7AB827A1
        for <netdev@vger.kernel.org>; Sat,  1 Oct 2022 01:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 21525C433D6;
        Sat,  1 Oct 2022 01:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664586615;
        bh=iWlZbxNP6fOXC/F9xHPuUHs+tjlVltXKawESuyKV2wI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sscAL4ogJAq68QwIjBz578fuXvBlrN70OAoCRl9XlYUZvvAMRTyYLzhXoU7yOREo+
         XygyrNbSzjCrf6YRNsev2b1L+WY7WSmszNXbi+ii/KztHuiLyB7kbcWH9J1dxhHYdP
         jqNJSir+FvbLNgEHvP/vbtCFXPuQBHOu3a5moUDfAkgSgXB/VbNvgvTadOfzRdjjj5
         MOL+ynvnPcvr+oFTss7iFa8Gqj+W3RiKSCgWy31bqb+Lf0k/JiECrobbUyAUBvgx+1
         Rn5+cHGGXLV5zgQOKAAAAGBg0j+1Wz0v2dL56Qs4ZVI5V0Xo3CAef7IqLVyC5rGZbc
         vG8I4Cj8i0L1g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 024CCE4D013;
        Sat,  1 Oct 2022 01:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next RESEND] genetlink: reject use of nlmsg_flags for new
 commands
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166458661500.24943.15612491035615658901.git-patchwork-notify@kernel.org>
Date:   Sat, 01 Oct 2022 01:10:15 +0000
References: <20220929142809.1167546-1-kuba@kernel.org>
In-Reply-To: <20220929142809.1167546-1-kuba@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, edumazet@google.com,
        pabeni@redhat.com, johannes@sipsolutions.net, razor@blackwall.org,
        nicolas.dichtel@6wind.com, gnault@redhat.com,
        florent.fourcot@wifirst.fr, pablo@netfilter.org, fw@strlen.de,
        jhs@mojatatu.com, jacob.e.keller@intel.com, liuhangbin@gmail.com
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 29 Sep 2022 07:28:09 -0700 you wrote:
> Commit 9c5d03d36251 ("genetlink: start to validate reserved header bytes")
> introduced extra validation for genetlink headers. We had to gate it
> to only apply to new commands, to maintain bug-wards compatibility.
> Use this opportunity (before the new checks make it to Linus's tree)
> to add more conditions.
> 
> Validate that Generic Netlink families do not use nlmsg_flags outside
> of the well-understood set.
> 
> [...]

Here is the summary with links:
  - [net-next,RESEND] genetlink: reject use of nlmsg_flags for new commands
    https://git.kernel.org/netdev/net-next/c/cff2d762cde6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


