Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D4DD45EB62D
	for <lists+netdev@lfdr.de>; Tue, 27 Sep 2022 02:20:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229814AbiI0AUX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 20:20:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57376 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230097AbiI0AUR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 20:20:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 57A889E137;
        Mon, 26 Sep 2022 17:20:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA532B81710;
        Tue, 27 Sep 2022 00:20:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AC3C0C433D6;
        Tue, 27 Sep 2022 00:20:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1664238013;
        bh=CowhpgyeW62rYNZW5JFMdCv27yYlQqE//Vf1xVn6ehc=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GQ41qw4Imsj8X1+Hfu5GSfjtQBmo1YDrj+Y1qR4EBNXEYIVFCbrYAAH3/JiWm/WCN
         9y8fl8Yq2Caq+EH+l8YTiagXb33YrPkyEqqepcccBDSbwwf+lrkR11tzcPAxr8KcY7
         MJyHW1XIlIMZA+Ilmi+Hq+8L/xFN0TZqd6tFxel0SlIrpQplZMO0LFIQLiFZqzUZme
         thER9eHUjJ8sAcxrKHk7hHH1AHTQBwc9Yd3UNbTmlCdW8B+SVj+4UDcvXONDH9und+
         gIr1JZh4bt3B+N89atBiG3sKlVkFPm4WZPdZTgJTM4c2I88zTqwhwow0MsYvMQ2jLP
         ORZZ7YiBBKaGA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 8E731E21EC3;
        Tue, 27 Sep 2022 00:20:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net-next] xdp: Adjust xdp_frame layout to avoid using
 bitfields
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166423801357.11940.13487466744913747650.git-patchwork-notify@kernel.org>
Date:   Tue, 27 Sep 2022 00:20:13 +0000
References: <166393728005.2213882.4162674859542409548.stgit@firesoul>
In-Reply-To: <166393728005.2213882.4162674859542409548.stgit@firesoul>
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev@vger.kernel.org, kuba@kernel.org, john.fastabend@gmail.com,
        davem@davemloft.net, ast@kernel.org, hawk@kernel.org,
        daniel@iogearbox.net, edumazet@google.com, pabeni@redhat.com,
        bpf@vger.kernel.org, lorenzo@kernel.org
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 23 Sep 2022 14:48:00 +0200 you wrote:
> Practical experience (and advice from Alexei) tell us that bitfields in
> structs lead to un-optimized assemply code. I've verified this change
> does lead to better x86_64 assemply, both via objdump and playing with
> code snippets in godbolt.org.
> 
> Using scripts/bloat-o-meter shows the code size is reduced with 24
> bytes for xdp_convert_buff_to_frame() that gets inlined e.g. in
> i40e_xmit_xdp_tx_ring() which were used for microbenchmarking.
> 
> [...]

Here is the summary with links:
  - [net-next] xdp: Adjust xdp_frame layout to avoid using bitfields
    https://git.kernel.org/netdev/net-next/c/b860a1b964be

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


