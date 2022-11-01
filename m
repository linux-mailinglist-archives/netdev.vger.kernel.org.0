Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E4B3961437C
	for <lists+netdev@lfdr.de>; Tue,  1 Nov 2022 04:10:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229718AbiKADKU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 31 Oct 2022 23:10:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiKADKT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 31 Oct 2022 23:10:19 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A918613F29
        for <netdev@vger.kernel.org>; Mon, 31 Oct 2022 20:10:18 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 50FC0B81B7F
        for <netdev@vger.kernel.org>; Tue,  1 Nov 2022 03:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DF5C2C43470;
        Tue,  1 Nov 2022 03:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667272215;
        bh=00tgkg0rGEd48pHqTKhFELe6yDno6b421PHnb0VEc1k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=a7otUj02VnDMk2Id3srJjGIysXtYVbbFgC18xDBTqO5rpdpEWTWPsE30bkNxrP0iJ
         G6lEauI1Go1KUy0z8mKxhKBGktfyARviycOLYxaYIjok6DaGCEVb+KjZ5mJDTz3iBu
         D2twvT66Kt4SM+TBwrkv0+GrAW40iLmyFpNY48dSCqSDYO+SKEG6KMcwnarObD12wN
         ZwEHbxWzeYRpUgGxIAaOVDo1pM3JENoI4bEueL3pJS5LfNHBvX8sb305pjNawlOZL1
         4E2/CkvNVR/EsnLWUaUacQ+KkJSfmEV/asRrK5KF3U1zFVlH3VVZSsj40yp1WCehj0
         u4qSNUnEhzK1w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id C4C05E50D71;
        Tue,  1 Nov 2022 03:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Change maintainers for vnic driver
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166727221580.414.3977218413726824805.git-patchwork-notify@kernel.org>
Date:   Tue, 01 Nov 2022 03:10:15 +0000
References: <20221028203509.4070154-1-ricklind@us.ibm.com>
In-Reply-To: <20221028203509.4070154-1-ricklind@us.ibm.com>
To:     Rick Lindsley <ricklind@us.ibm.com>
Cc:     haren@linux.ibm.com, nnac123@linux.ibm.com, danymadden@us.ibm.com,
        tlfalcon@linux.ibm.com, netdev@vger.kernel.org,
        linuxppc-dev@lists.ozlabs.org
X-Spam-Status: No, score=-8.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 28 Oct 2022 13:35:11 -0700 you wrote:
> Changed maintainers for vnic driver, since Dany has new responsibilities.
> Also added Nick Child as reviewer.
> 
> Signed-off-by: Rick Lindsley <ricklind@us.ibm.com>
> 
> ---
>  MAINTAINERS | 5 ++++-
>  1 file changed, 4 insertions(+), 1 deletion(-)

Here is the summary with links:
  - Change maintainers for vnic driver
    https://git.kernel.org/netdev/net/c/e230d36f7d4c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


