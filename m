Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EDF576E4098
	for <lists+netdev@lfdr.de>; Mon, 17 Apr 2023 09:20:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230355AbjDQHUc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Apr 2023 03:20:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230221AbjDQHUY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Apr 2023 03:20:24 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B11C4207;
        Mon, 17 Apr 2023 00:20:23 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F2A5161EF3;
        Mon, 17 Apr 2023 07:20:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5C04FC433EF;
        Mon, 17 Apr 2023 07:20:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681716022;
        bh=ATCzHu0AM9hhYzQ0hEl2s+8H9HWR5MRyo+URZre6FBU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=AH3uBEXXLf6yQsq6qJE6j2Ej3doMs09KIqmAUZoLY0sNepJCPMx0MCPX4LMKvfcnz
         GQ+YjEBNZ0R+KnJLo54oXlDzEjzLBAJzgFU8W4ihm8bRU7BottxH0uO2DPCZzQJKf6
         cpr57bF86GknK8R/ce9LjG5w9bW8pk01DuOyfoEbZ0o2Cbf/qZHTUp218NvwXbS85h
         mA9I4pBruKKsUJCsn9dp+MCWz7TQ6eVtJ77sPDcdA6XwkC5bAiNuoW/fHZ1RpLoF8u
         c8OXDt7gkWeUuQga7ABwohOVwRp45N++hrGGYDzssWN+OXgfKIlsjnUO6c+0gmX7z4
         /X5LpzKl/LXvw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3DDAAC41671;
        Mon, 17 Apr 2023 07:20:22 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next 0/3] selftests: openvswitch: add support for testing
 upcall interface
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168171602224.1935.16517094817384926030.git-patchwork-notify@kernel.org>
Date:   Mon, 17 Apr 2023 07:20:22 +0000
References: <20230414131750.4185160-1-aconole@redhat.com>
In-Reply-To: <20230414131750.4185160-1-aconole@redhat.com>
To:     Aaron Conole <aconole@redhat.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, pshelar@ovn.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, i.maximets@ovn.org, shuah@kernel.org,
        linux-kselftest@vger.kernel.org
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

This series was applied to netdev/net-next.git (main)
by David S. Miller <davem@davemloft.net>:

On Fri, 14 Apr 2023 09:17:47 -0400 you wrote:
> The existing selftest suite for openvswitch will work for regression
> testing the datapath feature bits, but won't test things like adding
> interfaces, or the upcall interface.  Here, we add some additional
> test facilities.
> 
> First, extend the ovs-dpctl.py python module to support the OVS_FLOW
> and OVS_PACKET netlink families, with some associated messages.  These
> can be extended over time, but the initial support is for more well
> known cases (output, userspace, and CT).
> 
> [...]

Here is the summary with links:
  - [net-next,1/3] selftests: openvswitch: add interface support
    https://git.kernel.org/netdev/net-next/c/74cc26f416b9
  - [net-next,2/3] selftests: openvswitch: add flow dump support
    https://git.kernel.org/netdev/net-next/c/e52b07aa1a54
  - [net-next,3/3] selftests: openvswitch: add support for upcall testing
    https://git.kernel.org/netdev/net-next/c/9feac87b673c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


