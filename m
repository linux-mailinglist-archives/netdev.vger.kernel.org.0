Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 60AF6502896
	for <lists+netdev@lfdr.de>; Fri, 15 Apr 2022 13:00:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1352521AbiDOLCn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Apr 2022 07:02:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242219AbiDOLCl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Apr 2022 07:02:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3282E68988;
        Fri, 15 Apr 2022 04:00:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BC60762254;
        Fri, 15 Apr 2022 11:00:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 11491C385A9;
        Fri, 15 Apr 2022 11:00:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1650020412;
        bh=xxBLbG0zk2w7QvaLqimPElzowCyAGhDvRmaAMz/60t0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=SYtF4cEe5XvMnLtsbqvbHcYiXnOC9adriRy5ewJjV+133VB1KMPB6duI/vLlBtMP7
         fK4JoRu8q0jB0NfakMIQnfv6hfKbg4ISiATywQ+SBWBadTApjIA6FwX/UTJiYTCRIb
         /0XMqnZqpMMzE03ggpnOEXWtNjOlvTW3by0WuFSNnzssN90WmWPkliURPuxOCWyCVi
         TXXBw41f/O+S/8JYnkzj+dIigWgrrbSXXcnYqtXqfDr+HCY9H94DObJT2JoXQpMmgl
         3O13vizizRRqR+Z7EFlNBQ8dlTuhrhVWcGYo+11QIA6TvuxiwpUxWOfqp/xI+PViLh
         axlIlw+g0UINQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E93BCEAC096;
        Fri, 15 Apr 2022 11:00:11 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] openvswitch: fix OOB access in reserve_sfa_size()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165002041195.31119.1787204270589616559.git-patchwork-notify@kernel.org>
Date:   Fri, 15 Apr 2022 11:00:11 +0000
References: <165001012108.2147631.5880395764325229829.stgit@fed.void>
In-Reply-To: <165001012108.2147631.5880395764325229829.stgit@fed.void>
To:     Paolo Valerio <pvalerio@redhat.com>
Cc:     netdev@vger.kernel.org, dev@openvswitch.org, pshelar@ovn.org,
        davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        stable@vger.kernel.org
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
by David S. Miller <davem@davemloft.net>:

On Fri, 15 Apr 2022 10:08:41 +0200 you wrote:
> Given a sufficiently large number of actions, while copying and
> reserving memory for a new action of a new flow, if next_offset is
> greater than MAX_ACTIONS_BUFSIZE, the function reserve_sfa_size() does
> not return -EMSGSIZE as expected, but it allocates MAX_ACTIONS_BUFSIZE
> bytes increasing actions_len by req_size. This can then lead to an OOB
> write access, especially when further actions need to be copied.
> 
> [...]

Here is the summary with links:
  - openvswitch: fix OOB access in reserve_sfa_size()
    https://git.kernel.org/netdev/net/c/cefa91b2332d

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


