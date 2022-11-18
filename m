Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 077C462F51A
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 13:40:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241787AbiKRMkW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 07:40:22 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51742 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234711AbiKRMkT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 07:40:19 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5E9545FD9;
        Fri, 18 Nov 2022 04:40:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 12133B823B4;
        Fri, 18 Nov 2022 12:40:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id D119BC433C1;
        Fri, 18 Nov 2022 12:40:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1668775216;
        bh=n/eTCbkZXLAsLYMgUVUFHHnwqkZMMlWlqyIrNnysN6I=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=uZ+kZarmrWpQn+DGJd1ssanLg/nWfL95i/cskOM9u+3RowIoR5uCXbOBsFQKVXk5q
         MPbEJljnu5zKTzAC9C6Zk6KL2nyERpGSo0dTfrvq82Fk1/I/UPZ9QiTy2Eu9+OHPfQ
         jo022VhyaPnAoxQhdT6UpCtvv8HVTPaI1wrZzJI82a2v2s5yjma9evQD7p1oNkFggR
         0qHcve9zGTcT4iogtgbcXbkiJWNsd4Fu6swyqaeFy1gS6/bE3g+ckupLolfz2NQPlG
         zKWD5iKkm1CA4Ua9rf7vESV2vjla81ad+P8ud+XOZ4L4euYI+w5tMat5AMiUsRkWcm
         XM8U6b9KbxA+w==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id BEA27C395F3;
        Fri, 18 Nov 2022 12:40:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH v2] nfc/nci: fix race with opening and closing
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <166877521677.4012.14328581399116193880.git-patchwork-notify@kernel.org>
Date:   Fri, 18 Nov 2022 12:40:16 +0000
References: <20221116130249.10232-1-linma@zju.edu.cn>
In-Reply-To: <20221116130249.10232-1-linma@zju.edu.cn>
To:     Lin Ma <linma@zju.edu.cn>
Cc:     krzk@kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, mudongliangabcd@gmail.com,
        syzbot+43475bf3cfbd6e41f5b7@syzkaller.appspotmail.com
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
by David S. Miller <davem@davemloft.net>:

On Wed, 16 Nov 2022 21:02:49 +0800 you wrote:
> Previously we leverage NCI_UNREG and the lock inside nci_close_device to
> prevent the race condition between opening a device and closing a
> device. However, it still has problem because a failed opening command
> will erase the NCI_UNREG flag and allow another opening command to
> bypass the status checking.
> 
> This fix corrects that by making sure the NCI_UNREG is held.
> 
> [...]

Here is the summary with links:
  - [v2] nfc/nci: fix race with opening and closing
    https://git.kernel.org/netdev/net/c/0ad6bded175e

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


