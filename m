Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8DB6469C7AF
	for <lists+netdev@lfdr.de>; Mon, 20 Feb 2023 10:30:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230314AbjBTJaV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Feb 2023 04:30:21 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37016 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229492AbjBTJaU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Feb 2023 04:30:20 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AE98D3593;
        Mon, 20 Feb 2023 01:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6DC31B80B94;
        Mon, 20 Feb 2023 09:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3322AC4339B;
        Mon, 20 Feb 2023 09:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676885417;
        bh=knYyAMqD/UJ750dYCLzNyWIRcOeL+YALvqMpMGU3PCI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=pDopfTjOirrf5G886dgbpn7Ao9IXLJpsh2XdY/D1dgNQD27We+xZZAUiJvBRIB+qr
         EiQ4u3GHOwsi28b5wiJdIHpFYGvo8xS6BsGURFFPwvjupwR4AvINiNCBwoLb32t20V
         M566WlWtXNtV5cfvTf/T0fXVBLHF7rq+tTt7+m8k+NCZ5zVUofTxngX5K4pZlMRjqR
         XVabSQ4JRWbkkQ5sHMSvqj8aRRP5YipamZQwOT0U7XoS3a570utBxUlwLU+EYuYunH
         2azYDURNB81aKfAYnKcDkGK6Aq+WRbeYgaI/ztFuEyTgPh6bSFd/d1ScA9S3LkeTuJ
         3kTmvgz4gwOcA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 15CE4E68D20;
        Mon, 20 Feb 2023 09:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3] l2tp: Avoid possible recursive deadlock in
 l2tp_tunnel_register()
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167688541708.4384.18050197483223837652.git-patchwork-notify@kernel.org>
Date:   Mon, 20 Feb 2023 09:30:17 +0000
References: <20230216163710.2508327-1-syoshida@redhat.com>
In-Reply-To: <20230216163710.2508327-1-syoshida@redhat.com>
To:     Shigeru Yoshida <syoshida@redhat.com>
Cc:     jchapman@katalix.com, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, gnault@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        cong.wang@bytedance.com
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

On Fri, 17 Feb 2023 01:37:10 +0900 you wrote:
> When a file descriptor of pppol2tp socket is passed as file descriptor
> of UDP socket, a recursive deadlock occurs in l2tp_tunnel_register().
> This situation is reproduced by the following program:
> 
> int main(void)
> {
> 	int sock;
> 	struct sockaddr_pppol2tp addr;
> 
> [...]

Here is the summary with links:
  - [net,v3] l2tp: Avoid possible recursive deadlock in l2tp_tunnel_register()
    https://git.kernel.org/netdev/net/c/9ca5e7ecab06

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


