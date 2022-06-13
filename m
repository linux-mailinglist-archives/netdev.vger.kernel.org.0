Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4FE44549A58
	for <lists+netdev@lfdr.de>; Mon, 13 Jun 2022 19:49:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232646AbiFMRtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jun 2022 13:49:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242906AbiFMRsX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jun 2022 13:48:23 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48E9C3CA6A;
        Mon, 13 Jun 2022 06:30:22 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id DC783612D5;
        Mon, 13 Jun 2022 13:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 3A11EC3411B;
        Mon, 13 Jun 2022 13:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655127021;
        bh=3owKJmN+C3KrJEir3DsRctBw54DfOoSMlpRJuhdRiu4=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=kxGF1j+eI+5kQ9AwgEWJQbIMyKWMkuWMh2YymfsxLeoUcyHSfh+u9NaCjsZW5Ci27
         vTsJYsAU/bj5451JRBoiCIZY66di1Q7BS3fcpqI1qf+L14TbWqYWroAS+JnbNP6p4e
         uVnxGIRT3PO02aIGBewc+ipWcchbuoF4KC6L3GCg4kZ97nqXH0hjrsyj7n3atE4uAM
         QwoDlKRynboAxbw6gmIFCLp85vsf59Y0Vsx0u8kkqPOHvKxoUOuZ1PhF+DxRJGR15I
         w8W2Sc08wUbogEwgW9COSZFjWJkJKBxfWao4czQMmNyiu3wRuj/2ilOGB301DjKyza
         AwSOUq9BPr1qw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 01FD217A1CBC;
        Mon, 13 Jun 2022 13:30:21 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] net: make __sys_accept4_file() static
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165512702100.2444.14881268183989098998.git-patchwork-notify@kernel.org>
Date:   Mon, 13 Jun 2022 13:30:21 +0000
References: <20220610091017.1991892-1-yajun.deng@linux.dev>
In-Reply-To: <20220610091017.1991892-1-yajun.deng@linux.dev>
To:     Yajun Deng <yajun.deng@linux.dev>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri, 10 Jun 2022 17:10:17 +0800 you wrote:
> __sys_accept4_file() isn't used outside of the file, make it static.
> 
> As the same time, move file_flags and nofile parameters into
> __sys_accept4_file().
> 
> Signed-off-by: Yajun Deng <yajun.deng@linux.dev>
> 
> [...]

Here is the summary with links:
  - [net-next] net: make __sys_accept4_file() static
    https://git.kernel.org/netdev/net-next/c/c04245328dd7

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


