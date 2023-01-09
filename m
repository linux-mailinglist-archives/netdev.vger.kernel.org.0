Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D71EB661F58
	for <lists+netdev@lfdr.de>; Mon,  9 Jan 2023 08:40:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236213AbjAIHk0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Jan 2023 02:40:26 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48322 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230494AbjAIHkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Jan 2023 02:40:18 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F14B13CCA
        for <netdev@vger.kernel.org>; Sun,  8 Jan 2023 23:40:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E633B60F3C
        for <netdev@vger.kernel.org>; Mon,  9 Jan 2023 07:40:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A8AAC433EF;
        Mon,  9 Jan 2023 07:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673250016;
        bh=aKG3RMa5fYfkJi+fsIgiCQuqyMAFMnloeis3YyVP8b0=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=dJZTtHz0DAqz6mZDvJo88uCpm6ah/QcrtCXizRwLJEJpaF2TfTNcWP4/fXbpX71wx
         HbFdmhPD2nu7Oex4QYNW7g2npDWaaxqGWIvqpcngRZLFdhujzht4T+E4khEH95fSi2
         XFyUjJjSYwses5RayKrvsccBmEJQbS3uTQWj/eXoAbQUcGTlgNctoFuqFBoWuJdCwM
         qETnWXT2lc1p59Cgbfrku9PntLAavWD9vHKrNi/0NeOvYwtheKfMP3Wk1kAxj51Ufi
         tzrWl/3eLT/599v6yN6OhhN4XnIItmEy1XbPrIqWyGuokfAwYojX8O2AktFKwpJJwx
         KevTS79T0ScDw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 1D78AE21EE6;
        Mon,  9 Jan 2023 07:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net] gro: take care of DODGY packets
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167325001611.30057.9997663107655151528.git-patchwork-notify@kernel.org>
Date:   Mon, 09 Jan 2023 07:40:16 +0000
References: <20230106142523.1234476-1-edumazet@google.com>
In-Reply-To: <20230106142523.1234476-1-edumazet@google.com>
To:     Eric Dumazet <edumazet@google.com>
Cc:     davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com,
        netdev@vger.kernel.org, eric.dumazet@gmail.com,
        jaroslav.pulchart@gooddata.com, lixiaoyan@google.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  6 Jan 2023 14:25:23 +0000 you wrote:
> Jaroslav reported a recent throughput regression with virtio_net
> caused by blamed commit.
> 
> It is unclear if DODGY GSO packets coming from user space
> can be accepted by GRO engine in the future with minimal
> changes, and if there is any expected gain from it.
> 
> [...]

Here is the summary with links:
  - [net] gro: take care of DODGY packets
    https://git.kernel.org/netdev/net/c/7871f54e3dee

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


