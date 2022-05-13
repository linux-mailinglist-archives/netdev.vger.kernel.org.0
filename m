Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EB335260E4
	for <lists+netdev@lfdr.de>; Fri, 13 May 2022 13:21:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1379881AbiEMLVs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 May 2022 07:21:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48748 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1379863AbiEMLVp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 May 2022 07:21:45 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1EC584C406;
        Fri, 13 May 2022 04:21:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 92FE5B82E22;
        Fri, 13 May 2022 11:21:40 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 49558C36AE3;
        Fri, 13 May 2022 11:21:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652440899;
        bh=chRjr8fIGtWEzRHU7W/HsmwaISg4XU7EChxyb0owTzI=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ROWH+cg5oD6TOsISdjZMaQMUQ5YRwcRz9iGyyvu+YSvOJzojCyED7YT67txTYSoFW
         E48fPM+8KlA8U+uyjkKP4xhxjliTRebRIN9pQUJdVgmW5fjX0WMprySl/dTHlObMA0
         ZwwCEefSFRHYeZa2rCOXMD2lrxfNjLp5yzb9uD2GMokuumNBGfXwi638C+1XL/U0Ow
         BpktEQIBuU69LBj5dCJZKYQ2hkC8YfZA4hoPrLUzJ/Ff/LQEBiA+HKDa8/7eLSl07t
         KXNBhRnx7/EA6hf/hYBhDJXxHSiP1L9zrKsi9tZjVXwdqwfsVBHVN600eDhx7JQNWo
         aIVuNncIU7q/Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 299D8F03938;
        Fri, 13 May 2022 11:21:39 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull request: bluetooth 2022-05-11
From:   patchwork-bot+bluetooth@kernel.org
Message-Id: <165244089916.8477.8514836330003824576.git-patchwork-notify@kernel.org>
Date:   Fri, 13 May 2022 11:21:39 +0000
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

This pull request was applied to bluetooth/bluetooth-next.git (master)
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
    https://git.kernel.org/bluetooth/bluetooth-next/c/a48ab883c4a9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


