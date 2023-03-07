Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 206B76AF804
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 22:50:40 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231628AbjCGVuc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 16:50:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33400 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231604AbjCGVuZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 16:50:25 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 08A9195465;
        Tue,  7 Mar 2023 13:50:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 940A1B81A45;
        Tue,  7 Mar 2023 21:50:22 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 0D27CC4339E;
        Tue,  7 Mar 2023 21:50:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678225821;
        bh=GSPQKquktL4JjjyNEvTusF3QMpG6B42fKmFuoGQsiUE=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=X+MJZfXY6UhEk7esMG/W6kx9hyk8iv0MavK0k3GV+wF6eQvV62uAEAOOCmbNPaU29
         pMVq3h8VB6whmED9qmrkPlQv+Ot7tf+Z2KMjT2qYT8uzdKwkaNEQumc7aWVQgmZKKa
         BBStzr63dIUC5c1OV21YCbmjdVMtsy+f+qf4gcS2cBh+a7U9zQXSFvCbZ9XPmBrFfJ
         n66B6SAArNaM5YvjARreNjYd4yp6AUwUoSeyDFofs3kgQxWUePBp35eNVD9GydWBAh
         Wwlji4jKoRJq/xh8ZvB1/dwGonTT9Q8FBwgxXoNgmX4ve2D8G83QVgTZX9Y+NGrHSz
         7w7HUgP/LkyHg==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id DB66EE61B67;
        Tue,  7 Mar 2023 21:50:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] nfc: change order inside nfc_se_io error path
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167822582089.6774.886285380993481424.git-patchwork-notify@kernel.org>
Date:   Tue, 07 Mar 2023 21:50:20 +0000
References: <20230306212650.230322-1-pchelkin@ispras.ru>
In-Reply-To: <20230306212650.230322-1-pchelkin@ispras.ru>
To:     Fedor Pchelkin <pchelkin@ispras.ru>
Cc:     kuba@kernel.org, krzysztof.kozlowski@linaro.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        khoroshilov@ispras.ru, lvc-project@linuxtesting.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This patch was applied to netdev/net.git (main)
by Jakub Kicinski <kuba@kernel.org>:

On Tue,  7 Mar 2023 00:26:50 +0300 you wrote:
> cb_context should be freed on the error path in nfc_se_io as stated by
> commit 25ff6f8a5a3b ("nfc: fix memory leak of se_io context in
> nfc_genl_se_io").
> 
> Make the error path in nfc_se_io unwind everything in reverse order, i.e.
> free the cb_context after unlocking the device.
> 
> [...]

Here is the summary with links:
  - [v2] nfc: change order inside nfc_se_io error path
    https://git.kernel.org/netdev/net/c/7d834b4d1ab6

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


