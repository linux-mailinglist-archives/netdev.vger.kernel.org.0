Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5AD505241DC
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 03:10:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349809AbiELBKV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 21:10:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349803AbiELBKR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 21:10:17 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CBE953B75;
        Wed, 11 May 2022 18:10:15 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 68119B826B6;
        Thu, 12 May 2022 01:10:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 17F7DC34115;
        Thu, 12 May 2022 01:10:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652317813;
        bh=8gWk5TN5nmWFSbi2bfWEoQfl064jT61g23HKV8FPloA=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=Ef4s36PEhZ1WZYLP8JWRWS6BoQGy5ySkTqZ9e8Xx/fy8GX7kKG86q2qZzemfNz6UN
         lyKbB3k8Ew3NN72Atk/YNFdQpIK1Mx4ijEr1QLOxZPMoOE2cGWhDO9KtqKkmASmhKl
         Nb6LfF3GHF8iU2zBNUS6X9TKRHbV9lj+6xgTHrkyx/4FlNaEDnFJC91ldzjuMnlIO/
         oNR9VdfQ9xAP3Tpdwu0YGlA57nJBAjFSeo9eCrSKEHFdHnxj/Y5JbwjRFksMkdznI5
         CIH7hhYRL6ys3NrFV879EFeuauoMCaFKQTBY6hLjWFvMF8iM6rcUtrjwdSg/lOrkvM
         2m6/fn+7O3jkw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E42BEF03934;
        Thu, 12 May 2022 01:10:12 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request: bluetooth 2022-05-11
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165231781293.19416.7491146999856919244.git-patchwork-notify@kernel.org>
Date:   Thu, 12 May 2022 01:10:12 +0000
References: <20220512002901.823647-1-luiz.dentz@gmail.com>
In-Reply-To: <20220512002901.823647-1-luiz.dentz@gmail.com>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     davem@davemloft.net, kuba@kernel.org,
        linux-bluetooth@vger.kernel.org, netdev@vger.kernel.org
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 11 May 2022 17:29:01 -0700 you wrote:
> The following changes since commit 3f95a7472d14abef284d8968734fe2ae7ff4845f:
> 
>   i40e: i40e_main: fix a missing check on list iterator (2022-05-11 15:19:28 -0700)
> 
> are available in the Git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/bluetooth/bluetooth.git tags/for-net-2022-05-11
> 
> [...]

Here is the summary with links:
  - pull request: bluetooth 2022-05-11
    https://git.kernel.org/netdev/net/c/a48ab883c4a9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


