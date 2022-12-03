Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7155A64144B
	for <lists+netdev@lfdr.de>; Sat,  3 Dec 2022 06:30:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231339AbiLCFaW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Dec 2022 00:30:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59158 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231225AbiLCFaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Dec 2022 00:30:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8DFCBE0D7;
        Fri,  2 Dec 2022 21:30:20 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4A466B822EF;
        Sat,  3 Dec 2022 05:30:19 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id E099FC433C1;
        Sat,  3 Dec 2022 05:30:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670045418;
        bh=uGLDfj+o0i0yHdpaTtpc94f4+DCED9qLLOuRFd/QEAQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bTJDSUXk7Z5hXdL61QrnZ++ByLwOwwVr/bdlhk9N6VOMv4GqXXrbJXfaMrCuLTP3m
         NKFQ4yODMgrxf6RUbPJ2gVarwfHBVl1lwt8cISEGoPrnGUZkjkcUPmfFNAnxIZ4Qd+
         033xKUbNuvonhjzGkF8XCgQCiMdOWjKvXfkaMv58rIjYOjVL+vbjHQ4N/V8DpgBYI1
         yMsdA/iu5D2G2axvFZjzTOlKNvT6u6v3Vadyy9LbYosC55EbrD94t7a54GVh/A2hmG
         S0fS+QwGNwoA5/C1UnZjc4X/SXLROFeOQwSsAvE5tEcaeumnLrlnC87SZZfIDo1OBN
         OW+liIETEfqfg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BB0E4C395F5;
        Sat,  3 Dec 2022 05:30:17 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] selftests/tls: Fix tls selftests dependency to correct
 algorithm
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167004541776.20517.10718412379070097932.git-patchwork-notify@kernel.org>
Date:   Sat, 03 Dec 2022 05:30:17 +0000
References: <20221201131852.38501-1-tianjia.zhang@linux.alibaba.com>
In-Reply-To: <20221201131852.38501-1-tianjia.zhang@linux.alibaba.com>
To:     Tianjia Zhang <tianjia.zhang@linux.alibaba.com>
Cc:     davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, shuah@kernel.org, Jason@zx2c4.com,
        herbert@gondor.apana.org.au, bagasdotme@gmail.com,
        netdev@vger.kernel.org, linux-kselftest@vger.kernel.org,
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

This patch was applied to netdev/net.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Thu,  1 Dec 2022 21:18:52 +0800 you wrote:
> Commit d2825fa9365d ("crypto: sm3,sm4 - move into crypto directory") moves
> SM3 and SM4 algorithm implementations from stand-alone library to crypto
> API. The corresponding configuration options for the API version (generic)
> are CONFIG_CRYPTO_SM3_GENERIC and CONFIG_CRYPTO_SM4_GENERIC, respectively.
> 
> Replace option selected in selftests configuration from the library version
> to the API version.
> 
> [...]

Here is the summary with links:
  - [v2] selftests/tls: Fix tls selftests dependency to correct algorithm
    https://git.kernel.org/netdev/net/c/6648eadba8d6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


