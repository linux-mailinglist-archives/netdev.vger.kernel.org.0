Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2F3606ED9B9
	for <lists+netdev@lfdr.de>; Tue, 25 Apr 2023 03:20:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233116AbjDYBUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Apr 2023 21:20:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60940 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229822AbjDYBUU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Apr 2023 21:20:20 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 615725269;
        Mon, 24 Apr 2023 18:20:19 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id F370262AA7;
        Tue, 25 Apr 2023 01:20:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 5A880C433D2;
        Tue, 25 Apr 2023 01:20:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1682385618;
        bh=WdI6hP/q8EEmT8zzHs8JYjtm1REhgN+Ch2N0q5+u/dU=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=L1MZyZ8DMQ+59sumUj2qrOxk4l+3hs/Qh9k1bBROxF24yzf7CZ6yHYhpuhNDGjxXa
         4Y7FmFZxo9HDM6jiwQVuaxUu6emmnl37mEJUShO5TM6nVqFdP+EJao/aY3+7+K2X2C
         aSKmiudKqjduTKRygELCFaLhseLUc2KePZesW5ilJsA/Zw7QHbadWQzmdmG5caEwkJ
         +XD8ZeZ13J2sqnNNx30PWyAjYBJ/AbjcmHYMd+ZXNmcmmfLTtt8YuhEWNcCLlz4LBf
         Sn16n5GbXitbPAF4+sSmDNSKGbpVQ5cM7tVFzcIlht/jxCfTBNSYFMegA4PRAlpttG
         zUQHbWcAFLjNg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 38AE8C395D8;
        Tue, 25 Apr 2023 01:20:18 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] drivers: nfc: nfcsim: remove return value check of `dev_dir`
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <168238561822.11483.11083488941331672380.git-patchwork-notify@kernel.org>
Date:   Tue, 25 Apr 2023 01:20:18 +0000
References: <20230424024140.34607-1-u202110722@hust.edu.cn>
In-Reply-To: <20230424024140.34607-1-u202110722@hust.edu.cn>
To:     Jianuo Kuang <u202110722@hust.edu.cn>
Cc:     krzysztof.kozlowski@linaro.org, thierry.escande@collabora.com,
        sameo@linux.intel.com, hust-os-kernel-patches@googlegroups.com,
        dzm91@hust.edu.cn, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
X-Spam-Status: No, score=-4.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net-next.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Mon, 24 Apr 2023 10:41:40 +0800 you wrote:
> Smatch complains that:
> nfcsim_debugfs_init_dev() warn: 'dev_dir' is an error pointer or valid
> 
> According to the documentation of the debugfs_create_dir() function,
> there is no need to check the return value of this function.
> Just delete the dead code.
> 
> [...]

Here is the summary with links:
  - drivers: nfc: nfcsim: remove return value check of `dev_dir`
    https://git.kernel.org/netdev/net-next/c/e515c330d7e2

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


