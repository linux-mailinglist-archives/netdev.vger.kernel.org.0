Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6FCEC69C6A8
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 09:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230493AbjBTIab (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 03:30:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44018 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230078AbjBTIaa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 03:30:30 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4691E1352F
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 00:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C3E8460D29
        for <netdev@vger.kernel.org>; Mon, 20 Feb 2023 08:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 22D4EC4339C;
        Mon, 20 Feb 2023 08:30:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676881818;
        bh=7Jlfv8F3IFCurx/lGXkGFQUzK92Lx/aDSQR7gN12cas=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=sxELU0zVMPouKLgrlrg1cj+EFc0qt8hu+frL7/xoVuSYU+QjUuXwgBPAlHfGO37Io
         UQXHj5Sw2gI1P7c40fyCB+fVAPVvagX72I1seBbrmDu/HHKjlvf0DyEvRJnj8LT/Lo
         7v/689KApiqAVJGR19FQ5F3Re7OjKldqfSfEgCdmYORhdkyefGw6XnCs3Dpn4ODPsZ
         s0VOLGbj2+Kh9vp3Ax7ESKeo2x5Zl3OIjdhjRktHycbmG0iBkUQbfNot/+YM2voQKG
         uKVUQddmK+8tODTPznAmihGXBC8KIDISQ86zThiLnzqi9izvlDmcqHDIVMtsWmOXyE
         OVdICS7SfAaVg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 02623C691DE;
        Mon, 20 Feb 2023 08:30:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] selftests/net: Interpret UDP_GRO cmsg data as an int
 value
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167688181799.23180.7389167269129529973.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Feb 2023 08:30:17 +0000
References: <20230216124340.875338-1-jakub@cloudflare.com>
In-Reply-To: <20230216124340.875338-1-jakub@cloudflare.com>
To:     Jakub Sitnicki <jakub@cloudflare.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, kernel-team@cloudflare.com
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Thu, 16 Feb 2023 13:43:40 +0100 you wrote:
> Data passed to user-space with a (SOL_UDP, UDP_GRO) cmsg carries an
> int (see udp_cmsg_recv), not a u16 value, as strace confirms:
> 
>   recvmsg(8, {msg_name=...,
>               msg_iov=[{iov_base="\0\0..."..., iov_len=96000}],
>               msg_iovlen=1,
>               msg_control=[{cmsg_len=20,         <-- sizeof(cmsghdr) + 4
>                             cmsg_level=SOL_UDP,
>                             cmsg_type=0x68}],    <-- UDP_GRO
>                             msg_controllen=24,
>                             msg_flags=0}, 0) = 11200
> 
> [...]

Here is the summary with links:
  - [net] selftests/net: Interpret UDP_GRO cmsg data as an int value
    https://git.kernel.org/netdev/net/c/436864095a95

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


