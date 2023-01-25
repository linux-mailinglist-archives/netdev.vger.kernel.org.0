Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8087167B2FF
	for <lists+netdev@lfdr.de>; Wed, 25 Jan 2023 14:10:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235154AbjAYNKn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Jan 2023 08:10:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48964 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235511AbjAYNKj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Jan 2023 08:10:39 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3125654211;
        Wed, 25 Jan 2023 05:10:21 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B312AB819B4;
        Wed, 25 Jan 2023 13:10:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 58077C4339B;
        Wed, 25 Jan 2023 13:10:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674652218;
        bh=YzpixvpW9PCMMyM0yTjHSwl7B7McNWqkoZlzm88zMtM=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GSerYtmkxTB/wiMovCOdwgakkZMpL+//Jk8RwYEA/wlXtBxkUPJaUMucP86CAVGbe
         BGNXuWmWmli6fUfUw4ojk93XdLKzqJc3WIHXkXy148GkDuwWipTlQt0odaAkd5Gsj1
         pAZ9P6mBYaTL2Q99M8UIOHS3FqpGc4Ns+hOscnURNAC01/IeIqeZfezth9p6M8HCj2
         qQh1iKgeIhTZ6fuuVlosAUTMFkickPNWBRXv2+TicPHedf6k5vF8VvJnE6Iah9DQ0p
         4TdYSxtmM5K5WanWpgfypb6UE4PiNjNPfxFKjFVby0E0lqtLGDkazAy0JRq5frRB+r
         8zmuzjS2F1vQg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 4080EC04E34;
        Wed, 25 Jan 2023 13:10:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/2] net: ravb: Fix potential issues
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167465221826.7884.3610835644530936754.git-patchwork-notify@kernel.org>
Date:   Wed, 25 Jan 2023 13:10:18 +0000
References: <20230124000211.1426624-1-yoshihiro.shimoda.uh@renesas.com>
In-Reply-To: <20230124000211.1426624-1-yoshihiro.shimoda.uh@renesas.com>
To:     Yoshihiro Shimoda <yoshihiro.shimoda.uh@renesas.com>
Cc:     s.shtylyov@omp.ru, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        linux-renesas-soc@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net.git (master)
by David S. Miller <davem@davemloft.net>:

On Tue, 24 Jan 2023 09:02:09 +0900 you wrote:
> Fix potentiall issues on the ravb driver.
> 
> Changes from v2:
> https://lore.kernel.org/all/20230123131331.1425648-1-yoshihiro.shimoda.uh@renesas.com/
>  - Add Reviewed-by in the patch [2/2].
>  - Add a commit description in the patch [2/2].
> 
> [...]

Here is the summary with links:
  - [net,v3,1/2] net: ravb: Fix lack of register setting after system resumed for Gen3
    https://git.kernel.org/netdev/net/c/c2b6cdee1d13
  - [net,v3,2/2] net: ravb: Fix possible hang if RIS2_QFF1 happen
    https://git.kernel.org/netdev/net/c/f3c07758c900

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


