Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A39C584F76
	for <lists+netdev@lfdr.de>; Fri, 29 Jul 2022 13:20:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236004AbiG2LU0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 07:20:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38694 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235974AbiG2LUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 07:20:21 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2C72A5F93;
        Fri, 29 Jul 2022 04:20:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 76BBA61EB5;
        Fri, 29 Jul 2022 11:20:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id C5F22C43142;
        Fri, 29 Jul 2022 11:20:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659093614;
        bh=Rh0GQbGirAs9zHLRDXJGs0XZOpDnaOvhtGKFa0lMpNg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LJbKK5i23XAgB6aUB5/XmxwoN4YhGDPcdIAwT2C4cic/G7coBQNcF0IFDjgO8K2au
         /uvBvot92cybeADcSvV347bGBwXxWhLeJolUg6O83YAb1dZHr2u0Dcs5JdCEllySNv
         7jL0QvMTu+E1+25SRqE3HzNtB5AdLewgfFcuVWBJStkGcXCJ+raMM8su6whAKnNy8M
         73hBciv2MoHrTpvUtnfqvuzZ9r77S4WlVoSZe5dSvVSQaTjRX5AcECh0FZkns2ubah
         00enPralDtuen556ZssSDKjtHfSjqebYsRxpDaqForQoywdUxK+UZnEeeLxKMsvPOV
         6ptO2fR3lpN5Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id ACFA3C43146;
        Fri, 29 Jul 2022 11:20:14 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net/af_packet: check len when min_header_len equals
 to 0
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165909361470.23060.13320367674986515693.git-patchwork-notify@kernel.org>
Date:   Fri, 29 Jul 2022 11:20:14 +0000
References: <20220727093312.125116-1-shaozhengchao@huawei.com>
In-Reply-To: <20220727093312.125116-1-shaozhengchao@huawei.com>
To:     Zhengchao Shao <shaozhengchao@huawei.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, liuhangbin@gmail.com,
        willemb@google.com, baruch@tkos.co.il, pablo@netfilter.org,
        yajun.deng@linux.dev, weiyongjun1@huawei.com, yuehaibing@huawei.com
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Wed, 27 Jul 2022 17:33:12 +0800 you wrote:
> User can use AF_PACKET socket to send packets with the length of 0.
> When min_header_len equals to 0, packet_snd will call __dev_queue_xmit
> to send packets, and sock->type can be any type.
> 
> Reported-by: syzbot+5ea725c25d06fb9114c4@syzkaller.appspotmail.com
> Fixes: fd1894224407 ("bpf: Don't redirect packets with invalid pkt_len")
> Signed-off-by: Zhengchao Shao <shaozhengchao@huawei.com>
> 
> [...]

Here is the summary with links:
  - [net-next] net/af_packet: check len when min_header_len equals to 0
    https://git.kernel.org/netdev/net-next/c/dc633700f00f

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


