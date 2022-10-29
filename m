Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3952C611F35
	for <lists+netdev@lfdr.de>; Sat, 29 Oct 2022 04:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229510AbiJ2CAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 22:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229379AbiJ2CA3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 22:00:29 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C09D65B52C;
        Fri, 28 Oct 2022 19:00:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 7701BB82DFB;
        Sat, 29 Oct 2022 02:00:26 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 17215C433D7;
        Sat, 29 Oct 2022 02:00:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1667008825;
        bh=XTNIRd6vh3jcHscZ6c+2LkfJZ1ZmQbs07HUfINZ5c7E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=UWfJcD1iDk5O/q9yQFFbi7qZ7/bmxvqUsNb2q3Xm9OO0XNXoL8LIaaqMoYMxFnySu
         MCOb9r8tSHhk7GKevds4T0SDgJAkyznbN9NvXaUnmRM3egaDHOVvH78VS0HoSSP+h7
         CBeHPb186SILBBj7yQnAQxLfyr5by/joZbLgPwPDQPBhIhBOgQjnl3PkAsha7DkZRc
         JqjSRUXgPljKoQjZq6aRaB0Jj0qXNyaT8DFgoO6QU8h39MhxEgCNKbRDU+jXJqLsyE
         lg7zR+yInA3fAk8ILEeihEUJ+/567nQ3EOTCqFfkmYTBd5OtVrqTL967mD+yAIcc4M
         yNN44bm1kgsBg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id E6C11C41672;
        Sat, 29 Oct 2022 02:00:24 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-next-2022-10-28
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166700882494.26130.18123233444739982911.git-patchwork-notify@kernel.org>
Date:   Sat, 29 Oct 2022 02:00:24 +0000
References: <20221028132943.304ECC433B5@smtp.kernel.org>
In-Reply-To: <20221028132943.304ECC433B5@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Fri, 28 Oct 2022 13:29:43 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net-next tree, more info below. Please let me know if
> there are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-next-2022-10-28
    https://git.kernel.org/netdev/net-next/c/196dd92a00ff

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


