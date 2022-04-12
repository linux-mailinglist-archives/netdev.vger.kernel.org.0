Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 83B764FCBF2
	for <lists+netdev@lfdr.de>; Tue, 12 Apr 2022 03:40:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244351AbiDLBml (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Apr 2022 21:42:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44648 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243683AbiDLBma (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Apr 2022 21:42:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B9C42495F;
        Mon, 11 Apr 2022 18:40:14 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0AABE61625;
        Tue, 12 Apr 2022 01:40:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id 4FEABC385A4;
        Tue, 12 Apr 2022 01:40:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1649727613;
        bh=4pJ/GTD/TfzI2ixLlzfc4FdOpYVdIdyqCW69dRiEgx8=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=fcVXNCkQVO7d3FlVd4xKD5DC33KNyBcufpEb+9JlfFWA2Wnc8q7ATTqwop7m0LkVV
         bUS3f2q78a/jKvDcJ9BFzl4VvqyiwuZ/3+LMvopiAq4Y63CtL6BkWeyNmoT77y66Iu
         hks4OotkNeWa5Q+g8gaMkck/AcFHOjR6Ngm4r0mU9vv9J2YxlY7TKH1IHOTzw3zKx7
         pDqLW8dJrbJxgk7EBeCgig8fbvRsaioCNQL+xVgoxvpYwNDL3sP2hA1mAlQpoiRWDS
         YhXBu5Vw5kMsw9sHdl2diuoTmYNAng8WH913ajrrRzL5ccFCTKkRVmSX0PcY7+S4pP
         71moZWXMkbGOw==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 3780DE73CC8;
        Tue, 12 Apr 2022 01:40:13 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH net 0/3] net/smc: fixes 2022-04-08
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <164972761322.2554.16742103046786911320.git-patchwork-notify@kernel.org>
Date:   Tue, 12 Apr 2022 01:40:13 +0000
References: <20220408151035.1044701-1-kgraul@linux.ibm.com>
In-Reply-To: <20220408151035.1044701-1-kgraul@linux.ibm.com>
To:     Karsten Graul <kgraul@linux.ibm.com>
Cc:     davem@davemloft.net, kuba@kernel.org, netdev@vger.kernel.org,
        linux-s390@vger.kernel.org, hca@linux.ibm.com,
        alibuda@linux.alibaba.com
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
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

On Fri,  8 Apr 2022 17:10:32 +0200 you wrote:
> Please apply the following patches to netdev's net tree.
> 
> Patch 1 fixes two usages of snprintf() with non null-terminated
> string which results into an out-of-bounds read.
> Pach 2 fixes a syzbot finding where a pointer check was missed
> before the call to dev_name().
> Patch 3 fixes a crash when already released memory is used as
> a function pointer.
> 
> [...]

Here is the summary with links:
  - [net,1/3] net/smc: use memcpy instead of snprintf to avoid out of bounds read
    https://git.kernel.org/netdev/net/c/b1871fd48efc
  - [net,2/3] net/smc: Fix NULL pointer dereference in smc_pnet_find_ib()
    https://git.kernel.org/netdev/net/c/d22f4f977236
  - [net,3/3] net/smc: Fix af_ops of child socket pointing to released memory
    https://git.kernel.org/netdev/net/c/49b7d376abe5

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


