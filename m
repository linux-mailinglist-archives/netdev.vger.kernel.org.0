Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 35B98637164
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 05:10:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229572AbiKXEKX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 23:10:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56112 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229595AbiKXEKV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 23:10:21 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4A8FAB5C6D
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 20:10:18 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 65D8161FE0
        for <netdev@vger.kernel.org>; Thu, 24 Nov 2022 04:10:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id BAD0AC433C1;
        Thu, 24 Nov 2022 04:10:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669263016;
        bh=8I0xUBaof6pd+GSTX0gpEPuWxecZwaIZZVUM0yXj26E=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=QSDnqBH+n7KbYU2rQNxeWOVJ5z2VejthBdntJypXnuSGUYULDB1P9IxZDyQULsbUU
         sPZ0u5w+RW06AhGJex+2j/IJogMWWMvaYY6alGjVAT9KI3Frk5f/mBXq0gxVbghg5z
         LmcDg93CPB54GTI+a2hnyoYu/AVgm/sx9iYhwIUKQEqRJqyLrLO18VLBoXJUtctcKI
         rLxblbU3jHmOcVmop0cE+NJGchl+yX/lOjpKZpkT1xqMrCDglHW8ruoXVMsDkzMumI
         W5hL6Z0+DolZ9lqluNdzWAQ/EpsVWzvb6vAUw2SQIcHIPifCm5rFePpgURBpbaGdKy
         MsD6Ls0yJjGZA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 96639C5C7C6;
        Thu, 24 Nov 2022 04:10:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v2 0/3] nfc: st-nci: Restructure validating logic in
 EVT_TRANSACTION
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166926301660.16668.1324123322171719255.git-patchwork-notify@kernel.org>
Date:   Thu, 24 Nov 2022 04:10:16 +0000
References: <20221122004246.4186422-1-mfaltesek@google.com>
In-Reply-To: <20221122004246.4186422-1-mfaltesek@google.com>
To:     Martin Faltesek <mfaltesek@google.com>
Cc:     kuba@kernel.org, netdev@vger.kernel.org, linux-nfc@lists.01.org,
        krzysztof.kozlowski@linaro.org, davem@davemloft.net,
        martin.faltesek@gmail.com, christophe.ricard@gmail.com,
        groeck@google.com, jordy@pwning.systems, krzk@kernel.org,
        sameo@linux.intel.com, theflamefire89@gmail.com, duoming@zju.edu.cn
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
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 21 Nov 2022 18:42:43 -0600 you wrote:
> These are the same 3 patches that were applied in st21nfca here:
> https://lore.kernel.org/netdev/20220607025729.1673212-1-mfaltesek@google.com
> with a couple minor differences.
> 
> st-nci has nearly identical code to that of st21nfca for EVT_TRANSACTION, except
> that there are two extra validation checks that are not present in the st-nci
> code. The 3/3 patch as coded for st21nfca pulls those checks in, bringing both
> drivers into parity.
> 
> [...]

Here is the summary with links:
  - [net,v2,1/3] nfc: st-nci: fix incorrect validating logic in EVT_TRANSACTION
    https://git.kernel.org/netdev/net/c/c60c15223082
  - [net,v2,2/3] nfc: st-nci: fix memory leaks in EVT_TRANSACTION
    https://git.kernel.org/netdev/net/c/440f2ae9c9f0
  - [net,v2,3/3] nfc: st-nci: fix incorrect sizing calculations in EVT_TRANSACTION
    https://git.kernel.org/netdev/net/c/0254f31a7df3

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


