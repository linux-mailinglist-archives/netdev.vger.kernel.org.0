Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7DD90543AF8
	for <lists+netdev@lfdr.de>; Wed,  8 Jun 2022 20:00:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233543AbiFHSAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jun 2022 14:00:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233505AbiFHSAR (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jun 2022 14:00:17 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2F13E1B318F
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 11:00:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id BBE2A61B4C
        for <netdev@vger.kernel.org>; Wed,  8 Jun 2022 18:00:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 209A8C3411D;
        Wed,  8 Jun 2022 18:00:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1654711215;
        bh=fPPtbtsEq8f9qkmqIsn6tTVNnnnu6GHud4P6OjNCrqQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=awYpTP7Kq55HuRqOo9GxAWt3IZWQ2x23FIUoF45WYfG6s98F56uVjJvoaxJkNEXOb
         3fzkh57dGYo3M2ANsZzYHzXCALlEeQilSYuzWsr/5peZ1YXFiRmWXqbZy+W+Hm3svP
         B8p4Bz2xqGT5hkv4Yv7zxr5GD/he7x0Jl8HYpC2Po/+M2rhAOdj1RnFDVANlY4ME6C
         JPVH0FgG3hQC1Wk1s4xrTDs2nI8rXcTn1ENcSxaNlph8TE7n8h1+0MEjLHnmBKsygc
         pN5n2iHFmJyrpjWCi6moCXPQMJBX/1kLWfqc03Kv/j8PNjHtpiDhJhg9XM+bTfyr7w
         TK3zRBLpXRVEA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 0777AE737FA;
        Wed,  8 Jun 2022 18:00:15 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net v3 0/3] Split "nfc: st21nfca: Refactor EVT_TRANSACTION"
 into 3
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <165471121502.25792.5851849748866620547.git-patchwork-notify@kernel.org>
Date:   Wed, 08 Jun 2022 18:00:15 +0000
References: <20220607025729.1673212-1-mfaltesek@google.com>
In-Reply-To: <20220607025729.1673212-1-mfaltesek@google.com>
To:     Martin Faltesek <mfaltesek@google.com>
Cc:     kuba@kernel.org, krzysztof.kozlowski@linaro.org,
        christophe.ricard@gmail.com, gregkh@linuxfoundation.org,
        groeck@google.com, jordy@pwning.systems, krzk@kernel.org,
        martin.faltesek@gmail.com, netdev@vger.kernel.org,
        linux-nfc@lists.01.org, sameo@linux.intel.com, wklin@google.com,
        theflamefire89@gmail.com
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

This series was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Mon,  6 Jun 2022 21:57:26 -0500 you wrote:
> Change log:
> 
> v2 -> v3:
> 
> 1. v2 review comment: modified sender email to match SoB line.
> 
> 2. v2 review comment: threading emails by using git send-email as
>    recommended.
> 
> [...]

Here is the summary with links:
  - [net,v3,1/3] nfc: st21nfca: fix incorrect validating logic in EVT_TRANSACTION
    https://git.kernel.org/netdev/net/c/77e5fe8f176a
  - [net,v3,2/3] nfc: st21nfca: fix memory leaks in EVT_TRANSACTION handling
    https://git.kernel.org/netdev/net/c/996419e0594a
  - [net,v3,3/3] nfc: st21nfca: fix incorrect sizing calculations in EVT_TRANSACTION
    https://git.kernel.org/netdev/net/c/f2e19b36593c

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


