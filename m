Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4D64F0D02
	for <lists+netdev@lfdr.de>; Mon,  4 Apr 2022 01:40:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230117AbiDCXmH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 3 Apr 2022 19:42:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33972 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1376691AbiDCXmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 3 Apr 2022 19:42:06 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3F3D22C650;
        Sun,  3 Apr 2022 16:40:12 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BD4B060FA7;
        Sun,  3 Apr 2022 23:40:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 13ACFC340F3;
        Sun,  3 Apr 2022 23:40:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649029211;
        bh=0llJGylLuc6zDSiUmx3f8sBZhJOqxtCcXbS0cPJ+2OY=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ba5hVXZ+OynFrfRY1+i2BniKemZbvcrilpVsrmsN8ah0usPYO0eSm7JLvD+MjuYBv
         8JOg/9zeE0Dv+PqSveRXr+ESyUbh0iIRWtr5cKAkTDIjAd2Mn7wqZrRl+Z0CjvH5RY
         omiCtqAU+MHGT0gEBLNwEU1KCzJzeMznX/yK0G3FhnGrTTsW0TodFJG2sFWpMGEO1w
         c42lPeJqrmZTjfWwj+2XibqsfpUohFdvLVSbhM2gL6BtAC8tI02RxNuiwZDYmba6WV
         fJsGYdJqL9R8VMOi07sh+56u2dDoXs6cHUFIgBvqiUo1We61m4wIY8r7bVN7JrXSOY
         vtUIfSAppjYew==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E3AAFE4A6CB;
        Sun,  3 Apr 2022 23:40:10 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] bpf: replace usage of supported with dedicated list
 iterator variable
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164902921092.1167.516960967267677519.git-patchwork-notify@kernel.org>
Date:   Sun, 03 Apr 2022 23:40:10 +0000
References: <20220331091929.647057-1-jakobkoschel@gmail.com>
In-Reply-To: <20220331091929.647057-1-jakobkoschel@gmail.com>
To:     Jakob Koschel <jakobkoschel@gmail.com>
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, rppt@kernel.org,
        bjohannesmeyer@gmail.com, c.giuffrida@vu.nl, h.j.bos@vu.nl
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

This patch was applied to bpf/bpf-next.git (master)
by Andrii Nakryiko <andrii@kernel.org>:

On Thu, 31 Mar 2022 11:19:29 +0200 you wrote:
> To move the list iterator variable into the list_for_each_entry_*()
> macro in the future it should be avoided to use the list iterator
> variable after the loop body.
> 
> To *never* use the list iterator variable after the loop it was
> concluded to use a separate iterator variable instead of a
> found boolean [1].
> 
> [...]

Here is the summary with links:
  - [v2] bpf: replace usage of supported with dedicated list iterator variable
    https://git.kernel.org/bpf/bpf-next/c/185da3da9379

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


