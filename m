Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 666485AD447
	for <lists+netdev@lfdr.de>; Mon,  5 Sep 2022 15:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238246AbiIENu2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 5 Sep 2022 09:50:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59460 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238242AbiIENu0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 5 Sep 2022 09:50:26 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6DD9A26ACD;
        Mon,  5 Sep 2022 06:50:20 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 175C161286;
        Mon,  5 Sep 2022 13:50:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 68B3DC43143;
        Mon,  5 Sep 2022 13:50:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1662385819;
        bh=0vgDGvw3E8r0rRG6HeP7R+P65BHkKRE2Hq/zH45bn9k=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=EpiBpGoePYQQzgILObCXeRBb2ggTjF5ZUAYcBcCj1WMk8jxjwVao57H3fWzVVeHCs
         PgtGeeBluNhMeqgueOSi+HvSpm5hyN2gi5SjaCW9HfqHVnM7tXYAZWzFsk4Jmwrpns
         C1u4v5mP0f1ywFaSnoRX6CIHAtdy8lSDFCM1cHCo0OFjPtEGwplGPaOcrdaHItro5g
         sKplO5wwRf1yssku61yY/gOUcVDa3dIKunmihsc5oXpQgkffYdvt6HZlkPNfHEQYqZ
         lSsxbyRGMLjGxE/nAAnI4PlBeUU1NLyUj15b6uehsKq3pnSBS3JBEZqttW3t3ZUv2n
         vXG7+sTP19dbA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 555B4C04E59;
        Mon,  5 Sep 2022 13:50:19 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request: bluetooth 2022-09-02
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166238581934.6349.6215414948226277032.git-patchwork-notify@kernel.org>
Date:   Mon, 05 Sep 2022 13:50:19 +0000
References: <20220902220404.2013285-1-luiz.dentz@gmail.com>
In-Reply-To: <20220902220404.2013285-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
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

This pull request was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Fri,  2 Sep 2022 15:04:04 -0700 you wrote:
> The following changes since commit e7506d344bf180096a86ec393515861fb5245915:
> 
>   Merge tag 'rxrpc-fixes-20220901' of git://git.kernel.org/pub/scm/linux/kernel/git/dhowells/linux-fs (2022-09-02 12:45:32 +0100)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-09-02
> 
> [...]

Here is the summary with links:
  - pull request: bluetooth 2022-09-02
    https://git.kernel.org/netdev/net/c/beb432528c79

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


