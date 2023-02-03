Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3BD3768A390
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 21:30:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233158AbjBCUaX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 15:30:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34284 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233097AbjBCUaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 15:30:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 857176534E;
        Fri,  3 Feb 2023 12:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3DFE1B82BA4;
        Fri,  3 Feb 2023 20:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D634BC4339B;
        Fri,  3 Feb 2023 20:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675456217;
        bh=3W9MwIWQwJfpWzK2GutTz6rAGfykRYt/n9bQ9jesbjg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=niOL9uwnuLSOnL2FvsBIY1iHE49reBjfKESkiGCyoEPF4fG0meR2nugIkc41s8Ykx
         /E9ag4bwHULzrMZsVRGwv6Uo6ejXs3ELnJR5UBKrJj8CJXG5ec0NPNguTT1UNsV65Y
         mkVtUVT1KVAAm/QYvbSjzhM8suIIDOEfA3I1OeikvdA+WYa9ZzrSRmCvc+0N6fdMGn
         bYP/IeQaqw3MRi96cFF4t3kO3XoNnxqoV0SEI85T0mYMskAyFqX6WMk9Gj25E5zU6z
         ud0qSB/z51Uhv2NlKhyrHIpm+FApDsRV2emIDjSMsXxmkKyNXYjtm5mBuB44voQ0XQ
         kjIIkOPk4S8gA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B8624E270CB;
        Fri,  3 Feb 2023 20:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] Bluetooth: Free potentially unfreed SCO connection
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <167545621774.19489.15945794650685892381.git-patchwork-notify@kernel.org>
Date:   Fri, 03 Feb 2023 20:30:17 +0000
References: <20230203173024.1.Ieb6662276f3bd3d79e9134ab04523d584c300c45@changeid>
In-Reply-To: <20230203173024.1.Ieb6662276f3bd3d79e9134ab04523d584c300c45@changeid>
To:     Archie Pusaka <apusaka@google.com>
Cc:     linux-bluetooth@vger.kernel.org, luiz.dentz@gmail.com,
        marcel@holtmann.org, chromeos-bluetooth-upstreaming@chromium.org,
        apusaka@chromium.org, yinghsu@chromium.org, davem@davemloft.net,
        edumazet@google.com, kuba@kernel.org, johan.hedberg@gmail.com,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bluetooth/bluetooth-next.git (master)
by Luiz Augusto von Dentz <luiz.von.dentz@intel.com>:

On Fri,  3 Feb 2023 17:30:55 +0800 you wrote:
> From: Archie Pusaka <apusaka@chromium.org>
> 
> It is possible to initiate a SCO connection while deleting the
> corresponding ACL connection, e.g. in below scenario:
> 
> (1) < hci setup sync connect command
> (2) > hci disconn complete event (for the acl connection)
> (3) > hci command complete event (for(1), failure)
> 
> [...]

Here is the summary with links:
  - Bluetooth: Free potentially unfreed SCO connection
    https://git.kernel.org/bluetooth/bluetooth-next/c/c2c762af5650

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


