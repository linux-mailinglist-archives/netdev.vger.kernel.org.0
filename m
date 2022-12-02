Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 87F00640A0F
	for <lists+netdev@lfdr.de>; Fri,  2 Dec 2022 17:02:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233923AbiLBQCG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Dec 2022 11:02:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35294 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233934AbiLBQBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Dec 2022 11:01:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 265877F8B2
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 08:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A91836231A
        for <netdev@vger.kernel.org>; Fri,  2 Dec 2022 16:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 06EF0C433D7;
        Fri,  2 Dec 2022 16:00:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669996818;
        bh=cw51wr2qhUEufBJYXbZuSdkGf3F8Zo9ay4/o5EFBXyc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=C5asIKBqQZJYNNGhFKNzo0VGzFnQ4A+eHm09vsKD6I6PsPEkRg5uaJiFOChnq3h6k
         rll+GkIb5v1DMPCfgEw+/KaL9zcVwSLXerrQ0642zezUj2lkWVZ3LeGWU+B/VcUeA8
         rO2dCLL7nskhrMKEXJj65TUQLKBfaxrg//+iwEjTPJ91qw34jqgFAr2r3Tjdm9i5fH
         phrjO6gebP1uab0ZU+JvhK8IG9oBDvuINqdIOjMLFHca/YZkAaZbXm3ue6d6VXwBmF
         vzGsnSu6n0016/hVVfMsoJWFTrk6wUnZrpIVvlItByKmvKtFNRJu4EMrmW+XwuL0Tz
         HU298psABKcNw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E2508C395F5;
        Fri,  2 Dec 2022 16:00:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH iproute2-next 1/1] taprio: fix wrong for loop condition in
 add_tc_entries()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166999681792.3415.1993317711039558116.git-patchwork-notify@kernel.org>
Date:   Fri, 02 Dec 2022 16:00:17 +0000
References: <1669962342-2806-1-git-send-email-tee.min.tan@linux.intel.com>
In-Reply-To: <1669962342-2806-1-git-send-email-tee.min.tan@linux.intel.com>
To:     Tan Tee Min <tee.min.tan@linux.intel.com>
Cc:     netdev@vger.kernel.org, dsahern@kernel.org,
        stephen@networkplumber.org, vladimir.oltean@nxp.com,
        vinicius.gomes@intel.com, muhammad.husaini.zulkifli@intel.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri,  2 Dec 2022 14:25:42 +0800 you wrote:
> The for loop in add_tc_entries() mistakenly included the last entry
> index+1. Fix it to correctly loop the max_sdu entry between tc=0 and
> num_max_sdu_entries-1.
> 
> Fixes: b10a6509c195 ("taprio: support dumping and setting per-tc max SDU")
> Signed-off-by: Tan Tee Min <tee.min.tan@linux.intel.com>
> 
> [...]

Here is the summary with links:
  - [iproute2-next,1/1] taprio: fix wrong for loop condition in add_tc_entries()
    https://git.kernel.org/pub/scm/network/iproute2/iproute2-next.git/commit/?id=43aa9d9ce7f8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


