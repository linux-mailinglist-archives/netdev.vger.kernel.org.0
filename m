Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B3CB268E007
	for <lists+netdev@lfdr.de>; Tue,  7 Feb 2023 19:31:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232331AbjBGSba (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Feb 2023 13:31:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56736 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229992AbjBGSb3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Feb 2023 13:31:29 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 75C2B1AE;
        Tue,  7 Feb 2023 10:31:28 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26827B81A1F;
        Tue,  7 Feb 2023 18:31:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 362F6C433EF;
        Tue,  7 Feb 2023 18:31:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675794685;
        bh=7D+FGdUcwyW9rKac2iRq0Q6ML2h/GFCkjJcCSB9Tu3E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Wn9h8sP7HD80T+q2uhlGOEc56yIl1cTicGx4Bg8WEXvGcisDb1NZ6Bh2TXPOC2fhr
         7gNRHy9bET+GgfBhyg+Ox6x/xYdNyMF4rdQs/623dpjQvsodx0g11r0qHaTEgiY/xA
         ouzb3XF5RR6v7yKuSAVKRmYVKDItJOKxUdx+eIKSqGwvmYKFhJv7JjwnRW0G3E5vcz
         i72VUFScVMzeHnqyjFvDYLAFP9Ju1uZGtjWhob4SANZydDtBwtXQl46DR7rB+EvhoU
         etnIBKSN5KMubloYUNXXEwq8XEiuaali+kRFVc6VADHBF8sOTXc4e5WiTvCx4Zgn4F
         fhRt+vq7skNUw==
Date:   Tue, 7 Feb 2023 10:31:24 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Qi Zheng <zhengqi.arch@bytedance.com>
Cc:     patchwork-bot+netdevbpf@kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        rafael@kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, vireshk@kernel.org, nm@ti.com,
        sboyd@kernel.org, linux-kernel@vger.kernel.org,
        linux-pm@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 0/3] some minor fixes of error checking about
 debugfs_rename()
Message-ID: <20230207103124.052b5ce1@kernel.org>
In-Reply-To: <aeae8fb8-b052-0d4a-5d3e-8de81e1b5092@bytedance.com>
References: <20230202093256.32458-1-zhengqi.arch@bytedance.com>
        <167548141786.31101.12461204128706467220.git-patchwork-notify@kernel.org>
        <aeae8fb8-b052-0d4a-5d3e-8de81e1b5092@bytedance.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 7 Feb 2023 18:30:40 +0800 Qi Zheng wrote:
> > Here is the summary with links:
> >    - [1/3] debugfs: update comment of debugfs_rename()
> >      (no matching commit)
> >    - [2/3] bonding: fix error checking in bond_debug_reregister()
> >      https://git.kernel.org/netdev/net/c/cbe83191d40d
> >    - [3/3] PM/OPP: fix error checking in opp_migrate_dentry()
> >      (no matching commit)  
> 
> Does "no matching commit" means that these two patches have not been
> applied? And I did not see them in the linux-next branch.

Correct, we took the networking patch to the networking tree.
You'd be better off not grouping patches from different subsystems
if there are no dependencies. Maintainers may get confused about
who's supposed to apply them, err on the side of caution and 
not apply anything.

> If so, hi Greg, Can you help to review and apply these two patches
> ([1/3] and [3/3])?

Or 3/3 should go to Viresh?.. Dunno..
