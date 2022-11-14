Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4C6F2627A20
	for <lists+netdev@lfdr.de>; Mon, 14 Nov 2022 11:12:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235750AbiKNKMO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Nov 2022 05:12:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235744AbiKNKLo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Nov 2022 05:11:44 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E821E20345;
        Mon, 14 Nov 2022 02:10:17 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id A8FB9B80DAE;
        Mon, 14 Nov 2022 10:10:16 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5250DC43145;
        Mon, 14 Nov 2022 10:10:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668420615;
        bh=KrzPPTjL6PexWhqzFouzhPVIW2ZyPIcPRZVzmDCcr9A=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ke+9eqTnOO1dYzVs4XuehR6CbDpjnFwZ2u8UtuXqWABI+svqJb9z+/E8pM7wCVrw9
         KRan2HCfmNenqC2i/44amiacqhf70BmwPTpAiFyL8Eswq/LO8CriRzqNwXccjo/cdF
         0nuAEdV1XCh++zr7lSKj7WB5sM9G4Abo9Td5dMCmTNd5EaCjL/5eOGl777SibhcZnF
         augtyCkx8Oul6LkqDDoXbeJXqM5a1YftUONbGZJ1lwjlnLWQLG9Tv12Fpx1Drux9i7
         MRYJkUIJXjJXpIJaT7VJ+EPQMA1Jc0Cv2NMkBgRopnr+nbJg9L+dAIMmSaEbuXBNr2
         Zcrjs21UqhTOg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3F3FBE4D021;
        Mon, 14 Nov 2022 10:10:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] net: tun: rebuild error handling in tun_get_user
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166842061525.15162.1239961999793813187.git-patchwork-notify@kernel.org>
Date:   Mon, 14 Nov 2022 10:10:15 +0000
References: <20221110073125.692259-1-nashuiliang@gmail.com>
In-Reply-To: <20221110073125.692259-1-nashuiliang@gmail.com>
To:     Chuang Wang <nashuiliang@gmail.com>
Cc:     kuba@kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Thu, 10 Nov 2022 15:31:25 +0800 you wrote:
> The error handling in tun_get_user is very scattered.
> This patch unifies error handling, reduces duplication of code, and
> makes the logic clearer.
> 
> Signed-off-by: Chuang Wang <nashuiliang@gmail.com>
> ---
> v1 -> v2:
> - fix problems based on Jakub Kicinski's comments
> 
> [...]

Here is the summary with links:
  - [v2] net: tun: rebuild error handling in tun_get_user
    https://git.kernel.org/netdev/net-next/c/ab00af85d2f8

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


