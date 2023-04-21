Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D9886EAD48
	for <lists+netdev@lfdr.de>; Fri, 21 Apr 2023 16:42:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233079AbjDUOmb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Apr 2023 10:42:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46120 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232959AbjDUOmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Apr 2023 10:42:11 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4CCE214F73;
        Fri, 21 Apr 2023 07:41:31 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id CA2C565151;
        Fri, 21 Apr 2023 14:40:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 30F87C433EF;
        Fri, 21 Apr 2023 14:40:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682088021;
        bh=kZ7gvK/5YC+dUYSNtEWHyg+7+yGvM4T1otJQAqhY4pg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=B4OySaK1kfWwB3eyGY/RRN1ozZsTetiWQoSLt492aj7xUmk+StYtGCE4pBI0gz5lE
         /ulJ62v6QyiFn7VhoLqA5Xr1PfjbDNnc0VVHQSPbYJjvK4zj8M5NpG4jfdXF7G4qCh
         aAQWjrUubNjI1tTxrLmtresY2dYobqJkh+viNFVmhtTdVAzhMCzv79ub0HoQUR6o8a
         pbhcfFTxqgXf4l3KzxuQRB38OEeU1u3W/VtFPrJyYr8BLfXcLFhhp5EstXqKT9PdeM
         w3pEcIlxxR69vLVMl7nmavNVhMjY5N/Kf1SN4eMHXNsYx6J5dinnDL26Bk3Dava4PB
         pVESB9ubuBVlg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 19E0EE501E7;
        Fri, 21 Apr 2023 14:40:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH bpf-next] selftests/xsk: put MAP_HUGE_2MB in correct argument
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168208802109.4759.4669418572848372343.git-patchwork-notify@kernel.org>
Date:   Fri, 21 Apr 2023 14:40:21 +0000
References: <20230421062208.3772-1-magnus.karlsson@gmail.com>
In-Reply-To: <20230421062208.3772-1-magnus.karlsson@gmail.com>
To:     Magnus Karlsson <magnus.karlsson@gmail.com>
Cc:     magnus.karlsson@intel.com, bjorn@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, netdev@vger.kernel.org,
        maciej.fijalkowski@intel.com, tirthendu.sarkar@intel.com,
        kal.conley@dectris.com, bpf@vger.kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to bpf/bpf-next.git (master)
by Daniel Borkmann <daniel@iogearbox.net>:

On Fri, 21 Apr 2023 08:22:08 +0200 you wrote:
> From: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> Put the flag MAP_HUGE_2MB in the correct flags argument instead of the
> wrong offset argument.
> 
> Fixes: 2ddade322925 ("selftests/xsk: Fix munmap for hugepage allocated umem")
> Signed-off-by: Magnus Karlsson <magnus.karlsson@intel.com>
> 
> [...]

Here is the summary with links:
  - [bpf-next] selftests/xsk: put MAP_HUGE_2MB in correct argument
    https://git.kernel.org/bpf/bpf-next/c/02e93e0475df

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


