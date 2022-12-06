Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CC232643C8D
	for <lists+netdev@lfdr.de>; Tue,  6 Dec 2022 06:00:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232501AbiLFFAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Dec 2022 00:00:44 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50622 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233366AbiLFFAf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Dec 2022 00:00:35 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7C9822657B;
        Mon,  5 Dec 2022 21:00:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 31B77B816A1;
        Tue,  6 Dec 2022 05:00:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id DCB6BC433D6;
        Tue,  6 Dec 2022 05:00:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1670302816;
        bh=zV+T0hsrwOx0nTIxYua5JY5/4x5uafiNfIzCdSBdbMg=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=bUpvQevQoEldRvj6qiXxCm0hfUh6OuJMvmmlDBx+mD40GHrVg8o04WEN8DxrC5JeX
         f1gdNSw0xdyup28FejuhJp1fCqanTCMoPqjth/OkULr/sZQSs9yXKz6veXyBO1f3eu
         dQOKWIp4SYJ9RKOjYWpSHuBMbN7oz6BFUxWJBNXYuwnhPZ6LR1fIXNeRJ3eYDnhPQ2
         Gpmh7f2JBcD4C2/x1t9l61jCnv5c1nYSRVYJ5WppC3MApd9f12VHBczHBzr8ynPgij
         lxoYcqF+QWGbWRjinsoxnJDP2cga0uTDQwOAdNxmZCPALMo/TQx/RCCAKBOoCMLMmC
         mU3/bUKquIEFQ==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id B8C77C395E5;
        Tue,  6 Dec 2022 05:00:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH] NFC: nci: Bounds check struct nfc_target arrays
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167030281674.5465.6825440514451542808.git-patchwork-notify@kernel.org>
Date:   Tue, 06 Dec 2022 05:00:16 +0000
References: <20221202214410.never.693-kees@kernel.org>
In-Reply-To: <20221202214410.never.693-kees@kernel.org>
To:     Kees Cook <keescook@chromium.org>
Cc:     krzysztof.kozlowski@linaro.org,
        syzbot+210e196cef4711b65139@syzkaller.appspotmail.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org, linville@tuxdriver.com,
        ilane@ti.com, linux-kernel@vger.kernel.org,
        linux-hardening@vger.kernel.org
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

On Fri,  2 Dec 2022 13:44:14 -0800 you wrote:
> While running under CONFIG_FORTIFY_SOURCE=y, syzkaller reported:
> 
>   memcpy: detected field-spanning write (size 129) of single field "target->sensf_res" at net/nfc/nci/ntf.c:260 (size 18)
> 
> This appears to be a legitimate lack of bounds checking in
> nci_add_new_protocol(). Add the missing checks.
> 
> [...]

Here is the summary with links:
  - NFC: nci: Bounds check struct nfc_target arrays
    https://git.kernel.org/netdev/net/c/e329e71013c9

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


