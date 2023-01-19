Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DEFA367307D
	for <lists+netdev@lfdr.de>; Thu, 19 Jan 2023 05:42:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230012AbjASEmj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Jan 2023 23:42:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230002AbjASEmG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Jan 2023 23:42:06 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68CD56E821;
        Wed, 18 Jan 2023 20:39:56 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9808661B13;
        Thu, 19 Jan 2023 04:20:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 01E05C433F0;
        Thu, 19 Jan 2023 04:20:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674102017;
        bh=myjt/Ku6FGvHxyQe5o8SwWtOXjmFnmf3xhU0A5snvDQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=GNvrOteKGlf3eKSpUirAZ3vvAoSkT5Nf1SHrLebIIMdjeWzmvv5q8hB3Wm84JKn5W
         EExUsSDenYqJ30q0nIzLSHbzt6FH7tRbj0Gza9aVSEY1gd/F/SU5JkpGgJpaUbkvU/
         oPIHOx9OhsKLLjTVpSLPd6Ww83P/KYCrU4tRy7ulBzap3tAYzJ9QSZPdUu6x7YMHGZ
         yBct5ZAPffRu7dlAKeg3oFnTH6TO+vclV02lPGyJTg0vPadu8AkaWSQYahuRU3+eSH
         qVTsHGy4wxlGyxWGtGlcEQR3UtGO0POF+KvoraodJo9h86pu6xUaHFfq9liLfK935s
         OUoZh9wwULT2g==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id D8747C5C7C4;
        Thu, 19 Jan 2023 04:20:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: pull-request: wireless-2023-01-18
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167410201688.30214.13535859451267128930.git-patchwork-notify@kernel.org>
Date:   Thu, 19 Jan 2023 04:20:16 +0000
References: <20230118073749.AF061C433EF@smtp.kernel.org>
In-Reply-To: <20230118073749.AF061C433EF@smtp.kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This pull request was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed, 18 Jan 2023 07:37:49 +0000 (UTC) you wrote:
> Hi,
> 
> here's a pull request to net tree, more info below. Please let me know if there
> are any problems.
> 
> Kalle
> 
> [...]

Here is the summary with links:
  - pull-request: wireless-2023-01-18
    https://git.kernel.org/netdev/net/c/edb5b63e5673

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


